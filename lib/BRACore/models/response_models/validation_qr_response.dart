// To parse this JSON data, do
//
//     final validationQrResponse = validationQrResponseFromJson(jsonString);

import 'dart:convert';

ValidationQrResponse validationQrResponseFromJson(String str) => ValidationQrResponse.fromJson(json.decode(str));

String validationQrResponseToJson(ValidationQrResponse data) => json.encode(data.toJson());

class ValidationQrResponse {
    ValidationQrResponse({
        this.mensaje,
    });

    Mensaje? mensaje;

    factory ValidationQrResponse.fromJson(Map<String, dynamic> json) => ValidationQrResponse(
        mensaje: Mensaje.fromJson(json["mensaje"]),
    );

    Map<String, dynamic> toJson() => {
        "mensaje": mensaje?.toJson(),
    };
}

class Mensaje {
    Mensaje({
        this.mensaje,
        this.status,
        this.tipo,
        this.celular,
        this.residente,
        this.estudiante,
    });

    String? mensaje;
    String? status;
    String? tipo;
    String? celular;
    String? residente;
    List<Estudiante>? estudiante;

    factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        mensaje: json["mensaje"],
        status: json["status"],
        tipo: json["tipo"],
        celular: json["celular"],
        residente: json["Residente"],
        estudiante: List<Estudiante>.from(json["Estudiante"].map((x) => Estudiante.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "mensaje": mensaje,
        "status": status,
        "tipo": tipo,
        "celular": celular,
        "Residente": residente,
        "Estudiante": estudiante != null ? List<dynamic>.from(estudiante!.map((x) => x.toJson())) : null,
    };
}

class Estudiante {
    Estudiante({
        this.idHijo,
        this.nombre,
        this.area,
        this.isSelected,
    });

    String? idHijo;
    String? nombre;
    String? area;
    bool? isSelected;

    factory Estudiante.fromJson(Map<String, dynamic> json) => Estudiante(
        idHijo: json["id_hijo"],
        nombre: json["nombre"],
        area: json["area"],
        isSelected: false,
    );

    Map<String, dynamic> toJson() => {
        "id_hijo": idHijo,
        "nombre": nombre,
        "area": area,
    };
}
