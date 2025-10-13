import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/parking/type_parking_register/type_parking_register_controller.dart';

class SearchCodeModal extends StatelessWidget {
  final TypeParkingRegisterController controller;

  const SearchCodeModal({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(195, 195, 195, 0.3),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
            BoxShadow(
              color: Color.fromRGBO(195, 195, 195, 0.12),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del modal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BRAText(
                  text: 'Buscar por Código',
                  size: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF231918),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF231918),
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Campo de texto para el código
            const BRAText(
              text: 'Ingrese el código:',
              size: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF231918),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: codeController,
              autofocus: true,
              decoration: CustomTextFormField.decorationFormCard(
                labelText: 'Código de parqueo',
                theme: Theme.of(context),
                focusNode: FocusNode(),
              ),
              style: const TextStyle(
                color: Color(0xFF231918),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

            // Botones
            Row(
              children: [
                // Botón Cancelar
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xFF85736F),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: BRAText(
                          text: 'Cancelar',
                          size: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF85736F),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Botón Buscar
                Expanded(
                  child: Obx(() => GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : () {
                                if (codeController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Debe ingresar un código',
                                    backgroundColor:
                                        Colors.red.withOpacity(0.8),
                                    colorText: Colors.white,
                                  );
                                  return;
                                }
                                controller
                                    .searchByCode(codeController.text.trim());
                              },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: controller.isLoading.value
                                ? const Color(0xFF85736F)
                                : const Color(0xFFEB472A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
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
                                    text: 'Buscar',
                                    size: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
