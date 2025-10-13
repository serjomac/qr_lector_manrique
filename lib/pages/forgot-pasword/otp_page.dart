import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/Constants/size_phone.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/bra-underline-button.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/forgot-pasword/otp_controller.dart';
import 'package:qr_scaner_manrique/shared/widgets/header_navigation_page.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class OtpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    OtpController otpController = Get.put(OtpController());
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    return Scaffold(
      body: GetBuilder<OtpController>(
          init: otpController,
          builder: (_) {
            return SafeArea(
                minimum: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 0,
                ),
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
                        'assets/images/escudo_otp.svg',
                        height: size.height < SizePhone.HEGTH_S
                            ? 130
                            : size.height < SizePhone.HEGTH_L
                                ? 170
                                : 180,
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      BRAText(
                        text: stringLocations.otpLabelTitle,
                        textStyle: TextStyle(
                          color: Color(0xFF202023),
                          fontSize: size.height < SizePhone.HEGTH_S ? 25 : 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      BRAText(
                        text: '${stringLocations.otpLabelSubtitle} ${_.email}',
                        textStyle: TextStyle(
                          color: Color(0xFF52566B),
                          fontSize: size.height < SizePhone.HEGTH_S ? 13 : 15,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: size.height < SizePhone.HEGTH_S ? 24 : 47,
                      ),
                      Form(
                        key: _.formKeyResetPassword,
                        child: Row(
                          children: [
                            Flexible(
                              child: CustomTextFormField(
                                focusNode: _.numberOneFocusNode!,
                                isFLoatingLabelVisible: false,
                                maxLength: 5,
                                verticalPadding: 10,
                                textStyle: textTheme.titleLarge!.copyWith(color: theme.own().primareyTextColor),
                                keyboardType: TextInputType.number,
                                onTap: () {},
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return stringLocations.otpEmptyCodeError;
                                  } else if (val.length != 5) {
                                    return stringLocations.otpIncorrectCodeError;
                                  } else {
                                    return null;
                                  }
                                },
                                label: stringLocations.otpLabelCode,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  _.otpNumber = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height < SizePhone.HEGTH_S ? 24 : 47,
                      ),
                      BRAButton(
                          loadingButton: _.loading,
                          label:stringLocations.sendLabel,
                          onPressed: () {
                            if (_.formKeyResetPassword.currentState!
                                .validate()) {
                              _.formKeyResetPassword.currentState!.save();
                              _.verifyOtp();
                            }
                          }),
                      SizedBox(
                        height: size.height < SizePhone.HEGTH_S ? 24 : 40,
                      ),
                      Obx(() {
                        if (_.timerCount.value == 59) {
                          return size.width < SizePhone.WIDTH_M
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BRAText(
                                      text: stringLocations.otpNotGetCodeLabel,
                                      textStyle: textTheme.bodyMedium!.copyWith(
                                          fontSize:
                                              size.width < SizePhone.WIDTH_M
                                                  ? 15
                                                  : 17),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _.resendOtp();
                                      },
                                      child: _.loadingOtp.value
                                          ? CircularProgressIndicator(
                                              color: theme.primaryColor,
                                            )
                                          : BRAText(
                                              text: stringLocations.otpResendCodeButton,
                                              textStyle:
                                                  textTheme.bodySmall!.copyWith(
                                                fontSize: size.width <
                                                        SizePhone.WIDTH_M
                                                    ? 15
                                                    : 17,
                                              ),
                                            ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BRAText(
                                      text: stringLocations.otpNotGetCodeLabel,
                                      textStyle: TextStyle(
                                        color: Color(0xFF202023),
                                        fontSize:
                                            size.height < SizePhone.HEGTH_M
                                                ? 15
                                                : 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    BRAUnderlineButton(
                                      title: stringLocations.otpResendCodeButton,
                                      loading: _.loadingOtp,
                                      onTap: () {
                                        _.resendOtp();
                                      },
                                    ),
                                  ],
                                );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BRAText(
                                text: stringLocations.otpResendTimmerCodeButton,
                                textStyle: textTheme.bodyMedium!.copyWith(
                                    fontSize: size.height < SizePhone.HEGTH_M
                                        ? 15
                                        : 17),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              BRAText(
                                text: '(' + _.timerCount.value.toString() + ')',
                                textStyle: textTheme.bodySmall!.copyWith(
                                    fontSize: size.height < SizePhone.HEGTH_M
                                        ? 15
                                        : 17),
                              ),
                            ],
                          );
                        }
                      })
                    ],
                  ),
                ));
          }),
    );
  }
}
