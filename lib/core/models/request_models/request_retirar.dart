// To parse this JSON data, do
//
//     final retirarRequest = retirarRequestFromJson(jsonString);

import 'dart:convert';

RetirarRequest retirarRequestFromJson(String str) => RetirarRequest.fromJson(json.decode(str));

String retirarRequestToJson(RetirarRequest data) => json.encode(data.toJson());

class RetirarRequest {
    RetirarRequest({
        this.nombre,
        this.celular,
        this.tipo,
        this.idHijos,
    });

    String? nombre;
    String? celular;
    String? tipo;
    String? idHijos;

    factory RetirarRequest.fromJson(Map<String, dynamic> json) => RetirarRequest(
        nombre: json["nombre"],
        celular: json["celular"],
        tipo: json["tipo"],
        idHijos: json["id_hijos"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "celular": celular,
        "tipo": tipo,
        "id_hijos": idHijos,
    };
}
