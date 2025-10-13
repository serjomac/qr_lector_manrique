// To parse this JSON data, do
//
//     final requestLogin = requestLoginFromJson(jsonString);

import 'dart:convert';

RequestLogin requestLoginFromJson(String str) => RequestLogin.fromJson(json.decode(str));

String requestLoginToJson(RequestLogin data) => json.encode(data.toJson());

class RequestLogin {
    RequestLogin({
        this.usuario,
        this.contrasena,
    });

    String? usuario;
    String? contrasena;

    factory RequestLogin.fromJson(Map<String, dynamic> json) => RequestLogin(
        usuario: json["usuario"],
        contrasena: json["contrasena"],
    );

    Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "contrasena": contrasena,
    };
}
