// To parse this JSON data, do
//
//     final salidaRequest = salidaRequestFromJson(jsonString);

import 'dart:convert';

List<ResponseSalida> salidaResponseFromJson(String str) => List<ResponseSalida>.from(json.decode(str).map((x) => ResponseSalida.fromJson(x)));

String salidaRequestToJson(List<ResponseSalida> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseSalida {
    ResponseSalida({
        this.padre,
        this.celular,
        this.idAula,
        this.hijos,
        this.observacion,
        this.fecha,
    });

    String? padre;
    String? celular;
    String? idAula;
    List<Hijo>? hijos;
    String? observacion;
    DateTime? fecha;

    factory ResponseSalida.fromJson(Map<String, dynamic> json) => ResponseSalida(
        padre: json["padre"],
        celular: json["celular"],
        idAula: json["id_aula"],
        hijos: List<Hijo>.from(json["hijos"].map((x) => Hijo.fromJson(x))),
        observacion: json["observacion"],
        fecha: DateTime.parse(json["fecha"]),
    );

    Map<String, dynamic> toJson() => {
        "padre": padre,
        "celular": celular,
        "id_aula": idAula,
        "hijos": hijos != null ? List<dynamic>.from(hijos!.map((x) => x.toJson())) : null,
        "observacion": observacion,
        "fecha": fecha != null ? fecha!.toIso8601String() : null,
    };
}

class Hijo {
    Hijo({
        this.idRetiro,
        this.hijo,
        this.idHijo,
        this.tipo,
    });

    String? idRetiro;
    String? hijo;
    String? idHijo;
    String? tipo;

    factory Hijo.fromJson(Map<String, dynamic> json) => Hijo(
        idRetiro: json["id_retiro"],
        hijo: json["hijo"],
        idHijo: json["id_hijo"],
        tipo: json["tipo"],
    );

    Map<String, dynamic> toJson() => {
        "id_retiro": idRetiro,
        "hijo": hijo,
        "id_hijo": idHijo,
        "tipo": tipo,
    };
}
