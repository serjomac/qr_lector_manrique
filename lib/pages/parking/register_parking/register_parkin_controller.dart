import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RegisterParkinController extends GetxController {
  // Text controllers for form fields
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController motivoController = TextEditingController();
  
  // Controllers específicos para el tab de Residente
  final TextEditingController nombreResidenteController = TextEditingController();
  final TextEditingController celularResidenteController = TextEditingController();
  final TextEditingController primarioController = TextEditingController();
  final TextEditingController secundarioController = TextEditingController();
  
  // Tab selection
  int selectedTabIndex = 0;
  
  // Tipo de invitado dropdown
  String selectedTipoInvitado = 'Ocasional';
  final List<String> tiposInvitado = ['Ocasional', 'Permanente', 'Temporal'];
  
  @override
  void onInit() {
    super.onInit();
    // Initialize with default values from Figma
    nombreController.text = 'Martha Delgado';
    cedulaController.text = '0922429735';
    celularController.text = '0922429735';
    placaController.text = 'GRV0651';
    
    // Valores para el tab de Residente
    nombreResidenteController.text = 'David Macías';
    celularResidenteController.text = '0981234567';
    primarioController.text = 'SOLAR';
    secundarioController.text = '1';
  }
  
  void selectTab(int index) {
    selectedTabIndex = index;
    update();
  }
  
  void changeTipoInvitado(String? newValue) {
    if (newValue != null) {
      selectedTipoInvitado = newValue;
      update();
    }
  }
  
  void onContinuePressed() {
    // Validate fields
    if (nombreController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor ingresa el nombre del invitado',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    if (cedulaController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor ingresa la cédula',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    // Continue with form submission
    Get.snackbar(
      'Éxito',
      'Formulario enviado correctamente',
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
  
    @override
  void onClose() {
    // Dispose all controllers
    nombreController.dispose();
    cedulaController.dispose();
    celularController.dispose();
    placaController.dispose();
    motivoController.dispose();
    nombreResidenteController.dispose();
    celularResidenteController.dispose();
    primarioController.dispose();
    secundarioController.dispose();
    super.onClose();
  }
}