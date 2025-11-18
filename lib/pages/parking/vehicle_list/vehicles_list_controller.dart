import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_parking.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/parking/validate_parking/validate_parking_page.dart';
import 'package:intl/intl.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:qr_scaner_manrique/pages/parking/type_parking_register/parking_validation_type.dart';

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

  // Main parking entry type
  final MainParkingEntry mainParkingEntry;

  // Constructor
  VehiclesValidationListController(
    {this.doorId, this.mainParkingEntry = MainParkingEntry.validation, required this.validationType});

  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool isCardLoading = false.obs;

  // API instance
  final ApiParking _apiParking = ApiParking();

  // Vehicle entries from API
  List<ParrkingResponse> vehicleEntries = [];
  List<ParrkingResponse> filteredVehicleEntries = [];

  // Validation type (qr, search, manual) to determine 'especial'
  final ParkingValidationType validationType;

  // Status filter property
  String? selectedStatusFilter;

  // Date filtering properties
  DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime endDate = DateTime.now();
  DateTime endDateTemprary = DateTime.now();

  bool get isEnglishLanguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }

  List<FilterLastDay> filterLastDay = [];

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

  // Índice del item seleccionado (reactivo para usar con Obx)
  final Rxn<int> selectedEntryIndex = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    // Inicializar con el filtro "Hoy" por defecto
    _initializeFilterLastDay();
    _lasDaysSelected = filterLastDay[0]; // "Hoy"
    print('Initialized with filter: ${_lasDaysSelected?.title}');
    print('Date range: ${rangeDateDescription}');
    // Forzar actualización de la UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });

    loadVehicleEntries();
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

  Future<void> loadVehicleEntries() async {
    try {
      isLoading.value = true;

      // Obtener placeId de UserData
      final String placeId =
          UserData.sharedInstance.placeSelected?.idLugar?.toString() ?? '1';

      // Formatear con fecha y hora: "YYYY-MM-DD HH:MM:SS"
      final String startDateFormatted =
          "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')} ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}:${startDate.second.toString().padLeft(2, '0')}";
      final String endDateFormatted =
          "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')} ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}:${endDate.second.toString().padLeft(2, '0')}";

      // Determinar el tipo de ingreso según el mainParkingEntry
      String entryType;
      switch (mainParkingEntry) {
        case MainParkingEntry.entry:
          entryType = 'I'; // Ingreso
          break;
        case MainParkingEntry.exit:
          entryType = 'V'; // Salida
          break;
        case MainParkingEntry.validation:
        default:
          entryType = 'I'; // Validación
          break;
      }

      final String doorIdParam =
          doorId ?? '1'; // Usar el doorId pasado como parámetro

      vehicleEntries = await _apiParking.getAllParqueoIngreso(
        placeId: placeId,
        startDate: startDateFormatted,
        endDate: endDateFormatted,
        entryType: entryType,
        doorId: doorIdParam,
      );

      // Update filtered entries
      filteredVehicleEntries = List.from(vehicleEntries);
      
      // Apply any existing filters
      _applyFilters();
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
        return 0xFF084F9C; // Orange
      case 'retirado':
        return 0xFFB86E00; // Red
      case 'caducado':
        return 0xFFA10101; // Gray
      default:
        return 0xFFB86E00; // Default orange
    }
  }

  int _getEstadoBgColor(ParrkingResponse entry) {
    final estado = entry.estado?.toLowerCase() ?? '';
    switch (estado) {
      case 'validado':
        return 0xFFCFF9E6; // Light green
      case 'ingresado':
        return 0xFFCDE7FE; // Light orange
      case 'retirado':
        return 0xFFFEEFC8; // Light red
      case 'caducado':
        return 0xFFFEC8C8; // Light gray
      default:
        return 0xFFFEEFC8; // Default light orange
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
    _applyFilters();
    update();
  }

  // Method to get status counts
  Map<String, int> getStatusCounts() {
    Map<String, int> counts = {};
    
    for (var entry in vehicleEntries) {
      final status = entry.estado?.toLowerCase() ?? 'sin estado';
      counts[status] = (counts[status] ?? 0) + 1;
    }
    
    return counts;
  }

  // Method to handle status filter tap
  void onStatusFilterTap(String? status) {
    selectedStatusFilter = status;
    _applyFilters();
    update();
  }

  // Apply both search and status filters
  void _applyFilters() {
    List<ParrkingResponse> result = List.from(vehicleEntries);
    
    // Apply status filter
    if (selectedStatusFilter != null) {
      result = result.where((entry) {
        final entryStatus = entry.estado?.toLowerCase() ?? 'sin estado';
        return entryStatus == selectedStatusFilter!.toLowerCase();
      }).toList();
    }
    
    // Apply search filter
    final searchQuery = placaController.text;
    if (searchQuery.isNotEmpty) {
      result = result.where((entry) =>
          (entry.placa ?? '').toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    
    filteredVehicleEntries = result;
  }

  // ParrkingResponse? get selectedEntry {
  //   if (selectedEntryIndex != null &&
  //       selectedEntryIndex! < filteredVehicleEntries.length) {
  //     return filteredVehicleEntries[selectedEntryIndex!];
  //   }
  //   return null;
  // }

  Future<void> onVehicleCardTap(ParrkingResponse selectedVehicle, int index) async {
    try {
      // Limpiar cualquier filtro aplicado en el buscador
      placaController.clear();
      searchByPlaca('');
      if (mainParkingEntry == MainParkingEntry.exit) {
        final result = await Get.to(() => ValidateParkingPage(
              vehicleData: selectedVehicle,
              mainParkingEntry: mainParkingEntry,
            ));

        // Si el resultado es true, actualizar la lista
        if (result == true) {
          await loadVehicleEntries();
        }
        return;
      }
  // Set the selected index and show loading
  selectedEntryIndex.value = index;
      isCardLoading.value = true;
      update();
      // Prepare parameters for getParqueoIngreso
      final String idIngreso = selectedVehicle.idIngreso?.toString() ?? '';
      final String idLugar =
          UserData.sharedInstance.placeSelected?.idLugar?.toString() ?? '';
      final String idPuerta = doorId ?? '';
      final String tipoIngreso = mainParkingEntry == MainParkingEntry.validation
          ? 'V'
          : mainParkingEntry == MainParkingEntry.entry
              ? 'I'
              : 'S';
      final String idUsuarioAdmin =
          UserData.sharedInstance.userLogin?.idUsuarioAdmin?.toString() ?? '5';

      // Call getParqueoIngreso service
      final ParrkingResponse vehicleDetails =
          await _apiParking.getParqueoIngreso(
        idIngreso: idIngreso,
        idLugar: idLugar,
        idPuerta: idPuerta,
        tipoIngreso: tipoIngreso,
        idUsuarioAdmin: idUsuarioAdmin,
      );

      // Navigate to ValidateParkingPage with the detailed vehicle data
  final result = await Get.to(() => ValidateParkingPage(
    vehicleData: vehicleDetails,
    mainParkingEntry: mainParkingEntry,
    validationType: validationType,
      ));

      // Si el resultado es true, actualizar la lista
      if (result == true) {
        await loadVehicleEntries();
      }
    } catch (e) {
    } finally {
      isCardLoading.value = false;
  selectedEntryIndex.value = null;
      update();
    }
  }

  @override
  void onClose() {
    placaController.dispose();
    super.onClose();
  }
}
