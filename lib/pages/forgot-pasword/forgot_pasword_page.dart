import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/Constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/Constants/size_phone.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/bra-underline-button.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/pages/forgot-pasword/forgot_password_controller.dart';
import 'package:qr_scaner_manrique/shared/widgets/header_navigation_page.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    ForgotPasswordController forgotPasswordController =
        Get.put(ForgotPasswordController());
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return Scaffold(
      body: GetBuilder<ForgotPasswordController>(
          init: forgotPasswordController,
          builder: (_) {
            return SafeArea(
                minimum: EdgeInsets.only(left: 24, right: 24, top: 0),
                child: HeaderNavigatedPage(
                  paddign: EdgeInsets.only(bottom: 30),
                  title: '',
                  onTapBack: () {
                    Get.back();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        ConstantsIcons.forgotPassword,
                        height: size.height < SizePhone.HEGTH_S
                            ? 130
                            : size.height < SizePhone.HEGTH_L
                                ? 150
                                : 230,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      BRAText(
                        text: stringLocations.forgotPasswordLabelTitle,
                        textStyle: TextStyle(
                          color: Color(0xFF202023),
                          fontSize: size.height < SizePhone.HEGTH_S ? 25 : 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      BRAText(
                        text: stringLocations.forgotPasswordLabelSubtitle,
                        textStyle: TextStyle(
                          color: Color(0xFF52566B),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: size.height < SizePhone.HEGTH_S ? 24 : 28,
                      ),
                      Form(
                          key: _.formKeyResetPass,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                  focusNode: _.phoneNumberFocusNode,
                                  controller: _.phoneNumberController,
                                  validator: ((val) {
                                    if (val!.isEmpty) {
                                      return stringLocations.userInputEmptyError;
                                    } else if (val.length < 3) {
                                      return stringLocations.userInputIncorrectError;
                                    }
                                    return null;
                                  }),
                                  onTap: () {},
                                  label: stringLocations.userInputLabel,
                                  onChanged: (value) {
                                    _.phoneNumber = value;
                                  })
                            ],
                          )),
                      SizedBox(
                        height: size.height < SizePhone.HEGTH_S ? 24 : 28,
                      ),
                      BRAButton(
                          loadingButton: _.loading,
                          label: stringLocations.continueLabel,
                          onPressed: () {
                            if (_.formKeyResetPass.currentState!.validate()) {
                              _.formKeyResetPass.currentState!.save();
                              _.resetPass();
                            } else {
                            }
                          }),
                      SizedBox(
                        height: 28,
                      )
                    ],
                  ),
                ));
          }),
    );
  }
}
