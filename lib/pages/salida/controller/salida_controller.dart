import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_managr.dart';
import 'package:qr_scaner_manrique/BRACore/api/local_api.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/marcar_salida_request.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/request_salida.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/area_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/response_salida_model.dart';
import 'package:qr_scaner_manrique/shared/widgets/dialog_hijos.dart';
import 'package:qr_scaner_manrique/shared/widgets/dialog_students.dart';
import 'package:qr_scaner_manrique/shared/widgets/dialog_sucess_error.dart';
import 'package:qr_scaner_manrique/utils/constants/constants.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';

class SalidaController extends GetxController {
  RxBool _loagindSalida = false.obs;
  RxBool seleccionarTodo = false.obs;
  ApiManager apiManager = ApiManager();
  LocalApi localApi = LocalApi();
  Map<String, dynamic> arguments = {};
  Area? _areaSelected;
  List<ResponseSalida> parentList = [];
  List<String> nombresHijos = [];
  GroupController controller = GroupController(isMultipleSelection: true);

  @override
  void onInit() {
    arguments = Get.arguments;
    if (arguments['areaSelected'] != null) {
      _areaSelected = arguments['areaSelected'] as Area;
    }
    getSalida(idArea: _areaSelected!.id!, tipo: 'P');
    super.onInit();
  }

  Area? get areaSelected {
    return _areaSelected;
  }

  // GETTERS NAD SETTERS
  RxBool get loagindSalida {
    return _loagindSalida;
  }

  set loagindSalida(RxBool v) {
    _loagindSalida = v;
  }

  Future<void> getSalida({required String idArea, required String tipo}) async {
    try {
      parentList = [];
      final salidaRequest = SalidaRequest(idArea: idArea, tipo: tipo);
      _loagindSalida.value = true;
      final res = await apiManager.getPadresSalida(salidaRequest);
      parentList = res;
      _loagindSalida.value = false;
    } catch (e) {
      _loagindSalida.value = false;
      log(e.toString());
      final error = e as ResponseErrorModel;
      return _showModalError('', Constants.INFORMATIVO, error.mensaje);
    }
  }

  _showModalError(String mensaje, String tipoRespuesta, String message) {
    showDialog(
        barrierDismissible: true,
        context: Get.overlayContext!,
        builder: (c) {
          return DialogSuccessError(
              titulo: message, mensaje: mensaje, tipo: tipoRespuesta);
        });
  }

  showModalStudentsList(
      String mensaje,
      String tipoRespuesta,
      String message,
      List<Hijo> hijos,
      List<String> itemsTitle,
      List<Hijo> valueCheck,
      GroupController controller,
      VoidCallback onTapAceptar) async {
    final result = await showDialog<bool>(
        barrierDismissible: false,
        context: Get.overlayContext!,
        builder: (c) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: DialogHijos(
              titulo: message,
              mensaje: mensaje,
              tipo: tipoRespuesta,
              studentsList: hijos,
              controller: controller,
              itemsTitle: itemsTitle,
              valueCheck: valueCheck,
              onTapAcept: onTapAceptar,
              seleccionarTodo: seleccionarTodo,
              onChange: (v) {},
            ),
          );
        });
    if (result != null && result) {
      getSalida(idArea: _areaSelected!.id!, tipo: 'P');
    }
  }

  List<String> getNombreHijos(ResponseSalida padre) {
    nombresHijos = [];
    for (var hijo in padre.hijos!) {
      nombresHijos.add(hijo.hijo!);
    }
    return nombresHijos;
  }

  marcarSalida(ResponseSalida parent) async {
    var retiro = '';
    final selectedItems = controller.selectedItem as List<Hijo>;
    for (var salida in selectedItems) {
      retiro += (salida.idRetiro ?? '') + ':' + (salida.idHijo ?? '') + '|';
    }
    retiro = retiro.substring(0, retiro.length - 1);
    try {
      final marcarSalidaRequest = MarcarSalidaRequest(
          celular: parent.celular,
          nombre: parent.padre,
          tipo: parent.hijos![0].tipo,
          idRetiro: retiro);
      _loagindSalida.value = true;
      final res = await apiManager.marcarSalida(marcarSalidaRequest);
      final resCloseDialog = await showDialog<bool>(
          barrierDismissible: false,
          context: Get.overlayContext!,
          builder: (c) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: DialogSuccessError(
                mensaje: res,
                tipo: Constants.EXITO,
                titulo: 'Registro exitoso',
                onTapAceptar: () {
                  Get.back(result: true);
                },
              ),
            );
          });
      if (resCloseDialog != null && resCloseDialog) {
        Get.back(result: true);
      }
      _loagindSalida.value = false;
    } catch (e) {
      _loagindSalida.value = false;
      log(e.toString());
      final error = e as ResponseErrorModel;
      return _showModalError('', Constants.INFORMATIVO, error.mensaje);
    }
  }
}
