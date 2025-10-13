import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart' as response_dio;
import 'package:qr_scaner_manrique/BRACore/api/dio_client.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/marcar_salida_request.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/request_areas.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/request_retirar.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/request_salida.dart';
import 'package:qr_scaner_manrique/BRACore/models/request_models/validate_qr_code.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/area_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/error_response_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/invitation_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/response_salida_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/validation_qr_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/representative.dart';

class ApiManager {
  final Dio _dio = DioClient().dio;

  Future<ValidationQrResponse> validateQrCode(
      ValidateQrCodeRequest validateQrCodeRequest) async {
    response_dio.Response response;
    try {
      log('request validacion' + validateQrCodeRequest.toJson().toString());
      response =
          await _dio.post('/validacion1', data: validateQrCodeRequest.toJson());
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
      response = await _dio.post('/areas', data: areaRequest.toJson());
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
      response = await _dio.post('/retirar', data: retirarRequest.toJson());
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
      response = await _dio.post('/salida', data: salidarequest.toJson());
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
      response =
          await _dio.post('/marcar_salida', data: marcarSalidaRequest.toJson());
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

  Future<List<Place>> fetchService(int useId) async {
    try {
      final resp = await _dio
          .post('/getAlllugar_Bitacora', data: {'id_usuario_admin': useId});
      log('RESPONSE PLACES: ' + json.encode(resp.data));
      final responseMap = placeFromJson(json.encode(resp.data));
      return responseMap;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<List<GateDoor>> fetchEntrances(String placeId, String tipo) async {
    try {
      final resp = await _dio.post('/getAllPuerta_lugarBitacora', data: {
        'id_lugar': placeId,
        'tipo': tipo,
      });
      log('RESPONSE ENTRANCES: ' + json.encode(resp.data));
      final responseMap = entranceFromJson(json.encode(resp.data));
      return responseMap;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<List<InvitationResponse>> fetchNormalInvitations(
      {required String placeId}) async {
    try {
      final resp = await _dio
          .post('/getAllInvitacionNormal_activas', data: {'id_lugar': placeId});
      log('RESPONSE NORMAL INVITATIONS: ' + json.encode(resp.data));
      final responseMap = invitationResponseFromJson(json.encode(resp.data));
      return responseMap;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<List<InvitationResponse>> fetchRecurrentInvitations(
      String placeId) async {
    try {
      final resp = await _dio.post('/getAllInvitacionRecurrente_activas',
          data: {'id_lugar': placeId});
      log('RESPONSE RECURRENT INVITATIONS: ' + json.encode(resp.data));
      final responseMap = invitationResponseFromJson(json.encode(resp.data));
      return responseMap;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Representative>> getAllRepresentants() async {
    try {
      final response = await _dio.get('/getAllRepresentants');
      final List<dynamic> data = response.data;
      return data.map((json) => Representative.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching representatives: $e');
      return Future.error(e);
    }
  }
}
