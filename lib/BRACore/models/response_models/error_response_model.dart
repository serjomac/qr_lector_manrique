import 'dart:convert';

import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:qr_scaner_manrique/utils/constants/http_status_code.dart';

ResponseErrorModel errorModelFromJson(String str) =>
    ResponseErrorModel.fromJson(json.decode(str));

String errorModelToJson(ResponseErrorModel data) => json.encode(data.toJson());

class ResponseErrorModel {
  bool get isEnglishLenguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }

  ResponseErrorModel({
    required this.codigoError,
    required this.mensaje,
    required this.causa,
  });

  int codigoError;
  String mensaje;
  String causa;

  ResponseErrorModel copyWith({
    required int codigoError,
    required String mensaje,
    required String causa,
  }) =>
      ResponseErrorModel(
        codigoError: codigoError,
        mensaje: mensaje,
        causa: causa,
      );

  factory ResponseErrorModel.fromJson(Map<String, dynamic> json) =>
      ResponseErrorModel(
        codigoError: json["codigoError"],
        mensaje: json["mensaje"],
        causa: json["causa"],
      );

  Map<String, dynamic> toJson() => {
        "codigoError": codigoError,
        "mensaje": mensaje,
        "causa": causa,
      };

  httpError() {
    switch (codigoError) {
      case HttpStatusCode.unauthorized:
        mensaje = isEnglishLenguage
            ? 'You do not have permission to perform this action'
            : 'No tiene permiso para realizar esta acción';
        break;
      case HttpStatusCode.internalServerError:
        mensaje = isEnglishLenguage
            ? 'Server problems, try again.'
            : 'Problemas con el servidor, intente nuevamente.';
        break;
      case HttpStatusCode.notFound:
        mensaje = isEnglishLenguage ? 'Route not found' : 'Ruta no encontrada';
        break;
      default:
        mensaje = isEnglishLenguage ? 'Unhandled error' : 'Error no controlado';
        break;
    }
  }
}
