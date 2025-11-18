import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_parking.dart';
import 'package:qr_scaner_manrique/BRACore/enums/main_parking_entry.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/parking_response.dart';
import 'dart:io';

import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';
import 'package:qr_scaner_manrique/pages/parking/validate_parking/validation_success_qr/validation_success_qr_bottom_sheet.dart';
import 'package:qr_scaner_manrique/pages/parking/type_parking_register/parking_validation_type.dart';
import 'package:qr_scaner_manrique/pages/parking/validate_parking/customer_data/customer_data_modal.dart';

class ValidateParkingController extends GetxController {
  // Vehicle data from previous page
  final ParrkingResponse vehicleData;
  final MainParkingEntry mainParkingEntry;
  final ParkingValidationType? validationType;
  
  // Constructor
  ValidateParkingController({
    required this.vehicleData,
    required this.mainParkingEntry,
    this.validationType,
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
  final TextEditingController observacionSalidaController = TextEditingController();
  final TextEditingController celularValidacionController = TextEditingController();

  // Form keys
  final GlobalKey<FormState> placaFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> celularFormKey = GlobalKey<FormState>();
  
  // Focus nodes
  final FocusNode placaFocusNode = FocusNode();
  final FocusNode celularValidacionFocusNode = FocusNode();
  
  // Checkbox para consumidor final (default true)
  final RxBool isConsumidorFinal = true.obs;

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
  bool get isImageGridReadOnly => mainParkingEntry == MainParkingEntry.validation || mainParkingEntry == MainParkingEntry.history;
  
  // Getter para verificar si mostrar el campo de observación de validación
  bool get shouldHideObservacionValidacion => 
    mainParkingEntry == MainParkingEntry.history && observacionValidacionController.text.isEmpty;
  
  // Getter para verificar si mostrar el campo de placa en modo salida
  bool get shouldShowPlacaField => 
    (mainParkingEntry == MainParkingEntry.exit || mainParkingEntry == MainParkingEntry.validation) && 
    (vehicleData.ingreso?.placa == null || vehicleData.ingreso!.placa!.isEmpty);
  
  // Getter para obtener el texto del modo actual
  String get currentModeText {
    switch (mainParkingEntry) {
      case MainParkingEntry.entry:
        return 'Modo: Registro de Entrada';
      case MainParkingEntry.validation:
        return 'Modo: Validación de Parqueo';
      case MainParkingEntry.exit:
        return 'Modo: Registro de Salida';
      case MainParkingEntry.history:
        return 'Modo: Historial de Parqueo';
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
      case MainParkingEntry.history:
        selectedTabIndex = 2; // Mostrar tab de salida para historial
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
    observacionSalidaController.dispose();
    celularValidacionController.dispose();
    
    // Dispose focus nodes
    placaFocusNode.dispose();
    celularValidacionFocusNode.dispose();
    
    // Limpiar imágenes de validación
    validacionImages.clear();
    
    super.onClose();
  }

  String getCurrentTabTitle() {
    switch (mainParkingEntry) {
      case MainParkingEntry.entry:
        return "Registro de ingreso";
      case MainParkingEntry.validation:
        return "Validación de ticket";
      case MainParkingEntry.exit:
        return "Registro de salida";
      case MainParkingEntry.history:
        return "Historial de parqueo";
      default:
        return "";
    }
  }

  void initializeData() {
    // Usar datos reales del vehículo
    nameController.text = vehicleData.ingreso?.nombre ?? '';
    
    // Solo inicializar la placa si no está vacía o si no estamos en modo salida
    if (mainParkingEntry != MainParkingEntry.exit || 
        (vehicleData.ingreso?.placa != null && vehicleData.ingreso!.placa!.isNotEmpty)) {
      placaController.text = vehicleData.ingreso?.placa?.toUpperCase() ?? '';
    }
    
    // Campos específicos según el tipo de entrada
    switch (mainParkingEntry) {
      case MainParkingEntry.entry:
        puertaController.text = vehicleData.ingreso?.nombrePuertaIngreso?.toString() ?? "Sin puerta";
        // fechaController.text = _formatDateTime(vehicleData.ingreso?.fechaIngreso);
        cedulaController.text = vehicleData.ingreso?.cedula ?? "";
        celularController.text = vehicleData.ingreso?.celular?.toString() ?? "";
        observacionController.text = vehicleData.ingreso?.observacionIngreso?.toString() ?? "";
        break;
        
      case MainParkingEntry.validation:
        puertaController.text = vehicleData.ingreso?.nombrePuertaIngreso?.toString() ?? "Sin puerta";
        // fechaController.text = _formatDateTime(vehicleData.ingreso?.fechaValidacion);
        cedulaController.text = vehicleData.ingreso?.cedula ?? "";
        celularController.text = vehicleData.ingreso?.celular?.toString() ?? "";
        observacionController.text = vehicleData.ingreso?.observacionValidacion?.toString() ?? "";
        break;
        
      case MainParkingEntry.exit:
        puertaController.text = vehicleData.ingreso?.nombrePuertaSalida?.toString() ?? "Sin puerta";
        // fechaController.text = _formatDateTime(vehicleData.ingreso?.fechaSalida);
        cedulaController.text = vehicleData.ingreso?.cedula ?? "";
        celularController.text = vehicleData.ingreso?.celular?.toString() ?? "";
        observacionController.text = vehicleData.ingreso?.observacionSalida?.toString() ?? "";
        break;
        
      case MainParkingEntry.history:
        // Para historial, mostrar datos de salida si existen, sino datos de validación
        if (vehicleData.ingreso?.fechaSalida != null) {
          puertaController.text = vehicleData.ingreso?.nombrePuertaSalida?.toString() ?? "Sin puerta";
          // fechaController.text = _formatDateTime(vehicleData.ingreso?.fechaSalida);
          observacionController.text = vehicleData.ingreso?.observacionSalida?.toString() ?? "";
        } else {
          puertaController.text = vehicleData.ingreso?.nombrePuertaIngreso?.toString() ?? "Sin puerta";
          // fechaController.text = _formatDateTime(vehicleData.ingreso?.fechaValidacion);
          observacionController.text = vehicleData.ingreso?.observacionValidacion?.toString() ?? "";
        }
        cedulaController.text = vehicleData.ingreso?.cedula ?? "";
        celularController.text = vehicleData.ingreso?.celular?.toString() ?? "";
        break;
    }
    
    // Datos de validación
    tiempoTotalController.text = vehicleData.ingreso?.tiempoTotal ?? '';
    tiempoPagoController.text = vehicleData.ingreso?.tiempoHorasPago ?? '';
    tarifaController.text = vehicleData.ingreso?.tarifaAplicada ?? '';
    totalController.text = vehicleData.ingreso?.valorTotal ?? '';
    fechaValidacionController.text = formatDateTime(vehicleData.ingreso?.fechaValidacion);
    observacionValidacionController.text = "";
    
    // Inicializar observación de salida según el modo
    if (mainParkingEntry == MainParkingEntry.exit) {
      observacionSalidaController.text = vehicleData.ingreso?.observacionSalida ?? "";
    } else {
      observacionSalidaController.text = "";
    }
    
    // Cargar imágenes según el tipo de entrada
    _loadImagesByEntryType();
    
    update();
  }
  
  void _loadImagesByEntryType() {
    switch (mainParkingEntry) {
      case MainParkingEntry.validation:
        // Modo validación: cargar imágenes informativas desde vehicleData.ingreso.imgValidacion
        loadValidationImages();
        break;
      case MainParkingEntry.entry:
        // Modo entrada: cargar imágenes de entrada si existen, o inicializar vacía para nuevas entradas
        loadEntryImages();
        break;
      case MainParkingEntry.exit:
        // Modo salida: cargar imágenes de salida si existen, o inicializar vacía para nuevas salidas
        loadExitImages();
        break;
      case MainParkingEntry.history:
        // Modo historial: cargar imágenes de salida si existen, sino imágenes de validación
        _loadHistoryImages();
        break;
    }
  }
  
  List<String> loadValidationImages() {
    if (vehicleData.ingreso?.imgValidacion != null && vehicleData.ingreso!.imgValidacion!.toString().isNotEmpty) {
      // Hacer split de las imágenes separadas por coma
      List<String> imagePaths = vehicleData.ingreso!.imgValidacion!.toString().split(',');

      // Limpiar espacios en blanco y filtrar entradas vacías
      imagePaths = imagePaths.map((path) => path.trim()).where((path) => path.isNotEmpty).toList();
      
      // Asegurar que tenemos máximo 4 imágenes
      int imageCount = imagePaths.length;
      
      // Inicializar la lista con las imágenes disponibles
      return List.generate(imageCount, (index) {
        return index < imageCount ? imagePaths[index] : '';
      });
    } else {
      // Si no hay imágenes, inicializar lista vacía
      return List.generate(0, (index) => '');
    }
  }
  
  List<String> loadEntryImages() {
    // Para modo entrada, cargar imágenes existentes o inicializar vacía
    if (vehicleData.ingreso?.imgIngreso != null && vehicleData.ingreso!.imgIngreso!.toString().isNotEmpty) {
      List<String> imagePaths = vehicleData.ingreso!.imgIngreso!.toString().split(',');
      imagePaths = imagePaths.map((path) => path.trim()).where((path) => path.isNotEmpty).toList();
      int imageCount = imagePaths.length;
      imageUrls = List.generate(imagePaths.length, (index) {
        return index < imageCount ? imagePaths[index] : '';
      });
      return imageUrls;
    } else {
      imageUrls = List.generate(0, (index) => '');
      return imageUrls;
    }
  }
  
  List<String> loadExitImages() {
    // Para modo salida, cargar imágenes de salida si existen
    if (vehicleData.ingreso?.imgSalida != null && vehicleData.ingreso!.imgSalida!.toString().isNotEmpty) {
      List<String> imagePaths = vehicleData.ingreso!.imgSalida!.toString().split(',');
      imagePaths = imagePaths.map((path) => path.trim()).where((path) => path.isNotEmpty).toList();
      int imageCount = imagePaths.length;
      imageUrls = List.generate(imagePaths.length, (index) {
        return index < imageCount ? imagePaths[index] : '';
      });
      return imageUrls; 
    } else {
      imageUrls = List.generate(0, (index) => '');
      return imageUrls;
    }
  }
  
  void _loadHistoryImages() {
    // Para modo historial, cargar imágenes de salida si existen, sino de validación
    if (vehicleData.ingreso?.imgSalida != null && vehicleData.ingreso!.imgSalida!.toString().isNotEmpty) {
      List<String> imagePaths = vehicleData.ingreso!.imgSalida!.toString().split(',');
      imagePaths = imagePaths.map((path) => path.trim()).where((path) => path.isNotEmpty).toList();
      int imageCount = imagePaths.length > 4 ? 4 : imagePaths.length;
      imageUrls = List.generate(imagePaths.length, (index) {
        return index < imageCount ? imagePaths[index] : '';
      });
    } else if (vehicleData.ingreso?.imgValidacion != null && vehicleData.ingreso!.imgValidacion!.toString().isNotEmpty) {
      List<String> imagePaths = vehicleData.ingreso!.imgValidacion!.toString().split(',');
      imagePaths = imagePaths.map((path) => path.trim()).where((path) => path.isNotEmpty).toList();
      int imageCount = imagePaths.length > 4 ? 4 : imagePaths.length;
      imageUrls = List.generate(imageCount, (index) {
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

  // Contact picker method
  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
  
  Future<void> pickContactForCelular() async {
    try {
      final contact = await _contactPicker.selectContact();
      if (contact != null && contact.phoneNumbers != null && contact.phoneNumbers!.isNotEmpty) {
        // Obtener el primer número de teléfono y limpiar formato
        String phoneNumber = contact.phoneNumbers!.first;
        // Remover espacios, guiones, paréntesis y otros caracteres
        phoneNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
        
        celularValidacionController.text = phoneNumber;
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo acceder a los contactos',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEB472A),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Helper methods
  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Aún no hay fecha';
    
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
      // Validar todos los campos al mismo tiempo
      bool placaValid = true;
      bool celularValid = true;
      
      // Validar placa si es necesario
      if (shouldShowPlacaField) {
        placaValid = placaFormKey.currentState?.validate() ?? true;
      }
      
      // Validar celular en modo validación
      if (mainParkingEntry == MainParkingEntry.validation) {
        celularValid = celularFormKey.currentState?.validate() ?? true;
      }
      
      // Si alguna validación falló, poner foco en el primer campo con error
      if (!placaValid || !celularValid) {
        // Poner foco en el primer campo que falló
        if (!placaValid) {
          placaFocusNode.requestFocus();
        } else if (!celularValid) {
          celularValidacionFocusNode.requestFocus();
        }
        return; // No continuar si hay errores
      }
      
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
          observacion: observacionSalidaController.text,
        );

        // Cerrar pantalla anterior y mostrar diálogo de éxito
        Get.back(result: true);
        Get.dialog(
          SuccessDialog(
            title: 'Salida Registrada',
            subtitle: 'La salida del parqueo ha sido registrada correctamente',
            iconSvg: 'assets/icons/success.svg',
            onTapAcept: () {
              Get.back(); // Cerrar el diálogo
            },
          ),
          barrierDismissible: false,
        );

        // Actualizar estado del ticket
        isTicketExpired = false;
        update();
      } else {
        // Modo validación: llamar al servicio de validación y capturar respuesta
        // Determinar flag 'especial': S para manual, N para QR (u otros)
        final String especialFlag = (validationType == ParkingValidationType.manual)
            ? 'S'
            : 'N';

        // Preparar datos del cliente
        Map<String, dynamic>? customerData;
        
        if (isConsumidorFinal.value) {
          // Si consumidor final está seleccionado, usar datos por defecto
          customerData = {
            'tipo_identificacion': '',
            'identificacion': '9999999999',
            'mail_cliente': '',
            'telefono': '',
            'direccion_cliente': '',
            'nombre_cliente': '',
          };
        } else {
          // Si no es consumidor final, abrir modal para capturar datos del cliente
          customerData = await Get.dialog(
            const CustomerDataModal(),
            barrierDismissible: false,
          );

          // Si el usuario cancela, no continuar
          if (customerData == null) {
            return;
          }
        }

        final res = await _apiParking.validarParqueoRegistro(
          idIngreso: idIngreso,
          idLugar: idLugar,
          imagenes: imagenes.isNotEmpty ? imagenes : null,
          observacion: observacionValidacionController.text,
          tiempoTotal: tiempoTotalController.text,
          tiempoHorasPago: tiempoPagoController.text,
          tarifaAplicada: tarifaController.text,
          valorTotal: totalController.text,
          estado: vehicleData.ingreso?.estado ?? '',
          placa: placaController.text,
          especial: especialFlag,
          // Datos del formulario
          tipoIdentificacion: customerData['tipo_identificacion']?.toString(),
          identificacion: customerData['identificacion']?.toString(),
          mailCliente: customerData['mail_cliente']?.toString(),
          telefono: customerData['telefono']?.toString(),
          direccionCliente: customerData['direccion_cliente']?.toString(),
          nombreCliente: customerData['nombre_cliente']?.toString(),
          celular: celularValidacionController.text.trim(),
        );

        final String? url = (res['url'] ?? res['URL'])?.toString();
        if (url != null && url.trim().isNotEmpty) {
          // Mostrar ticket/QR en WebView dentro de un bottom sheet
          await Get.bottomSheet(
            ValidationSuccessQrBottomSheet(url: url),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
          // Al cerrar el bottom sheet, regresar a la lista con resultado para refrescar
          Get.back(result: true);
        } else {
          // Flujo original de éxito sin URL
          Get.back(result: true);
          Get.dialog(
            SuccessDialog(
              title: 'Validación Exitosa',
              subtitle: 'El parqueo ha sido validado correctamente',
              iconSvg: 'assets/icons/success.svg',
              onTapAcept: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
        }

        // Actualizar estado del ticket
        isTicketExpired = false;
        update();
      }
      
    } catch (e) {
    } finally {
      isValidating.value = false;
      update();
    }
  }
}