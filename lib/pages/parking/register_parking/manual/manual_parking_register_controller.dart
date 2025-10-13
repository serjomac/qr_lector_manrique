import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_lector.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_parking.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/ocr_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/file_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/shared/widgets/loading_dialog.dart';
import 'package:qr_scaner_manrique/pages/parking/register_parking/manual_register_success_qr/manual_register_success_qr_bottom_sheet.dart';

class ManualParkingRegisterController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Text editing controllers
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController observacionController = TextEditingController();
  
  // Focus nodes
  final FocusNode cedulaFocusNode = FocusNode();
  
  // API instances
  final ApiLector apiLector = ApiLector();
  final ApiParking apiParking = ApiParking();
  final ApiAuth apiAuth = ApiAuth();
  
  // Loading state
  RxBool isLoading = false.obs;
  RxBool isCedulaLoading = false.obs;
  
  // Images state
  Rx<File?> fotoCedulaFile = Rx<File?>(null);
  Rx<File?> fotoPlacaFile = Rx<File?>(null);
  RxList<File> imagenesAdicionalesFiles = <File>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // Añadir listener para validación en tiempo real de la placa
    placaController.addListener(() {
      update(); // Trigger UI update when placa changes
    });
    
    // Agregar listener para detectar pérdida de foco en cédula
    cedulaFocusNode.addListener(() {
      if (!cedulaFocusNode.hasFocus) {
        // Cuando pierde el foco, llamar al servicio
        lookupPersonByCedula(cedulaController.text);
      }
    });
  }
  
  @override
  void onClose() {
    // Dispose controllers
    nombreController.dispose();
    cedulaController.dispose();
    celularController.dispose();
    placaController.dispose();
    observacionController.dispose();
    
    // Dispose focus nodes
    cedulaFocusNode.dispose();
    
    super.onClose();
  }
  
  // Método para tomar foto de cédula con OCR
  Future<void> takeFotoCedula() async {
    await takePhotoWithOcr(photoType: PhotoType.dni);
  }
  
  // Método para tomar foto de placa con OCR
  Future<void> takeFotoPlaca() async {
    await takePhotoWithOcr(photoType: PhotoType.frontLicensePlate);
  }
  
  // Método para añadir imágenes adicionales
  Future<void> addImagenes() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (image == null) return;
    File imageTemporary = File(image.path);
    File compressedImage = await imageTemporary.ensureFileSize(1500000);
    String newPath = path.join(
      path.dirname(compressedImage.path),
      'image-adicional-\${DateTime.now().millisecondsSinceEpoch}',
    );
    compressedImage = await compressedImage.rename(newPath);
    imagenesAdicionalesFiles.add(compressedImage);
    update(); // Trigger UI update
  }

  // Método para eliminar una imagen adicional
  void removeImage(int index) {
    if (index >= 0 && index < imagenesAdicionalesFiles.length) {
      imagenesAdicionalesFiles.removeAt(index);
      update(); // Trigger UI update
    }
  }

  // Método para buscar datos de persona por cédula
  Future<void> lookupPersonByCedula(String cedula) async {
    // Validar que la cédula no esté vacía y tenga al menos 5 caracteres
    if (cedula.trim().isEmpty || cedula.trim().length < 5) {
      return;
    }

    try {
      isCedulaLoading.value = true;
      
      // Llamar al servicio para obtener datos de la persona
      final peopleData = await apiAuth.getPeopleDataBy(cedula.trim());
      
      // Mapear los datos obtenidos al campo nombre
      if (peopleData.nombres != null && peopleData.nombres!.isNotEmpty) {
        nombreController.text = peopleData.nombres!;
      }
    } catch (e) {
    } finally {
      isCedulaLoading.value = false;
    }
  }

  // Método para tomar foto con OCR
  Future<void> takePhotoWithOcr({required PhotoType photoType}) async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (image == null) return;
    File imageTemporary = File(image.path);
    File compressedImage = await imageTemporary.ensureFileSize(1500000);
    String newPath = path.join(
      path.dirname(compressedImage.path),
      'image-${photoType.value}-${DateTime.now().millisecondsSinceEpoch}',
    );
    compressedImage = await compressedImage.rename(newPath);

    if (photoType == PhotoType.dni) {
      fotoCedulaFile.value = compressedImage;
      update(); // Trigger UI update
      try {
        final resOcrDni = await getOrc(
          ocrType: OcrType.dni,
          filepath: compressedImage.path,
        );
        cedulaController.text = resOcrDni['CEDULA'] ?? '';
        nombreController.text = resOcrDni['NOMBRES'] ?? '';
      } catch (e) {
        // Error handled silently - OCR failed but image is still captured
      }
    } else if (photoType == PhotoType.frontLicensePlate) {
      fotoPlacaFile.value = compressedImage;
      update(); // Trigger UI update
      try {
        final resOcrPlate = await getOrc(
          ocrType: OcrType.licensePlate,
          filepath: compressedImage.path,
        );
        placaController.text = resOcrPlate['PLACA'] ?? '';
      } catch (e) {
        // Error handled silently - OCR failed but image is still captured
      }
    }
  }

  // Método para llamar al servicio OCR
  Future<dynamic> getOrc(
      {required OcrType ocrType, required String filepath}) async {
    try {
      showLoadingDialog(
        context: Get.overlayContext!,
        message: ocrType.dialogMessage,
      );
      final res = await apiLector.ocrLector(
        filePath: filepath,
        ocrType: ocrType,
        placeId: UserData.sharedInstance.placeSelected?.idLugar.toString() ?? '1',
      );
      Get.back();
      return res;
    } catch (e) {
      Get.back();
      rethrow;
    }
  }
  
    // Método para validar el formulario
  Future<void> validateForm() async {
    if (formKey.currentState?.validate() ?? false) {
      // Formulario válido - procesar datos
      isLoading.value = true;
      
      try {
        // Preparar datos para el servicio
        final placeId = UserData.sharedInstance.placeSelected?.idLugar.toString() ?? '1';
        final doorId = '17'; // TODO: Obtener el ID de puerta correcto del contexto actual
        
        // Generar fecha actual en formato YYYY-MM-DD HH:mm:ss
        final now = DateTime.now();
        final fechaIngreso = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
        
        // Preparar lista de imágenes (fotos principales + adicionales)
        List<File> allImages = [];
        if (fotoCedulaFile.value != null) {
          allImages.add(fotoCedulaFile.value!);
        }
        if (fotoPlacaFile.value != null) {
          allImages.add(fotoPlacaFile.value!);
        }
        allImages.addAll(imagenesAdicionalesFiles);
        
        // Llamar al servicio
        final registerResponse = await apiParking.insertParqueoRegistro(
          idPuerta: doorId,
          idLugar: placeId,
          nombre: nombreController.text.trim(),
          cedula: cedulaController.text.trim(),
          celular: celularController.text.trim(),
          placa: placaController.text.trim(),
          observacion: observacionController.text.trim(),
          fechaIngreso: fechaIngreso,
          imagenes: allImages.isNotEmpty ? allImages : null,
        );
        
        // Éxito - mostrar bottomSheet
        Get.bottomSheet(
          ManualRegisterSuccessQrBottomSheet(registerResponse: registerResponse),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
        
        // Limpiar formulario después de un breve delay
        Future.delayed(const Duration(seconds: 1), () {
          _clearForm();
        });
        
      } on DioError {
      } finally {
        isLoading.value = false;
      }
    }
  }
  
  // Método para volver atrás
  void goBack() {
    Get.back();
  }
  
  // Método para limpiar el formulario
  void _clearForm() {
    nombreController.clear();
    cedulaController.clear();
    celularController.clear();
    placaController.clear();
    observacionController.clear();
    fotoCedulaFile.value = null;
    fotoPlacaFile.value = null;
    imagenesAdicionalesFiles.clear();
    update();
  }
}
