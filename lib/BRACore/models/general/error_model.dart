import 'dart:convert';

import 'package:qr_scaner_manrique/utils/constants/http_status_code.dart';

ErrorModel errorModelFromJson(String str) =>
    ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  ErrorModel({
    required this.httpCode,
    required this.codigoError,
    required this.mensaje,
    required this.causa,
  });

  int httpCode;
  String codigoError;
  String mensaje;
  String causa;

  ErrorModel copyWith({
    required int httpCode,
    required String codigoError,
    required String mensaje,
    required String causa,
  }) =>
      ErrorModel(
        httpCode: httpCode,
        codigoError: codigoError,
        mensaje: mensaje,
        causa: causa,
      );

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        httpCode: json["httpCode"],
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
    switch (httpCode) {
      case HttpStatusCode.unauthorized:
        mensaje = 'No tiene permiso para realizar esta acción';
        break;
      case HttpStatusCode.internalServerError:
        mensaje = 'Problemas con el servidor, intente nuevamente.';
        break;
      case HttpStatusCode.notFound:
        mensaje = 'Ruta no encontrada';
        break;
      default:
        mensaje = 'Error no controlado';
        break;
    }
  }
}
