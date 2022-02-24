import 'dart:convert';
import 'package:qr_scaner_manrique/utils/constants/http_status_code.dart';

ResponseErrorModel errorModelFromJson(String str) => ResponseErrorModel.fromJson(json.decode(str));

String errorModelToJson(ResponseErrorModel data) => json.encode(data.toJson());

class ResponseErrorModel {
  ResponseErrorModel({
    required this.codigoError,
  });

  int codigoError;
  String? _mensaje;

  set mensaje(String mensaje) {
    _mensaje = mensaje;
  }

  String get mensaje {
    if (_mensaje != null) {
      return _mensaje!;
    } else {
      switch (codigoError) {
      case HttpStatusCode.unauthorized:
        _mensaje = 'No tiene permiso para realizar esta acción';
        return _mensaje!;
      case HttpStatusCode.internalServerError:
        _mensaje = 'Problemas con el servidor, intente nuevamente.';
        return _mensaje!;
      case HttpStatusCode.notFound:
        _mensaje = 'Ruta no encontrada';
        return _mensaje!;
      default:
        _mensaje = 'Error no controlado';
        return _mensaje!;
    }
    }
  }

  ResponseErrorModel copyWith({
    required int codigoError
  }) =>
      ResponseErrorModel(
        codigoError: codigoError
      );

  factory ResponseErrorModel.fromJson(Map<String, dynamic> json) => ResponseErrorModel(
        codigoError: json["codigoError"]
      );

  Map<String, dynamic> toJson() => {
        "codigoError": codigoError,
        "mensaje": mensaje,
      };
}
