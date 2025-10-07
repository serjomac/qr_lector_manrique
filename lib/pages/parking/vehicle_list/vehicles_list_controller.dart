import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_parking.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/parking/validate_parking/validate_parking_page.dart';
import 'package:intl/intl.dart';

// Clase para filtros de fecha
class FilterLastDay {
  final String title;
  final int value;
  FilterLastDay({required this.title, required this.value});
}

class VehiclesValidationListController extends GetxController {
  // Text controller for search field
  final TextEditingController placaController = TextEditingController();
  
  // Door ID parameter
  final String? doorId;
  
  // Constructor
  VehiclesValidationListController({this.doorId});
  
  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isCardLoading = false.obs;
  
  // API instance
  final ApiParking _apiParking = ApiParking();
  
  // Vehicle entries from API
  List<ParrkingResponse> vehicleEntries = [];
  List<ParrkingResponse> filteredVehicleEntries = [];
  
  // Date filtering properties
  DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime endDate = DateTime.now();
  DateTime endDateTemprary = DateTime.now();
  
  // Filtros de fecha predefinidos
  List<FilterLastDay> filterLastDay = [
    FilterLastDay(title: 'Hoy', value: 0),
    FilterLastDay(title: 'Ayer', value: 1),
    FilterLastDay(title: '7 días', value: 7),
    FilterLastDay(title: '15 días', value: 15),
    FilterLastDay(title: '30 días', value: 30),
  ];
  
  FilterLastDay? _lasDaysSelected;
  
  // Getter y setter para el filtro de días seleccionado
  set lasDaysSelected(FilterLastDay? filterLastDay) {
    _lasDaysSelected = filterLastDay;
    endDate = DateTime.now();
    endDateTemprary = DateTime.now();
    startDate = endDate.subtract(Duration(days: filterLastDay?.value ?? 1));
    update();
    loadVehicleEntries();
  }
  
  FilterLastDay? get lasDaysSelected {
    return _lasDaysSelected;
  }
  
  // Descripción del rango de fechas
  String get rangeDateDescription {
    final formatter = DateFormat('dd MMM yyyy');
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }
  

  int? selectedEntryIndex;

  @override
  void onInit() {
    super.onInit();
    // Inicializar con el filtro "Hoy" por defecto
    _lasDaysSelected = filterLastDay[0]; // "Hoy"
    print('Initialized with filter: ${_lasDaysSelected?.title}');
    print('Date range: ${rangeDateDescription}');
    
    // Forzar actualización de la UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
    
    loadVehicleEntries();
  }

  Future<void> loadVehicleEntries() async {
    try {
      isLoading.value = true;
      
      // Obtener placeId de UserData
      final String placeId = UserData.sharedInstance.placeSelected?.idLugar?.toString() ?? '1';
      
      // Formatear con fecha y hora: "YYYY-MM-DD HH:MM:SS"
      final String startDateFormatted = "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')} ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}:${startDate.second.toString().padLeft(2, '0')}";
      final String endDateFormatted = "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')} ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}:${endDate.second.toString().padLeft(2, '0')}";
      final String entryType = 'I'; // 'I' para ingreso
      final String doorIdParam = doorId ?? '1'; // Usar el doorId pasado como parámetro
      
      vehicleEntries = await _apiParking.getAllParqueoIngreso(
        placeId: placeId,
        startDate: startDateFormatted,
        endDate: endDateFormatted,
        entryType: entryType,
        doorId: doorIdParam,
      );
      
      // Update filtered entries
      filteredVehicleEntries = List.from(vehicleEntries);
      
    } catch (e) {
      print('Error loading vehicle entries: $e');
      // Clear entries on error
      vehicleEntries.clear();
      filteredVehicleEntries.clear();
    } finally {
      isLoading.value = false;
      update();
    }
  }



  String _getEstadoFromApi(ParrkingResponse entry) {
    // Use the actual estado field from API
    return entry.estado ?? 'Sin estado';
  }

  int _getEstadoColor(ParrkingResponse entry) {
    final estado = entry.estado?.toLowerCase() ?? '';
    switch (estado) {
      case 'validado':
        return 0xFF036546; // Green
      case 'ingresado':
        return 0xFFEB472A; // Red
      case 'retirado':
        return 0xFF5B5856; // Gray
      case 'caducado':
        return 0xFFC3C3C3; // Light gray
      default:
        return 0xFFEB472A; // Default red
    }
  }

  int _getEstadoBgColor(ParrkingResponse entry) {
    final estado = entry.estado?.toLowerCase() ?? '';
    switch (estado) {
      case 'validado':
        return 0xFFCFF9E6; // Light green
      case 'ingresado':
        return 0xFFFFE5E0; // Light red
      case 'retirado':
        return 0xFFF2F2F2; // Light gray
      case 'caducado':
        return 0xFFF8F8F8; // Very light gray
      default:
        return 0xFFFFE5E0; // Default light red
    }
  }

  String _calculateAccumulatedTime(ParrkingResponse entry) {
    if (entry.fechaIngreso == null) return '0h 0min';
    
    final DateTime ingreso = entry.fechaIngreso!;
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(ingreso);
    
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes.remainder(60);
    
    return '${hours}h ${minutes}min';
  }

  void searchByPlaca(String query) {
    if (query.isEmpty) {
      filteredVehicleEntries = List.from(vehicleEntries);
    } else {
      filteredVehicleEntries = vehicleEntries
          .where((entry) => (entry.placa ?? '')
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    update();
  }

  ParrkingResponse? get selectedEntry {
    if (selectedEntryIndex != null && selectedEntryIndex! < filteredVehicleEntries.length) {
      return filteredVehicleEntries[selectedEntryIndex!];
    }
    return null;
  }

  Future<void> onVehicleCardTap(int index) async {
    try {
      // Limpiar cualquier filtro aplicado en el buscador
      placaController.clear();
      searchByPlaca('');
      
      // Set the selected index and show loading
      selectedEntryIndex = index;
      isCardLoading.value = true;
      update();
      
      final selectedVehicle = filteredVehicleEntries[index];
      
      // Prepare parameters for getParqueoIngreso
      final String idIngreso = selectedVehicle.idIngreso?.toString() ?? '';
      final String idLugar = UserData.sharedInstance.placeSelected?.idLugar?.toString() ?? '';
      final String idPuerta = doorId ?? '';
      final String tipoIngreso = 'V'; // V para validación
      final String idUsuarioAdmin = UserData.sharedInstance.userLogin?.idUsuarioAdmin?.toString() ?? '5';
      
      // Call getParqueoIngreso service
      final ParrkingResponse vehicleDetails = await _apiParking.getParqueoIngreso(
        idIngreso: idIngreso,
        idLugar: idLugar,
        idPuerta: idPuerta,
        tipoIngreso: tipoIngreso,
        idUsuarioAdmin: idUsuarioAdmin,
      );
      
      // Navigate to ValidateParkingPage with the detailed vehicle data
      final result = await Get.to(() => ValidateParkingPage(
        vehicleData: vehicleDetails,
        mainParkingEntry: MainParkingEntry.validation,
      ));
      
      // Si el resultado es true, actualizar la lista
      if (result == true) {
        await loadVehicleEntries();
      }
      
    } catch (e) {
      print('Error al obtener detalles del vehículo: $e');
      Get.snackbar(
        'Error',
        'No se pudieron cargar los detalles del vehículo',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isCardLoading.value = false;
      update();
    }
  }

  @override
  void onClose() {
    placaController.dispose();
    super.onClose();
  }
}