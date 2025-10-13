import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';
import 'package:qr_scaner_manrique/pages/forgot-pasword/reset_password_page.dart';

class OtpController extends GetxController {
  String otpNumber = '';
  final GlobalKey<FormState> formKeyResetPassword = GlobalKey();
  FocusNode? numberOneFocusNode = FocusNode();
  TextEditingController phoneNumberController = TextEditingController();
  final ApiAuth _authService = ApiAuth();
  RxBool loading = false.obs;
  RxBool loadingOtp = false.obs;
  String phoneNumber = '';
  String email = '';
  Timer? timer;
  RxInt timerCount = 59.obs;

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments != null) {
      if (arguments['phoneNumber'] != null && arguments['email'] != null) {
        phoneNumber = arguments['phoneNumber'];
        email = arguments['email'];
      }
    }
    super.onInit();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    super.onClose();
  }

  verifyOtp() async {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    loading.value = true;
    try {
      await _authService.validateResetPassword(usuario: phoneNumber, code: otpNumber);
      loading.value = false;
      Get.to(
        ResetPasswordPage(),
        arguments: {
          'phoneNumber': phoneNumber,
          'otp': otpNumber,
        },
      );
    } catch (e) {
      loading.value = false;
    }
  }

  resendOtp() async {
    loadingOtp.value = true;
    try {
      final res = await _authService.resetPassword(phoneNumber);
      email = res;
      timer = Timer.periodic(const Duration(seconds: 1), (timerTmp) {
        loadingOtp.value = false;
        timerCount.value--;
        if (timerCount.value == 0) {
          timerCount.value = 59;
          timerTmp.cancel();
          timer = null;
        }
      });
    } catch (e) {
      loadingOtp.value = false;
    }
  }
}
