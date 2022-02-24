import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/core/api/api_managr.dart';
import 'package:qr_scaner_manrique/core/api/local_api.dart';
import 'package:qr_scaner_manrique/core/models/request_models/request_login.dart';
import 'package:qr_scaner_manrique/core/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/core/routes/app_routes.dart';
import 'package:qr_scaner_manrique/shared/widgets/dialog_sucess_error.dart';
import 'package:qr_scaner_manrique/utils/constants/constants.dart';

class LoginController extends GetxController {
  // VARIALBES PARA LA VISTA
  final GlobalKey<FormState> formKey = GlobalKey();
  RxBool presentSpinner = false.obs;
  bool _isVisiblePass = false;

  // OBTEJO DE CATCH
  ResponseErrorModel? _dioError;

  ApiManager apiManager = ApiManager();
  LocalApi localApi = LocalApi();

  // CAMPOS LOGIN
  String _email = '';
  String _password = '';

  //GETTERS Y SETTERS
  String get email {
    return _email;
  }

  set email(e) {
    _email = e;
  }

  String get password {
    return _password;
  }

  set password(p) {
    _password = p;
  }

  bool get isVisiblePass {
    return _isVisiblePass;
  }

  set isVisiblePass(v) {
    _isVisiblePass = v;
    update(['pass-field']);
  }

  @override
  void onInit() async {
    final userData = await localApi.getUserData();
    if (userData != null) {
      Get.offAllNamed(AppRoutes.QR_SCANNER);
    }
    super.onInit();
  }

  //LLAMADO A SERVICIOS
  Future<void> login(String email, String password) async {
    presentSpinner.value = true;
    try {
      RequestLogin requestLogin = RequestLogin(usuario: email, clave: password);
      final responseLogin = await apiManager.login(requestLogin);
      presentSpinner.value = false;
      localApi.saveUserData(responseLogin);
      Get.toNamed(AppRoutes.Schools);
    } catch (e) {
      _dioError = e as ResponseErrorModel;
      presentSpinner.value = false;
      _showModalErrorLogin(_dioError!.mensaje);
    }
    // if (responseLogin['nombres'] != null) {
    //   User usuarioTmp = User.fromJsonM(responseLogin);
    //   UserData.sharedInstance.saveUserData(usuarioTmp);
    //   Get.offAll(NavigationBarPage());
    // } else {
    //   CustomDialogPage.showDialog('Error', responseLogin['status'], Colors.red);
    // }
  }

  _showModalErrorLogin(String mensaje) {
    showDialog(
        barrierDismissible: true,
        context: Get.overlayContext!,
        builder: (c) {
          return DialogSuccessError(titulo: 'Informativo', mensaje: mensaje, tipo: Constants.ERROR);
        });
  }

  back() {
    Get.back();
  }
}
