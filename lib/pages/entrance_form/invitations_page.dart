import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/enums/card_invitationtype_enum.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/invitations_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/gate_entry_form.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/visitor_entry_form.dart';
import 'package:qr_scaner_manrique/shared/loadings_pages/loading_invitations_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/header_navigation_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/invitation_card.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class InvitationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return Scaffold(
      body: GetBuilder<InvitationsControllers>(
          init: InvitationsControllers(),
          builder: (_) {
            return Obx(() {
              if (_.loadingInvitations.value) {
                return LoadingInvitationsPage();
              } else {
                return SafeArea(
                  minimum: EdgeInsets.only(left: 24, right: 24),
                  child: HeaderNavigatedPage(
                    onTapBack: () {
                      Get.back();
                    },
                    title: stringLocations.gateEntryLabel,
                    isScrolled: false,
                    child: Expanded(
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
                                    controller: _.tabController,
                                      unselectedLabelColor:
                                          theme.own().primareyTextColor,
                                      labelStyle:
                                          TextStyle(color: Colors.white),
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
                                          text: stringLocations.whoEntryLabel,
                                        ),
                                        Tab(
                                          text:
                                              stringLocations.invitationsLabel,
                                        ),
                                      ]),
                                )),
                            body: TabBarView(
                                controller: _.tabController,
                                children: [
                                  GateEntryForm(),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                      ),
                                      Container(
                                        child: CustomTextFormField(
                                          focusNode: _.seachFocusNode,
                                          onTap: () {},
                                          label: stringLocations
                                              .propertiesSearchLabel,
                                          onEditingComplete: () {
                                            _.seachFocusNode.unfocus();
                                          },
                                          onChanged: (value) {
                                            _.getFilterInvitations(
                                                query: value);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RefreshIndicator(
                                          color: theme.primaryColor,
                                          onRefresh: () async {
                                            _.tabController.animateTo(1);
                                            _.fetchNormalsInvitations();
                                          },
                                          child: ListView.builder(
                                            padding: EdgeInsets.only(
                                                top: 16, bottom: 80),
                                            itemCount: _.isFiltering
                                                ? _.filterInvitations.length
                                                : _.invitations.length,
                                            itemBuilder: (context, index) {
                                              final invitation = _.isFiltering
                                                  ? _.filterInvitations[index]
                                                  : _.invitations[index];
                                              return InvitationCard(
                                                invitation: invitation,
                                                cardInvitationType:
                                                    CardInvitationType
                                                        .residentGateEntry,
                                                onTap: () {
                                                  _.selectInvitation(
                                                      invitation: invitation);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          )),
                    ),
                  ),
                );
              }
            });
          }),
    );
  }
}
