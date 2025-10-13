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
import 'controller/exit_request_form_controller.dart';
import 'views/children_list_view.dart';
import 'enums/registration_type.dart';

class ExitWithoutQrToSchoolRequestFormPage extends StatelessWidget {
  final RegistrationType registrationType;
  final ResidentChildsResponse residentChildsResponse;
  final MainActionType mainActionType;
  final List<PendingSchoolRegisterResponse>? pendingRegisters;
  final PendingSchoolRegisterResponse? selectedPendingRegister;

  ExitWithoutQrToSchoolRequestFormPage({
    Key? key,
    this.registrationType = RegistrationType.withQR,
    required this.residentChildsResponse,
    required this.mainActionType,
    this.pendingRegisters,
    this.selectedPendingRegister,
  });

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
            DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            controller.dateTimeController.text =
                '${date.day}/${date.month}/${date.year} ${time.format(context)}';
          }
        });
      }
    });
  }

  Widget _buildPhotosRow(ExitRequestFormController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => controller.credentialUrlImage?.value != '' && controller.credentialUrlImage?.value != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BRAText(
                    text: 'Credencial',
                    size: 14,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    width: 153,
                    height: 146,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF85736F)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: controller.credentialUrlImage?.value ?? '',
                        width: 153,
                        height: 146,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink()),
        SizedBox(width: (controller.credentialUrlImage?.value != '' && controller.credentialUrlImage?.value != null) &&
                       (controller.profileUrlImage?.value != '' && controller.profileUrlImage?.value != null) ? 20 : 0),
        Obx(() => controller.profileUrlImage?.value != '' && controller.profileUrlImage?.value != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BRAText(
                    text: 'Perfil',
                    size: 14,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    width: 153,
                    height: 146,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF85736F)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: controller.profileUrlImage?.value ?? '',
                        width: 153,
                        height: 146,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildInformationTab(
      BuildContext context, ExitRequestFormController controller) {
    // When mainActionType is gateLeave, show WithoutQR form with pending register data
    if (controller.mainActionType == MainActionType.gateLeave) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photos row first
            _buildPhotosRow(controller),
            const SizedBox(height: 28),

            // Tipo de Pinlet - always show
            CustomTextFormField(
              label: 'Tipo de Pinlet',
              hintText: '',
              controller: controller.pinletTypeController,
              focusNode: FocusNode(),
              onChanged: (value) {},
              readOnly: true,
            ),
            const SizedBox(height: 20),

            // Residente - always show
            CustomTextFormField(
              label: 'Residente',
              hintText: '',
              controller: controller.representativeController,
              focusNode: controller.representativeFocus,
              onChanged: (value) {},
              readOnly: true,
            ),
            const SizedBox(height: 20),

            // Celular de residente - always show
            CustomTextFormField(
              label: 'Celular de residente',
              hintText: '',
              controller: controller.phoneController,
              focusNode: controller.phoneFocus,
              onChanged: (value) {},
              readOnly: true,
            ),
            const SizedBox(height: 20),

            // Primario y Secundario row
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: 'Primario',
                    hintText: '',
                    controller: controller.primaryController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Secundario',
                    hintText: '',
                    controller: controller.secondaryController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                    readOnly: true,
                  ),
                ),
              ],
            ),

            // Conditional fields - only show if not empty
            GetBuilder<ExitRequestFormController>(builder: (controller) {
              List<Widget> conditionalFields = [];

              // Nombre del que retira
              if (controller.guestNameController.text.isNotEmpty) {
                conditionalFields.addAll([
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    label: 'Nombre del que retira',
                    hintText: '',
                    controller: controller.guestNameController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                    readOnly: true,
                  ),
                ]);
              }

              // Cédula del que retira
              if (controller.guestIdController.text.isNotEmpty) {
                conditionalFields.addAll([
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    label: 'Cédula del que retira',
                    hintText: '',
                    controller: controller.guestIdController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                    readOnly: true,
                  ),
                ]);
              }

              // Celular
              if (controller.guestPhoneController.text.isNotEmpty) {
                conditionalFields.addAll([
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    label: 'Celular',
                    hintText: '',
                    controller: controller.guestPhoneController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                    readOnly: true,
                  ),
                ]);
              }

              // Placa
              if (controller.plateController.text.isNotEmpty) {
                conditionalFields.addAll([
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    label: 'Placa',
                    hintText: '',
                    controller: controller.plateController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                    readOnly: true,
                  ),
                ]);
              }

              // Motivo
              if (controller.visitReasonController.text.isNotEmpty) {
                conditionalFields.addAll([
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    label: 'Motivo',
                    hintText: '',
                    controller: controller.visitReasonController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                    readOnly: true,
                  ),
                ]);
              }
              return Column(children: conditionalFields);
            }),
          ],
        ),
      );
    }
    // Original logic for other action types
    else if (controller.registrationType.value == RegistrationType.withoutQR) {
      // Vista con QR
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPhotosRow(controller),
            const SizedBox(height: 28),
            CustomTextFormField(
              label: 'Tipo de Pinlet',
              hintText: '',
              focusNode: FocusNode(),
              controller: controller.pinletTypeController,
              onChanged: (value) {},
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'Nombre y Apellido',
              hintText: '',
              controller: controller.representativeController,
              focusNode: controller.representativeFocus,
              onChanged: (value) {},
              readOnly: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: 'Primario',
                    hintText: '',
                    focusNode: FocusNode(),
                    controller: controller.primaryController,
                    onChanged: (value) {},
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Secundario',
                    hintText: '',
                    focusNode: FocusNode(),
                    controller: controller.secondaryController,
                    onChanged: (value) {},
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'Cédula',
              hintText: '',
              focusNode: FocusNode(),
              controller: controller.idController,
              onChanged: (value) {},
              readOnly: true,
            ),
            const SizedBox(height: 20),
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
    } else {
      // Vista sin QR
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotosRow(controller),
            const SizedBox(height: 28),
            controller.pinletTypeController.text.isEmpty
                ? Container()
                : CustomTextFormField(
                    label: 'Tipo de Pinlet',
                    hintText: '',
                    controller: controller.pinletTypeController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                  ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'Residente',
              hintText: '',
              controller: controller.representativeController,
              focusNode: controller.representativeFocus,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              label: 'Celular de residente',
              hintText: '',
              controller: controller.phoneController,
              focusNode: controller.phoneFocus,
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: 'Primario',
                    hintText: '',
                    controller: controller.primaryController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    label: 'Secundario',
                    hintText: '',
                    controller: controller.secondaryController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            controller.guestNameController.text.isEmpty
                ? Container()
                : CustomTextFormField(
                    label: 'Nombre del invitado',
                    hintText: '',
                    controller: controller.guestNameController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                  ),
            SizedBox(height: controller.guestIdController.text.isEmpty ? 0 : 20),
            controller.guestIdController.text.isEmpty
                ? Container()
                : CustomTextFormField(
                    label: 'Cédula Invitado',
                    hintText: '',
                    controller: controller.guestIdController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                  ),
            SizedBox(height: controller.guestPhoneController.text.isEmpty ? 0 : 20),
            controller.guestPhoneController.text.isEmpty
                ? Container()
                : CustomTextFormField(
                    label: 'Celular Invitado',
                    hintText: '',
                    controller: controller.guestPhoneController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                  ),
            SizedBox(
                height: controller.plateController.text.isEmpty ? 0 : 20),
            controller.plateController.text.isEmpty
                ? Container()
                : CustomTextFormField(
                    label: 'Placa',
                    hintText: '',
                    controller: controller.plateController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                  ),
            SizedBox(height: controller.visitReasonController.text.isEmpty ? 0 : 20),
            controller.visitReasonController.text.isEmpty
                ? Container()
                : CustomTextFormField(
                    label: 'Motivo de invitación',
                    hintText: '',
                    controller: controller.visitReasonController,
                    focusNode: FocusNode(),
                    onChanged: (value) {},
                  ),
          ],
        ),
      );
    }
  }

  Widget _buildDetailTab(
      BuildContext context, ExitRequestFormController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BRAText(
            text: 'Detalles del retiro',
            size: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF231918),
          ),
          const SizedBox(height: 16),
          
          // Mostrar campos en modo read-only cuando es histórico
          if (controller.mainActionType == MainActionType.historic || controller.mainActionType == MainActionType.hisotric) ...[
            // Mostrar imágenes si están disponibles
            if (controller.residentChildsResponse.imagenes != null && controller.residentChildsResponse.imagenes!.isNotEmpty) ...[
              const BRAText(
                text: 'Imágenes del retiro',
                size: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF231918),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.residentChildsResponse.imagenes!.length,
                  itemBuilder: (context, index) {
                    final imageUrl = controller.residentChildsResponse.imagenes![index];
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF85736F)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 100,
                          height: 120,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Color(0xFF85736F),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Modo histórico: mostrar información como solo lectura
            if (controller.nameController.text.isNotEmpty) ...[
              CustomTextFormField(
                label: 'Nombre del que retira',
                hintText: '',
                focusNode: controller.nameFocus,
                controller: controller.nameController,
                onChanged: (value) {},
                readOnly: true,
              ),
              const SizedBox(height: 16),
            ],
            if (controller.idController.text.isNotEmpty) ...[
              CustomTextFormField(
                label: 'Cédula del que retira',
                hintText: '',
                focusNode: controller.idFocus,
                controller: controller.idController,
                onChanged: (value) {},
                readOnly: true,
              ),
              const SizedBox(height: 16),
            ],
            if (controller.licensePlateController.text.isNotEmpty) ...[
              CustomTextFormField(
                label: 'Placa',
                hintText: '',
                focusNode: controller.licensePlateFocus,
                controller: controller.licensePlateController,
                onChanged: (value) {},
                readOnly: true,
              ),
              const SizedBox(height: 16),
            ],
            if (controller.reasonController.text.isNotEmpty) ...[
              CustomTextFormField(
                label: 'Motivo',
                hintText: '',
                focusNode: controller.reasonFocus,
                controller: controller.reasonController,
                onChanged: (value) {},
                readOnly: true,
              ),
              const SizedBox(height: 16),
            ],
            if (controller.dateTimeController.text.isNotEmpty) ...[
              CustomTextFormField(
                label: 'Fecha y hora',
                hintText: '',
                focusNode: controller.dateTimeFocus,
                controller: controller.dateTimeController,
                onChanged: (value) {},
                readOnly: true,
              ),
            ],
            // Si no hay datos para mostrar, mostrar mensaje
            if (controller.nameController.text.isEmpty && 
                controller.idController.text.isEmpty && 
                controller.licensePlateController.text.isEmpty &&
                controller.reasonController.text.isEmpty && 
                controller.dateTimeController.text.isEmpty &&
                (controller.residentChildsResponse.imagenes == null || controller.residentChildsResponse.imagenes!.isEmpty)) ...[
              const BRAText(
                text: 'No hay detalles adicionales disponibles para este registro.',
                size: 14,
                color: Color(0xFF5B5856),
              ),
            ],
          ] else ...[
            // Modo normal: campos editables
            CustomTextFormField(
              label: 'Motivo',
              hintText: 'Ingrese el motivo del retiro',
              focusNode: controller.reasonFocus,
              controller: controller.reasonController,
              onChanged: (value) {},
              maxLength: 200,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              label: 'Fecha y hora',
              hintText: 'Seleccione fecha y hora',
              focusNode: controller.dateTimeFocus,
              controller: controller.dateTimeController,
              onChanged: (value) {},
              readOnly: true,
              onTap: () => _showDateTimePicker(context, controller),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ExitRequestFormController>(
          init: ExitRequestFormController(
            residentChildsResponse: residentChildsResponse,
            mainActionType: mainActionType,
            pendingRegisters: pendingRegisters,
            selectedPendingRegister: selectedPendingRegister,
          ),
          builder: (controller) {
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
                                width: (controller.shouldShowDetailView || mainActionType == MainActionType.historic || mainActionType == MainActionType.hisotric) ? 110 : 170, // Expand width if no detail tab
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
                                width: (controller.shouldShowDetailView || mainActionType == MainActionType.historic || mainActionType == MainActionType.hisotric) ? 110 : 170, // Expand width if no detail tab
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
                            // Detail tab - Solo mostrar si debe mostrarse o está en modo histórico
                            if (controller.shouldShowDetailView || mainActionType == MainActionType.historic || mainActionType == MainActionType.hisotric)
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
                                    text: (mainActionType == MainActionType.historic || mainActionType == MainActionType.hisotric) 
                                        ? 'Detalles'
                                        : (mainActionType == MainActionType.gateLeave ? 'Detalles' : 'Detallar'),
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
                          // Mostrar DetailTab en modo histórico
                          return (mainActionType == MainActionType.historic || mainActionType == MainActionType.hisotric) 
                              ? _buildDetailTab(context, controller)
                              : controller.shouldShowDetailView 
                                  ? DetailView()
                                  : const SizedBox.shrink();
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
