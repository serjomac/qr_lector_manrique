import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/core/api/api_managr.dart';
import 'package:qr_scaner_manrique/core/api/local_api.dart';
import 'package:qr_scaner_manrique/core/models/request_models/request_retirar.dart';
import 'package:qr_scaner_manrique/core/models/request_models/validate_qr_code.dart';
import 'package:qr_scaner_manrique/core/models/response_models/area_model.dart';
import 'package:qr_scaner_manrique/core/models/response_models/auth_login.dart';
import 'package:qr_scaner_manrique/core/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/core/models/response_models/validation_qr_response.dart';
import 'package:qr_scaner_manrique/pages/qr_scanner/ui/scan_camera.dart';
import 'package:qr_scaner_manrique/shared/widgets/dialog_students.dart';
import 'package:qr_scaner_manrique/shared/widgets/dialog_sucess_error.dart';
import 'package:qr_scaner_manrique/utils/constants/constants.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';

class QrScannerController extends GetxController {
  ApiManager apiManager = ApiManager();
  LocalApi localApi = LocalApi();

  AuthLoginModel? userData;
  Area? area;
  GroupController controller = GroupController(isMultipleSelection: true);

  RxBool loadingValidateQrCode = false.obs;
  RxBool seleccionarTodo = false.obs;
  List<Estudiante> _studentsList = [];
  List<Estudiante> _studentsSelected = [];

  @override
  void onInit() async {
    userData = await localApi.getUserData();
    area = await localApi.getAreaselected();
    update();
    super.onInit();
  }

  Future<void> scanCode() async {
    final result = await Get.to(
      const ScanCamera(),
      fullscreenDialog: true,
      duration: const Duration(milliseconds: 400),
    );
    log('RESPUESTA QR' + result.toString());
    if (result != null) {
      validateQrCode(result, area!.id!);
    }
  }

  Future<void> validateQrCode(String qrCode, String idArea) async {
    loadingValidateQrCode.value = true;
    ValidateQrCodeRequest validateQrCodeRequest =
        ValidateQrCodeRequest(codigo: qrCode, idArea: idArea);
    try {
      final responseValidacionQR =
          await apiManager.validateQrCode(validateQrCodeRequest);
      loadingValidateQrCode.value = false;
      _studentsList = responseValidacionQR.mensaje!.estudiante!;
      update(['']);
      final List<String> itemsTitle = [];
      for (var e in responseValidacionQR.mensaje!.estudiante!) {
        itemsTitle.add(e.nombre!);
      }
      seleccionarTodo.value = false;
      _showModalStudentsList(
          'Alumnos por recoger',
          Constants.EXITO,
          responseValidacionQR.mensaje!.mensaje!,
          _studentsList,
          itemsTitle,
          responseValidacionQR.mensaje!.estudiante!,
          controller, () async {
        _studentsSelected = controller.selectedItem as List<Estudiante>;
        var idHijos = '';
        for (var estudiante in _studentsSelected) {
          idHijos += estudiante.idHijo! + '|';
        }
        idHijos = idHijos.substring(0, idHijos.length - 1);
        final req = RetirarRequest(
            celular: responseValidacionQR.mensaje!.celular,
            nombre: responseValidacionQR.mensaje!.residente,
            tipo: responseValidacionQR.mensaje!.tipo,
            idHijos: idHijos);
        try {
          final res = await apiManager.RetirarEstudiante(req);
          if (res) {
            Get.back();
            Get.snackbar('Validación exitosa', 'Dejar pasar al residente',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2));
          } else {
            Get.snackbar('Error', 'Volver a intetar');
          }
        } catch (e) {
          final error = e as ResponseErrorModel;
          Get.snackbar('Error', error.mensaje);
        }
      });
    } catch (e) {
      loadingValidateQrCode.value = false;
      final error = e as ResponseErrorModel;
      return _showModalErrorLogin(error.causa, Constants.ERROR, error.mensaje);
    }
  }

  _showModalErrorLogin(String mensaje, String tipoRespuesta, String message) {
    showDialog(
        barrierDismissible: true,
        context: Get.overlayContext!,
        builder: (c) {
          return DialogSuccessError(
              titulo: message, mensaje: mensaje, tipo: tipoRespuesta);
        });
  }

  _showModalStudentsList(
      String mensaje,
      String tipoRespuesta,
      String message,
      List<Estudiante> studentsList,
      List<String> itemsTitle,
      List<Estudiante> valueCheck,
      GroupController controller,
      VoidCallback onTapAceptar) {
    showDialog(
        barrierDismissible: false,
        context: Get.overlayContext!,
        builder: (c) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: DialogStudents(
              titulo: message,
              mensaje: mensaje,
              tipo: tipoRespuesta,
              studentsList: studentsList,
              controller: controller,
              itemsTitle: itemsTitle,
              valueCheck: valueCheck,
              onTapAcept: onTapAceptar,
              seleccionarTodo: seleccionarTodo,
            ),
          );
        });
  }
}
