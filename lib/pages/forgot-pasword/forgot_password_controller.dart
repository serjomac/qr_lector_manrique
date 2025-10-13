import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/pages/forgot-pasword/otp_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';

class ForgotPasswordController extends GetxController {
  String phoneNumber = '';
  RxBool loading = false.obs;
  FocusNode phoneNumberFocusNode = new FocusNode();
  String email = '';
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> formKeyResetPass = GlobalKey<FormState>();
  ApiAuth apiAuth = ApiAuth();
  // final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
  }

  resetPass() async {
    loading.value = true;
    try {
     final res = await apiAuth.resetPassword(phoneNumberController.text);
      loading.value = false;
      email = res;
      Get.to(
        OtpPage(),
        arguments: {
          'phoneNumber': phoneNumber,
          'email': email,
        },
      );
    } on DioError catch (_) {
      loading.value = false;
    }
  }
}
