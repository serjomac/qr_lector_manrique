// To parse this JSON data, do
//
//     final marcarSalidaRequest = marcarSalidaRequestFromJson(jsonString);

import 'dart:convert';

MarcarSalidaRequest marcarSalidaRequestFromJson(String str) => MarcarSalidaRequest.fromJson(json.decode(str));

String marcarSalidaRequestToJson(MarcarSalidaRequest data) => json.encode(data.toJson());

class MarcarSalidaRequest {
    MarcarSalidaRequest({
        this.nombre,
        this.celular,
        this.tipo,
        this.idRetiro,
        this.observacion,
    });

    String? nombre;
    String? celular;
    String? tipo;
    String? idRetiro;
    String? observacion;

    factory MarcarSalidaRequest.fromJson(Map<String, dynamic> json) => MarcarSalidaRequest(
        nombre: json["nombre"],
        celular: json["celular"],
        tipo: json["tipo"],
        idRetiro: json["id_retiro"],
        observacion: json["observacion"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "celular": celular,
        "tipo": tipo,
        "id_retiro": idRetiro,
        "observacion": observacion ?? '',
    };
}
