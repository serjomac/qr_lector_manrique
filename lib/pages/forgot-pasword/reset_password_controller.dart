import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/request_login.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/login/ui/login_page.dart';
import 'package:qr_scaner_manrique/pages/properties/properties_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';

class ResetPasswordController extends GetxController {
  String password = '';
  String confirmPassword = '';
  String phoneNumber = '';
  String otp = '';
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode confirmPasswordFocusNode = new FocusNode();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKeyChangePass = GlobalKey();
  final ApiAuth _authService = ApiAuth();
  RxBool loading = false.obs;

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments != null) {
      if (arguments['phoneNumber'] != null && arguments['otp'] != null) {
        phoneNumber = arguments['phoneNumber'];
        otp = arguments['otp'];
      }
    }
    super.onInit();
  }

  resetPassword() async {
    if (password != confirmPassword) {
      showDialog(
        context: Get.overlayContext!,
        builder: (c) {
          return SuccessDialog(
            title: 'Error',
            subtitle: 'Las contraseñas no coinciden',
            onTapAcept: () {
              Get.back();
            },
          );
        },
      );
      return;
    }
    loading.value = true;
    try {
      final res = await _authService.updateResetPassword(
        code: otp,
        password: password,
        usuario: phoneNumber,
      );
      RequestLogin requestLogin =
          RequestLogin(usuario: phoneNumber, contrasena: password);
      final resLogin = await _authService.login(requestLogin);
      UserData.sharedInstance.saveUserData(resLogin);
      // localApi.saveUserData(responseLogin);
      // getAreasByUser(responseLogin.idUsuarioAdmin.toString());
      loading.value = false;
      showDialog(
        context: Get.overlayContext!,
        builder: (c) {
          return SuccessDialog(
            title: 'En hora buena',
            iconSvg: ConstantsIcons.success,
            subtitle: 'Contrseña actualizada con éxito',
            onTapAcept: () {
              Get.offAll(PropertiesPage());
            },
          );
        },
      );
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }
}
