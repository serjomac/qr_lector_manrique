import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:qr_scaner_manrique/BRACore/api/dio_client.dart';
import 'package:qr_scaner_manrique/data/dto/user_dto.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/request_login.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/auth_login.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/people_data_response.dart';

class ApiAuth {
  final Dio _dio = DioClient().dio;

  Future<AuthLoginModel> login(RequestLogin requestLogin) async {
    try {
      final response =
          await _dio.post('/login_Bitacora', data: requestLogin.toJson());
      log(json.encode(response.data));
      final res = authLoginModelFromJson(json.encode(response.data));
      return res;
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
          codigoError: e.response!.statusCode!,
          mensaje: e.response!.data['mensaje'],
          causa: e.response!.data['causa']);
      return Future.error(e);
    }
  }

  Future<UserDTO> auth(String user, String password) async {
    try {
      final response = await _dio.post('/login_Bitacora',
          data: {'usuario': user, 'contrasena': password});
      log(json.encode(response.data));
      final res = userDTOFromJson(json.encode(response.data));
      return res;
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
          codigoError: e.response!.statusCode!,
          mensaje: e.response!.data['mensaje'],
          causa: e.response!.data['causa']);
      return Future.error(errorModel);
    }
  }

  Future<String> resetPassword(String usuario) async {
    try {
      final response = await _dio.post(
        '/reseteo_usuarioAdmin',
        data: {
          'usuario': usuario,
          'usuario_modificacion': 'app',
        },
      );
      print(response.data);
      return response.data['correo'];
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<void> validateResetPassword({
    required String code,
    required String usuario,
  }) async {
    try {
      final response = await _dio.post(
        '/validar_reseteoAdmin',
        data: {
          'usuario': usuario,
          'codigo': code,
          'usuario_modificacion': 'app',
        },
      );
      print(response.data);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<void> updateResetPassword({
    required String code,
    required String password,
    required String usuario,
  }) async {
    try {
      final response = await _dio.post(
        '/updateContrasenaAdmin_reseteo',
        data: {
          'usuario': usuario,
          'codigo': code,
          'contrasena': password,
          'usuario_modificacion': 'app',
        },
      );
      print(response.data);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<PeopleData> getPeopleDataBy(String cardId) async {
    try {
      Response resp = await _dio.post(
        '/getRegistro_cedula_bitacora',
        data: {
          'cedula': cardId,
        },
      );
      log(json.encode(resp.data));
      final responseMap = peopleDataFromJson(json.encode(resp.data));
      return responseMap;
    } on DioError catch (e) {
      print(e.response.toString());
      return Future.error(e);
    }
  }
}
