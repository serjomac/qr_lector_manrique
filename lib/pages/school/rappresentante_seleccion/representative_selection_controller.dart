import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_school.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_childs_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';

class RepresentativeSelectionController extends GetxController {
  final ApiSchool _apiSchool = ApiSchool();
  final RxBool isLoading = false.obs;
  final RxList<ResidentChildsResponse> representatives =
      <ResidentChildsResponse>[].obs;
  final RxList<ResidentChildsResponse> filteredRepresentatives =
      <ResidentChildsResponse>[].obs;
  final GateDoor gateSelected;
  final MainActionType mainActionType;
  
  // Search functionality
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  final RxString searchQuery = ''.obs;

  RepresentativeSelectionController({required this.gateSelected, required this.mainActionType});

  @override
  void onInit() {
    super.onInit();
    fetchRepresentatives();
  }

  Future<void> fetchRepresentatives() async {
    try {
      isLoading.value = true;
      final result = await _apiSchool.getAllRepresentants(
        UserData.sharedInstance.placeSelected!.idLugar.toString(),
        gateSelected.idPuerta.toString(),
        UserData.sharedInstance.userLogin!.idUsuarioAdmin.toString(),
      );
      representatives.assignAll(result);
      filteredRepresentatives.assignAll(result);
    } catch (e) {
      print('Error fetching representatives: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchRepresentatives(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      filteredRepresentatives.assignAll(representatives);
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    final filtered = representatives.where((representative) {
      final name = (representative.nombresResidente ?? '').toLowerCase();
      final lastName = (representative.apellidosResidente ?? '').toLowerCase();
      final cedula = (representative.cedulaResidente ?? '').toLowerCase();
      
      return name.contains(lowercaseQuery) ||
             lastName.contains(lowercaseQuery) ||
             cedula.contains(lowercaseQuery);
    }).toList();
    
    filteredRepresentatives.assignAll(filtered);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredRepresentatives.assignAll(representatives);
    searchFocusNode.unfocus();
  }

  void onRepresentativeSelected() {
    // Clear search and close keyboard when a representative is selected
    clearSearch();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
