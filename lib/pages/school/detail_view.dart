import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/controller/exit_request_form_controller.dart';

class DetailView extends StatelessWidget {
  const DetailView({Key? key}) : super(key: key);

  Widget _buildImagePreview(
    BuildContext context, {
    required String title,
    required File? imageFile,
    required Function() onTap,
    required Function()? onDelete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BRAText(
          text: title,
          size: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF231918),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(12),
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageFile == null
                ? const Center(
                    child: Icon(Icons.add_photo_alternate,
                        size: 48, color: Colors.grey),
                  )
                : Stack(
                    children: [
                      if (onDelete != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: onDelete,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 20, color: Colors.black),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalPhotos(ExitRequestFormController controller) {
    final isGateLeave = controller.mainActionType == MainActionType.gateLeave;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BRAText(
          text: isGateLeave ? 'Imágenes' : 'Añadir imágenes',
          size: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF231918),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: isGateLeave 
            ? _buildGateLeaveImages(controller)
            : _buildOriginalImages(controller),
        ),
      ],
    );
  }

  Widget _buildGateLeaveImages(ExitRequestFormController controller) {
    final images = controller.detailViewImages;
    if (images.isEmpty) {
      return const Center(
        child: Text(
          'No hay imágenes disponibles',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, index) {
        final imageUrl = images[index];
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () => _showImageModal(context, imageUrl),
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.white, size: 48),
                            SizedBox(height: 8),
                            Text(
                              'Error al cargar la imagen',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOriginalImages(ExitRequestFormController controller) {
    return Obx(() => ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.additionalPhotos.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Botón de añadir al inicio
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () async {
                await controller.pickImage(ImageSource.camera);
                controller.additionalPhotos.refresh(); // Ensure the list updates
              },
              child: Container(
                width: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey),
                    SizedBox(height: 4),
                    Text(
                      'Añadir\nimágenes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final photo = controller.additionalPhotos[index - 1];
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox(
            width: 120,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => controller.removeAdditionalPhoto(index - 1),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExitRequestFormController>();
    final isGateLeave = controller.mainActionType == MainActionType.gateLeave;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photos Section - ID and License Plate Photos - Solo mostrar si no es gateLeave
          if (!isGateLeave) ...[
          Row(
            children: [
              // ID Photo
              Expanded(
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BRAText(
                      text: 'Foto cédula',
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF231918),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: GestureDetector(
                        onTap: () => controller.takePhotoWithOcr(photoType: PhotoType.dni),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(12),
                            image: controller.idPhotoFile.value != null
                                ? DecorationImage(
                                    image: FileImage(controller.idPhotoFile.value!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: controller.idPhotoFile.value == null
                              ? const Center(
                                  child: Icon(Icons.add_photo_alternate,
                                      size: 48, color: Colors.grey),
                                )
                              : Stack(
                                  children: [
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => controller.idPhotoFile.value = null,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close,
                                              size: 20, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              const SizedBox(width: 16),
              // License Plate Photo
              Expanded(
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BRAText(
                      text: 'Foto Placa',
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF231918),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: GestureDetector(
                        onTap: () => controller.takePhotoWithOcr(photoType: PhotoType.frontLicensePlate),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F4),
                            borderRadius: BorderRadius.circular(12),
                            image: controller.licensePlatePhotoFile.value != null
                                ? DecorationImage(
                                    image: FileImage(controller.licensePlatePhotoFile.value!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: controller.licensePlatePhotoFile.value == null
                              ? const Center(
                                  child: Icon(Icons.add_photo_alternate,
                                      size: 48, color: Colors.grey),
                                )
                              : Stack(
                                  children: [
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => controller.licensePlatePhotoFile.value = null,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close,
                                              size: 20, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Additional Photos Section
          _buildAdditionalPhotos(controller),
          const SizedBox(height: 24),
          ],

          // Para gateLeave, solo mostrar fotos adicionales si las hay
          if (isGateLeave && controller.detailViewImages.isNotEmpty) ...[
            _buildAdditionalPhotos(controller),
            const SizedBox(height: 24),
          ],
          
          // Form Fields Section
          // Solo mostrar campos que tienen valores cuando es gateLeave
          if (!isGateLeave || controller.nameController.text.isNotEmpty) ...[
            Obx(() => CustomTextFormField(
              label: 'Nombre',
              hintText: controller.isLoadingPeopleData.value 
                  ? 'Consultando información...' 
                  : 'Ingrese el nombre',
              focusNode: controller.nameFocus,
              controller: controller.nameController,
              onChanged: (value) {},
              maxLength: 50,
              readOnly: isGateLeave || controller.isLoadingPeopleData.value,
            )),
            const SizedBox(height: 16),
          ],
          if (!isGateLeave || controller.idController.text.isNotEmpty) ...[
            Obx(() => CustomTextFormField(
              label: 'Cédula',
              hintText: controller.isLoadingPeopleData.value 
                  ? 'Consultando datos...' 
                  : 'Ingrese la cédula',
              focusNode: controller.idFocus,
              controller: controller.idController,
              onChanged: (value) {},
              onEditingComplete: () {
                // Trigger lookup when user finishes editing
                if (controller.idController.text.isNotEmpty) {
                  controller.lookupPeopleDataById(controller.idController.text);
                }
              },
              maxLength: 10,
              keyboardType: TextInputType.number,
              suxffixIcon: controller.isLoadingPeopleData.value
                  ? InkWell(
                      onTap: () {}, // No action needed for loader
                      child: Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(4.0),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : null,
              readOnly: isGateLeave || controller.isLoadingPeopleData.value,
            )),
            const SizedBox(height: 16),
          ],
          if (!isGateLeave || controller.licensePlateController.text.isNotEmpty) ...[
            CustomTextFormField(
              label: 'Placa',
              hintText: 'Ingrese la placa',
              focusNode: controller.licensePlateFocus,
              controller: controller.licensePlateController,
              onChanged: (value) {},
              maxLength: 8,
              readOnly: isGateLeave,
            ),
            const SizedBox(height: 16),
          ],
          if (!isGateLeave || controller.reasonController.text.isNotEmpty) ...[
            CustomTextFormField(
              label: 'Motivo',
              hintText: 'Ingrese el motivo del retiro',
              focusNode: controller.reasonFocus,
              controller: controller.reasonController,
              onChanged: (value) {},
              maxLength: 200,
              readOnly: isGateLeave,
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
