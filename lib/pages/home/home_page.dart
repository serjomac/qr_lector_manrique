import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-images.dart';
import 'package:qr_scaner_manrique/BRACore/enums/entrances_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_page.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/invitations_page.dart';
import 'package:qr_scaner_manrique/pages/entry_historic/entry_historic_page.dart';
import 'package:qr_scaner_manrique/pages/home/home_card.dart';
import 'package:qr_scaner_manrique/pages/home/home_controller.dart';
import 'package:qr_scaner_manrique/pages/login/ui/login_page.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/enums/registration_type.dart';
import 'package:qr_scaner_manrique/shared/widgets/header_navigation_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  final bool isHiddenBackButton;
  final bool showNewVersionButton;
  final int initialTab;
  final PropertyEntryType propertyEntryType;

  const HomePage({
    Key? key,
    this.isHiddenBackButton = false,
    required this.showNewVersionButton,
    required this.propertyEntryType,
    this.initialTab = 0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return Scaffold(
      body: GetBuilder<HomeController>(
          init: HomeController(propertyEntryType: propertyEntryType)
            ..setInitialTab(initialTab),
          builder: (_) {
            return Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: Image.asset(
                    ConstantsImages.city,
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  minimum: EdgeInsets.only(left: 24, right: 24),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        top: 24,
                        child: Row(
                          children: [
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
                      ),
                      Positioned(
                        top: 80,
                        left: 0,
                        right: 0,
                        child: Image(
                          image: AssetImage('assets/images/logo-dark.png'),
                          width: 100,
                          height: 45,
                        ),
                      ),
                      HeaderNavigatedPage(
                        title: stringLocations.homeTitle,
                        isScrolled: false,
                        isHiddenBackButton: isHiddenBackButton,
                        onTapBack: () {
                          Get.back();
                        },
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Obx(() {
                                  if (_.entrancesLoading.value) {
                                    return SizedBox(
                                      width: 35,
                                      height: 35,
                                      child: CircularProgressIndicator(
                                        color: theme.colorScheme.primary,
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      width: size.width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButtonFormField2(
                                              decoration: CustomTextFormField
                                                  .decorationFormCard(
                                                labelText: stringLocations
                                                    .selectedGateLabel,
                                                theme: theme,
                                                labelStyle: TextStyle(
                                                  fontSize: 18,
                                                  color: theme
                                                      .own()
                                                      .tertiaryTextColor,
                                                ),
                                                focusNode: FocusNode(),
                                                isFLoatingLabelVisible: true,
                                              ),
                                              value: _.entranceIdSelected,
                                              style: TextStyle(
                                                color: Colors.transparent,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                maxHeight: size.height * 0.55,
                                                width: size.width * 0.80,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14)),
                                                offset: const Offset(0, -12),
                                                scrollbarTheme:
                                                    ScrollbarThemeData(
                                                  radius:
                                                      const Radius.circular(40),
                                                  thickness:
                                                      MaterialStateProperty.all<
                                                          double>(6),
                                                  thumbVisibility:
                                                      MaterialStateProperty.all<
                                                          bool>(true),
                                                ),
                                              ),
                                              items: _.entrances
                                                  .map(
                                                    (e) => DropdownMenuItem<
                                                        GateDoor>(
                                                      value: e,
                                                      child: BRAText(
                                                        text: e.nombre ?? '',
                                                        size: 17,
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (GateDoor? value) {
                                                _.entranceIdSelected = value;
                                              },
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _.fetchEntrances(
                                                placeId: UserData.sharedInstance
                                                    .placeSelected!.idLugar
                                                    .toString(),
                                              );
                                            },
                                            child: Icon(
                                              Icons.refresh,
                                              color: theme.primaryColor,
                                              size: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              HomeCard(
                                title: stringLocations.scanPinletLabel,
                                icon: ConstantsIcons.qrIcon,
                                loading: _.validatingQrCodeLoading,
                                onTap: _.entrances.isEmpty
                                    ? () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return SuccessDialog(
                                              iconSvg: ConstantsIcons.alertIcon,
                                              title: 'Informativo',
                                              subtitle:
                                                  'Debe seleccionar una puerta antes de continuar',
                                              primaryButtonText:
                                                  'Actualizar puertas',
                                              onTapAcept: () {
                                                _.fetchEntrances(
                                                  placeId: UserData
                                                      .sharedInstance
                                                      .placeSelected!
                                                      .idLugar
                                                      .toString(),
                                                );
                                                Get.back();
                                              },
                                            );
                                          },
                                        );
                                      }
                                    : () {
                                        _.scanCode();
                                      },
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              HomeCard(
                                title: stringLocations.registerEntryLabel,
                                icon: ConstantsIcons.loginIcon,
                                loading: _.entranceFormLoading,
                                onTap: _.entrances.isEmpty
                                    ? () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return SuccessDialog(
                                              iconSvg: ConstantsIcons.alertIcon,
                                              title: 'Informativo',
                                              subtitle:
                                                  'Debe seleccionar una puerta antes de continuar',
                                              primaryButtonText:
                                                  'Actualizar puertas',
                                              onTapAcept: () {
                                                _.fetchEntrances(
                                                  placeId: UserData
                                                      .sharedInstance
                                                      .placeSelected!
                                                      .idLugar
                                                      .toString(),
                                                );
                                                Get.back();
                                              },
                                            );
                                          },
                                        );
                                      }
                                    : () {
                                        _.handleNavigationUsing(
                                          mainActionType:
                                              MainActionType.gateEntryForm,
                                          arguments: {
                                            'gateIdSelected': _
                                                .entranceIdSelected?.idPuerta
                                                .toString()
                                          },
                                        );
                                      },
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              HomeCard(
                                title: stringLocations.registerExitLabel,
                                icon: ConstantsIcons.logoutIcon,
                                loading: _.exitFormLoading,
                                onTap: _.entrances.isEmpty
                                    ? () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return SuccessDialog(
                                              iconSvg: ConstantsIcons.alertIcon,
                                              title: 'Informativo',
                                              subtitle:
                                                  'Debe seleccionar una puerta antes de continuar',
                                              primaryButtonText:
                                                  'Actualizar puertas',
                                              onTapAcept: () {
                                                _.fetchEntrances(
                                                  placeId: UserData
                                                      .sharedInstance
                                                      .placeSelected!
                                                      .idLugar
                                                      .toString(),
                                                );
                                                Get.back();
                                              },
                                            );
                                          },
                                        );
                                      }
                                    : () {
                                        _.handleNavigationUsing(
                                          mainActionType:
                                              MainActionType.gateLeave,
                                          arguments: {
                                            'mainActionType':
                                                MainActionType.gateLeave,
                                            'gateIdSelected': _
                                                .entranceIdSelected?.idPuerta
                                                ?.toString()
                                          },
                                        );
                                      },
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(EntryHistoricPage(
                                      propertyEntryType: propertyEntryType,
                                    ), arguments: {
                                      'mainActionType': MainActionType.hisotric,
                                      'gateIdSelected': _
                                          .entranceIdSelected?.idPuerta
                                          ?.toString()
                                    });
                                  },
                                  child: Container(
                                    width: size.width * 0.4,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: theme.own().component,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            ConstantsIcons.hisotric),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        BRAText(
                                          text: stringLocations.historyLabel,
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            color:
                                                theme.own().primareyTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                showNewVersionButton
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                BRAText(
                                  text: stringLocations.newVersionAvilableLabel,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: theme.own().secundaryTextColor!,
                                      blurRadius: 8,
                                      blurStyle: BlurStyle.outer)
                                ],
                                color: theme.primaryColor),
                          ),
                        ),
                      )
                    : Container(),
              ],
            );
          }),
    );
  }
}
