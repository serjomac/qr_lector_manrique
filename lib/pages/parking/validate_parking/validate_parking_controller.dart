import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_parking.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/string_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';
import 'dart:io';

import 'package:qr_scaner_manrique/shared/widgets/invitation_card.dart';

class ValidateParkingController extends GetxController {
  // Vehicle data from previous page
  final ParrkingResponse vehicleData;
  final MainParkingEntry mainParkingEntry;
  
  // Constructor
  ValidateParkingController({
    required this.vehicleData,
    required this.mainParkingEntry,
  });
  // Text Editing Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController observacionController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController puertaController = TextEditingController();
  
  // Controllers para tab de validación
  final TextEditingController tiempoTotalController = TextEditingController();
  final TextEditingController tiempoPagoController = TextEditingController();
  final TextEditingController tarifaController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController fechaValidacionController = TextEditingController();
  final TextEditingController observacionValidacionController = TextEditingController();

  // Tab control
  int selectedTabIndex = 0;

  // Lista de imágenes placeholder
  List<String> imageUrls = List.generate(0, (index) => '');
  
  // Estado del ticket
  bool isTicketExpired = true;
  
  // Imágenes de validación
  List<File> validacionImages = [];
  final ImagePicker _picker = ImagePicker();
  
  // API instance
  final ApiParking _apiParking = ApiParking();
  
  // Loading state
  final RxBool isValidating = false.obs;
  
  // Getter para verificar si las imágenes son solo informativas
  bool get isImageGridReadOnly => mainParkingEntry == MainParkingEntry.validation;
  
  // Getter para obtener el texto del modo actual
  String get currentModeText {
    switch (mainParkingEntry) {
      case MainParkingEntry.entry:
        return 'Modo: Registro de Entrada';
      case MainParkingEntry.validation:
        return 'Modo: Validación de Parqueo';
      case MainParkingEntry.exit:
        return 'Modo: Registro de Salida';
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Inicializar tab seleccionado según el tipo de entrada
    _initializeSelectedTab();
    // Inicializar con datos de ejemplo
    initializeData();
  }
  
  void _initializeSelectedTab() {
    switch (mainParkingEntry) {
      case MainParkingEntry.entry:
        selectedTabIndex = 0; // Ingreso
        break;
      case MainParkingEntry.validation:
        selectedTabIndex = 1; // Validación
        break;
      case MainParkingEntry.exit:
        selectedTabIndex = 2; // Salida
        break;
    }
    // Trigger UI update
    update();
  }

  @override
  void onClose() {
    // Dispose controllers
    nameController.dispose();
    cedulaController.dispose();
    celularController.dispose();
    observacionController.dispose();
    placaController.dispose();
    fechaController.dispose();
    puertaController.dispose();
    tiempoTotalController.dispose();
    tiempoPagoController.dispose();
    tarifaController.dispose();
    totalController.dispose();
    fechaValidacionController.dispose();
    observacionValidacionController.dispose();
    
    // Limpiar imágenes de validación
    validacionImages.clear();
    
    super.onClose();
  }

  String getCurrentTabTitle() {
    switch (mainParkingEntry) {
      case MainParkingEntry.entry:
        return "Regsitro de ingreso";
      case MainParkingEntry.validation:
        return "Validación de ticket";
      case MainParkingEntry.exit:
        return "Regsitro de salida";
      default:
        return "";
    }
  }

  void initializeData() {
    // Usar datos reales del vehículo
    final names = vehicleData.ingreso?.nombresInvitado ?? ('${vehicleData.ingreso?.nombresResidente} ${vehicleData.ingreso?.apellidosResidente?.getFirstName}');
    nameController.text = names;
    placaController.text = vehicleData.ingreso?.placa?.toUpperCase() ?? '';
    
    // Campos específicos según el tipo de entrada
    switch (mainParkingEntry) {
      case MainParkingEntry.entry:
        puertaController.text = vehicleData.ingreso?.nombrePuertaIngreso?.toString() ?? "Sin puerta";
        fechaController.text = _formatDateTime(vehicleData.ingreso?.fechaIngreso);
        cedulaController.text = vehicleData.ingreso?.cedula ?? "";
        celularController.text = vehicleData.ingreso?.celular?.toString() ?? "";
        observacionController.text = vehicleData.ingreso?.observacionIngreso?.toString() ?? "";
        break;
        
      case MainParkingEntry.validation:
        puertaController.text = vehicleData.ingreso?.nombrePuertaIngreso?.toString() ?? "Sin puerta";
        fechaController.text = _formatDateTime(vehicleData.ingreso?.fechaValidacion);
        cedulaController.text = vehicleData.ingreso?.cedula ?? "";
        celularController.text = vehicleData.ingreso?.celular?.toString() ?? "";
        observacionController.text = vehicleData.ingreso?.observacionValidacion?.toString() ?? "";
        break;
        
      case MainParkingEntry.exit:
        puertaController.text = vehicleData.ingreso?.nombrePuertaSalida?.toString() ?? "Sin puerta";
        fechaController.text = _formatDateTime(vehicleData.ingreso?.fechaSalida);
        cedulaController.text = vehicleData.ingreso?.cedula ?? "";
        celularController.text = vehicleData.ingreso?.celular?.toString() ?? "";
        observacionController.text = vehicleData.ingreso?.observacionSalida?.toString() ?? "";
        break;
    }
    
    // Datos de validación
    tiempoTotalController.text = vehicleData.ingreso?.tiempoTotal ?? '';
    tiempoPagoController.text = vehicleData.ingreso?.tiempoHorasPago ?? '';
    tarifaController.text = vehicleData.ingreso?.tarifaAplicada ?? '';
    totalController.text = vehicleData.ingreso?.valorTotal ?? '';
    fechaValidacionController.text = _formatDateTime(vehicleData.ingreso?.fechaIngreso);
    observacionValidacionController.text = "";
    
    // Cargar imágenes según el tipo de entrada
    _loadImagesByEntryType();
    
    update();
  }
  
  void _loadImagesByEntryType() {
    switch (mainParkingEntry) {
      case MainParkingEntry.validation:
        // Modo validación: cargar imágenes informativas desde vehicleData.ingreso.imgValidacion
        _loadValidationImages();
        break;
      case MainParkingEntry.entry:
        // Modo entrada: cargar imágenes de entrada si existen, o inicializar vacía para nuevas entradas
        _loadEntryImages();
        break;
      case MainParkingEntry.exit:
        // Modo salida: cargar imágenes de salida si existen, o inicializar vacía para nuevas salidas
        _loadExitImages();
        break;
    }
  }
  
  void _loadValidationImages() {
    if (vehicleData.ingreso?.imgValidacion != null && vehicleData.ingreso!.imgValidacion!.toString().isNotEmpty) {
      // Hacer split de las imágenes separadas por coma
      List<String> imagePaths = vehicleData.ingreso!.imgValidacion!.toString().split(',');

      // Limpiar espacios en blanco y filtrar entradas vacías
      imagePaths = imagePaths.map((path) => path.trim()).where((path) => path.isNotEmpty).toList();
      
      // Asegurar que tenemos máximo 4 imágenes
      int imageCount = imagePaths.length > 4 ? 4 : imagePaths.length;
      
      // Inicializar la lista con las imágenes disponibles
      imageUrls = List.generate(imageCount, (index) {
        return index < imageCount ? imagePaths[index] : '';
      });
    } else {
      // Si no hay imágenes, inicializar lista vacía
      imageUrls = List.generate(0, (index) => '');
    }
  }
  
  void _loadEntryImages() {
    // Para modo entrada, cargar imágenes existentes o inicializar vacía
    if (vehicleData.ingreso?.imgIngreso != null && vehicleData.ingreso!.imgIngreso!.toString().isNotEmpty) {
      List<String> imagePaths = vehicleData.ingreso!.imgIngreso!.toString().split(',');
      imagePaths = imagePaths.map((path) => path.trim()).where((path) => path.isNotEmpty).toList();
      int imageCount = imagePaths.length > 4 ? 4 : imagePaths.length;
      imageUrls = List.generate(imagePaths.length, (index) {
        return index < imageCount ? imagePaths[index] : '';
      });
    } else {
      imageUrls = List.generate(4, (index) => '');
    }
  }
  
  void _loadExitImages() {
    // Para modo salida, cargar imágenes de salida si existen
    if (vehicleData.ingreso?.imgSalida != null && vehicleData.ingreso!.imgSalida!.toString().isNotEmpty) {
      List<String> imagePaths = vehicleData.ingreso!.imgSalida!.toString().split(',');
      imagePaths = imagePaths.map((path) => path.trim()).where((path) => path.isNotEmpty).toList();
      int imageCount = imagePaths.length > 4 ? 4 : imagePaths.length;
      imageUrls = List.generate(imagePaths.length, (index) {
        return index < imageCount ? imagePaths[index] : '';
      });
    } else {
      imageUrls = List.generate(0, (index) => '');
    }
  }

  void selectTab(int index) {
    selectedTabIndex = index;
    update();
  }

  void addImage(int index, String imageUrl) {
    if (index >= 0 && index < imageUrls.length) {
      imageUrls[index] = imageUrl;
      update();
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < imageUrls.length) {
      imageUrls[index] = '';
      update();
    }
  }

  // Métodos para imágenes de validación
  Future<void> takeValidacionPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );
      
      if (image != null) {
        validacionImages.add(File(image.path));
        update();
      }
    } catch (e) {
      // Manejo de diferentes tipos de errores
      String errorMessage = 'No se pudo acceder a la cámara';
      
      if (e.toString().contains('camera_access_denied')) {
        errorMessage = 'Permiso de cámara denegado. Por favor habilita el acceso a la cámara en configuración.';
      } else if (e.toString().contains('camera_unavailable')) {
        errorMessage = 'Cámara no disponible en este dispositivo.';
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEB472A),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void removeValidacionImage(int index) {
    if (index >= 0 && index < validacionImages.length) {
      validacionImages.removeAt(index);
      update();
    }
  }

  void clearValidacionImages() {
    validacionImages.clear();
    update();
  }

  // Helper methods
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '---';
    
    // Format as "dd MMM. yyyy HH:MM"
    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    
    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$day $month. $year $hour:$minute';
  }

  String _calculateAccumulatedTime(ParrkingResponse entry) {
    if (entry.fechaIngreso == null) return '0h 0m';
    
    final DateTime ingreso = entry.fechaIngreso!;
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(ingreso);
    
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes.remainder(60);
    
    return '${hours}h ${minutes}m';
  }

  Future<void> onValidarPressed() async {
    try {
      isValidating.value = true;
      
      // Preparar parámetros comunes
      final String idIngreso = vehicleData.idIngreso?.toString() ?? '';
      final String idLugar = vehicleData.idLugar?.toString() ?? '';
      final String idPuerta = vehicleData.idPuerta?.toString() ?? '';
      
      // Preparar lista de imágenes
      List<File> imagenes = validacionImages;
      
      // Determinar qué servicio llamar según el modo
      if (mainParkingEntry == MainParkingEntry.exit) {
        // Modo salida: llamar al servicio de salida
        await _apiParking.salidaParqueoRegistro(
          idIngreso: idIngreso,
          idPuerta: idPuerta,
          idLugar: idLugar,
          placa: placaController.text,
          imagenes: imagenes.isNotEmpty ? imagenes : null,
          observacion: observacionValidacionController.text,
        );
      } else {
        // Modo validación: llamar al servicio de validación
        await _apiParking.validarParqueoRegistro(
          idIngreso: idIngreso,
          idLugar: idLugar,
          imagenes: imagenes.isNotEmpty ? imagenes : null,
          observacion: observacionValidacionController.text,
          tiempoTotal: tiempoTotalController.text,
          tiempoHorasPago: tiempoPagoController.text,
          tarifaAplicada: tarifaController.text,
          valorTotal: totalController.text,
          estado: 'VALIDO',
          placa: placaController.text,
          especial: 'S',
        );
      }

      Get.back(result: true);
      
      // Mostrar mensaje de éxito según el modo
      final String successTitle = mainParkingEntry == MainParkingEntry.exit 
          ? 'Salida Registrada' 
          : 'Validación Exitosa';
      final String successMessage = mainParkingEntry == MainParkingEntry.exit
          ? 'La salida del parqueo ha sido registrada correctamente'
          : 'El parqueo ha sido validado correctamente';
      
      Get.snackbar(
        successTitle,
        successMessage,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Actualizar estado del ticket
      isTicketExpired = false;
      update();
      
    } catch (e) {
      print('Error en ${mainParkingEntry == MainParkingEntry.exit ? 'salida' : 'validación'}: $e');
      
      final String errorMessage = mainParkingEntry == MainParkingEntry.exit
          ? 'No se pudo registrar la salida del parqueo. Intenta nuevamente.'
          : 'No se pudo validar el parqueo. Intenta nuevamente.';
      
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isValidating.value = false;
      update();
    }
  }
}