import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/string_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/enums/registration_type.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/exit_without_qr_to_school_request_form_page.dart';
import 'representative_selection_controller.dart';
import 'package:qr_scaner_manrique/shared/loadings_pages/loading_invitations_page.dart'
    as shared_loading;

class RepresentativeSelectionPage extends StatelessWidget {
  final RegistrationType registrationType;
  final GateDoor gateSelected;
  final MainActionType mainActionType;
  const RepresentativeSelectionPage({
    Key? key,
    required this.registrationType,
    required this.gateSelected,
    required this.mainActionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<RepresentativeSelectionController>(
          init: RepresentativeSelectionController(
            gateSelected: gateSelected,
            mainActionType: mainActionType,
          ),
          builder: (_) {
            return Stack(
              children: [
                // Background image (ciudad)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/ciudad.png',
                    fit: BoxFit.cover,
                  ),
                ),

                // Main content
                SafeArea(
                  child: Column(
                    children: [
                      // App Bar with back button
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
                            BRAText(
                              text: 'Selección del padre/representante',
                              size: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF231918),
                            ),
                          ],
                        ),
                      ),

                      // Search field
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: CustomTextFormField(
                          focusNode: _.searchFocusNode,
                          controller: _.searchController,
                          label: '',
                          hintText: 'Buscar por nombre, apellido o cédula',
                          onChanged: (value) {
                            _.searchRepresentatives(value);
                          },
                        ),
                      ),

                      // Representative cards
                      Expanded(
                        child: Obx(() {
                          if (_.isLoading.value) {
                            return shared_loading.LoadingInvitationsPage();
                          }
                          return RefreshIndicator(
                            onRefresh: () async {
                              await _.fetchRepresentatives();
                            },
                            child: Obx(() {
                              if (_.filteredRepresentatives.isEmpty && _.searchQuery.value.isNotEmpty) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Color(0xFF5B5856),
                                      ),
                                      SizedBox(height: 16),
                                      BRAText(
                                        text: 'No se encontraron resultados',
                                        size: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF5B5856),
                                      ),
                                      SizedBox(height: 8),
                                      BRAText(
                                        text: 'Intenta con otro término de búsqueda',
                                        size: 14,
                                        color: Color(0xFFC3C3C3),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              
                              return ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 23.0),
                                itemCount: _.filteredRepresentatives.length,
                                itemBuilder: (context, index) {
                                  final representative = _.filteredRepresentatives[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 22.0),
                                    child: _RepresentativeCard(
                                      name:
                                          '${representative.nombresResidente?.getFirstName} ${representative.apellidosResidente}',
                                      ci: representative.cedulaResidente ?? '',
                                      count:
                                          (representative.childrens?.length ?? 0)
                                              .toString(),
                                      tipo:
                                          representative.informacion?.tipoCodigo,
                                      onTap: () async {
                                        // Clear search and close keyboard when selecting
                                        _.onRepresentativeSelected();
                                        
                                        final res = await Get.to(() =>
                                            ExitWithoutQrToSchoolRequestFormPage(
                                              registrationType: registrationType,
                                              residentChildsResponse:
                                                  representative,
                                              mainActionType: mainActionType,
                                            ));
                                        if (res == true) {
                                          _.fetchRepresentatives();
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            }),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class _RepresentativeCard extends StatelessWidget {
  final String name;
  final String ci;
  final String count;
  final EntryTypeCode? tipo;
  final VoidCallback onTap;

  const _RepresentativeCard({
    required this.name,
    required this.ci,
    required this.count,
    this.tipo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 65,
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
        child: Row(
          children: [
            const SizedBox(width: 20),
            const Icon(Icons.person_outline,
                size: 24, color: Color(0xFF5B5856)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BRAText(
                    text: name,
                    size: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF202023),
                  ),
                  const SizedBox(width: 8),
                  if (tipo != null) _buildStatusBadge(tipo!),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BRAText(
                    text: '$count ${int.parse(count) == 1 ? 'hijo' : 'hijos'}',
                    size: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5B5856),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
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
