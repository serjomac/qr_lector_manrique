import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as response_dio;
import 'package:qr_scaner_manrique/core/models/request_models/request_login.dart';
import 'package:qr_scaner_manrique/core/models/request_models/validate_qr_code.dart';
import 'package:qr_scaner_manrique/core/models/response_models/auth_login.dart';
import 'package:qr_scaner_manrique/core/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/utils/constants/secrets.dart';

class ApiManager {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://104.154.225.61/apiRest1/corp/v1'
        ),
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
        data: requestLogin.toJson(),
        options: opcionesHeader()
      );
      if (response.data['status'] == null) {
        final result = AuthLoginModel.fromJson(response.data);
        return result;
      } else {
        ResponseErrorModel errorModel = ResponseErrorModel(codigoError: 0);
        errorModel.mensaje = response.data['status'];
        return Future.error(errorModel);
      }
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(codigoError: e.response!.statusCode!);
      return Future.error(errorModel);
    }
  }


  Future<bool> validateQrCode(ValidateQrCodeRequest validateQrCodeRequest) async {
    response_dio.Response response;
    try {
      response = await _dio.post('/validacion',
        data: validateQrCodeRequest.toJson(),
        options: opcionesHeader()
      );
      if (response.data['mensaje'] != null && response.data['mensaje'][0] == 'Codigo valido') {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        ResponseErrorModel errorModel = ResponseErrorModel(codigoError: e.response!.statusCode!);
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      } else {
        ResponseErrorModel errorModel = ResponseErrorModel(codigoError: 0);
        log('ERROR DE PETICION' + errorModel.mensaje);
        return Future.error(errorModel);
      }
    }
  }
}
