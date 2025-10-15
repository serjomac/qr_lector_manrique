import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/size_phone.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/login/ui/login_page.dart';
import 'package:qr_scaner_manrique/pages/properties/properties_controller.dart';
import 'package:qr_scaner_manrique/shared/loadings_pages/loading_invitations_page.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final propertiesInvitationsController = PropertiesController();
    final Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return GetBuilder<PropertiesController>(
        init: propertiesInvitationsController,
        builder: (_) {
          return Scaffold(
            body: GetBuilder<PropertiesController>(
                init: propertiesInvitationsController,
                builder: (_) {
                  return SafeArea(
                    bottom: false,
                    minimum: EdgeInsets.only(top: 44),
                    child: Stack(
                      children: [
                        Positioned(
                            bottom: 0,
                            child: Column(
                              children: [
                                Image(
                                    width: MediaQuery.of(context).size.width,
                                    // height: 130,
                                    fit: BoxFit.fill,
                                    image:
                                        AssetImage('assets/images/ciudad.png')),
                              ],
                            )),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 28),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: BRAText(
                                      text: stringLocations.propertiesTitle,
                                      textStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: theme.own().primareyTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    UserData.sharedInstance.removeSession();
                                    Get.offAll(LoginPage());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 28),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.logout_rounded,
                                          size: 30,
                                        ),
                                        BRAText(
                                          text: stringLocations.logoutLabel,
                                          size: 15,
                                          color: theme.own().primareyTextColor,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _.places.length >= 5
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 24),
                                    child: CustomTextFormField(
                                      focusNode: _.seachFocusNode,
                                      onTap: () {},
                                      label:
                                          stringLocations.propertiesSearchLabel,
                                      onEditingComplete: () {
                                        _.seachFocusNode.unfocus();
                                      },
                                      onChanged: (value) {
                                        _.filterPlace(query: value);
                                      },
                                    ),
                                  )
                                : Container(),
                            Expanded(
                              child: Obx(() {
                                if (_.loading.value) {
                                  return LoadingInvitationsPage();
                                }
                                return RefreshIndicator(
                                  color: theme.primaryColor,
                                  onRefresh: () async {
                                    _.getPlaces(isRefresh: true);
                                  },
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          top: _.places.length >= 5 ? 15 : 30,
                                          left: 24,
                                          bottom: _.showNewVersionButton ? 140 : 50,
                                          right: 24),
                                      itemCount: _.placesFilter != null
                                          ? _.placesFilter!.length
                                          : _.places.length,
                                      itemBuilder: ((c, i) {
                                      final placeTemp = _.placesFilter != null
                                          ? _.placesFilter![i]
                                          : _.places[i];
                                      return Obx(() {
                                        return InkWell(
                                          onTap: () async {
                                            _.onTapPropertie(
                                                placeTemp: placeTemp,
                                                indexPropertie: i);
                                          },
                                          onLongPress: () {
                                            _.onTapPropertie(
                                                placeTemp: placeTemp,
                                                indexPropertie: i,
                                                isEmergency: true);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 16),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            decoration: BoxDecoration(
                                                color:
                                                    theme.colorScheme.background,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: theme
                                                          .own()
                                                          .primareyTextColor!
                                                          .withOpacity(0.1),
                                                      blurRadius: 8)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 14,
                                                    ),
                                                    Container(
                                                      clipBehavior: Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: theme.colorScheme
                                                              .background,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 5,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                            )
                                                          ]),
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 30.0,
                                                        child: _
                                                                .loadingPermissons[
                                                                    i]
                                                                .value
                                                            ? CircularProgressIndicator(
                                                                color: theme
                                                                    .primaryColor,
                                                              )
                                                            : CachedNetworkImage(
                                                                imageUrl:
                                                                    'https://storage.googleapis.com/pinlet/Lugar/' +
                                                                        (placeTemp
                                                                                .imagen ??
                                                                            ''),
                                                                // width: 34,
                                                                // height: 34,
                                                                errorWidget:
                                                                    (context, url,
                                                                            error) =>
                                                                        Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: theme
                                                                          .highlightColor),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              25),
                                                                  child: Image(
                                                                    image:
                                                                        AssetImage(
                                                                      'assets/images/casa.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              constraints: BoxConstraints(
                                                                  maxWidth: size
                                                                          .width *
                                                                      (size.height <
                                                                              SizePhone.HEGTH_S
                                                                          ? 0.35
                                                                          : 0.4)),
                                                              child: BRAText(
                                                                text: placeTemp
                                                                        .nombre ??
                                                                    '',
                                                                textStyle: theme
                                                                    .textTheme
                                                                    .headlineSmall!
                                                                    .copyWith(
                                                                        color: theme
                                                                            .own()
                                                                            .primareyTextColor,
                                                                        fontSize: size.height <
                                                                                SizePhone.HEGTH_S
                                                                            ? 15
                                                                            : 17),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    })),
                                );
                              }),
                            ),
                          ],
                        ),
                        _.showNewVersionButton
                            ? Positioned(
                                bottom: 60,
                                left: 70,
                                right: 70,
                                child: GestureDetector(
                                  onTap: () {
                                    if (Platform.isAndroid) {
                                      launch(
                                        'https://play.google.com/store/apps/details?id=com.vionsolutions.botacoraPinlet',
                                      );
                                    } else if (Platform.isIOS) {
                                      launch(
                                        'https://apps.apple.com/us/app/pinlet-bitácora/id6502011248',
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        BRAText(
                                          text: stringLocations
                                              .newVersionAvilableLabel,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: theme
                                                  .own()
                                                  .secundaryTextColor!,
                                              blurRadius: 8,
                                              blurStyle: BlurStyle.outer)
                                        ],
                                        color: theme.primaryColor),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
