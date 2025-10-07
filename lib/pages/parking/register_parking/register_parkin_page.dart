import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'register_parkin_controller.dart';

class RegisterParkinPage extends StatelessWidget {
  const RegisterParkinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<RegisterParkinController>(
        init: RegisterParkinController(),
        builder: (controller) {
          return SafeArea(
            child: Column(
              children: [
                // Header with back button and title
                _buildHeader(),
                // Tab selector
                _buildTabSelector(controller),
                // Form content
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildFormContent(controller),
                  ),
                ),
                // Continue button
                _buildContinueButton(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
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
              icon: Icon(
                Icons.arrow_back_ios,
                color: const Color(0xFF231918),
                size: 20,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          const SizedBox(width: 8),
          // Title
          Expanded(
            child: BRAText(
              text: 'Formulario de ingreso',
              size: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF231918),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector(RegisterParkinController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        child: Row(
          children: [
            _buildTabItem(controller, 0, 'Invitado'),
            _buildTabItem(controller, 1, 'Quien ingresa'),
            _buildTabItem(controller, 2, 'Residente'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(RegisterParkinController controller, int index, String title) {
    final isSelected = controller.selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectTab(index),
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: BRAText(
              text: title,
              size: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF231918),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(RegisterParkinController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _buildTabContent(controller),
    );
  }

  Widget _buildTabContent(RegisterParkinController controller) {
    switch (controller.selectedTabIndex) {
      case 0:
        return _buildInvitadoTab(controller);
      case 1:
        return _buildQuienIngresaTab(controller);
      case 2:
        return _buildResidenteTab(controller);
      default:
        return _buildInvitadoTab(controller);
    }
  }

  Widget _buildInvitadoTab(RegisterParkinController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        // Tipo de invitado
        _buildDropdownField(
          label: 'Tipo de invitado',
          value: controller.selectedTipoInvitado,
          items: controller.tiposInvitado,
          onChanged: (value) => controller.changeTipoInvitado(value),
          isActive: false,
        ),
        const SizedBox(height: 20),
        // Nombre del invitado
        _buildTextField(
          label: 'Nombre del invitado',
          controller: controller.nombreController,
          isActive: false,
        ),
        const SizedBox(height: 20),
        // Cédula
        _buildTextField(
          label: 'Cédula',
          controller: controller.cedulaController,
          isActive: false,
        ),
        const SizedBox(height: 20),
        // Celular
        _buildTextField(
          label: 'Celular',
          controller: controller.celularController,
          isActive: false,
        ),
        const SizedBox(height: 20),
        // Placa (active field)
        _buildTextField(
          label: 'Placa',
          controller: controller.placaController,
          isActive: true,
        ),
        const SizedBox(height: 20),
        // Motivo de invitación
        _buildTextField(
          label: 'Motivo de invitación (Opcional)',
          controller: controller.motivoController,
          isActive: true,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildQuienIngresaTab(RegisterParkinController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        _buildImageUploadSection(),
        const SizedBox(height: 20),
        _buildTextField(
          label: "Nombre y Apellido (Opcional)",
          controller: controller.nombreController,
          isActive: true,
          hint: "Martha Delgado",
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: "Cédula (Opcional)",
          controller: controller.cedulaController,
          isActive: true,
          hint: "0922429735",
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: "Celular(Opcional)",
          controller: controller.celularController,
          isActive: true,
          hint: "0922429735",
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: "Placa",
          controller: controller.placaController,
          isActive: true,
          hint: "GRV0651",
        ),
        const SizedBox(height: 20),
        _buildObservationField(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildResidenteTab(RegisterParkinController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        _buildTextField(
          label: "Nombre de residente",
          controller: controller.nombreResidenteController,
          isActive: false,
          hint: "David Macías",
          labelColor: const Color(0xFFB3B1B8),
          hintColor: const Color(0xFFB3B1B8),
          borderColor: const Color(0xFFB3B1B8),
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: "Celular",
          controller: controller.celularResidenteController,
          isActive: false,
          hint: "0981234567",
          labelColor: const Color(0xFFB3B1B8),
          hintColor: const Color(0xFFB3B1B8),
          borderColor: const Color(0xFFB3B1B8),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildTextField(
                label: "Primario",
                controller: controller.primarioController,
                isActive: true,
                hint: "SOLAR",
              ),
            ),
            const SizedBox(width: 38),
            Expanded(
              child: _buildTextField(
                label: "Secundario",
                controller: controller.secundarioController,
                isActive: true,
                hint: "1",
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool isActive,
    String? hint,
    Color? labelColor,
    Color? hintColor,
    Color? borderColor,
  }) {
    final defaultLabelColor = isActive ? const Color(0xFF231918) : const Color(0xFFB3B1B8);
    final defaultHintColor = isActive ? const Color(0xFF998e8c) : const Color(0xFFB3B1B8);
    final defaultBorderColor = isActive ? const Color(0xFF85736F) : const Color(0xFFB3B1B8);
    
    return Container(
      height: 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 8),
            child: BRAText(
              text: label,
              size: 14,
              fontWeight: FontWeight.w400,
              color: labelColor ?? defaultLabelColor,
            ),
          ),
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor ?? defaultBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: hintColor ?? defaultHintColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: TextStyle(
                  color: isActive ? const Color(0xFF534340) : (hintColor ?? defaultHintColor),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required bool isActive,
  }) {
    return Container(
      height: 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 8),
            child: BRAText(
              text: label,
              size: 14,
              fontWeight: FontWeight.w400,
              color: isActive ? const Color(0xFF231918) : const Color(0xFFB3B1B8),
            ),
          ),
          // Dropdown
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isActive ? const Color(0xFF85736F) : const Color(0xFFB3B1B8),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                value: value,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                ),
                style: TextStyle(
                  color: isActive ? const Color(0xFF534340) : const Color(0xFFB3B1B8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                dropdownColor: Colors.white,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: BRAText(
                      text: item,
                      size: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF534340),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildImageUploadCard(
                icon: Icons.camera_alt_outlined,
                label: "Foto cédula",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildImageUploadCard(
                icon: Icons.camera_alt_outlined,
                label: "Foto Placa",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildImageUploadCard(
                icon: Icons.camera_alt_outlined,
                label: "Añadir imagenes",
                isAddMore: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUploadCard({
    required IconData icon,
    required String label,
    bool isAddMore = false,
  }) {
    return Container(
      height: 61,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFB4A9A6),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isAddMore) ...[
            Icon(
              icon,
              size: 18,
              color: const Color(0xFF998E8C),
            ),
            const SizedBox(height: 4),
          ],
          BRAText(
            text: label,
            size: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF998E8C),
            textAlign: TextAlign.center,
          ),
          if (isAddMore) ...[
            const SizedBox(height: 4),
            Icon(
              icon,
              size: 18,
              color: const Color(0xFF998E8C),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildObservationField() {
    return Container(
      height: 89,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Container(
            margin: const EdgeInsets.only(left: 10, bottom: 8),
            child: BRAText(
              text: "Añadir observación",
              size: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF231918),
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
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
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

  Widget _buildContinueButton(RegisterParkinController controller) {
    return Container(
      margin: const EdgeInsets.all(24),
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: () => controller.onContinuePressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEB472A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: BRAText(
          text: 'Continuar',
          size: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}