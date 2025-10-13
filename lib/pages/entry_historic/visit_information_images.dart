import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entry_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/shared/widgets/control_images_list.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class VisitInformationImages extends StatelessWidget {
  final EntryResponse entry;

  VisitInformationImages({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24),
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        children: [
          SizedBox(
            height: 24,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(bottom: 24),
              height: 4,
              width: 100,
              decoration: BoxDecoration(
                color: theme.own().tertiaryTextColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: BRAText(
                text: stringLocations.visitDataTitleLabel,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Expanded(
              child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(60.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.own().component,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TabBar(
                              unselectedLabelColor:
                                  theme.own().primareyTextColor,
                              labelStyle: TextStyle(color: Colors.white),
                              indicatorColor: theme.colorScheme.primary,
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
                                  text: stringLocations.dataLabel,
                                ),
                                Tab(
                                  text: stringLocations.imagesLabel,
                                ),
                              ]),
                        )),
                    body: TabBarView(children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 24, top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.entryTypeLabel}: ',
                                    descirption: entry.tipoCodigo?.value),
                            (entry.fechaInicio != null)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.startInvitationDateLabel}: ',
                                    descirption: '${DateFormat.yMMMd('ES').format(entry.fechaInicio!)} - ${DateFormat.Hm('ES').format(entry.fechaInicio!)}')
                                : Container(),
                            (entry.fechaTermino != null)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.dueInvitationDateLabel}: ',
                                    descirption: '${DateFormat.yMMMd('ES').format(entry.fechaTermino!)} - ${DateFormat.Hm('ES').format(entry.fechaTermino!)}')
                                : Container(),
                            (entry.tipoAcceso != null)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.accessType}: ',
                                    descirption: entry.tipoAcceso?.value)
                                : Container(),
                            (entry.nombrePuerta != null)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.gateName}: ',
                                    descirption: entry.nombrePuerta)
                                : Container(),
                            (entry.nombreVisitante != null &&
                                    entry.nombreVisitante!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.nameGuestInputLabel}: ',
                                    descirption: entry.nombreVisitante)
                                : Container(),
                            (entry.cedulaVisitante != null &&
                                    entry.cedulaVisitante!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.dniGuestInputLabel}: ',
                                    descirption: entry.cedulaVisitante)
                                : Container(),
                            (entry.nacionalidadVisitante != null &&
                                    entry.nacionalidadVisitante!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.nationalityGuestLabel}:',
                                    descirption: entry.nacionalidadVisitante)
                                : Container(),
                            (entry.sexoVisitante != null)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.genderLabel}:',
                                    descirption: entry.sexoVisitante!.value)
                                : Container(),
                            (entry.placaVisitante != null &&
                                    entry.placaVisitante!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.guestLicensePlate}: ',
                                    descirption: entry.placaVisitante)
                                : Container(),
                            (entry.cedulaVisitante != null &&
                                    entry.cedulaVisitante!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.cellphoneGuestLabel}: ',
                                    descirption: entry.cedulaVisitante)
                                : Container(),
                            (entry.tipoVisitante != null)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.guestTypeLabel}: ',
                                    descirption: entry.tipoVisitante!.value)
                                : Container(),
                            (entry.nombresResidente != null &&
                                    entry.nombresResidente!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.residentNameLabel}: ',
                                    descirption:
                                        '${entry.nombresResidente} ${entry.apellidosResidente}')
                                : Container(),
                            (entry.celularResidente != null &&
                                    entry.celularResidente!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: '${stringLocations.cellphoneResidentLabel}: ',
                                    descirption: entry.celularResidente)
                                : Container(),
                            (entry.nombrePrimario != null &&
                                    entry.nombrePrimario!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: entry.nombrePrimario,
                                    descirption: entry.primarioResidente)
                                : Container(),
                            (entry.nombreSecundario != null &&
                                    entry.nombreSecundario!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: entry.nombreSecundario,
                                    descirption: entry.secundarioResidente)
                                : Container(),
                            (entry.actividad != null &&
                                    entry.actividad!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: stringLocations.visitReasonLabel,
                                    descirption: entry.actividad)
                                : Container(),
                            (entry.observacion != null &&
                                    entry.observacion!.isNotEmpty)
                                ? itemVisit(
                                    themeData: theme,
                                    title: stringLocations.observationsLabel,
                                    descirption: entry.observacion)
                                : Container(),
                          ],
                        ),
                      ),
                      ControlImagesList(imagesList: entry.imagenes!)
                    ]),
                  ))),
        ],
      ),
    );
  }

  Widget itemVisit(
      {required ThemeData themeData,
      required String? title,
      required String? descirption}) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BRAText(
              text: title ?? '',
              size: 17,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 6,
            ),
            BRAText(
                text: descirption ?? '', size: 15, textAlign: TextAlign.start),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
