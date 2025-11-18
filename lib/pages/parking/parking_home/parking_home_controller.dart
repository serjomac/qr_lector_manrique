import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_managr.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_parking.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/parking/historic_parking/historic_parkin_page.dart';
import 'package:qr_scaner_manrique/pages/parking/plate_search/plate_search_modal.dart';
import 'package:qr_scaner_manrique/pages/parking/type_parking_register/parking_validation_type.dart';
import 'package:qr_scaner_manrique/pages/parking/type_parking_register/type_parking_register_modal.dart';
import 'package:qr_scaner_manrique/pages/parking/validate_parking/validate_parking_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';

class ParkingHomeController extends GetxController {
  ApiManager apiManager = ApiManager();
  ApiParking apiParking = ApiParking();
  
  // Lista de puertas de parqueo
  List<GateDoor> parkingEntrances = [];
  RxBool entrancesLoading = true.obs;
  GateDoor? entranceIdSelected;
  
  // Estados de carga para las operaciones
  RxBool validatingQrCodeLoading = false.obs;
  RxBool entranceFormLoading = false.obs;
  RxBool exitFormLoading = false.obs;
  RxBool plateSearchLoading = false.obs;

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

  // Navegación a búsqueda por placa
  void goToPlateSearch() {
    // Mostrar modal de búsqueda por placa
    Get.dialog(
      PlateSearchModal(
        onSearch: searchByPlate,
      ),
      barrierDismissible: true,
    );
  }

  // Método para buscar vehículo por placa
  Future<void> searchByPlate(String placa, DateTime startDate, DateTime endDate) async {
    try {
      plateSearchLoading.value = true;

      // Usar las fechas proporcionadas por el modal
      final String fechaInicio = _formatDateTime(startDate);
      final String fechaTermino = _formatDateTime(endDate);

      log('Searching plate: $placa from $fechaInicio to $fechaTermino');

      // Llamar al API - ahora retorna una lista
      final List<ParrkingResponse> vehiclesList = await apiParking.getIngreso_placa(
        placa: placa,
        idLugar: UserData.sharedInstance.placeSelected!.idLugar.toString(),
        fechaInicio: fechaInicio,
        fechaTermino: fechaTermino,
      );

      // Verificar la cantidad de resultados
      if (vehiclesList.isEmpty) {
        _showNoVehiclesFoundDialog(placa);
        return;
      }

      // Si solo hay un vehículo, verificar si ya salió
      if (vehiclesList.length == 1) {
        final vehicle = vehiclesList[0];
        if (vehicle.estado?.toUpperCase() == 'SALIDA') {
          _showVehicleAlreadyExitedDialog();
          return;
        }
        await _loadAndNavigateToVehicleDetails(vehicle);
        return;
      }

      // Si hay más de un vehículo, mostrar bottom sheet con la lista
      _showVehiclesListBottomSheet(vehiclesList);

    } catch (e) {
      log('Error searching by plate: $e');
      Get.snackbar(
        'Error',
        'Ocurrió un error al buscar el vehículo',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFE8D6D3),
        colorText: const Color(0xFF231918),
      );
    } finally {
      plateSearchLoading.value = false;
    }
  }

  // Método para mostrar el bottom sheet con la lista de vehículos
  void _showVehiclesListBottomSheet(List<ParrkingResponse> vehicles) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(Get.overlayContext!).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header del bottom sheet
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Column(
                children: [
                  // Línea indicadora
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Título
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vehículos encontrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF231918),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${vehicles.length} registro${vehicles.length != 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF231918),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Lista de vehículos
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return _buildVehicleCard(vehicle);
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  // Widget para construir cada tarjeta de vehículo
  Widget _buildVehicleCard(ParrkingResponse vehicle) {
    // Determinar el color según el estado
    Color statusColor;
    Color statusBgColor;
    String statusText = vehicle.estado ?? 'Sin estado';
    
    switch (vehicle.estado?.toUpperCase()) {
      case 'INGRESO':
        statusColor = const Color(0xFF084F9C);
        statusBgColor = const Color(0xFFCDE7FE);
        break;
      case 'VALIDO':
      case 'VALIDADO':
        statusColor = const Color(0xFF036546);
        statusBgColor = const Color(0xFFCFF9E6);
        break;
      case 'RETIRADO':
        statusColor = const Color(0xFFB86E00);
        statusBgColor = const Color(0xFFFEEFC8);
        break;
      case 'CADUCADO':
        statusColor = const Color(0xFFA10101);
        statusBgColor = const Color(0xFFFEC8C8);
        break;
      default:
        statusColor = const Color(0xFF534340);
        statusBgColor = const Color(0xFFF5F5F5);
    }

    return GestureDetector(
      onTap: () => _onVehicleSelected(vehicle),
      child: Container(
        height: 123,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(69, 63, 61, 0.1),
              offset: Offset(0, 4),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Color.fromRGBO(69, 63, 61, 0.03),
              offset: Offset(0, 8),
              blurRadius: 50,
              spreadRadius: 7,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Door label (top left)
            Positioned(
              left: 19,
              top: 17,
              child: Text(
                (vehicle.ingreso?.nombrePuertaIngreso ?? vehicle.nombrePuerta ?? 'Puerta').toString().toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5B5856),
                ),
              ),
            ),
            
            // Status badge (top right)
            Positioned(
              right: 15,
              top: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  border: Border.all(color: statusColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ),
            
            // Vehicle info section (left)
            Positioned(
              left: 14,
              top: 40,
              child: Container(
                width: 160,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    // Vehicle icon
                    Container(
                      width: 32,
                      height: 31,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        color: Color(0xFF5B5856),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Plate info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Placa',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF5B5856),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            vehicle.placa?.toUpperCase() ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFEB472A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Garita badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFF565656)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              vehicle.ingreso?.tipoIngreso ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF565656),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Time section (right)
            Positioned(
              right: 50,
              top: 45,
              child: Column(
                children: [
                  // Ingreso time
                  Column(
                    children: [
                      const Text(
                        'Ingreso',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5B5856),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDateTimeForCard(vehicle.fechaIngreso),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5B5856),
                        ),
                      ),
                    ],
                  ),
                  
                  // Separator
                  Container(
                    width: 5,
                    height: 2,
                    color: const Color(0xFFC3C3C3),
                  ),
                  
                  // Validación time
                  Column(
                    children: [
                      const Text(
                        'Validación',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5B5856),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDateTimeForCard(vehicle.fechaValidacion),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5B5856),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Accumulated time (top right, below status)
            Positioned(
              right: 90,
              top: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Tiempo acumulado',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5B5856),
                    ),
                  ),
                  Text(
                    _calculateAccumulatedTime(vehicle),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5B5856),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para calcular el tiempo acumulado
  String _calculateAccumulatedTime(ParrkingResponse vehicle) {
    if (vehicle.fechaIngreso == null) return '0h 0min';
    
    final DateTime ingreso = vehicle.fechaIngreso!;
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(ingreso);
    
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes.remainder(60);
    
    return '${hours}h ${minutes}min';
  }

  // Método para formatear fecha/hora para las tarjetas
  String _formatDateTimeForCard(DateTime? dateTime) {
    if (dateTime == null) return '---';
    
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$day-$month-$year $hour:$minute';
  }

  // Método que se ejecuta al seleccionar un vehículo de la lista
  Future<void> _onVehicleSelected(ParrkingResponse vehicle) async {
    // Verificar si el vehículo ya ha salido
    if (vehicle.estado?.toUpperCase() == 'SALIDA') {
      // No cerrar el bottom sheet, mostrar el diálogo sobre la lista
      _showVehicleAlreadyExitedDialog();
      return;
    }

    // Cerrar el bottom sheet si está abierto antes de navegar
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    
    await _loadAndNavigateToVehicleDetails(vehicle);
  }

  // Método para cargar los detalles del vehículo y navegar
  Future<void> _loadAndNavigateToVehicleDetails(ParrkingResponse vehicle) async {
    try {
      // Mostrar loading
      _showLoadingDialog();

      // Obtener los detalles completos del vehículo
      final ParrkingResponse vehicleDetails = await _fetchVehicleDetails(vehicle);

      // Cerrar el loading
      _closeLoadingDialog();

      // Determinar el tipo de entrada y navegar
      final MainParkingEntry entryType = _determineEntryType(vehicleDetails);
      
      log('Vehicle details loaded with state: ${vehicleDetails.estado}, navigating to: $entryType');

      // Navegar a ValidateParkingPage
      _navigateToValidatePage(vehicleDetails, entryType);

    } catch (e) {
      _closeLoadingDialog();
      _showErrorSnackbar('Ocurrió un error al cargar los detalles del vehículo');
      log('Error loading vehicle details: $e');
    }
  }

  // Método para obtener los detalles del vehículo desde el API
  Future<ParrkingResponse> _fetchVehicleDetails(ParrkingResponse vehicle) async {
    final String idIngreso = vehicle.idIngreso?.toString() ?? '';
    final String idLugar = UserData.sharedInstance.placeSelected?.idLugar?.toString() ?? '';
    final String idPuerta = entranceIdSelected?.idPuerta?.toString() ?? '';
    final String idUsuarioAdmin = UserData.sharedInstance.userLogin?.idUsuarioAdmin?.toString() ?? '';
    final String tipoIngreso = _determineTipoIngreso(vehicle.estado);

    log('Calling getParqueoIngreso with: idIngreso=$idIngreso, tipoIngreso=$tipoIngreso');

    return await apiParking.getParqueoIngreso(
      idIngreso: idIngreso,
      idLugar: idLugar,
      idPuerta: idPuerta,
      tipoIngreso: tipoIngreso,
      idUsuarioAdmin: idUsuarioAdmin,
    );
  }

  // Método para determinar el tipo de ingreso basado en el estado
  String _determineTipoIngreso(String? estado) {
    final estadoUpper = estado?.toUpperCase();
    
    if (estadoUpper == 'INGRESADO') {
      return 'V'; // Validación
    } else if (estadoUpper == 'VALIDO' || estadoUpper == 'VALIDADO') {
      return 'S'; // Salida
    }
    
    return 'V'; // Por defecto validación
  }

  // Método para determinar MainParkingEntry basado en el estado del vehículo
  MainParkingEntry _determineEntryType(ParrkingResponse vehicleDetails) {
    final estadoUpper = vehicleDetails.estado?.toUpperCase();
    
    if (estadoUpper == 'INGRESADO') {
      return MainParkingEntry.validation;
    } else if (estadoUpper == 'VALIDO' || estadoUpper == 'VALIDADO') {
      return MainParkingEntry.exit;
    }
    
    // Para otros estados, usar validation como default
    return MainParkingEntry.validation;
  }

  // Método para navegar a la página de validación
  void _navigateToValidatePage(ParrkingResponse vehicleData, MainParkingEntry entryType) {
    Get.to(() => ValidateParkingPage(
          vehicleData: vehicleData,
          mainParkingEntry: entryType,
          validationType: ParkingValidationType.manual,
        ));
  }

  // Método para mostrar el diálogo de loading
  void _showLoadingDialog() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF231918),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Método para cerrar el diálogo de loading
  void _closeLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // Método para mostrar diálogo cuando no se encuentran vehículos
  void _showNoVehiclesFoundDialog(String placa) {
    Get.dialog(
      AlertDialog(
        title: const Text('No se encontró vehículo'),
        content: Text('No hay registros con la placa "$placa" en el rango de fechas seleccionado'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Método para mostrar diálogo cuando el vehículo ya ha salido
  void _showVehicleAlreadyExitedDialog() {
    Get.dialog(
      SuccessDialog(
        title: 'Vehículo ya salió',
        subtitle: 'El vehículo ya ha salido del parqueadero',
        onTapAcept: () => Get.back(),
        primaryButtonText: 'Aceptar',
      ),
      barrierDismissible: false,
    );
  }

  // Método para mostrar snackbar de error
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFE8D6D3),
      colorText: const Color(0xFF231918),
    );
  }

  // Método auxiliar para formatear fecha y hora
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-'
           '${dateTime.month.toString().padLeft(2, '0')}-'
           '${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}:'
           '${dateTime.second.toString().padLeft(2, '0')}';
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