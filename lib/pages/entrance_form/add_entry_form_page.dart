import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/invitations_page.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/gate_leave_form.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/gues_entry_informative_form.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/resident_entry_form.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/visitor_entry_form.dart';
import 'package:qr_scaner_manrique/shared/widgets/header_navigation_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/take_photo_card.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class AddEntryFormPage extends StatelessWidget {
  final LectorResponse? lectorResponse;
  
  const AddEntryFormPage({Key? key, this.lectorResponse}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AddEntryFormController entranceFormController =
        Get.put(AddEntryFormController(lectorResponse: lectorResponse));
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    return Scaffold(
      body: GetBuilder<AddEntryFormController>(
          init: entranceFormController,
          builder: (_) {
            return SafeArea(
              minimum: const EdgeInsets.only(left: 24, right: 24),
              child: SizedBox(
                height: size.height,
                child: Stack(
                  children: [
                    HeaderNavigatedPage(
                      paddign: const EdgeInsets.only(bottom: 100),
                      title: _.title,
                      onTapBack: () {
                        _.back();
                      },
                      isScrolled: false,
                      child: GetBuilder<AddEntryFormController>(
                        id: 'form',
                        builder: (context) {
                          return _.isResidentEntry
                              ? Expanded(child: ResidentEntryForm())
                              : _.isGateLeave
                                  ? Expanded(child: GateLeaveForm())
                                  : Expanded(
                                      child: _.isResidentEntry
                                          ? Container()
                                          : DefaultTabController(
                                              length: _.isActionResidenceGate
                                                  ? 2
                                                  : 3,
                                              child: Scaffold(
                                                appBar: PreferredSize(
                                                  preferredSize:
                                                      const Size.fromHeight(
                                                          60.0),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          theme.own().component,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: TabBar(
                                                      // controller: _.tabController,
                                                      unselectedLabelColor: theme
                                                          .own()
                                                          .primareyTextColor,
                                                      labelStyle: TextStyle(
                                                          color: Colors.white),
                                                      indicatorColor: theme
                                                          .colorScheme.primary,
                                                      indicatorSize:
                                                          TabBarIndicatorSize
                                                              .tab,
                                                      indicator: BoxDecoration(
                                                        color: theme
                                                            .own()
                                                            .secundaryTextColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          20,
                                                        ),
                                                      ),
                                                      dividerHeight: 0,
                                                      tabs:
                                                          _.isActionResidenceGate
                                                              ? [
                                                                  Tab(
                                                                    text: stringLocations.invitationsLabel,
                                                                  ),
                                                                  Tab(
                                                                    text: stringLocations.whoEntryLabel,
                                                                  ),
                                                                ]
                                                              : [
                                                                  Tab(
                                                                    text: stringLocations.residentLabel,
                                                                  ),
                                                                  Tab(
                                                                    text: stringLocations.guestLabel,
                                                                  ),
                                                                  Tab(
                                                                    text: stringLocations.whoEntryLabel,
                                                                  ),
                                                                ],
                                                    ),
                                                  ),
                                                ),
                                                body: TabBarView(
                                                  // controller: _.tabController,
                                                  children:
                                                      _.isActionResidenceGate
                                                          ? [
                                                              InvitationsPage(),
                                                              VisitorEntryForm(),
                                                            ]
                                                          : [
                                                              ResidentEntryForm(),
                                                              GuesEntryInformativeForm(),
                                                              VisitorEntryForm(),
                                                            ],
                                                ),
                                              ),
                                            ),
                                    );
                        },
                      ),
                    ),
                    _.isHiddenNextButton
                        ? Container()
                        : Positioned(
                            bottom: 15,
                            left: 0,
                            right: 0,
                            child: BRAButton(
                              loadingButton: _.addEntryLoading,
                              label: 'Continuar',
                              onPressed: () {
                                if (_.isResidentEntry) {
                                  _.isResidentFormValidatedOnce = true;
                                  if (_.formKeyResident.currentState!
                                      .validate()) {
                                    _.formKeyResident.currentState!.save();
                                    _.addEntrance();
                                  }
                                } else {
                                  _.isVisitorFormValidatedOnce = true;
                                  _.addEntrance();
                                }
                              },
                            ),
                          ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
