import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/models/general/error_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/login/ui/login_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:qr_scaner_manrique/utils/constants/secrets.dart';
import 'package:qr_scaner_manrique/utils/ip_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInterceptors extends Interceptor {
  PackageInfo? packageInfo;
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, String> infoData = {};
    String ip = '';
    try {
      ip = await IPGenerator.getIpAddress();
    } catch (e) {}
    try {
      if (kIsWeb) {
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        infoData = {
          'branch': webBrowserInfo.browserName.name,
          'model': webBrowserInfo.browserName.name,
          'soVersion': '',
          'manufacturer': 'Apple',
          'serialNumber': '',
          'id': '',
          'so': webBrowserInfo.platform ?? '',
          'ip': ip
        };
      } else {
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          infoData = {
            'branch': androidInfo.brand,
            'model': androidInfo.model,
            'soVersion': androidInfo.version.release,
            'manufacturer': androidInfo.manufacturer,
            'serialNumber': androidInfo.serialNumber,
            'id': androidInfo.id,
            'so': Platform.operatingSystem,
            'ip': ip
          };
        } else if (Platform.isIOS) {
          IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
          infoData = {
            'deviceName': iosDeviceInfo.name,
            'branch': iosDeviceInfo.model,
            'model': iosDeviceInfo.model,
            'soVersion': iosDeviceInfo.systemVersion,
            'manufacturer': 'Apple',
            'serialNumber': '',
            'id': iosDeviceInfo.identifierForVendor ?? '',
            'so': Platform.operatingSystem,
            'ip': ip
          };
        }
      }
    } catch (e) {
      log('ERRORRR DE INFO DEVICE');
      log(e.toString());
    }
    log('URL INFO DEVICE: ' + json.encode(infoData));
    log('URL REQUEST: ' + options.baseUrl + options.path);
    if (options.contentType != 'multipart/form-data') {
      log('BODY: ' + json.encode(options.data));
    } else {
      if (options.data is FormData) {
        FormData formData = options.data;
        formData.fields.forEach((element) {
          log('FIELD: ${element.key}: ${element.value}');
        });
        formData.files.forEach((element) {
          log(
              'FILE: ${element.key}: Filename: ${element.value.filename}, Content-Type: ${element.value.contentType}');
        });
      }
    }
    if (UserData.sharedInstance.userLogin != null) {
      final token = UserData.sharedInstance.userLogin!.tokenG!;
      log('TOKEN GENERAL: ' + token);
      options.headers['Authorization'] = 'Bearer ' + token;
    } else {
      options.headers['Authorization'] = 'Bearer ' + Secrets.accessToken;
    }
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String infoDataEncode = stringToBase64.encode(json.encode(infoData));
    options.headers['dispositivo'] = infoDataEncode;
    options.headers['Canal'] = 'App-Bitacora';
    options.headers['languageCode'] = AppLocalizationsGenerator.languageCode;
    options.headers['version'] = packageInfo?.version ?? '';
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    if (err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.connectTimeout) {
      return;
    }
    if (err.type == DioErrorType.other &&
        !UserData.sharedInstance.isNonConnectionDialogPresented) {
      ErrorModel errorModel = ErrorModel(
          httpCode: 500,
          codigoError: '500',
          mensaje:
              'Parece que no estás conectado a internet, vuelve a intentar más tarde.',
          causa: 'Error el solicitud');
      UserData.sharedInstance.isNonConnectionDialogPresented = true;
      _showDialog(errorModel);
    } else {
      if (err.response!.data != null && err.response!.data != '') {
        ErrorModel errorModel = ErrorModel(
            httpCode: err.response!.statusCode!,
            codigoError: err.response!.data['codigo'],
            mensaje: err.response!.data['mensaje'],
            causa: err.response!.data['causa']);
        if (verifyShowDialog(errorModel.codigoError)) {
          _showDialog(errorModel);
        }
      }
    }
  }

  _showDialog(ErrorModel error) {
    showDialog(
        context: getx.Get.overlayContext!,
        builder: (c) {
          return SuccessDialog(
              title: error.causa,
              height: error.codigoError == '101' ? 350 : null,
              iconSvg: ConstantsIcons.alertIcon,
              subtitle: error.mensaje,
              onTapAcept: () async {
                if (error.codigoError == '101') {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('userLogin');
                  UserData.sharedInstance.userLogin = null;
                  UserData.sharedInstance.placeSelected = null;
                  getx.Get.offAll(LoginPage());
                } else {
                  if (error.codigoError == '500') {
                    UserData.sharedInstance.isNonConnectionDialogPresented =
                        false;
                  }
                  getx.Get.back();
                }
              });
        });
  }

  bool verifyShowDialog(String code) {
    switch (code) {
      case '106':
        return false;
      default:
        return true;
    }
  }
}
