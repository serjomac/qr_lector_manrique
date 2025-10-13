import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_school.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/pending_school_regiter_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';

class PendingSchoolRegisterController extends GetxController {
  final ApiSchool apiSchool = ApiSchool();

  // Search controller for the text field
  final TextEditingController searchController = TextEditingController();

  // List to store the original pending school registers
  final RxList<PendingSchoolRegisterResponse> _allPendingRegisters = <PendingSchoolRegisterResponse>[].obs;

  // List to store the filtered pending school registers
  final RxList<PendingSchoolRegisterResponse> pendingRegisters = <PendingSchoolRegisterResponse>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Grouping state
  final RxBool isGrouped = false.obs;

  // Selected entrance
  final GateDoor? entranceIdSelected;

  PendingSchoolRegisterController({required this.entranceIdSelected});

  @override
  void onInit() {
    super.onInit();
    fetchPendingRegisters();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchPendingRegisters() async {
    try {
      isLoading.value = true;
      final placeId = UserData.sharedInstance.placeSelected!.idLugar.toString();
      final doorId = entranceIdSelected?.idPuerta.toString() ?? '1';
      final idUserAdmin = UserData.sharedInstance.userLogin!.idUsuarioAdmin.toString();
      final result = await apiSchool.getAllColegioPendiente(placeId, doorId, idUserAdmin);
      _allPendingRegisters.assignAll(result);
      pendingRegisters.assignAll(result);
    } catch (e) {
      // Handle error
      print('Error fetching pending registers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterRegisters() {
    final query = searchController.text.toLowerCase();
    List<PendingSchoolRegisterResponse> filteredList;
    
    if (query.isEmpty) {
      filteredList = List.from(_allPendingRegisters);
    } else {
      filteredList = _allPendingRegisters.where((register) {
        final nombresResidente = (register.nombresResidente ?? '').toLowerCase();
        final cedulaResidente = (register.cedulaResidente ?? '').toLowerCase();
        final apellidosResidente = (register.apellidosResidente ?? '').toLowerCase();
        final nombreHijo = (register.nombreHijo ?? '').toLowerCase();
        
        return nombresResidente.contains(query) ||
               cedulaResidente.contains(query) ||
               apellidosResidente.contains(query) ||
               nombreHijo.contains(query);
      }).toList();
    }
    
    // Apply grouping if enabled
    if (isGrouped.value) {
      filteredList = _groupByRepresentative(filteredList);
    }
    
    pendingRegisters.assignAll(filteredList);
    
    // Trigger rebuild for the search field UI
    update();
  }

  void toggleGrouping() {
    isGrouped.value = !isGrouped.value;
    filterRegisters(); // Re-filter with new grouping state
  }

  List<PendingSchoolRegisterResponse> _groupByRepresentative(List<PendingSchoolRegisterResponse> registers) {
    // Group by representative using tipo, idResidenteLugar and fechaCreacion as the key
    Map<String, List<PendingSchoolRegisterResponse>> grouped = {};
    
    for (var register in registers) {
      final tipo = register.tipo?.description ?? '';
      final idResidenteLugar = register.idResidenteLugar?.toString() ?? '';
      final fechaCreacion = register.fechaCreacion?.toIso8601String() ?? ''; // Fecha y hora completa
      final key = '$tipo-$idResidenteLugar-$fechaCreacion';
      
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(register);
    }
    
    // Return only one representative per group (the first one from each group)
    List<PendingSchoolRegisterResponse> result = [];
    for (var group in grouped.values) {
      if (group.isNotEmpty) {
        // Take the first register from each group to represent the entire group
        result.add(group.first);
      }
    }
    
    return result;
  }

  // Helper method to get count of children for a representative
  int getChildrenCount(PendingSchoolRegisterResponse representative) {
    if (!isGrouped.value) return 1;
    
    final tipo = representative.tipo?.description ?? 'unknown';
    final idResidenteLugar = representative.idResidenteLugar?.toString() ?? 'unknown';
    final fechaCreacion = representative.fechaCreacion?.toIso8601String() ?? 'unknown'; // Fecha y hora completa
    final key = '$tipo-$idResidenteLugar-$fechaCreacion';
    
    return _allPendingRegisters.where((register) {
      final registerTipo = register.tipo?.description ?? 'unknown';
      final registerIdResidenteLugar = register.idResidenteLugar?.toString() ?? 'unknown';
      final registerFechaCreacion = register.fechaCreacion?.toIso8601String() ?? 'unknown'; // Fecha y hora completa
      final registerKey = '$registerTipo-$registerIdResidenteLugar-$registerFechaCreacion';
      
      return registerKey == key;
    }).length;
  }

  // Helper method to get all children for a representative group
  List<PendingSchoolRegisterResponse> getGroupChildren(PendingSchoolRegisterResponse representative) {
    if (!isGrouped.value) return [representative];
    
    final tipo = representative.tipo?.description ?? '';
    final idResidenteLugar = representative.idResidenteLugar?.toString() ?? '';
    final fechaCreacion = representative.fechaCreacion?.toIso8601String() ?? ''; // Fecha y hora completa
    final key = '$tipo-$idResidenteLugar-$fechaCreacion';
    
    return _allPendingRegisters.where((register) {
      final registerTipo = register.tipo?.description ?? '';
      final registerIdResidenteLugar = register.idResidenteLugar?.toString() ?? '';
      final registerFechaCreacion = register.fechaCreacion?.toIso8601String() ?? ''; // Fecha y hora completa
      final registerKey = '$registerTipo-$registerIdResidenteLugar-$registerFechaCreacion';
      
      return registerKey == key;
    }).toList();
  }

  // Helper method to get all pending registers (unfiltered)
  List<PendingSchoolRegisterResponse> getAllPendingRegisters() {
    return List.from(_allPendingRegisters);
  }

  // Helper method to get all pending registers filtered by idResidenteLugar and tipo
  List<PendingSchoolRegisterResponse> getAllPendingRegistersByGroup(PendingSchoolRegisterResponse selectedRegister) {
    return _allPendingRegisters.where((register) => 
      register.idResidenteLugar == selectedRegister.idResidenteLugar && 
      register.tipo == selectedRegister.tipo &&
      register.fechaCreacion?.toIso8601String() == selectedRegister.fechaCreacion?.toIso8601String() // Fecha y hora completa
    ).toList();
  }
}