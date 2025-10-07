import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:qr_scaner_manrique/BRACore/api/dio_client.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_childs_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_respose.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/pending_school_regiter_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/history_school_response.dart';

class ApiSchool {
  final Dio _dio = DioClient().dio;

  Future<List<ResidentChildsResponse>> getAllRepresentants(
    String placeId,
    String doorId,
    String idUserAdmin,
  ) async {
    try {
      final response = await _dio.post('/getAllResidenteHijo', data: {
        'id_lugar': placeId,
        'id_puerta': doorId,
        'id_usuario_admin': idUserAdmin,
      });
      log(json.encode(response.data));
      final res = residentChildsResponseFromJson(json.encode(response.data));
      return res;
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
          codigoError: e.response!.statusCode!,
          mensaje: e.response!.data['mensaje'],
          causa: e.response!.data['causa']);
      return Future.error(errorModel);
    }
  }

  Future<List<PendingSchoolRegisterResponse>> getAllColegioPendiente(
    String placeId,
    String doorId,
    String idUserAdmin,
  ) async {
    try {
      final response = await _dio.post('/getAllColegioPendiente', data: {
        'id_lugar': placeId,
        'id_puerta': doorId,
        'id_usuario_admin': idUserAdmin,
      });
      log(json.encode(response.data));
      final res = pendingSchoolRegisterResponseFromJson(json.encode(response.data));
      return res;
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
          codigoError: e.response!.statusCode!,
          mensaje: e.response!.data['mensaje'],
          causa: e.response!.data['causa']);
      return Future.error(errorModel);
    }
  }

  Future<void> insertSchoolRegister({
    required String placeId,
    required String codeId,
    required String doorId,
    required String childList,
    required String description,
    required String creationDate,
    required String name,
    required String idCard,
    required String plate,
    required List<String> images,
    required String type,
    required String residentPlaceId,
    required String guestName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'id_lugar': placeId,
        'id_codigo': codeId,
        'id_puerta': doorId,
        'listaHijo': childList,
        'descripcion': description,
        'fecha_creacion': creationDate,
        'nombre': name,
        'cedula': idCard,
        'placa': plate,
        'tipo': type,
        'id_residente_lugar': residentPlaceId,
        'nombre_invitado': guestName,
        'imagenes[]': images
            .map((imagePath) => MultipartFile.fromFileSync(imagePath))
            .toList(),
      });

      final res = await _dio.post(
        '/insertColegioRegistro',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      log(res.data.toString());
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
        codigoError: e.response?.statusCode ?? 0,
        mensaje: e.response?.data['mensaje'] ?? 'Unknown error',
        causa: e.response?.data['causa'] ?? 'Unknown cause',
      );
      return Future.error(errorModel);
    }
  }

  Future<void> retirarColegio({
    required String placeId,
    required String doorId,
    required String residentPlaceId,
    required String type,
    required String childrenList,
  }) async {
    try {
      final response = await _dio.post('/retirarColegio', data: {
        'id_lugar': placeId,
        'id_puerta': doorId,
        'id_residente_lugar': residentPlaceId,
        'tipo': type,
        'lista': childrenList,
      });
      log(json.encode(response.data));
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
        codigoError: e.response?.statusCode ?? 0,
        mensaje: e.response?.data['mensaje'] ?? 'Unknown error',
        causa: e.response?.data['causa'] ?? 'Unknown cause',
      );
      return Future.error(errorModel);
    }
  }

  Future<List<HistorySchoolResponse>> getAllColegioHistorial({
    required String placeId,
    required String doorId,
    required String idUserAdmin,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.post('/getAllColegioHistorial', data: {
        'id_lugar': placeId,
        'id_puerta': doorId,
        'id_usuario_admin': idUserAdmin,
        'fecha_inicio': startDate,
        'fecha_termino': endDate,
      });
      log(json.encode(response.data));
      final res = historySchoolResponseFromJson(json.encode(response.data));
      return res;
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
        codigoError: e.response?.statusCode ?? 0,
        mensaje: e.response?.data['mensaje'] ?? 'Unknown error',
        causa: e.response?.data['causa'] ?? 'Unknown cause',
      );
      return Future.error(errorModel);
    }
  }
}
