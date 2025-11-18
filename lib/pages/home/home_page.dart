import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';
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
                              onTap: () async {
                                // Llamar al API de logout si hay usuario logueado
                                final userLogin = UserData.sharedInstance.userLogin;
                                if (userLogin?.idUsuarioAdmin != null) {
                                  final apiAuth = ApiAuth();
                                  await apiAuth.logoutSession(
                                    userLogin!.idUsuarioAdmin.toString(),
                                  );
                                }
                                
                                // Proceder con el logout local
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
                                              selectedItemBuilder: (context) {
                                                return _.entrances.map((e) {
                                                  return Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 14,
                                                        height: 14,
                                                        decoration: BoxDecoration(
                                                          color: e.tipoIngreso == TypeDoor.entrance 
                                                            ? Colors.green.shade600 
                                                            : Colors.red.shade600,
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: e.tipoIngreso == TypeDoor.entrance 
                                                              ? Colors.green.shade800 
                                                              : Colors.red.shade800,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Icon(
                                                          e.tipoIngreso == TypeDoor.entrance 
                                                            ? Icons.arrow_downward 
                                                            : Icons.arrow_upward,
                                                          color: Colors.white,
                                                          size: 8,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      BRAText(
                                                        text: e.nombre ?? '',
                                                        size: 17,
                                                        color: theme.own().primareyTextColor,
                                                      ),
                                                    ],
                                                  );
                                                }).toList();
                                              },
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
                                                      child: Row(
                                                        children: [
                                                          Tooltip(
                                                            message: e.tipoIngreso == TypeDoor.entrance 
                                                              ? 'Puerta de Entrada' 
                                                              : 'Puerta de Salida',
                                                            child: Container(
                                                              width: 14,
                                                              height: 14,
                                                              decoration: BoxDecoration(
                                                                color: e.tipoIngreso == TypeDoor.entrance 
                                                                  ? Colors.green.shade600 
                                                                  : Colors.red.shade600,
                                                                shape: BoxShape.circle,
                                                                border: Border.all(
                                                                  color: e.tipoIngreso == TypeDoor.entrance 
                                                                    ? Colors.green.shade800 
                                                                    : Colors.red.shade800,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                e.tipoIngreso == TypeDoor.entrance 
                                                                  ? Icons.arrow_downward 
                                                                  : Icons.arrow_upward,
                                                                color: Colors.white,
                                                                size: 8,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Expanded(
                                                            child: BRAText(
                                                              text: e.nombre ?? '',
                                                              size: 17,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (GateDoor? value) {
                                                _.entranceIdSelected = value;
                                                _.update(); // Update UI to reflect color change
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
                              // Usar Obx para reaccionar a cambios en entranceFormLoading y entrancesLoading
                              Obx(() {
                                // Mostrar shimmer loading cuando entrancesLoading está activo
                                if (_.entrancesLoading.value) {
                                  return Column(
                                    children: [
                                      // Shimmer para "Escanear QR Pinlet"
                                      _buildShimmerCard(),
                                      const SizedBox(height: 24),
                                      // Shimmer para "Registrar Entrada"
                                      _buildShimmerCard(),
                                      const SizedBox(height: 24),
                                      // Shimmer para "Registrar Salida"
                                      _buildShimmerCard(),
                                    ],
                                  );
                                }
                                
                                // Ocultar todos los cards cuando entranceFormLoading está activo
                                if (_.entranceFormLoading.value) {
                                  return Container(); // No mostrar nada cuando está cargando
                                }
                                
                                return Column(
                                  children: [
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
                                    SizedBox(
                                      height: (_.entranceIdSelected?.tipoIngreso != TypeDoor.exit || propertyEntryType != PropertyEntryType.residentGate) ? 24 : 0,
                                    ),
                                    // Mostrar "Registrar Entrada" solo si no es una puerta de salida
                                    if (_.entranceIdSelected?.tipoIngreso != TypeDoor.exit || propertyEntryType != PropertyEntryType.residentGate)
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
                                    // Separador solo cuando se muestra "Registrar Entrada" y también se va a mostrar "Registrar Salida"
                                    if (_.entranceIdSelected?.tipoIngreso != TypeDoor.exit || 
                                        _.entranceIdSelected?.tipoIngreso != TypeDoor.entrance)
                                      const SizedBox(
                                        height: 24,
                                      ),
                                    // Mostrar "Registrar Salida" solo si no es una puerta de entrada
                                    if (_.entranceIdSelected?.tipoIngreso != TypeDoor.entrance || propertyEntryType != PropertyEntryType.residentGate)
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
                                  ],
                                );
                              }),
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

  Widget _buildShimmerCard() {
    return Container(
      width: double.infinity,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Shimmer para el ícono
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            // Shimmer para el texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
