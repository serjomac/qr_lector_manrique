import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/bra-underline-button.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/pages/forgot-pasword/forgot_pasword_page.dart';
import 'package:qr_scaner_manrique/pages/login/controller/login_controller.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (_) {
          return Center(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: size.height * 0.15,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 50),
                      child: GetBuilder<LoginController>(
                        id: 'lblLogin',
                        builder: (_) {
                          return SvgPicture.asset(
                            ConstantsIcons.mainLogoWhite,
                            color: Colors.white,
                            width: 250,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 41, left: 24, right: 24),
                      decoration: BoxDecoration(
                        color: colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 44),
                        child: Form(
                          key: _.formKey,
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: BRAText(
                                  text: stringLocations.loginTitle,
                                  textStyle: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: theme.own().primareyTextColor),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Container(
                                child: CustomTextFormField(
                                  label: stringLocations.userInputLabel,
                                  focusNode: _.cellFocusNode,
                                  autocorect: false,
                                  hintText: '',
                                  onChanged: (value) {
                                    _.email = value;
                                  },
                                  validator: (String? value) {
                                    final textValue = value ?? '';
                                    if ((textValue.isEmpty)) {
                                      return stringLocations.userInputEmptyError;
                                    } else if (textValue.length < 3) {
                                      return stringLocations.userInputIncorrectError;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                margin: const EdgeInsets.only(bottom: 10.0),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Container(
                                child: GetBuilder<LoginController>(
                                    id: 'pass-field',
                                    builder: (context) {
                                      return CustomTextFormField(
                                        label: stringLocations.loginPasswordInputLabel,
                                        autocorect: false,
                                        hintText: '*********',
                                        suxffixIcon: !_.isVisiblePass
                                            ? InkWell(
                                                child: const Icon(Icons
                                                    .visibility_off_rounded),
                                                onTap: () {
                                                  _.isVisiblePass =
                                                      !_.isVisiblePass;
                                                },
                                              )
                                            : InkWell(
                                                child: const Icon(
                                                  Icons.visibility_rounded,
                                                ),
                                                onTap: () {
                                                  _.isVisiblePass =
                                                      !_.isVisiblePass;
                                                },
                                              ),
                                        obscureText: !_.isVisiblePass,
                                        keyboardType: TextInputType.text,
                                        onChanged: (String value) {
                                          _.password = value;
                                        },
                                        validator: (String? value) {
                                          final textValue = value ?? '';
                                          if ((textValue.isEmpty)) {
                                            return stringLocations.loginPasswordInputEmptyLabel;
                                          } else if (textValue.length < 5) {
                                            return stringLocations.loginPasswordInputIncorrectLabel;
                                          } else {
                                            return null;
                                          }
                                        },
                                        focusNode: _.passwordFocusNode,
                                      );
                                    }),
                                margin: const EdgeInsets.only(bottom: 25.0),
                              ),
                              BRAUnderlineButton(
                                title: stringLocations.loginForgotPasswordButton,
                                onTap: () {
                                  Get.to(ForgotPasswordPage());
                                },
                              ),
                              BRAButton(
                                loadingButton: _.loading,
                                label: stringLocations.loginTitle,
                                onPressed: () {
                                  if (_.formKey.currentState!.validate()) {
                                    _.formKey.currentState!.save();
                                    _.login(_.email, _.password);
                                  } else {
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
