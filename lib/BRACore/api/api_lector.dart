import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/api/dio_client.dart';
import 'package:qr_scaner_manrique/BRACore/enums/ocr_type.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_childs_response.dart';

class ApiLector {
  final Dio _dio = DioClient().dio;

  Future<LectorResponse> validateQrCode({
    required String code,
    required String placeId,
    required String entranceId,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        '/lector',
        data: {
          'codigo': code,
          'id_lugar': placeId,
          'id_puerta': entranceId,
          'id_usuario_admin': userId,
        },
      );
      log(json.encode(response.data));
      final res = lectorResponseFromJson(json.encode(response.data));
      return res;
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
          codigoError: e.response!.statusCode!,
          mensaje: e.response!.data['mensaje'],
          causa: e.response!.data['causa']);
      return Future.error(errorModel);
    }
  }

  Future<ResidentChildsResponse> validateQrCodeForSchool({
    required String code,
    required String placeId,
    required String entranceId,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        '/lectorColegio', // Endpoint específico para school o usar el mismo endpoint
        data: {
          'codigo': code,
          'id_lugar': placeId,
          'id_puerta': entranceId,
          'id_usuario_admin': userId,
        },
      );
      log(json.encode(response.data));
      // Parseamos la respuesta como ResidentChildsResponse
      final res = ResidentChildsResponse.fromJson(response.data);
      return res;
    } on DioError catch (e) {
      ResponseErrorModel errorModel = ResponseErrorModel(
          codigoError: e.response!.statusCode!,
          mensaje: e.response!.data['mensaje'],
          causa: e.response!.data['causa']);
      return Future.error(errorModel);
    }
  }

  Future<dynamic> ocrLector({
    required String filePath,
    required OcrType ocrType,
    required String placeId,
  }) async {
    try {
      String fileName = filePath.split('/').last; // Obtén el nombre del archivo
      FormData formData = FormData.fromMap(
        {
          'imagen': await MultipartFile.fromFile(
            filePath,
            filename: fileName,
          ),
          'tipo': ocrType.valueOrc,
          'id_lugar': placeId
        },
      );
      Response response = await _dio.post(
        '/OCR_bitacora',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response.toString());
      return Future.error(e);
    }
  }
}
