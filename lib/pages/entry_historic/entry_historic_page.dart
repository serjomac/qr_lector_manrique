import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/card_invitationtype_enum.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entry_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/gate_entry_form.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/gate_leave_form.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/resident_entry_form.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/resident_leave_form.dart';
import 'package:qr_scaner_manrique/pages/entry_historic/date_range_historic.dart';
import 'package:qr_scaner_manrique/pages/entry_historic/entry_historic_controller.dart';
import 'package:qr_scaner_manrique/pages/entry_historic/visit_information_images.dart';
import 'package:qr_scaner_manrique/shared/loadings_pages/loading_invitations_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/control_images_list.dart';
import 'package:qr_scaner_manrique/shared/widgets/header_navigation_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/invitation_card.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/enums/registration_type.dart';

class EntryHistoricPage extends StatelessWidget {
  final PropertyEntryType? propertyEntryType;

  const EntryHistoricPage({Key? key, this.propertyEntryType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return Scaffold(
      body: GetBuilder<EntryHistoricController>(
          init: EntryHistoricController(propertyEntryType: propertyEntryType),
          builder: (_) {
            return Obx(() {
              if (_.loadingEntries.value) {
                return LoadingInvitationsPage();
              } else {
                return SafeArea(
                  minimum: EdgeInsets.only(left: 24, right: 24),
                  child: HeaderNavigatedPage(
                    onTapBack: () {
                      Get.back();
                    },
                    title: _.tite,
                    isScrolled: false,
                    child: _.isGateLeave
                        ? Expanded(
                            child: DefaultTabController(
                              length: 2,
                              child: Scaffold(
                                appBar: PreferredSize(
                                  preferredSize: const Size.fromHeight(60.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.own().component,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TabBar(
                                        unselectedLabelColor:
                                            theme.own().primareyTextColor,
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        indicatorColor:
                                            theme.colorScheme.primary,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        indicator: BoxDecoration(
                                          color: theme.own().secundaryTextColor,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        dividerHeight: 0,
                                        tabs: [
                                          Tab(
                                            text: stringLocations.guestExit,
                                          ),
                                          Tab(
                                            text: stringLocations.residentExit,
                                          ),
                                        ]),
                                  ),
                                ),
                                body: TabBarView(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 16,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    backgroundColor: theme
                                                        .colorScheme.background,
                                                    isScrollControlled: true,
                                                    builder: (context) {
                                                      return DateRangeHistoric();
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: _.lasDaysSelected !=
                                                            null
                                                        ? Color(0xFFFFF8F6)
                                                        : theme.colorScheme
                                                            .background,
                                                    border: Border.all(
                                                        color:
                                                            Color(0xFFD8C2BD)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          ConstantsIcons
                                                              .calendarIcon),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      BRAText(
                                                        text: _.lasDaysSelected != null
                                                            ? _.lasDaysSelected!
                                                                .title
                                                            : _.rangeDateDescription,
                                                        color: theme
                                                            .own()
                                                            .primareyTextColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        size: 12,
                                                      ),
                                                      Icon(Icons
                                                          .keyboard_arrow_down_rounded)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        // Chips filter for entry types
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: GetBuilder<EntryHistoricController>(
                                            builder: (controller) {
                                              final typeCounts = controller.getEntryTypeCounts();
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  BRAText(
                                                    text: 'Filtrar por tipo',
                                                    size: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xFF5B5856),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  SizedBox(
                                                    height: 40,
                                                    child: ListView(
                                                      scrollDirection: Axis.horizontal,
                                                      children: controller.entryTypeCode.map((entryType) {
                                                        final isSelected = controller.entryTypeSelected == entryType.value;
                                                        final count = typeCounts[entryType.value] ?? 0;
                                                        final backgroundColor = controller.propertyEntryType == PropertyEntryType.schoolGate
                                                            ? controller.getEntryTypeColor(entryType.value)
                                                            : (isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.grey[100]);
                                                        final borderColor = controller.propertyEntryType == PropertyEntryType.schoolGate
                                                            ? controller.getEntryTypeBorderColor(entryType.value)
                                                            : (isSelected ? theme.colorScheme.primary : Colors.grey[300]!);
                                                        return Padding(
                                                          padding: const EdgeInsets.only(right: 8),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              controller.entryTypeSelected = entryType.value;
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                              decoration: BoxDecoration(
                                                                color: backgroundColor,
                                                                border: Border.all(
                                                                  color: borderColor,
                                                                  width: isSelected ? 2 : 1,
                                                                ),
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  BRAText(
                                                                    text: entryType.title,
                                                                    size: 12,
                                                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                                                    color: controller.propertyEntryType == PropertyEntryType.schoolGate
                                                                        ? controller.getEntryTypeTextColor(entryType.value)
                                                                        : (isSelected 
                                                                            ? theme.colorScheme.primary
                                                                            : const Color(0xFF5B5856)),
                                                                  ),
                                                                  const SizedBox(width: 4),
                                                                  Container(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                                    decoration: BoxDecoration(
                                                                      color: isSelected 
                                                                          ? theme.colorScheme.primary.withOpacity(0.2)
                                                                          : Colors.grey[300],
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child: BRAText(
                                                                      text: count.toString(),
                                                                      size: 10,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: isSelected 
                                                                          ? theme.colorScheme.primary
                                                                          : const Color(0xFF5B5856),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Container(
                                          child: CustomTextFormField(
                                            focusNode: _.seachFocusNode,
                                            onTap: () {},
                                            label: stringLocations.searchLabel,
                                            onEditingComplete: () {
                                              _.seachFocusNode.unfocus();
                                            },
                                            onChanged: (value) {
                                              _.getFilterEntries(query: value);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: RefreshIndicator(
                                            onRefresh: () async {
                                              _.fetchEntries();
                                            },
                                            child:
                                                _.propertyEntryType ==
                                                        PropertyEntryType
                                                            .schoolGate
                                                    ? ListView.builder(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 16,
                                                                bottom: 80),
                                                        itemCount: _.isFiltering
                                                            ? _.filterSchoolHistoryEntries
                                                                .length
                                                            : _.schoolHistoryEntries
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final schoolEntry = _
                                                                  .isFiltering
                                                              ? _.filterSchoolHistoryEntries[
                                                                  index]
                                                              : _.schoolHistoryEntries[
                                                                  index];
                                                          final isGroupedView = _.isGrouped.value;
                                                          final childrenCount = _.getChildrenCount(schoolEntry);
                                                          
                                                          return GestureDetector(
                                                            onTap: () {
                                                              _.onTapSchoolEntry(schoolEntry);
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      bottom: 12),
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      16),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: theme
                                                                    .colorScheme
                                                                    .background,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      blurRadius:
                                                                          5,
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.6))
                                                                ],
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            BRAText(
                                                                          text: isGroupedView
                                                                              ? '${schoolEntry.nombresResidente ?? ''} ${schoolEntry.apellidosResidente ?? ''}'
                                                                              : schoolEntry.nombreHijo ?? 'Sin nombre',
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          size:
                                                                              16,
                                                                          color: theme
                                                                              .own()
                                                                              .primareyTextColor,
                                                                        ),
                                                                      ),
                                                                      if (isGroupedView)
                                                                        Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 4),
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.blue.withOpacity(0.1),
                                                                            borderRadius: BorderRadius.circular(8),
                                                                          ),
                                                                          child: BRAText(
                                                                            text: '$childrenCount ${childrenCount == 1 ? 'hijo' : 'hijos'}',
                                                                            size: 12,
                                                                            color: Colors.blue,
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        )
                                                                      else
                                                                        Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal:
                                                                                  8,
                                                                              vertical:
                                                                                  4),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: schoolEntry.estado ==
                                                                                    'A'
                                                                                ? Colors.green.withOpacity(0.1)
                                                                                : Colors.red.withOpacity(0.1),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              BRAText(
                                                                            text: schoolEntry.estado ==
                                                                                    'A'
                                                                                ? 'Activo'
                                                                                : 'Inactivo',
                                                                            size:
                                                                                12,
                                                                            color: schoolEntry.estado ==
                                                                                    'A'
                                                                                ? Colors.green
                                                                                : Colors.red,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(height: 8),
                                                                  // Información específica según vista agrupada o individual
                                                                  if (isGroupedView) ...[
                                                                    // Vista agrupada: mostrar información del representante
                                                                    BRAText(
                                                                      text: 'Celular: ${schoolEntry.celularResidente ?? ''}',
                                                                      size: 14,
                                                                      color: theme.own().tertiaryTextColor,
                                                                    ),
                                                                    if (schoolEntry.tipo != null) ...[
                                                                      const SizedBox(height: 4),
                                                                      Row(
                                                                        children: [
                                                                          BRAText(
                                                                            text: 'Tipo:',
                                                                            size: 14,
                                                                            color: theme.own().tertiaryTextColor,
                                                                          ),
                                                                          const SizedBox(width: 8),
                                                                          Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                            decoration: BoxDecoration(
                                                                              color: _.getEntryTypeColor(schoolEntry.tipo!),
                                                                              border: Border.all(
                                                                                color: _.getEntryTypeBorderColor(schoolEntry.tipo!),
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            child: BRAText(
                                                                              text: schoolEntry.tipo!.value,
                                                                              size: 12,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: _.getEntryTypeTextColor(schoolEntry.tipo!),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ] else ...[
                                                                    // Vista individual: mostrar información del estudiante
                                                                    if (schoolEntry.nombreCategoria != null)
                                                                      BRAText(
                                                                        text: 'Categoría: ${schoolEntry.nombreCategoria}',
                                                                        size: 14,
                                                                        color: theme.own().tertiaryTextColor,
                                                                      ),
                                                                    if (schoolEntry.nombresResidente != null || schoolEntry.apellidosResidente != null)
                                                                      BRAText(
                                                                        text: 'Residente: ${schoolEntry.nombresResidente ?? ''} ${schoolEntry.apellidosResidente ?? ''}',
                                                                        size: 14,
                                                                        color: theme.own().tertiaryTextColor,
                                                                      ),
                                                                    // Campo de tipo con colores de chips
                                                                    if (schoolEntry.tipo != null) ...[
                                                                      const SizedBox(height: 4),
                                                                      Row(
                                                                        children: [
                                                                          BRAText(
                                                                            text: 'Tipo:',
                                                                            size: 14,
                                                                            color: theme.own().tertiaryTextColor,
                                                                          ),
                                                                          const SizedBox(width: 8),
                                                                          Container(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                            decoration: BoxDecoration(
                                                                              color: _.getEntryTypeColor(schoolEntry.tipo!),
                                                                              border: Border.all(
                                                                                color: _.getEntryTypeBorderColor(schoolEntry.tipo!),
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            child: BRAText(
                                                                              text: schoolEntry.tipo!.value,
                                                                              size: 12,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: _.getEntryTypeTextColor(schoolEntry.tipo!),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                    // Solo mostrar "Retira" si el tipo NO es RE (Residente), nombreRetira no está vacío y nombreInvitado no está vacío
                                                                    if (schoolEntry.nombreRetira != null && 
                                                                        schoolEntry.nombreRetira!.isNotEmpty &&
                                                                        schoolEntry.tipo != EntryTypeCode.RE &&
                                                                        schoolEntry.nombreInvitado != null &&
                                                                        schoolEntry.nombreInvitado!.isNotEmpty)
                                                                      BRAText(
                                                                        text: 'Retira: ${schoolEntry.nombreInvitado}',
                                                                        size: 14,
                                                                        color: theme.own().tertiaryTextColor,
                                                                      ),
                                                                  ],
                                                                  if (schoolEntry.fechaCreacion != null)
                                                                    BRAText(
                                                                      text: 'Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(schoolEntry.fechaCreacion!)}',
                                                                      size: 12,
                                                                      color: theme.own().secundaryTextColor,
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : ListView.builder(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 16,
                                                                bottom: 80),
                                                        itemCount: _.isFiltering
                                                            ? _.filterEntries
                                                                .length
                                                            : _.entries.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final entry = _
                                                                  .isFiltering
                                                              ? _.filterEntries[
                                                                  index]
                                                              : _.entries[
                                                                  index];
                                                          return InvitationCard(
                                                            entry: entry,
                                                            cardInvitationType:
                                                                CardInvitationType
                                                                    .historial,
                                                            onTap: () {
                                                              _.onTapInvitation(
                                                                  entry);
                                                            },
                                                          );
                                                        },
                                                      ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ResidentLeaveForm()
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor:
                                                theme.colorScheme.background,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return DateRangeHistoric();
                                            },
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: _.lasDaysSelected != null
                                                ? Color(0xFFFFF8F6)
                                                : theme.colorScheme.background,
                                            border: Border.all(
                                                color: Color(0xFFD8C2BD)),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                  ConstantsIcons.calendarIcon),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              BRAText(
                                                text: _.lasDaysSelected != null
                                                    ? _.lasDaysSelected!.title
                                                    : _.rangeDateDescription,
                                                color: theme
                                                    .own()
                                                    .primareyTextColor,
                                                fontWeight: FontWeight.w500,
                                                size: 12,
                                              ),
                                              Icon(Icons
                                                  .keyboard_arrow_down_rounded)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                // Chips filter for entry types
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: GetBuilder<EntryHistoricController>(
                                    builder: (controller) {
                                      final typeCounts = controller.getEntryTypeCounts();
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BRAText(
                                            text: 'Filtrar por tipo',
                                            size: 12,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF5B5856),
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            height: 40,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: controller.entryTypeCode.map((entryType) {
                                                final isSelected = controller.entryTypeSelected == entryType.value;
                                                final count = typeCounts[entryType.value] ?? 0;
                                                final backgroundColor = controller.propertyEntryType == PropertyEntryType.schoolGate
                                                    ? controller.getEntryTypeColor(entryType.value)
                                                    : (isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.grey[100]);
                                                final borderColor = controller.propertyEntryType == PropertyEntryType.schoolGate
                                                    ? controller.getEntryTypeBorderColor(entryType.value)
                                                    : (isSelected ? theme.colorScheme.primary : Colors.grey[300]!);
                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 8),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller.entryTypeSelected = entryType.value;
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: backgroundColor,
                                                        border: Border.all(
                                                          color: borderColor,
                                                          width: isSelected ? 2 : 1,
                                                        ),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          BRAText(
                                                            text: entryType.title,
                                                            size: 12,
                                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                                            color: controller.propertyEntryType == PropertyEntryType.schoolGate
                                                                ? controller.getEntryTypeTextColor(entryType.value)
                                                                : (isSelected 
                                                                    ? theme.colorScheme.primary
                                                                    : const Color(0xFF5B5856)),
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                            decoration: BoxDecoration(
                                                              color: isSelected 
                                                                  ? theme.colorScheme.primary.withOpacity(0.2)
                                                                  : Colors.grey[300],
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: BRAText(
                                                              text: count.toString(),
                                                              size: 10,
                                                              fontWeight: FontWeight.w600,
                                                              color: isSelected 
                                                                  ? theme.colorScheme.primary
                                                                  : const Color(0xFF5B5856),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  child: CustomTextFormField(
                                    focusNode: _.seachFocusNode,
                                    onTap: () {},
                                    label: stringLocations.searchLabel,
                                    onEditingComplete: () {
                                      _.seachFocusNode.unfocus();
                                    },
                                    onChanged: (value) {
                                      _.getFilterEntries(query: value);
                                    },
                                  ),
                                ),
                                // Checkbox de agrupación solo para schoolGate
                                if (_.propertyEntryType == PropertyEntryType.schoolGate) ...[
                                  SizedBox(height: 16),
                                  Obx(() => Row(
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
                                          _.toggleGrouping();
                                        },
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: _.isGrouped.value
                                                ? const Color(0xFFEB472A)
                                                : Colors.white,
                                            border: Border.all(
                                              color: _.isGrouped.value
                                                  ? const Color(0xFFEB472A)
                                                  : const Color(0xFFC3C3C3),
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 16,
                                            color: _.isGrouped.value
                                                ? Colors.white
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                                Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      _.fetchEntries();
                                    },
                                    child: _.propertyEntryType ==
                                            PropertyEntryType.schoolGate
                                        ? ListView.builder(
                                            padding: EdgeInsets.only(
                                                top: 16, bottom: 80),
                                            itemCount: _.isFiltering
                                                ? _.filterSchoolHistoryEntries
                                                    .length
                                                : _.schoolHistoryEntries.length,
                                            itemBuilder: (context, index) {
                                              final schoolEntry = _.isFiltering
                                                  ? _.filterSchoolHistoryEntries[
                                                      index]
                                                  : _.schoolHistoryEntries[
                                                      index];
                                              final isGroupedView = _.isGrouped.value;
                                              final childrenCount = _.getChildrenCount(schoolEntry);
                                              
                                              return GestureDetector(
                                                onTap: () {
                                                  _.onTapSchoolEntry(schoolEntry);
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(bottom: 12),
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: theme
                                                        .colorScheme.background,
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 5,
                                                          color: Colors.grey
                                                              .withOpacity(0.6))
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                BRAText(
                                                              text: isGroupedView
                                                                  ? '${schoolEntry.nombresResidente ?? ''} ${schoolEntry.apellidosResidente ?? ''}'
                                                                  : schoolEntry.nombreHijo ?? 'Sin nombre',
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              size:
                                                                  16,
                                                              color: theme
                                                                  .own()
                                                                  .primareyTextColor,
                                                            ),
                                                          ),
                                                          if (isGroupedView)
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                              decoration: BoxDecoration(
                                                                color: Colors.blue.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              child: BRAText(
                                                                text: '$childrenCount ${childrenCount == 1 ? 'hijo' : 'hijos'}',
                                                                size: 12,
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            )
                                                          else
                                                            Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      8,
                                                                  vertical:
                                                                      4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: schoolEntry.estado ==
                                                                        'A'
                                                                    ? Colors.green.withOpacity(0.1)
                                                                    : Colors.red.withOpacity(0.1),
                                                                borderRadius:
                                                                    BorderRadius.circular(8),
                                                              ),
                                                              child:
                                                                  BRAText(
                                                                text: schoolEntry.estado ==
                                                                        'A'
                                                                    ? 'Activo'
                                                                    : 'Inactivo',
                                                                size:
                                                                    12,
                                                                color: schoolEntry.estado ==
                                                                        'A'
                                                                    ? Colors.green
                                                                    : Colors.red,
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8),
                                                      // Información específica según vista agrupada o individual
                                                      if (isGroupedView) ...[
                                                        // Vista agrupada: mostrar información del representante
                                                        BRAText(
                                                          text: 'Celular: ${schoolEntry.celularResidente ?? ''}',
                                                          size: 14,
                                                          color: theme.own().tertiaryTextColor,
                                                        ),
                                                        if (schoolEntry.tipo != null) ...[
                                                          const SizedBox(height: 4),
                                                          Row(
                                                            children: [
                                                              BRAText(
                                                                text: 'Tipo:',
                                                                size: 14,
                                                                color: theme.own().tertiaryTextColor,
                                                              ),
                                                              const SizedBox(width: 8),
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                decoration: BoxDecoration(
                                                                  color: _.getEntryTypeColor(schoolEntry.tipo!),
                                                                  border: Border.all(
                                                                    color: _.getEntryTypeBorderColor(schoolEntry.tipo!),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: BRAText(
                                                                  text: schoolEntry.tipo!.value,
                                                                  size: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: _.getEntryTypeTextColor(schoolEntry.tipo!),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ] else ...[
                                                        // Vista individual: mostrar información del estudiante
                                                        if (schoolEntry.nombreCategoria != null)
                                                          BRAText(
                                                            text: 'Categoría: ${schoolEntry.nombreCategoria}',
                                                            size: 14,
                                                            color: theme.own().tertiaryTextColor,
                                                          ),
                                                        if (schoolEntry.nombresResidente != null || schoolEntry.apellidosResidente != null)
                                                          BRAText(
                                                            text: 'Residente: ${schoolEntry.nombresResidente ?? ''} ${schoolEntry.apellidosResidente ?? ''}',
                                                            size: 14,
                                                            color: theme.own().tertiaryTextColor,
                                                          ),
                                                        // Solo mostrar "Retira" si el tipo NO es RE (Residente) y nombreRetira no está vacío
                                                        if (schoolEntry.nombreRetira != null && 
                                                            schoolEntry.nombreRetira!.isNotEmpty &&
                                                            schoolEntry.tipo != EntryTypeCode.RE)
                                                          BRAText(
                                                            text: 'Retira: ${schoolEntry.nombreRetira}',
                                                            size: 14,
                                                            color: theme.own().tertiaryTextColor,
                                                          ),
                                                        // Mostrar tipo
                                                        if (schoolEntry.tipo != null)
                                                          Row(
                                                            children: [
                                                              BRAText(
                                                                text: 'Tipo',
                                                                size: 14,
                                                                color: theme.own().tertiaryTextColor,
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(left: 8),
                                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                decoration: BoxDecoration(
                                                                  color: _.getEntryTypeColor(schoolEntry.tipo!),
                                                                  border: Border.all(
                                                                    color: _.getEntryTypeBorderColor(schoolEntry.tipo!),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: BRAText(
                                                                  text: schoolEntry.tipo!.value,
                                                                  size: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: _.getEntryTypeTextColor(schoolEntry.tipo!),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                      if (schoolEntry.fechaCreacion != null)
                                                        BRAText(
                                                          text: 'Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(schoolEntry.fechaCreacion!)}',
                                                          size: 12,
                                                          color: theme.own().secundaryTextColor,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : ListView.builder(
                                            padding: EdgeInsets.only(
                                                top: 16, bottom: 80),
                                            itemCount: _.isFiltering
                                                ? _.filterEntries.length
                                                : _.entries.length,
                                            itemBuilder: (context, index) {
                                              final entry = _.isFiltering
                                                  ? _.filterEntries[index]
                                                  : _.entries[index];
                                              return InvitationCard(
                                                entry: entry,
                                                cardInvitationType:
                                                    CardInvitationType
                                                        .historial,
                                                onTap: () {
                                                  _.onTapInvitation(entry);
                                                },
                                              );
                                            },
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                );
              }
            });
          }),
    );
  }
}
