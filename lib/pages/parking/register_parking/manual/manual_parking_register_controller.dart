import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:qr_scaner_manrique/BRACore/api/api_lector.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/ocr_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/file_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/shared/widgets/loading_dialog.dart';

class ManualParkingRegisterController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Text editing controllers
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController observacionController = TextEditingController();
  
  // API instance
  final ApiLector apiLector = ApiLector();
  
  // Loading state
  RxBool isLoading = false.obs;
  
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
  }
  
  @override
  void onClose() {
    // Dispose controllers
    nombreController.dispose();
    cedulaController.dispose();
    celularController.dispose();
    placaController.dispose();
    observacionController.dispose();
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

  // Método para tomar foto con OCR
  Future<void> takePhotoWithOcr({required PhotoType photoType}) async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (image == null) return;
    File imageTemporary = File(image.path);
    File compressedImage = await imageTemporary.ensureFileSize(1500000);
    String newPath = path.join(
      path.dirname(compressedImage.path),
      'image-\${photoType.value}-\${DateTime.now().millisecondsSinceEpoch}',
    );
    compressedImage = await compressedImage.rename(newPath);

    switch (photoType) {
      case PhotoType.dni:
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
        break;
      case PhotoType.frontLicensePlate:
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
        break;
      default:
        break;
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
      
      // Simular procesamiento
      await Future.delayed(const Duration(seconds: 2));
      
      isLoading.value = false;
      
      // TODO: Implementar lógica real de envío de datos
      // Aquí iría la lógica para enviar los datos al backend
    }
  }
  
  // Método para volver atrás
  void goBack() {
    Get.back();
  }
}
