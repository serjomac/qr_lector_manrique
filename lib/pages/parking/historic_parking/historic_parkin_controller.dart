import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_scaner_manrique/pages/parking/historic_parking/parking_date_range_historic.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  
  // Loading state
  bool isLoading = false;
  
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
  void fetchVehicleRecords() {
    isLoading = true;
    update();
    
    // Simulate API call with different data based on date range
    Future.delayed(Duration(milliseconds: 500), () {
      _loadVehicleDataForDateRange();
      isLoading = false;
      update();
    });
  }
  
  void _loadVehicleDataForDateRange() {
    // Generate different sample data based on selected date range
    int daysDiff = endDate.difference(startDate).inDays;
    
    List<VehicleRecord> baseRecords = [
      VehicleRecord(
        placa: 'GDF 4576',
        puerta: 'PUERTA X',
        horaIngreso: '10:45 AM',
        horaValidacion: '10:45 AM',
        tiempoAcumulado: '1h 45min',
        estado: VehicleStatus.validado,
        tipoValidacion: 'Garita',
      ),
      VehicleRecord(
        placa: 'ABC 1234',
        puerta: 'PUERTA Y',
        horaIngreso: '9:30 AM',
        horaValidacion: '9:35 AM',
        tiempoAcumulado: '2h 15min',
        estado: VehicleStatus.ingresado,
        tipoValidacion: 'Automático',
      ),
      VehicleRecord(
        placa: 'XYZ 9876',
        puerta: 'PUERTA Z',
        horaIngreso: '8:15 AM',
        horaValidacion: '8:20 AM',
        tiempoAcumulado: '3h 30min',
        estado: VehicleStatus.retirado,
        tipoValidacion: 'Manual',
      ),
      VehicleRecord(
        placa: 'DEF 5555',
        puerta: 'PUERTA X',
        horaIngreso: '7:00 AM',
        horaValidacion: '7:05 AM',
        tiempoAcumulado: '4h 45min',
        estado: VehicleStatus.caducado,
        tipoValidacion: 'Garita',
      ),
    ];
    
    // Add more records for longer periods
    if (daysDiff > 1) {
      baseRecords.addAll([
        VehicleRecord(
          placa: 'HIJ 7890',
          puerta: 'PUERTA Y',
          horaIngreso: '11:15 AM',
          horaValidacion: '11:20 AM',
          tiempoAcumulado: '2h 30min',
          estado: VehicleStatus.validado,
          tipoValidacion: 'Automático',
        ),
        VehicleRecord(
          placa: 'KLM 2468',
          puerta: 'PUERTA Z',
          horaIngreso: '2:45 PM',
          horaValidacion: '2:50 PM',
          tiempoAcumulado: '1h 15min',
          estado: VehicleStatus.ingresado,
          tipoValidacion: 'Manual',
        ),
      ]);
    }
    
    if (daysDiff > 3) {
      baseRecords.addAll([
        VehicleRecord(
          placa: 'NOP 1357',
          puerta: 'PUERTA X',
          horaIngreso: '4:20 PM',
          horaValidacion: '4:25 PM',
          tiempoAcumulado: '3h 45min',
          estado: VehicleStatus.retirado,
          tipoValidacion: 'Garita',
        ),
        VehicleRecord(
          placa: 'QRS 9753',
          puerta: 'PUERTA Y',
          horaIngreso: '6:10 PM',
          horaValidacion: '6:15 PM',
          tiempoAcumulado: '2h 10min',
          estado: VehicleStatus.caducado,
          tipoValidacion: 'Automático',
        ),
      ]);
    }
    
    vehicleRecords = baseRecords;
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
    // TODO: Implement filtering logic based on placa and tipo
    // For now, just show all records
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
  final String placa;
  final String puerta;
  final String horaIngreso;
  final String horaValidacion;
  final String tiempoAcumulado;
  final VehicleStatus estado;
  final String tipoValidacion;
  
  VehicleRecord({
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
        return const Color(0xFFFEEFC8); // Light orange
      case VehicleStatus.retirado:
        return const Color(0xFFFEC8C8); // Light red
      case VehicleStatus.validado:
        return const Color(0xFFCFF9E6); // Light green
      case VehicleStatus.caducado:
        return const Color(0xFFE5E8EC); // Light gray
    }
  }
  
  Color get textColor {
    switch (this) {
      case VehicleStatus.ingresado:
        return const Color(0xFFB86E00); // Orange
      case VehicleStatus.retirado:
        return const Color(0xFFA10101); // Red
      case VehicleStatus.validado:
        return const Color(0xFF036546); // Green
      case VehicleStatus.caducado:
        return const Color(0xFF565656); // Gray
    }
  }
  
  Color get borderColor {
    switch (this) {
      case VehicleStatus.ingresado:
        return const Color(0xFFB86E00); // Orange
      case VehicleStatus.retirado:
        return const Color(0xFFA10101); // Red
      case VehicleStatus.validado:
        return const Color(0xFF036546); // Green
      case VehicleStatus.caducado:
        return const Color(0xFF565656); // Gray
    }
  }
}