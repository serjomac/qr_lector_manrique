import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/core/api/api_managr.dart';
import 'package:qr_scaner_manrique/core/api/local_api.dart';
import 'package:qr_scaner_manrique/core/models/request_models/validate_qr_code.dart';
import 'package:qr_scaner_manrique/core/models/response_models/auth_login.dart';
import 'package:qr_scaner_manrique/pages/qr_scanner/ui/scan_camera.dart';
import 'package:qr_scaner_manrique/shared/widgets/dialog_sucess_error.dart';
import 'package:qr_scaner_manrique/utils/constants/constants.dart';

class QrScannerController extends GetxController {

  ApiManager apiManager = ApiManager();
  LocalApi localApi = LocalApi();

  AuthLoginModel? userData;
  
  RxBool loadingValidateQrCode = false.obs;

  @override
  void onInit() async {
    userData = await localApi.getUserData();
    super.onInit();
  }

  Future<void> scanCode() async {
    final result = await Get.to(
      const ScanCamera(),
      fullscreenDialog: true,
      duration: const Duration(seconds: 1),
    );
    log('RESPUESTA QR' + result.toString());
    if (result != null) {
      final isCodeValid = await validateQrCode(result);
      print('REPSUES CDIGO' + isCodeValid.toString());
      if (isCodeValid) {
        _showModalErrorLogin('Dejar pasar', Constants.EXITO, 'QR VÁLIDO');
      } else {
        _showModalErrorLogin('NO DEJAR PASAR', Constants.ERROR, 'QR INVÁLIDO');
      }
    }
  }


  Future<bool> validateQrCode(String qrCode) async {
    loadingValidateQrCode.value = true;
    ValidateQrCodeRequest validateQrCodeRequest = ValidateQrCodeRequest(
      codigo: qrCode
    );
    loadingValidateQrCode.value = false;
    final responseLogin = await apiManager.validateQrCode(validateQrCodeRequest);
    return responseLogin;
  }


  _showModalErrorLogin(String mensaje, String tipoRespuesta, String message) {
    showDialog(
        barrierDismissible: true,
        context: Get.overlayContext!,
        builder: (c) {
          return DialogSuccessError(
            titulo: message,
            mensaje: mensaje,
            tipo: tipoRespuesta);
        });
  }
  
  
}