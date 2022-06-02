// To parse this JSON data, do
//
//     final areaRequest = areaRequestFromJson(jsonString);

import 'dart:convert';

AreaRequest areaRequestFromJson(String str) => AreaRequest.fromJson(json.decode(str));

String areaRequestToJson(AreaRequest data) => json.encode(data.toJson());

class AreaRequest {
    AreaRequest({
        this.idUsuario,
    });

    String? idUsuario;

    factory AreaRequest.fromJson(Map<String, dynamic> json) => AreaRequest(
        idUsuario: json["id_usuario"],
    );

    Map<String, dynamic> toJson() => {
        "id_usuario": idUsuario,
    };
}
