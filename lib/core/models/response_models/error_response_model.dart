import 'dart:convert';

import 'package:qr_scaner_manrique/utils/constants/http_status_code.dart';

ResponseErrorModel errorModelFromJson(String str) =>
    ResponseErrorModel.fromJson(json.decode(str));

String errorModelToJson(ResponseErrorModel data) => json.encode(data.toJson());

class ResponseErrorModel {
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
