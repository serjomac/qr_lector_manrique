import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_parking.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_lector.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/parking/validate_parking/validate_parking_page.dart';
import 'package:qr_scaner_manrique/pages/parking/vehicle_list/vehicles_list_page.dart';
import 'package:qr_scaner_manrique/pages/qr_scanner/ui/scan_camera.dart';
import 'package:qr_scaner_manrique/pages/parking/type_parking_register/search_code_modal.dart';
import 'package:qr_scaner_manrique/pages/parking/register_parking/manual/manual_parking_register_page.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_page.dart';

enum ParkingValidationType {
  qr,
  search,
  manual,
}

class TypeParkingRegisterController extends GetxController {
  // Door ID parameter
  final String? doorId;
  
  // Main parking entry type
  final MainParkingEntry mainParkingEntry;

  // API instances
  final ApiParking _apiParking = ApiParking();
  final ApiLector _apiLector = ApiLector();

  // Constructor
  TypeParkingRegisterController({
    this.doorId,
    this.mainParkingEntry = MainParkingEntry.validation,
  });

  // Opción seleccionada
  Rx<ParkingValidationType?> selectedType = Rx<ParkingValidationType?>(null);

  // Estado de carga para el botón continuar
  RxBool isLoading = false.obs;

  // Método para seleccionar un tipo de validación
  void selectType(ParkingValidationType type) {
    selectedType.value = type;
  }

  // Método para continuar con la opción seleccionada
  void continueWithSelectedType() {

    isLoading.value = true;

    // Navegar según la opción seleccionada
    switch (selectedType.value!) {
      case ParkingValidationType.qr:
        navigateToQrScanner();
        break;
      case ParkingValidationType.search:
        navigateToSearch();
        break;
      case ParkingValidationType.manual:
        navigateToManual();
        break;
    }

    isLoading.value = false;
  }

  // Navegación a scanner QR con lógica completa
  Future<void> navigateToQrScanner() async {
    Get.back(); // Cerrar el modal

    try {
      print('Opción Por QR seleccionada');

      // Abrir QR scanner
      final qrResult = await Get.to(
        const ScanCamera(),
        fullscreenDialog: true,
        duration: const Duration(milliseconds: 400),
      );

      if (qrResult != null && qrResult.isNotEmpty) {
        print('QR escaneado: $qrResult');

        // Activar loading state
        isLoading.value = true;

        // Llamar al servicio lectorParqueo usando la variable de clase
        final String placeId =
            UserData.sharedInstance.placeSelected?.idLugar?.toString() ?? '1';
        final String idUsuarioAdmin =
            UserData.sharedInstance.userLogin?.idUsuarioAdmin?.toString() ??
                '5';

        // Determinar el tipo de ingreso según el mainParkingEntry
        String tipoIngreso;
        switch (mainParkingEntry) {
          case MainParkingEntry.entry:
            tipoIngreso = 'I'; // Ingreso
            break;
          case MainParkingEntry.exit:
            tipoIngreso = 'S'; // Salida
            break;
          case MainParkingEntry.validation:
          default:
            tipoIngreso = 'V'; // Validación
            break;
        }

        // Para entrada general, usar ApiLector.validateQrCode()
        if (mainParkingEntry == MainParkingEntry.entry) {
          final lectorResponse = await _apiLector.validateQrCode(
            code: qrResult,
            placeId: placeId,
            entranceId: doorId ?? '1',
            userId: idUsuarioAdmin,
          );

          // Navegar a AddEntryFormPage con el LectorResponse
          Get.to(() => AddEntryFormPage(lectorResponse: lectorResponse));
        } else {
          // Para parqueo (validación/salida), usar ApiParking.lectorParqueo()
          final vehicleData = await _apiParking.lectorParqueo(
            codigo: qrResult,
            idLugar: placeId,
            idPuerta: doorId ?? '1',
            tipoIngreso: tipoIngreso,
            idUsuarioAdmin: idUsuarioAdmin,
          );

          // Para otros casos (validación, salida), navegar a ValidateParkingPage
          Get.to(() => ValidateParkingPage(
                vehicleData: vehicleData,
                mainParkingEntry: mainParkingEntry,
              ));
        }
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // Navegación a búsqueda - mostrar modal de código
  void navigateToSearch() {
    Get.back(); // Cerrar el modal actual

    // Importar y mostrar el modal de búsqueda por código
    Get.dialog(
      SearchCodeModal(controller: this),
      barrierDismissible: false,
    );
  }

  // Buscar por código usando lectorParqueo
  Future<void> searchByCode(String code) async {
    try {
      isLoading.value = true;

      // Llamar al servicio lectorParqueo
      final String placeId =
          UserData.sharedInstance.placeSelected?.idLugar?.toString() ?? '1';
      final String idUsuarioAdmin =
          UserData.sharedInstance.userLogin?.idUsuarioAdmin?.toString() ?? '5';

      final vehicleData = await _apiParking.lectorParqueo(
        codigo: code,
        idLugar: placeId,
        idPuerta: doorId ?? '1',
        tipoIngreso: mainParkingEntry == MainParkingEntry.validation ? 'V' : mainParkingEntry == MainParkingEntry.entry ? 'I' : 'S',
        idUsuarioAdmin: idUsuarioAdmin,
      );

      // Cerrar el modal de búsqueda solo si es exitoso
      Get.back();

      // Navegar a ValidateParkingPage
      Get.to(() => ValidateParkingPage(
        vehicleData: vehicleData,
        mainParkingEntry: mainParkingEntry,
      ));

    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // Navegación a registro manual
  void navigateToManual() {
    Get.back(); // Cerrar el modal
    
    // Navegar según el tipo de entrada principal
    switch (mainParkingEntry) {
      case MainParkingEntry.entry:
        // Para ingreso, navegar a formulario manual de ingreso
        Get.to(() => const ManualParkingRegisterPage());
        print('Navegando a formulario manual de ingreso de parqueo');
        break;
      case MainParkingEntry.validation:
      case MainParkingEntry.exit:
      default:
        // Para validación y salida, navegar a lista de vehículos
        Get.to(() => VehiclesListPage(doorId: doorId, mainParkingEntry: mainParkingEntry));
        print('Navegando a lista de vehículos para validación/salida');
        break;
    }
  }

  // Cerrar el modal
  void closeModal() {
    Get.back();
  }
}
