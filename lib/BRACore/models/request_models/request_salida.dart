// To parse this JSON data, do
//
//     final salidaRequest = salidaRequestFromJson(jsonString);

import 'dart:convert';

SalidaRequest salidaRequestFromJson(String str) => SalidaRequest.fromJson(json.decode(str));

String salidaRequestToJson(SalidaRequest data) => json.encode(data.toJson());

class SalidaRequest {
    SalidaRequest({
        this.idArea,
        this.tipo,
    });

    String? idArea;
    String? tipo;

    factory SalidaRequest.fromJson(Map<String, dynamic> json) => SalidaRequest(
        idArea: json["id_area"],
        tipo: json["tipo"],
    );

    Map<String, dynamic> toJson() => {
        "id_area": idArea,
        "tipo": tipo,
    };
}
