import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_managr.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/parking/historic_parking/historic_parkin_page.dart';
import 'package:qr_scaner_manrique/pages/parking/type_parking_register/type_parking_register_modal.dart';

class ParkingHomeController extends GetxController {
  ApiManager apiManager = ApiManager();
  
  // Lista de puertas de parqueo
  List<GateDoor> parkingEntrances = [];
  RxBool entrancesLoading = true.obs;
  GateDoor? entranceIdSelected;
  
  // Estados de carga para las operaciones
  RxBool validatingQrCodeLoading = false.obs;
  RxBool entranceFormLoading = false.obs;
  RxBool exitFormLoading = false.obs;

  // Nombre del lugar/propiedad actual
  String get placeName => UserData.sharedInstance.placeSelected?.nombre ?? 'Arcos Plaza';

  @override
  void onInit() {
    super.onInit();
    fetchParkingEntrances(
      placeId: UserData.sharedInstance.placeSelected!.idLugar.toString(),
    );
  }

  // Método para obtener las puertas de parqueo
  fetchParkingEntrances({required String placeId}) async {
    try {
      entrancesLoading.value = true;
      final allEntrances = await apiManager.fetchEntrances(placeId, 'P');
      
      // Mostrar todas las puertas disponibles
      parkingEntrances = allEntrances;
      
      entrancesLoading.value = false;
      
      // Seleccionar la primera puerta si existe
      if (parkingEntrances.isNotEmpty) {
        entranceIdSelected = parkingEntrances[0];
      }
      
      update();
    } on DioError catch (e) {
      log('Error fetching parking entrances: $e');
      entrancesLoading.value = false;
      update();
    }
  }

  // Método para cambiar la puerta de parqueo seleccionada
  void changeParkingGate(GateDoor gate) {
    entranceIdSelected = gate;
    update();
  }

  // Navegación a validación de parqueo
  void goToValidation() {
    if (entranceIdSelected == null) {
      _showGateSelectionDialog();
      return;
    }
    
    // Mostrar el modal de tipo de validación con doorId
    Get.dialog(
      TypeParkingRegisterModal(
        doorId: entranceIdSelected?.idPuerta?.toString(),
        mainParkingEntry: MainParkingEntry.validation,
      ),
      barrierDismissible: true,
    );
  }

  // Navegación a ingreso de parqueo
  void goToEntry() {
    if (entranceIdSelected == null) {
      _showGateSelectionDialog();
      return;
    }
    
    // Mostrar el modal de tipo de registro sin la opción "Buscar"
    Get.dialog(
      TypeParkingRegisterModal(
        doorId: entranceIdSelected?.idPuerta?.toString(),
        showSearchOption: false, // Ocultar opción de búsqueda para ingreso
        mainParkingEntry: MainParkingEntry.entry,
      ),
      barrierDismissible: true,
    );
  }

  // Navegación a salida de parqueo
  void goToExit() {
    if (entranceIdSelected == null) {
      _showGateSelectionDialog();
      return;
    }
    
    // Mostrar el modal de tipo de registro para salida
    Get.dialog(
      TypeParkingRegisterModal(
        doorId: entranceIdSelected?.idPuerta?.toString(),
        mainParkingEntry: MainParkingEntry.exit,
      ),
      barrierDismissible: true,
    );
  }

  // Navegación a historial
  void goToHistory() {
    Get.to(() => const HistoricParkinPage());
  }

  // Método para volver atrás
  void goBack() {
    Get.back();
  }

  // Método privado para mostrar diálogo cuando no hay puerta seleccionada
  void _showGateSelectionDialog() {
    // Por ahora usamos snackbar, pero se puede cambiar a diálogo modal si se requiere
    Get.snackbar(
      'Informativo',
      'Debe seleccionar una puerta de parqueo antes de continuar',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: const Color(0xFFE8D6D3),
      colorText: const Color(0xFF231918),
    );
  }
}