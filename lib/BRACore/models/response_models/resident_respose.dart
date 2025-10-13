// To parse this JSON data, do
//
//     final residentResponse = residentResponseFromJson(jsonString);

import 'dart:convert';

import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';

List<ResidentResponse> residentResponseFromJson(String str) => List<ResidentResponse>.from(json.decode(str).map((x) => ResidentResponse.fromJson(x)));

String residentResponseToJson(List<ResidentResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResidentResponse {
    int? idResidenteLugar;
    int? idResidente;
    int? idSecundario;
    int? idPrimario;
    int? idLugar;
    String? nombres;
    String? apellidos;
    String? cedula;
    String? celular;
    String? correo;
    String? foto;
    String? fotoCredencial;
    String? nombrePrimario;
    String? nombreSecundario;
    String? descripcion;
    EstadoResident? estado;
    EstadoActualizarResidnet? estadoLogin;
    EstadoResident? estadoEditar;
    EstadoActualizarResidnet? estadoActualizar;
    EstadoResident? estadoCorreo;

    ResidentResponse({
        this.idResidenteLugar,
        this.idResidente,
        this.idSecundario,
        this.idPrimario,
        this.idLugar,
        this.nombres,
        this.apellidos,
        this.cedula,
        this.celular,
        this.correo,
        this.foto,
        this.fotoCredencial,
        this.nombrePrimario,
        this.nombreSecundario,
        this.descripcion,
        this.estado,
        this.estadoLogin,
        this.estadoEditar,
        this.estadoActualizar,
        this.estadoCorreo,
    });

    factory ResidentResponse.fromJson(Map<String, dynamic> json) => ResidentResponse(
        idResidenteLugar: json["id_residente_lugar"],
        idResidente: json["id_residente"],
        idSecundario: json["id_secundario"],
        idPrimario: json["id_primario"],
        idLugar: json["id_lugar"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        cedula: json["cedula"],
        celular: json["celular"],
        correo: json["correo"],
        foto: json["foto"],
        fotoCredencial: json["foto_credencial"],
        nombrePrimario: json["nombre_primario"],
        nombreSecundario: json["nombre_secundario"],
        descripcion: json["descripcion"],
        estado: estadoValues.map[json["estado"]],
        estadoLogin: estadoActualizarEnumValues.map[json["estado_login"]],
        estadoEditar: estadoValues.map[json["estado_editar"]],
        estadoActualizar: estadoActualizarEnumValues.map[json["estado_actualizar"]],
        estadoCorreo: estadoValues.map[json["estado_correo"]],
    );

    Map<String, dynamic> toJson() => {
        "id_residente_lugar": idResidenteLugar,
        "id_residente": idResidente,
        "id_secundario": idSecundario,
        "id_primario": idPrimario,
        "id_lugar": idLugar,
        "nombres": nombres,
        "apellidos": apellidos,
        "cedula": cedula,
        "celular": celular,
        "correo": correo,
        "foto": foto,
        "foto_credencial": fotoCredencial,
        "nombre_primario": nombrePrimario,
        "nombre_secundario": nombreSecundario,
        "descripcion": descripcion,
        "estado": estadoValues.reverse[estado],
        "estado_login": estadoActualizarEnumValues.reverse[estadoLogin],
        "estado_editar": estadoValues.reverse[estadoEditar],
        "estado_actualizar": estadoActualizarEnumValues.reverse[estadoActualizar],
        "estado_correo": estadoValues.reverse[estadoCorreo],
    };

  String get firstLastName {
    return apellidos?.split(' ').first ?? '';
  }
  
  String get firstName {
    return nombres?.split(' ').first ?? '';
  }

}

enum EstadoResident {
    A,
    P
}

final estadoValues = EnumValues({
    "A": EstadoResident.A,
    "P": EstadoResident.P
});

enum EstadoActualizarResidnet {
    N,
    S
}

final estadoActualizarEnumValues = EnumValues({
    "N": EstadoActualizarResidnet.N,
    "S": EstadoActualizarResidnet.S
});
