import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/formaters/formatter_space.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/forgot-pasword/reset_password_controller.dart';
import 'package:qr_scaner_manrique/shared/widgets/header_navigation_page.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stringLocations = AppLocalizationsGenerator .appLocalizations(context: context);
    return Scaffold(
      body: GetBuilder<ResetPasswordController>(
          init: ResetPasswordController(),
          builder: (_) {
            return SafeArea(
              minimum: EdgeInsets.only(left: 24, right: 24, top: 0),
              child: HeaderNavigatedPage(
                title: stringLocations.changePasswordTitle,
                onTapBack: () {
                  Get.back();
                },
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Form(
                        key: _.formKeyChangePass,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 22,
                            ),
                            CustomTextFormField(
                              focusNode: _.passwordFocusNode,
                              controller: _.passwordController,
                              onTap: () {},
                              label: stringLocations.changePasswordLabelPassword,
                              inputFormatters: [NoSpaceInputFormatter()],
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return stringLocations.changePasswordEmptyPasswordError;
                                } else if (val.length < 5) {
                                  return stringLocations.changePasswordIncorrectPasswordError;
                                } else {
                                  return null;
                                }
                              },
                              onChanged: ((value) {
                                _.password = value;
                              }),
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            CustomTextFormField(
                              focusNode: _.confirmPasswordFocusNode,
                              controller: _.confirmPasswordController,
                              onTap: () {},
                              label: stringLocations.changePasswordLabelConfirmPassword,
                              inputFormatters: [NoSpaceInputFormatter()],
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return stringLocations.changePasswordEmptyConfirmPasswordError;
                                } else if (val.length < 5) {
                                  return stringLocations.changePasswordIncorrectConfirmPasswordError;
                                } else {
                                  return null;
                                }
                              },
                              onChanged: ((value) {
                                _.confirmPassword = value;
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BRAButton(
                        loadingButton: _.loading,
                        label: stringLocations.changePasswordSaveButton,
                        onPressed: (() {
                          if (_.formKeyChangePass.currentState!.validate()) {
                            _.formKeyChangePass.currentState!.save();
                            _.resetPassword();
                          }
                        }),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
