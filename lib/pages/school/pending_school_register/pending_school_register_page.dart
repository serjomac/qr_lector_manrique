import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/string_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_childs_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/pending_school_regiter_response.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/exit_without_qr_to_school_request_form_page.dart';
import 'pending_school_register_controller.dart';

class PendingSchoolRegisterPage extends StatelessWidget {
  final GateDoor? entranceIdSelected;
  final MainActionType mainActionType;
  const PendingSchoolRegisterPage(
      {Key? key,
      required this.entranceIdSelected,
      required this.mainActionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF231918)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const BRAText(
          text: 'Estudiantes a retirar',
          size: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF231918),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search bar and grouping controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            child: Column(
              children: [
                // Search field
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFC3C3C3)),
                  ),
                  child: GetBuilder<PendingSchoolRegisterController>(
                    init: PendingSchoolRegisterController(
                        entranceIdSelected: entranceIdSelected),
                    builder: (controller) {
                      return TextField(
                        controller: controller.searchController,
                        onChanged: (value) {
                          controller.filterRegisters();
                        },
                        decoration: InputDecoration(
                          hintText: 'Buscar',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5B5856),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                          suffixIcon:
                              controller.searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Color(0xFF5B5856),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        controller.searchController.clear();
                                        controller.update();
                                      },
                                    )
                                  : null,
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5B5856),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Group checkbox
                GetBuilder<PendingSchoolRegisterController>(
                  builder: (controller) {
                    return Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const BRAText(
                            text: 'Agrupar',
                            size: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              controller.toggleGrouping();
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: controller.isGrouped.value
                                    ? const Color(0xFFEB472A)
                                    : Colors.white,
                                border: Border.all(
                                  color: controller.isGrouped.value
                                      ? const Color(0xFFEB472A)
                                      : const Color(0xFFC3C3C3),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: controller.isGrouped.value
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          // List of students
          Expanded(
            child: GetBuilder<PendingSchoolRegisterController>(
              init: PendingSchoolRegisterController(
                  entranceIdSelected: entranceIdSelected),
              builder: (controller) {
                return Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFEB472A)),
                      ),
                    );
                  }

                  if (controller.pendingRegisters.isEmpty) {
                    final hasSearchQuery =
                        controller.searchController.text.isNotEmpty;
                    return Center(
                      child: BRAText(
                        text: hasSearchQuery
                            ? 'No se encontraron resultados para "${controller.searchController.text}"'
                            : 'No hay registros pendientes',
                        size: 16,
                        color: Color(0xFF5B5856),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    itemCount: controller.pendingRegisters.length,
                    itemBuilder: (context, index) {
                      final register = controller.pendingRegisters[index];
                      final isGroupedView = controller.isGrouped.value;
                      final childrenCount =
                          controller.getChildrenCount(register);

                      return GestureDetector(
                        onTap: () async {
                          List<PendingSchoolRegisterResponse> registersToSend;
                          
                          if (isGroupedView) {
                            // When grouped, get all children of the group
                            registersToSend = controller.getGroupChildren(register);
                          } else {
                            // When not grouped, get all registers with same idResidenteLugar and tipo from all registers
                            registersToSend = controller.getAllPendingRegistersByGroup(register);
                          }
                          
                          final result = await Get.to(ExitWithoutQrToSchoolRequestFormPage(
                            residentChildsResponse: ResidentChildsResponse(),
                            mainActionType: mainActionType,
                            pendingRegisters: registersToSend,
                            selectedPendingRegister: register,
                          ));
                          
                          // If result is true, refresh the pending registers
                          if (result == true) {
                            await controller.fetchPendingRegisters();
                            if (controller.isGrouped.value) {
                              controller.filterRegisters();
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          height: 93,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(69, 63, 61, 0.1),
                                blurRadius: 15,
                                offset: Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Color.fromRGBO(69, 63, 61, 0.03),
                                blurRadius: 50,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Course/Group info - top right (or children count when grouped)
                              Positioned(
                                top: 14.5,
                                right: 24,
                                child: BRAText(
                                  text: isGroupedView
                                      ? '$childrenCount ${childrenCount == 1 ? 'hijo' : 'hijos'}'
                                      : register.nombreCategoria ?? '',
                                  size: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF5B5856),
                                ),
                              ),

                              // Student/Representative icon
                              Positioned(
                                left: 17,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 25,
                                  height: 31,
                                  child: Icon(
                                    isGroupedView ? Icons.person : Icons.school,
                                    color: Color(0xFF5B5856),
                                    size: 24,
                                  ),
                                ),
                              ),

                              // Name (Representative name when grouped, Student name when not grouped)
                              Positioned(
                                left: 55,
                                top: 36,
                                child: BRAText(
                                  text: isGroupedView
                                      ? '${register.nombresResidente!.getFirstName} ${register.apellidosResidente}'
                                      : register.nombreHijo ?? '',
                                  size: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF202023),
                                ),
                              ),

                              // Secondary info (ID when grouped, Person who withdraws when not grouped)
                              Positioned(
                                left: 58,
                                top: 64.5,
                                child: BRAText(
                                  text: isGroupedView
                                      ? 'Cédula: ${register.cedulaResidente ?? ''}'
                                      : register.nombresResidente ?? '',
                                  size: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF202023),
                                ),
                              ),

                              // Status badge
                              Positioned(
                                right: 16,
                                bottom: 14,
                                child: _buildStatusBadge(register.tipo!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(EntryTypeCode type) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    String text;

    switch (type) {
      case EntryTypeCode.RE:
        backgroundColor = const Color(0xFFCFF9E6);
        borderColor = const Color(0xFF036546);
        textColor = const Color(0xFF036546);
        text = type.value;
        break;
      case EntryTypeCode.IO:
        backgroundColor = const Color(0xFFFFBCBC);
        borderColor = const Color(0xFFA30003);
        textColor = const Color(0xFFA30003);
        text = type.value;
        break;
      case EntryTypeCode.IR:
        backgroundColor = const Color(0xFFFEEFC8);
        borderColor = const Color(0xFFB86E00);
        textColor = const Color(0xFFB86E00);
        text = type.value;
        break;
      default:
        backgroundColor = const Color(0xFFCFF9E6);
        borderColor = const Color(0xFF036546);
        textColor = const Color(0xFF036546);
        text = type.value;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(3),
      ),
      child: BRAText(
        text: text,
        size: 9,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}
