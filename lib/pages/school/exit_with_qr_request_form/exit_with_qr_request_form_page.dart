import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/shared/widgets/custom_text_field.dart';
import 'exit_with_qr_request_form_controller.dart';

class ExitWithQrRequestFormPage extends StatelessWidget {
  final ExitWithQrRequestFormController controller = Get.put(ExitWithQrRequestFormController());

  ExitWithQrRequestFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: controller.goBack,
          ),
          const SizedBox(width: 8),
          const Text(
            'Formulario de solicitud de retiro',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF231918),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(3.0),
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Obx(() => Row(
        children: [
          _buildStepButton('Información', 0),
          _buildStepButton('Hijos', 1),
          _buildStepButton('Detallar', 2),
        ],
      )),
    );
  }

  Widget _buildStepButton(String label, int step) {
    return Obx(() {
      final isSelected = controller.currentStep.value == step;
      return Expanded(
        child: GestureDetector(
          onTap: () => controller.currentStep.value = step,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF231918),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildTextField(
          label: 'Tipo de Pinlet',
          value: controller.selectedType,
          onChanged: controller.onTypeChanged,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Residente',
          value: controller.resident,
          onChanged: controller.onResidentChanged,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Primario',
                value: controller.primary,
                onChanged: controller.onPrimaryChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'Secundario',
                value: controller.secondary,
                onChanged: controller.onSecondaryChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Nombre del invitado',
          value: controller.guestName,
          onChanged: controller.onGuestNameChanged,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Cédula Invitado',
          value: controller.guestId,
          onChanged: controller.onGuestIdChanged,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Celular Invitado',
          value: controller.guestPhone,
          onChanged: controller.onGuestPhoneChanged,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Placa',
          value: controller.licensePlate,
          onChanged: controller.onLicensePlateChanged,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Motivo de invitación',
          value: controller.reason,
          onChanged: controller.onReasonChanged,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required RxString value,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF231918),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => CustomTextFormField(
          focusNode: FocusNode(),
          label: '',
          initialValue: value.value,
          onChanged: onChanged,
          // borderColor: const Color(0xFF85736F),
          // textColor: const Color(0xFF534340),
          // inputType: TextInputType.text,
          // hintText: label,
        )),
      ],
    );
  }
}
