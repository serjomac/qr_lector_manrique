import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';

class RegisterParkinController extends GetxController {
  // Parking response data (requerido, cuando viene desde QR)
  final ParrkingResponse parkingResponse;

  RegisterParkinController({required this.parkingResponse});
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
    
    // Llenar campos con datos del vehículo escaneado
    nombreController.text = parkingResponse.nombres ?? '';
    cedulaController.text = parkingResponse.cedula ?? '';
    celularController.text = parkingResponse.celular ?? '';
    placaController.text = parkingResponse.placa ?? '';
    motivoController.text = parkingResponse.observacion ?? '';
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