// To parse this JSON data, do
//
//     final authLoginModel = authLoginModelFromJson(jsonString);

import 'dart:convert';

AuthLoginModel authLoginModelFromJson(String str) => AuthLoginModel.fromJson(json.decode(str));

String authLoginModelToJson(AuthLoginModel data) => json.encode(data.toJson());

class AuthLoginModel {
    int? idUsuarioAdmin;
    String? nombres;
    String? apellidos;
    String? celular;
    String? correo;
    String? usuario;
    String? tipo;
    String? tokenFcm;
    String? estado;
    String? tokenG;

    AuthLoginModel({
        this.idUsuarioAdmin,
        this.nombres,
        this.apellidos,
        this.celular,
        this.correo,
        this.usuario,
        this.tipo,
        this.tokenFcm,
        this.estado,
        this.tokenG,
    });

    factory AuthLoginModel.fromJson(Map<String, dynamic> json) => AuthLoginModel(
        idUsuarioAdmin: json["id_usuario_admin"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        celular: json["celular"],
        correo: json["correo"],
        usuario: json["usuario"],
        tipo: json["tipo"],
        tokenFcm: json["tokenFCM"],
        estado: json["estado"],
        tokenG: json["tokenG"],
    );

    Map<String, dynamic> toJson() => {
        "id_usuario_admin": idUsuarioAdmin,
        "nombres": nombres,
        "apellidos": apellidos,
        "celular": celular,
        "correo": correo,
        "usuario": usuario,
        "tipo": tipo,
        "tokenFCM": tokenFcm,
        "estado": estado,
        "tokenG": tokenG,
    };
}
