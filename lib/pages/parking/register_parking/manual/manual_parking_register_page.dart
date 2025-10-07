import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'manual_parking_register_controller.dart';

class ManualParkingRegisterPage extends StatelessWidget {
  const ManualParkingRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ManualParkingRegisterController>(
        init: ManualParkingRegisterController(),
        builder: (controller) {
          return SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                _buildHeader(controller),
                
                // Form content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildFormContent(controller),
                    ),
                  ),
                ),
                
                // Validate button
                _buildValidateButton(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ManualParkingRegisterController controller) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          // Back button
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF231918),
                size: 20,
              ),
              onPressed: controller.goBack,
            ),
          ),
          const SizedBox(width: 8),
          // Title
          const Expanded(
            child: BRAText(
              text: 'Formulario de ingreso a parqueadero',
              size: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF231918),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent(ManualParkingRegisterController controller) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          
          // Photo upload section
          _buildPhotoUploadSection(controller),
          
          const SizedBox(height: 20),
          
          // Sección de imágenes adicionales
          _buildAdditionalImagesSection(controller),
          
          const SizedBox(height: 20),
          
          // Nombre y Apellido field
          _buildTextField(
            label: 'Nombre y Apellido',
            controller: controller.nombreController,
            isRequired: false,
          ),
          
          const SizedBox(height: 20),
          
          // Cédula field
          _buildTextField(
            label: 'Cédula',
            controller: controller.cedulaController,
            isRequired: false,
          ),
          
          const SizedBox(height: 20),
          
          // Celular field
          _buildTextField(
            label: 'Celular',
            controller: controller.celularController,
            isRequired: false,
          ),
          
          const SizedBox(height: 20),
          
          // Placa field (required)
          _buildTextField(
            label: 'Placa',
            controller: controller.placaController,
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La placa es obligatoria';
              }
              if (value.trim().length < 3) {
                return 'La placa debe tener al menos 3 caracteres';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          // Observación field
          _buildObservationField(controller),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadSection(ManualParkingRegisterController controller) {
    return Row(
      children: [
        // Foto cédula
        Expanded(
          child: Obx(() => _buildPhotoUploadCard(
            label: 'Foto cédula',
            onTap: controller.takeFotoCedula,
            imageFile: controller.fotoCedulaFile.value,
          )),
        ),
        const SizedBox(width: 16),
        
        // Foto placa
        Expanded(
          child: Obx(() => _buildPhotoUploadCard(
            label: 'Foto Placa',
            onTap: controller.takeFotoPlaca,
            imageFile: controller.fotoPlacaFile.value,
          )),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadCard({
    required String label,
    required VoidCallback onTap,
    bool isAddMore = false,
    File? imageFile,
    int additionalImagesCount = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFB4A9A6),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: imageFile != null
            ? Stack(
                children: [
                  // Preview de la imagen
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      imageFile,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Overlay con icono de editar
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isAddMore) ...[
                    const Icon(
                      Icons.camera_alt_outlined,
                      size: 18,
                      color: Color(0xFF998E8C),
                    ),
                    const SizedBox(height: 4),
                  ],
                  BRAText(
                    text: isAddMore && additionalImagesCount > 0 
                        ? '$label ($additionalImagesCount)'
                        : label,
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF998E8C),
                    textAlign: TextAlign.center,
                  ),
                  if (isAddMore) ...[
                    const SizedBox(height: 4),
                    Icon(
                      additionalImagesCount > 0 
                          ? Icons.add_photo_alternate_outlined
                          : Icons.camera_alt_outlined,
                      size: 18,
                      color: const Color(0xFF998E8C),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool isRequired = false,
    String? errorText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label con indicador de obligatorio
        Row(
          children: [
            BRAText(
              text: label,
              size: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF231918),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const BRAText(
                text: '*',
                size: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Text field
        Container(
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null 
                  ? Colors.red
                  : isRequired 
                      ? const Color(0xFFEB472A).withOpacity(0.6)
                      : const Color(0xFF85736F),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
              hintText: hint ?? (isRequired ? '$label (requerido)' : '$label (opcional)'),
              hintStyle: TextStyle(
                color: const Color(0xFF998E8C).withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF534340),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        // Error message
        if (errorText != null) ...[
          const SizedBox(height: 4),
          BRAText(
            text: errorText,
            size: 12,
            fontWeight: FontWeight.w400,
            color: Colors.red,
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildObservationField(ManualParkingRegisterController controller) {
    return SizedBox(
      height: 89,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 8),
            child: BRAText(
              text: 'Añadir observación',
              size: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF231918),
            ),
          ),
          // Text field (multiline)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF85736F),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: controller.observacionController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF534340),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidateButton(ManualParkingRegisterController controller) {
    return Container(
      margin: const EdgeInsets.all(24),
      width: double.infinity,
      height: 46,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.validateForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEB472A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const BRAText(
                text: 'Validar',
                size: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
      )),
    );
  }

  Widget _buildAdditionalImagesSection(ManualParkingRegisterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BRAText(
          text: 'Imágenes adicionales',
          size: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF231918),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Botón para agregar nueva imagen
                _buildAddImageButton(controller),
                // Imágenes existentes con botón de eliminar
                ...controller.imagenesAdicionalesFiles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final imageFile = entry.value;
                  return _buildImagePreview(
                    imageFile,
                    () => controller.removeImage(index),
                  );
                }).toList(),
              ],
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildAddImageButton(ManualParkingRegisterController controller) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFB4A9A6),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: controller.addImagenes,
        borderRadius: BorderRadius.circular(8),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 24,
              color: Color(0xFF998E8C),
            ),
            SizedBox(height: 4),
            BRAText(
              text: 'Agregar',
              size: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xFF998E8C),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(File imageFile, VoidCallback onDelete) {
    return Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFB4A9A6),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              imageFile,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Botón de eliminar
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}