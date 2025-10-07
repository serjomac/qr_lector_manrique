import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:qr_scaner_manrique/BRACore/api/dio_client.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/access_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/entrances_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entry_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_respose.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';

class ApiBinnacle {
  final Dio _dio = DioClient().dio;

  Future<void> addNormalEntrances({
    EntryTypeCode? entryTypeCode,
    String? normalInvitationId,
    String? recurrentInvitationId,
    String? entryId,
    String? residentePlaceId,
    required MainActionType mainActionType,
    required String entranceId,
    required String name,
    required String dni,
    required String nationality,
    File? carIdImageFrontI,
    File? carIdImageBackI,
    File? dniImageI,
    File? imageSelphiI,
    required String gender,
    required String carId,
    required AccessType accessType,
    required String activity,
    required String observation,
    required RegisterEntryType entranceType,
    required String placeId,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {
        'id_puerta': entranceId,
        'nombre': name,
        'cedula': dni,
        'placa': carId,
        'tipo_acceso': accessType.value,
        'observacion': observation,
        'usuario_creacion': UserData.sharedInstance.userLogin!.usuario,
        'tipo': entranceType.value,
        'id_lugar': placeId,
      };
      String endpoint = '';
      if (mainActionType == MainActionType.gateEntryResident) {
        endpoint = entryTypeCode?.addEntryEndpoint ?? '';
        formDataMap['id_residente_lugar'] = residentePlaceId;
        formDataMap['nacionalidad'] = nationality;
        formDataMap['sexo'] = gender;
        formDataMap['actividad'] = activity;
        formDataMap['estado'] = 'I';
      } else if (mainActionType == MainActionType.gateLeave) {
        if (entryTypeCode == EntryTypeCode.RE) {
          endpoint = '/insertIngresoResidente_bitacora';
          formDataMap['id_residente_lugar'] = residentePlaceId;
        } else {
          endpoint = '/insertSalida';
          formDataMap['tipo'] = entryTypeCode?.description;
          formDataMap['id_ingreso'] = entryId;
          formDataMap['id_puerta_salida'] = entranceId;
        }
      } else {
        endpoint = entryTypeCode!.addEntryEndpoint;
        switch (entryTypeCode) {
          case EntryTypeCode.RE:
            formDataMap['id_residente_lugar'] = residentePlaceId;
            break;
          case EntryTypeCode.IR:
            formDataMap['id_invitacion_recurrente'] = recurrentInvitationId;
            formDataMap['actividad'] = activity;
            break;
          case EntryTypeCode.IO:
            formDataMap['id_invitacion_normal'] = normalInvitationId;
            formDataMap['nacionalidad'] = nationality;
            formDataMap['sexo'] = gender;
            formDataMap['actividad'] = activity;
            break;
          default:
        }
      }
      formDataMap['imagen_placa_delantera'] = 'none';
      formDataMap['imagen_placa_trasera'] = 'none';
      formDataMap['imagen_cedula'] = 'none';
      formDataMap['imagen_rostro'] = 'none';
      formDataMap['estado'] = 'I';
      if (carIdImageFrontI != null) {
        String carIdImageFrontIFileName = carIdImageFrontI.path.split('/').last;
        formDataMap['imagen_placa_delanteraI'] = await MultipartFile.fromFile(
          carIdImageFrontI.path,
          filename: carIdImageFrontIFileName,
        );
        formDataMap['imagen_placa_delantera'] = 'SI';
      }
      if (carIdImageBackI != null) {
        String carIdImageBackIFileName = carIdImageBackI.path.split('/').last;
        formDataMap['imagen_placa_traseraI'] = await MultipartFile.fromFile(
          carIdImageBackI.path,
          filename: carIdImageBackIFileName,
        );
        formDataMap['imagen_placa_trasera'] = 'SI';
      }
      if (dniImageI != null) {
        String dniImageIFileName = dniImageI.path.split('/').last;
        formDataMap['imagen_cedulaI'] = await MultipartFile.fromFile(
          dniImageI.path,
          filename: dniImageIFileName,
        );
        formDataMap['imagen_cedula'] = 'SI';
      }
      if (imageSelphiI != null) {
        String imageSelphiIFileName = imageSelphiI.path.split('/').last;
        formDataMap['imagen_rostroI'] = await MultipartFile.fromFile(
          imageSelphiI.path,
          filename: imageSelphiIFileName,
        );
        formDataMap['imagen_rostro'] = 'SI';
      }
      FormData formData = FormData.fromMap(formDataMap);
      Response response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      print(response.data);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future<List<ResidentResponse>> getAllResidentsByPlace(String placeId) async {
    try {
      Response resp = await _dio.post(
        '/getAllResidenteLugar_lugarA',
        data: {'id_lugar': placeId, 'estado': 'A'},
      );
      log(json.encode(resp.data));
      final responseMap = residentResponseFromJson(json.encode(resp.data));
      return responseMap;
    } on DioError catch (e) {
      print(e.response.toString());
      return Future.error(e);
    }
  }

  Future<List<EntryResponse>> fetchAllEntries({
    required MainActionType mainActionType,
    required DateTime startDate,
    required DateTime endDate,
    required String placeId,
    required EntryTypeCode entryTypeCode,
  }) async {
    try {
      Response resp = await _dio.post(
        mainActionType == MainActionType.hisotric
            ? '/getAllIngreso'
            : '/getAllSalidas',
        data: {
          'id_lugar': placeId,
          'fecha_inicio': startDate.toString(),
          'fecha_termino': endDate.toString(),
          'tipo_codigo': entryTypeCode.description
        },
        // data: {
        //   'id_lugar': '94',
        //   'fecha_inicio': '2024-01-17 22:05:29',
        //   'fecha_termino': '2024-04-17 22:05:29',
        //   'tipo_codigo': 'IR'
        // },
      );
      log(json.encode(resp.data));
      final responseMap = entryResponseFromJson(json.encode(resp.data));
      return responseMap;
    } on DioError catch (e) {
      print(e.response.toString());
      return Future.error(e);
    }
  }
}
