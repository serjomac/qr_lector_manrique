import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as response_dio;
import 'package:qr_scaner_manrique/core/models/request_models/marcar_salida_request.dart';
import 'package:qr_scaner_manrique/core/models/request_models/request_areas.dart';
import 'package:qr_scaner_manrique/core/models/request_models/request_login.dart';
import 'package:qr_scaner_manrique/core/models/request_models/request_retirar.dart';
import 'package:qr_scaner_manrique/core/models/request_models/request_salida.dart';
import 'package:qr_scaner_manrique/core/models/request_models/validate_qr_code.dart';
import 'package:qr_scaner_manrique/core/models/response_models/area_model.dart';
import 'package:qr_scaner_manrique/core/models/response_models/auth_login.dart';
import 'package:qr_scaner_manrique/core/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/core/models/response_models/response_salida_model.dart';
import 'package:qr_scaner_manrique/core/models/response_models/validation_qr_response.dart';
import 'package:qr_scaner_manrique/utils/constants/secrets.dart';

class ApiManager {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://104.154.225.61/apiRest1/corp/v1'),
  );

  Options opcionesHeader() {
    Options options = Options();
    options.headers = <String, dynamic>{};
    options.headers!["Content-Type"] = "application/json";
    options.headers!['Authorization'] = 'Bearer ' + Secrets.accessToken;
    return options;
  }

  Future<AuthLoginModel> login(RequestLogin requestLogin) async {
    response_dio.Response response;
    try {
      response = await _dio.post('/login',
          data: requestLogin.toJson(), options: opcionesHeader());
      if (response.data['status'] == null) {
        final result = AuthLoginModel.fromJson(response.data);
        return result;
      } else {
        ResponseErrorModel errorModel =
            ResponseErrorModel(codigoError: 0, causa: '', mensaje: '');
        errorModel.mensaje = response.data['status'];
        return Future.error(errorModel);
      }
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
          codigoError: e.response!.statusCode!,
          mensaje: e.response!.data['mensaje'],
          causa: e.response!.data['causa']);
      return Future.error(errorModel);
    }
  }

  Future<ValidationQrResponse> validateQrCode(
      ValidateQrCodeRequest validateQrCodeRequest) async {
    response_dio.Response response;
    try {
      log('request validacion' + validateQrCodeRequest.toJson().toString());
      response = await _dio.post('/validacion1',
          data: validateQrCodeRequest.toJson(), options: opcionesHeader());
      if (response.data['mensaje'] != null &&
          response.data['mensaje']['status'] == 'A') {
        log('response validaricion' + response.data.toString());
        return validationQrResponseFromJson(json.encode(response.data));
      } else {
        ResponseErrorModel errorModel = ResponseErrorModel(
            codigoError: 0, causa: 'No dejar pasar', mensaje: '');
        errorModel.mensaje = response.data['mensaje']['mensaje'];
        return Future.error(errorModel);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        ResponseErrorModel errorModel = ResponseErrorModel(
            codigoError: e.response!.statusCode!,
            mensaje: e.response!.data['mensaje'],
            causa: e.response!.data['causa']);
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      } else {
        ResponseErrorModel errorModel =
            ResponseErrorModel(codigoError: 0, causa: '', mensaje: '');
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      }
    }
  }

  Future<List<Area>> getAreasByUser(AreaRequest areaRequest) async {
    response_dio.Response response;
    try {
      response = await _dio.post('/areas',
          data: areaRequest.toJson(), options: opcionesHeader());
      return areaFromJson(json.encode(response.data));
    } on DioError catch (e) {
      if (e.response != null) {
        ResponseErrorModel errorModel = ResponseErrorModel(
            codigoError: e.response!.statusCode!,
            mensaje: e.response!.data['mensaje'],
            causa: e.response!.data['causa']);
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      } else {
        ResponseErrorModel errorModel = ResponseErrorModel(
            codigoError: e.response!.statusCode!,
            mensaje: e.response!.data['mensaje'],
            causa: e.response!.data['causa']);
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      }
    }
  }

  Future<bool> RetirarEstudiante(RetirarRequest retirarRequest) async {
    response_dio.Response response;
    try {
      log('request retirar: ' + retirarRequest.toJson().toString());
      response = await _dio.post('/retirar',
          data: retirarRequest.toJson(), options: opcionesHeader());
      print('response retirar' + response.data.toString());
      if (response.data['status'] != null &&
          response.data['status'] == 'Operación realizada OK') {
        return true;
      } else {
        return true;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        ResponseErrorModel errorModel = ResponseErrorModel(
            codigoError: e.response!.statusCode!,
            mensaje: e.response!.data['mensaje'],
            causa: e.response!.data['causa']);
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      } else {
        ResponseErrorModel errorModel =
            ResponseErrorModel(codigoError: 0, causa: '', mensaje: '');
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      }
    }
  }

  Future<List<ResponseSalida>> getPadresSalida(
      SalidaRequest salidarequest) async {
    response_dio.Response response;
    try {
      response = await _dio.post('/salida',
          data: salidarequest.toJson(), options: opcionesHeader());
      log('response padres---' + response.data.toString());
      if (response.data[0] == null) {
        ResponseErrorModel errorModel =
            ResponseErrorModel(codigoError: 0, causa: '', mensaje: '');
        errorModel.mensaje = response.data['mensaje'];
        return Future.error(errorModel);
      } else {
        return salidaResponseFromJson(json.encode(response.data));
      }
    } on DioError catch (e) {
      if (e.response != null) {
        ResponseErrorModel errorModel = ResponseErrorModel(
            codigoError: e.response!.statusCode!,
            mensaje: e.response!.data['mensaje'],
            causa: e.response!.data['causa']);
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      } else {
        ResponseErrorModel errorModel =
            ResponseErrorModel(codigoError: 0, causa: '', mensaje: '');
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      }
    }
  }

  Future<String> marcarSalida(MarcarSalidaRequest marcarSalidaRequest) async {
    response_dio.Response response;
    log('request marcar salida: ' + marcarSalidaRequest.toJson().toString());
    try {
      response = await _dio.post('/marcar_salida',
          data: marcarSalidaRequest.toJson(), options: opcionesHeader());
      log('response marcar---' + response.data.toString());
      if (response.data['status'] == null) {
        ResponseErrorModel errorModel =
            ResponseErrorModel(codigoError: 0, causa: '', mensaje: '');
        errorModel.mensaje = response.data['mensaje'];
        return Future.error(errorModel);
      } else {
        return response.data['status'].toString();
      }
    } on DioError catch (e) {
      if (e.response != null) {
        ResponseErrorModel errorModel = ResponseErrorModel(
            codigoError: e.response!.statusCode!,
            mensaje: e.response!.data['mensaje'],
            causa: e.response!.data['causa']);
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      } else {
        ResponseErrorModel errorModel =
            ResponseErrorModel(codigoError: 0, causa: '', mensaje: '');
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      }
    }
  }
}
