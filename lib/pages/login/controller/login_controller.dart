import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_managr.dart';
import 'package:qr_scaner_manrique/BRACore/api/local_api.dart';
import 'package:qr_scaner_manrique/BRACore/models/general/error_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/request_areas.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/request_login.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/area_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/BRACore/routes/app_routes.dart';
import 'package:qr_scaner_manrique/pages/forgot-pasword/reset_password_page.dart';
import 'package:qr_scaner_manrique/pages/properties/properties_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/dialog_sucess_error.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';
import 'package:qr_scaner_manrique/utils/constants/constants.dart';

class LoginController extends GetxController {
  // VARIALBES PARA LA VISTA
  final GlobalKey<FormState> formKey = GlobalKey();
  RxBool loading = false.obs;
  bool _isVisiblePass = false;
  FocusNode cellFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  // OBTEJO DE CATCH
  ResponseErrorModel? _dioError;

  ApiManager apiManager = ApiManager();
  ApiAuth apiAuth = ApiAuth();
  LocalApi localApi = LocalApi();
  List<Area> _areaList = [];

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
    final araSelected = await localApi.getAreaselected();
    // if (userData != null) {
    //   if (araSelected != null) {
    //     Get.offAllNamed(AppRoutes.QR_SCANNER);
    //   } else {
    //     getAreasByUser(userData.idUsuarioAdmin.toString());
    //   }
    // }
    super.onInit();
  }

  //LLAMADO A SERVICIOS
  Future<void> login(String email, String password) async {
    loading.value = true;
    try {
      RequestLogin requestLogin =
          RequestLogin(usuario: email, contrasena: password);
      final responseLogin = await apiAuth.login(requestLogin);
      UserData.sharedInstance.saveUserData(responseLogin);
      // localApi.saveUserData(responseLogin);
      // getAreasByUser(responseLogin.idUsuarioAdmin.toString());
      loading.value = false;
      Get.offAll(PropertiesPage());
    } on DioError catch (e) {
      loading.value = false;
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        ErrorModel errorModel = ErrorModel(
            httpCode: 503,
            codigoError: '503',
            mensaje: 'Superó el tiempo máximo de espera, vuelva a intentar',
            causa: 'Informativo');
        _showDialog(errorModel);
        return;
      }
      ErrorModel errorModel = ErrorModel(
          httpCode: e.response!.statusCode!,
          codigoError: e.response!.data['codigo'],
          mensaje: e.response!.data['mensaje'],
          causa: e.response!.data['causa']);
      if (errorModel.codigoError == '106') {
        _showDialog(errorModel);
      }
    }
  }

  _showDialog(ErrorModel error) {
    showDialog(
      context: Get.overlayContext!,
      builder: (c) {
        return SuccessDialog(
            title: error.causa,
            subtitle: error.mensaje,
            iconSvg: 'assets/icons_svg/alert_icon.svg',
            onTapAcept: () {
              customNavigateError(error.codigoError);
            });
      },
    );
  }

//88937
  customNavigateError(String code) {
    switch (code) {
      case '106':
        Get.to(ResetPasswordPage(), arguments: {
          'phoneNumber': email,
          'otp': password,
        });
        break;
      default:
        Get.back();
    }
  }

  Future<void> getAreasByUser(String idUser) async {
    try {
      AreaRequest areaRequest = AreaRequest(idUsuario: idUser);
      _areaList = await apiManager.getAreasByUser(areaRequest);
      loading.value = false;
      Get.offAllNamed(AppRoutes.Schools, arguments: {'idUser': idUser});
    } catch (e) {
      _dioError = e as ResponseErrorModel;
      loading.value = false;
      _showModalErrorLogin(_dioError!.mensaje);
    }
  }

  _showModalErrorLogin(String mensaje) {
    showDialog(
        barrierDismissible: true,
        context: Get.overlayContext!,
        builder: (c) {
          return DialogSuccessError(
              titulo: 'Informativo', mensaje: mensaje, tipo: Constants.ERROR);
        });
  }

  back() {
    Get.back();
  }
}
