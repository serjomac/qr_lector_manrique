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
  
  // Cache configuration - configurable values
  static const int _defaultCacheMinutes = 30; // Default: 30 minutes
  static const bool _defaultEnableCache = true; // Default: cache enabled
  
  // Cache variables - stores residents data and timestamps per place
  static final Map<String, List<ResidentResponse>> _residentsCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  
  // Configuration getters with defaults
  /// Get cache duration in minutes (default: 30 minutes)
  static int get cacheMinutes => _defaultCacheMinutes;
  /// Get whether cache is enabled by default (default: true)
  static bool get enableCache => _defaultEnableCache;

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
    required String registerType,
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
      formDataMap['tipo?ingreso'] = registerType;
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

  /// Get all residents by place with intelligent caching
  /// 
  /// [placeId] - The place ID to fetch residents for
  /// [forceRefresh] - If true, ignores cache and fetches fresh data
  /// [customCacheMinutes] - Override default cache time (default: 30 minutes)
  /// [enableCacheControl] - Override cache enable/disable (default: true)
  /// 
  /// Examples:
  /// ```dart
  /// // Use default caching (30 minutes)
  /// final residents = await apiBinnacle.getAllResidentsByPlace('123');
  /// 
  /// // Force refresh ignoring cache
  /// final residents = await apiBinnacle.getAllResidentsByPlace('123', forceRefresh: true);
  /// 
  /// // Use custom cache time (60 minutes)
  /// final residents = await apiBinnacle.getAllResidentsByPlace('123', customCacheMinutes: 60);
  /// 
  /// // Disable cache for this call
  /// final residents = await apiBinnacle.getAllResidentsByPlace('123', enableCacheControl: false);
  /// ```
  Future<List<ResidentResponse>> getAllResidentsByPlace(
    String placeId, {
    bool forceRefresh = false,
    int? customCacheMinutes,
    bool? enableCacheControl,
  }) async {
    final bool shouldUseCache = enableCacheControl ?? enableCache;
    final int cacheTime = customCacheMinutes ?? cacheMinutes;
    
    // Check if cache is enabled and if we should use cached data
    if (shouldUseCache && !forceRefresh) {
      final DateTime? lastFetch = _cacheTimestamps[placeId];
      final List<ResidentResponse>? cachedData = _residentsCache[placeId];
      
      if (lastFetch != null && cachedData != null) {
        final Duration timeDifference = DateTime.now().difference(lastFetch);
        
        // If less than configured minutes have passed, return cached data
        if (timeDifference.inMinutes < cacheTime) {
          log('Returning cached residents data for placeId: $placeId (cached ${timeDifference.inMinutes} minutes ago)');
          return cachedData;
        }
      }
    }
    
    try {
      log('Fetching fresh residents data from API for placeId: $placeId');
      Response resp = await _dio.post(
        '/getAllResidenteLugar_lugarA',
        data: {'id_lugar': placeId, 'estado': 'A'},
      );
      log(json.encode(resp.data));
      final responseMap = residentResponseFromJson(json.encode(resp.data));
      
      // Cache the response if cache is enabled
      if (shouldUseCache) {
        _residentsCache[placeId] = responseMap;
        _cacheTimestamps[placeId] = DateTime.now();
      }
      
      return responseMap;
    } on DioError catch (e) {
      print(e.response.toString());
      return Future.error(e);
    }
  }
  
  /// Clear cache for a specific place or all cached data
  static void clearResidentsCache({String? placeId}) {
    if (placeId != null) {
      _residentsCache.remove(placeId);
      _cacheTimestamps.remove(placeId);
      log('Cleared residents cache for placeId: $placeId');
    } else {
      _residentsCache.clear();
      _cacheTimestamps.clear();
      log('Cleared all residents cache');
    }
  }
  
  /// Get cache status for a specific place
  static Map<String, dynamic> getCacheStatus(String placeId) {
    final DateTime? lastFetch = _cacheTimestamps[placeId];
    final bool hasCache = _residentsCache.containsKey(placeId);
    
    return {
      'hasCache': hasCache,
      'lastFetch': lastFetch,
      'minutesAgo': lastFetch != null ? DateTime.now().difference(lastFetch).inMinutes : null,
      'isExpired': lastFetch != null ? DateTime.now().difference(lastFetch).inMinutes >= cacheMinutes : true,
    };
  }

  Future<List<EntryResponse>> fetchAllEntries({
    required MainActionType mainActionType,
    required DateTime startDate,
    required DateTime endDate,
    required String placeId,
    required EntryTypeCode entryTypeCode,
    String? idPuerta,
  }) async {
    try {
      Map<String, dynamic> requestData = {
        'id_lugar': placeId,
        'fecha_inicio': startDate.toString(),
        'fecha_termino': endDate.toString(),
        'tipo_codigo': entryTypeCode.description
      };
      
      // Add id_puerta if provided
      if (idPuerta != null && idPuerta.isNotEmpty) {
        requestData['id_puerta'] = idPuerta;
      }
      
      Response resp = await _dio.post(
        mainActionType == MainActionType.hisotric
            ? '/getAllIngreso'
            : '/getAllSalidas',
        data: requestData,
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
