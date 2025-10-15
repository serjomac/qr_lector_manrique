import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_scaner_manrique/pages/parking/historic_parking/parking_date_range_historic.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_parking.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/parking_history_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/pages/parking/validate_parking/validate_parking_page.dart';

class FilterLastDay {
  final String title;
  final int value;
  FilterLastDay({required this.title, required this.value});
}

class HistoricParkinController extends GetxController {
  // Text controllers for form fields
  final TextEditingController placaController = TextEditingController();
  
  // Dropdown values
  String selectedTipo = 'Todos';
  final List<String> tiposVehiculo = ['Todos', 'Ocasional', 'Permanente', 'Temporal'];
  
  // Date range properties
  DateTime startDate = DateTime.now().subtract(Duration(days: 1));
  DateTime endDate = DateTime.now();
  DateTime endDateTemprary = DateTime.now();
  
  // Filter properties
  List<FilterLastDay> filterLastDay = [];
  FilterLastDay? _lasDaysSelected;
  
  // Language support
  bool get isEnglishLanguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }
  
  // Date range
  String selectedDateRange = 'Último día';
  
  // Vehicle records list
  List<VehicleRecord> vehicleRecords = [];
  List<VehicleRecord> allVehicleRecords = []; // Original unfiltered list
  
  // API parking history data
  List<ParkingHistoryResponse> parkingHistoryData = [];
  
  // Filter properties
  VehicleStatus? selectedStatusFilter;
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // API instance
  final ApiParking _apiParking = ApiParking();
  
  @override
  void onInit() async {
    super.onInit();
    await initializeDateFormatting('es', '');
    _initializeFilterLastDay();
    // Initialize with vehicle data for the default date range
    fetchVehicleRecords();
  }
  
  void _initializeFilterLastDay() {
    filterLastDay = [
      FilterLastDay(
          title: isEnglishLanguage ? 'Last day' : 'Último día', value: 1),
      FilterLastDay(
          title: isEnglishLanguage ? 'Last 3 days' : 'Últimos 3 días',
          value: 3),
      FilterLastDay(
          title: isEnglishLanguage ? 'Last 5 days' : 'Últimos 5 días',
          value: 5),
      FilterLastDay(
          title: isEnglishLanguage ? 'Last 7 days' : 'Últimos 7 días',
          value: 7),
    ];
  }
  
  // Getters and setters for date range
  set lasDaysSelected(FilterLastDay? filterLastDay) {
    _lasDaysSelected = filterLastDay;
    endDate = DateTime.now();
    endDateTemprary = DateTime.now();
    startDate = endDate.subtract(Duration(days: filterLastDay?.value ?? 7));
    // Reload vehicle records based on new date range
    fetchVehicleRecords();
  }

  FilterLastDay? get lasDaysSelected {
    return _lasDaysSelected;
  }
  
  String get rangeDateDescription {
    return '${DateFormat.yMMMd('ES').format(startDate)} - ${DateFormat.yMMMd('ES').format(endDate)}';
  }
  
  // Method to fetch vehicle records based on date range
  Future<void> fetchVehicleRecords({bool clearFilters = false}) async {
    try {
      isLoading.value = true;
      
      // Clear filters if requested (e.g., on refresh)
      if (clearFilters) {
        this.clearFilters();
      }
      
      // Get placeId from UserData
      final String placeId = UserData.sharedInstance.placeSelected?.idLugar?.toString() ?? '1';
      
      // Format dates for API: "YYYY-MM-DD HH:MM:SS"
      final String startDateFormatted =
          "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')} ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}:${startDate.second.toString().padLeft(2, '0')}";
      final String endDateFormatted =
          "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')} ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}:${endDate.second.toString().padLeft(2, '0')}";
      
      // Use a default door ID (you can modify this as needed)
      const String doorId = '20';
      
      // Call API service
      parkingHistoryData = await _apiParking.getAllParqueoHistorial(
        placeId: placeId,
        startDate: startDateFormatted,
        endDate: endDateFormatted,
        doorId: doorId,
      );
      
      // Convert API data to VehicleRecord format for UI compatibility
      _mapApiDataToVehicleRecords();
      
    } catch (e) {
      print('Error fetching parking history: $e');
      // Clear data on error
      parkingHistoryData.clear();
      allVehicleRecords.clear();
      vehicleRecords.clear();
    } finally {
      isLoading.value = false;
      update();
    }
  }
  
  void _mapApiDataToVehicleRecords() {
    allVehicleRecords = parkingHistoryData.map((parkingData) {
      return VehicleRecord(
        idIngreso: parkingData.idIngreso,
        placa: parkingData.placa?.toUpperCase() ?? 'N/A',
        puerta: (parkingData.nombrePuerta ?? '').toUpperCase(),
        horaIngreso: _formatTime(parkingData.fechaIngreso),
        horaValidacion: _formatTime(parkingData.fechaValidacion),
        tiempoAcumulado: _calculateAccumulatedTime(parkingData),
        estado: _mapApiStatusToVehicleStatus(parkingData.estado),
        tipoValidacion: parkingData.ingreso?.tipoIngreso ?? 'N/A',
      );
    }).toList();
    
    // Apply current filters
    _filterRecords();
  }
  
  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '---';
    
    // Format as dd - mm - yyyy hh:mm
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$day-$month-$year $hour:$minute';
  }
  
  String _calculateAccumulatedTime(ParkingHistoryResponse parkingData) {
    if (parkingData.fechaIngreso == null) return '0h 0min';
    
    final DateTime ingreso = parkingData.fechaIngreso!;
    final DateTime endTime = parkingData.fechaSalida ?? DateTime.now();
    final Duration difference = endTime.difference(ingreso);
    
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes.remainder(60);
    
    return '${hours}h ${minutes}min';
  }
  
  VehicleStatus _mapApiStatusToVehicleStatus(String? apiStatus) {
    switch (apiStatus?.toUpperCase()) {
      case 'INGRESADO':
        return VehicleStatus.ingresado;
      case 'SALIDA':
      case 'RETIRADO':
        return VehicleStatus.retirado;
      case 'VALIDADO':
        return VehicleStatus.validado;
      case 'CADUCADO':
        return VehicleStatus.caducado;
      default:
        return VehicleStatus.ingresado;
    }
  }
  
  void onSearchPlaca(String value) {
    placaController.text = value;
    _filterRecords();
    update();
  }
  
  void onTipoChanged(String? newTipo) {
    if (newTipo != null) {
      selectedTipo = newTipo;
      _filterRecords();
      update();
    }
  }
  
  void onDateRangePressed() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Theme.of(Get.context!).colorScheme.background,
      isScrollControlled: true,
      builder: (context) {
        return ParkingDateRangeHistoric();
      },
    );
  }
  
  void _filterRecords() {
    List<VehicleRecord> filteredRecords = List.from(allVehicleRecords);
    
    // Filter by status if selected
    if (selectedStatusFilter != null) {
      filteredRecords = filteredRecords
          .where((record) => record.estado == selectedStatusFilter)
          .toList();
    }
    
    // Filter by placa search
    final searchText = placaController.text.trim().toLowerCase();
    if (searchText.isNotEmpty) {
      filteredRecords = filteredRecords
          .where((record) => record.placa.toLowerCase().contains(searchText))
          .toList();
    }
    
    // Filter by tipo if not "Todos"
    if (selectedTipo != 'Todos') {
      filteredRecords = filteredRecords
          .where((record) => record.tipoValidacion.toLowerCase() == selectedTipo.toLowerCase())
          .toList();
    }
    
    vehicleRecords = filteredRecords;
  }
  
  void onStatusFilterTap(VehicleStatus? status) {
    selectedStatusFilter = status;
    _filterRecords();
    update();
  }
  
  void clearFilters() {
    selectedStatusFilter = null;
    placaController.clear();
    selectedTipo = 'Todos';
    _filterRecords();
    update();
  }
  
  Map<VehicleStatus, int> getStatusCounts() {
    Map<VehicleStatus, int> counts = {};
    
    for (VehicleStatus status in VehicleStatus.values) {
      counts[status] = allVehicleRecords
          .where((record) => record.estado == status)
          .length;
    }
    
    return counts;
  }
  
  void onVehicleRecordTap(VehicleRecord record) {
    // Find the corresponding parking history data
    final ParkingHistoryResponse? parkingData = parkingHistoryData.firstWhereOrNull(
      (data) => data.idIngreso == record.idIngreso,
    );
    
    if (parkingData != null) {
      // Convert ParkingHistoryResponse to ParrkingResponse for compatibility
      final ParrkingResponse vehicleData = _convertToParrkingResponse(parkingData);
      
      // Navigate to ValidateParkingPage with history mode
      Get.to(() => ValidateParkingPage(
        vehicleData: vehicleData,
        mainParkingEntry: MainParkingEntry.history,
      ));
    }
  }
  
  ParrkingResponse _convertToParrkingResponse(ParkingHistoryResponse historyData) {
    return ParrkingResponse(
      idIngreso: historyData.idIngreso,
      idLugar: historyData.idLugar,
      idPuerta: historyData.idPuerta,
      placa: historyData.placa,
      estado: historyData.estado,
      fechaIngreso: historyData.fechaIngreso,
      fechaValidacion: historyData.fechaValidacion,
      fechaSalida: historyData.fechaSalida,
      observacion: historyData.observacion,
      ingreso: historyData.ingreso != null ? Ingreso(
        idIngreso: historyData.ingreso!.idIngreso,
        idResidenteLugar: historyData.ingreso!.idResidenteLugar,
        idInvitacion: historyData.ingreso!.idInvitacion,
        idPuertaIngreso: historyData.ingreso!.idPuertaIngreso,
        idPuertaSalida: historyData.ingreso!.idPuertaSalida,
        nombrePuertaIngreso: historyData.ingreso!.nombrePuertaIngreso,
        nombrePuertaSalida: historyData.ingreso!.nombrePuertaSalida,
        idLugar: historyData.ingreso!.idLugar,
        cedula: historyData.ingreso!.cedula,
        celular: historyData.ingreso!.celular,
        placa: historyData.ingreso!.placa,
        imgIngreso: historyData.ingreso!.imgIngreso,
        imgValidacion: historyData.ingreso!.imgValidacion,
        imgSalida: historyData.ingreso!.imgSalida,
        tipoIngreso: historyData.ingreso!.tipoIngreso,
        tipoSalida: historyData.ingreso!.tipoSalida,
        actividad: historyData.ingreso!.actividad,
        observacionIngreso: historyData.ingreso!.observacionIngreso,
        observacionValidacion: historyData.ingreso!.observacionValidacion,
        observacionSalida: historyData.ingreso!.observacionSalida,
        estado: historyData.ingreso!.estado,
        fechaIngreso: historyData.ingreso!.fechaIngreso,
        fechaValidacion: historyData.ingreso!.fechaValidacion,
        fechaSalida: historyData.ingreso!.fechaSalida,
        tarifaAplicada: historyData.ingreso!.tarifaAplicada,
        tiempoTotal: historyData.ingreso!.tiempoTotal,
        valorTotal: historyData.ingreso!.valorTotal,
        tiempoHorasPago: historyData.ingreso!.tiempoHorasPago,
        mensaje: historyData.ingreso!.mensaje,
        fechaCreacion: historyData.ingreso!.fechaCreacion,
        fechaModificacion: historyData.ingreso!.fechaModificacion,
        usuarioCreacion: historyData.ingreso!.usuarioCreacion,
        usuarioModificacion: historyData.ingreso!.usuarioModificacion,
        nombresResidente: historyData.ingreso!.nombresResidente,
        apellidosResidente: historyData.ingreso!.apellidosResidente,
        cedulaResidente: historyData.ingreso!.cedulaResidente,
        celularResidente: historyData.ingreso!.celularResidente,
        primarioResidente: historyData.ingreso!.primarioResidente,
        secundarioResidente: historyData.ingreso!.secundarioResidente,
        nombresInvitado: historyData.ingreso!.nombresInvitado,
        idIngresoVinculo: historyData.ingreso!.idIngresoVinculo,
        idSalidaVinculo: historyData.ingreso!.idSalidaVinculo,
        nombreLugar: historyData.ingreso!.nombreLugar,
      ) : null,
    );
  }

  void onBackPressed() {
    Get.back();
  }
  
  @override
  void onClose() {
    placaController.dispose();
    super.onClose();
  }
}

// Vehicle record model
class VehicleRecord {
  final int? idIngreso;
  final String placa;
  final String puerta;
  final String horaIngreso;
  final String horaValidacion;
  final String tiempoAcumulado;
  final VehicleStatus estado;
  final String tipoValidacion;
  
  VehicleRecord({
    required this.idIngreso,
    required this.placa,
    required this.puerta,
    required this.horaIngreso,
    required this.horaValidacion,
    required this.tiempoAcumulado,
    required this.estado,
    required this.tipoValidacion,
  });
}

// Vehicle status enum
enum VehicleStatus {
  ingresado,
  retirado,
  validado,
  caducado,
}

// Extension for status colors and labels
extension VehicleStatusExtension on VehicleStatus {
  String get label {
    switch (this) {
      case VehicleStatus.ingresado:
        return 'Ingresado';
      case VehicleStatus.retirado:
        return 'Retirado';
      case VehicleStatus.validado:
        return 'Validado';
      case VehicleStatus.caducado:
        return 'Caducado';
    }
  }
  
  Color get backgroundColor {
    switch (this) {
      case VehicleStatus.ingresado:
        return const Color(0xFFCDE7FE); // Light orange
      case VehicleStatus.retirado:
        return const Color(0xFFFEEFC8); // Light red
      case VehicleStatus.validado:
        return const Color(0xFFCFF9E6); // Light green
      case VehicleStatus.caducado:
        return const Color(0xFFFEC8C8); // Light gray
    }
  }
  
  Color get textColor {
    switch (this) {
      case VehicleStatus.ingresado:
        return const Color(0xFF084F9C); // Orange
      case VehicleStatus.retirado:
        return const Color(0xFFB86E00); // Red
      case VehicleStatus.validado:
        return const Color(0xFF036546); // Green
      case VehicleStatus.caducado:
        return const Color(0xFFA10101); // Gray
    }
  }
  
  Color get borderColor {
    switch (this) {
      case VehicleStatus.ingresado:
        return const Color(0xFF084F9C); // Orange
      case VehicleStatus.retirado:
        return const Color(0xFFB86E00); // Red
      case VehicleStatus.validado:
        return const Color(0xFF036546); // Green
      case VehicleStatus.caducado:
        return const Color(0xFFA10101); // Gray
    }
  }
}