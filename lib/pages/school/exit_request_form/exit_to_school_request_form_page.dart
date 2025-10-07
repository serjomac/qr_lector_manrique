import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_childs_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/pending_school_regiter_response.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/school/detail_view.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/controller/exit_request_form_controller.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/enums/registration_type.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/views/children_list_view.dart';

class ExitToSchoolRequestFormPage extends StatelessWidget {
  final RegistrationType registrationType;
  final ResidentChildsResponse residentChildsResponse;
  final MainActionType mainActionType;
  final List<PendingSchoolRegisterResponse>? pendingRegisters;
  
  ExitToSchoolRequestFormPage({
    Key? key,
    required this.registrationType,
    required this.residentChildsResponse,
    required this.mainActionType,
    this.pendingRegisters,
  }) : super(key: key) {
  }

  void _showDateTimePicker(
      BuildContext context, ExitRequestFormController controller) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((time) {
          if (time != null) {
            controller.dateTimeController.text =
                '${date.day}/${date.month}/${date.year} ${time.format(context)}';
          }
        });
      }
    });
  }

  Widget _buildInformationTab(
      BuildContext context, ExitRequestFormController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Photos row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => GestureDetector(
                    onTap: () => controller.pickImage(ImageSource.camera,
                        isIdPhoto: true),
                    child: Container(
                      width: 153,
                      height: 146,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF85736F)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: controller.credentialUrlImage?.value != ''
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        controller.credentialUrlImage?.value ??
                                            '',
                                    width: 153,
                                    height: 146,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => controller
                                        .credentialUrlImage?.value = '',
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Icon(Icons.add_a_photo_outlined,
                                  size: 40, color: Color(0xFF85736F)),
                            ),
                    ),
                  )),
              const SizedBox(width: 20),
              Obx(() => GestureDetector(
                    onTap: () => controller.pickImage(ImageSource.camera,
                        isLicensePlatePhoto: true),
                    child: Container(
                      width: 153,
                      height: 146,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF85736F)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: controller.profileUrlImage?.value != ''
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        controller.profileUrlImage?.value ?? '',
                                    width: 153,
                                    height: 146,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () =>
                                        controller.profileUrlImage?.value = '',
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Icon(Icons.add_a_photo_outlined,
                                  size: 40, color: Color(0xFF85736F)),
                            ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 28),

          // Tipo de Pinlet dropdown
          CustomTextFormField(
            label: 'Tipo de Pinlet',
            hintText: 'Residente',
            focusNode: FocusNode(),
            controller: TextEditingController(),
            onChanged: (value) {},
            readOnly: true,
          ),
          const SizedBox(height: 20),

          // Nombre y Apellido field
          CustomTextFormField(
            label: 'Nombre y Apellido',
            hintText: 'Martha Delgado',
            controller: controller.representativeController,
            focusNode: controller.representativeFocus,
            onChanged: (value) {},
            readOnly: true,
          ),
          const SizedBox(height: 20),

          // Primary and Secondary fields row
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  label: 'Primario',
                  hintText: 'SOLAR',
                  focusNode: FocusNode(),
                  controller: TextEditingController(),
                  onChanged: (value) {},
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomTextFormField(
                  label: 'Secundario',
                  hintText: '1',
                  focusNode: FocusNode(),
                  controller: TextEditingController(),
                  onChanged: (value) {},
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Cédula field
          CustomTextFormField(
            label: 'Cédula',
            hintText: '0922429735',
            focusNode: FocusNode(),
            controller: TextEditingController(),
            onChanged: (value) {},
            readOnly: true,
          ),
          const SizedBox(height: 20),

          // Celular field
          CustomTextFormField(
            label: 'Celular',
            hintText: '0922429735',
            controller: controller.phoneController,
            focusNode: controller.phoneFocus,
            onChanged: (value) {},
            readOnly: true,
          ),
        ],
      ),
    );
  }

  // Widget _buildDetailTab(
  //     BuildContext context, ExitRequestFormController controller) {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const BRAText(
  //           text: 'Detalles del retiro',
  //           size: 16,
  //           fontWeight: FontWeight.w600,
  //           color: Color(0xFF231918),
  //         ),
  //         const SizedBox(height: 16),
  //         CustomTextFormField(
  //           label: 'Motivo',
  //           hintText: 'Ingrese el motivo del retiro',
  //           focusNode: controller.reasonFocus,
  //           controller: controller.reasonController,
  //           onChanged: (value) {},
  //           maxLength: 200,
  //         ),
  //         const SizedBox(height: 16),
  //         CustomTextFormField(
  //           label: 'Fecha y hora',
  //           hintText: 'Seleccione fecha y hora',
  //           focusNode: controller.dateTimeFocus,
  //           controller: controller.dateTimeController,
  //           onChanged: (value) {},
  //           readOnly: true,
  //           onTap: () => _showDateTimePicker(context, controller),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExitRequestFormController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ExitRequestFormController>(
          init: ExitRequestFormController(
            residentChildsResponse: residentChildsResponse,
            mainActionType: mainActionType,
            pendingRegisters: pendingRegisters,
          ),
          builder: (_) {
            return SafeArea(
              child: Column(
                children: [
                  // Header with back button and title
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, top: 12.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF231918),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const BRAText(
                          text: 'Formulario de solicitud de retiro',
                          size: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF231918),
                        ),
                      ],
                    ),
                  ),

                  // Tab selector
                  Obx(() => Container(
                        margin: const EdgeInsets.only(top: 15.0),
                        width: 342,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F4),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Information tab
                            GestureDetector(
                              onTap: () => controller.currentTabIndex.value = 0,
                              child: Container(
                                width: 110,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: controller.currentTabIndex.value == 0
                                      ? Colors.black
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                alignment: Alignment.center,
                                child: BRAText(
                                  text: 'información',
                                  size: 12,
                                  fontWeight: FontWeight.w500,
                                  color: controller.currentTabIndex.value == 0
                                      ? Colors.white
                                      : const Color(0xFF231918),
                                ),
                              ),
                            ),
                            // Children tab
                            GestureDetector(
                              onTap: () => controller.currentTabIndex.value = 1,
                              child: Container(
                                width: 110,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: controller.currentTabIndex.value == 1
                                      ? Colors.black
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                alignment: Alignment.center,
                                child: BRAText(
                                  text: 'Hijos',
                                  size: 12,
                                  fontWeight: FontWeight.w500,
                                  color: controller.currentTabIndex.value == 1
                                      ? Colors.white
                                      : const Color(0xFF231918),
                                ),
                              ),
                            ),
                            // Detail tab
                            GestureDetector(
                              onTap: () => controller.currentTabIndex.value = 2,
                              child: Container(
                                width: 110,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: controller.currentTabIndex.value == 2
                                      ? Colors.black
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                alignment: Alignment.center,
                                child: BRAText(
                                  text: 'Detallar',
                                  size: 12,
                                  fontWeight: FontWeight.w500,
                                  color: controller.currentTabIndex.value == 2
                                      ? Colors.white
                                      : const Color(0xFF231918),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  // Tab content
                  Expanded(
                    child: Obx(() {
                      switch (controller.currentTabIndex.value) {
                        case 0:
                          return _buildInformationTab(context, controller);
                        case 1:
                          return const ChildrenListView();
                        case 2:
                          return const DetailView();
                        default:
                          return const SizedBox.shrink();
                      }
                    }),
                  ),
                  // Expanded(
                  //   child: SingleChildScrollView(
                  //     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  //     child: Column(
                  //       children: [
                  //         // Photos row
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Image.asset(
                  //               'assets/images/photo_placeholder.png',
                  //               width: 153,
                  //               height: 146,
                  //             ),
                  //             const SizedBox(width: 20),
                  //             Image.asset(
                  //               'assets/images/photo_placeholder.png',
                  //               width: 153,
                  //               height: 146,
                  //             ),
                  //           ],
                  //         ),
                  //         const SizedBox(height: 28),

                  //         // Name field
                  //         CustomTextFormField(
                  //           focusNode: FocusNode(),
                  //           label: 'Nombre y Apellido',
                  //           controller: _.representativeController,
                  //           onChanged: (value) {},
                  //           readOnly: true,
                  //         ),
                  //         const SizedBox(height: 20),

                  //         // ID field
                  //         CustomTextFormField(
                  //           focusNode: FocusNode(),
                  //           label: 'Cédula',
                  //           // controller: idController,
                  //           onChanged: (value) {},
                  //           readOnly: true,
                  //         ),
                  //         const SizedBox(height: 20),

                  //         // Phone field
                  //         CustomTextFormField(
                  //           focusNode: _.phoneFocus,
                  //           label: 'Celular',
                  //           controller: _.phoneController,
                  //           onChanged: (value) {},
                  //           readOnly: true,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          }),
    );
  }
}
