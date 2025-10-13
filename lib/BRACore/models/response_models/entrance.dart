// To parse this JSON data, do
//
//     final entrance = entranceFromJson(jsonString);

import 'dart:convert';

import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';

List<GateDoor> entranceFromJson(String str) =>
    List<GateDoor>.from(json.decode(str).map((x) => GateDoor.fromJson(x)));

String entranceToJson(List<GateDoor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GateDoor {
  int? idPuerta;
  int? idLugar;
  String? nombre;
  TypeDoor? tipoIngreso;
  String? estado;
  DateTime? fechaCreacion;
  String? usuarioCreacion;
  dynamic fechaModificacion;
  dynamic usuarioModificacion;

  GateDoor({
    this.idPuerta,
    this.idLugar,
    this.nombre,
    this.tipoIngreso,
    this.estado,
    this.fechaCreacion,
    this.usuarioCreacion,
    this.fechaModificacion,
    this.usuarioModificacion,
  });

  factory GateDoor.fromJson(Map<String, dynamic> json) => GateDoor(
        idPuerta: json["id_puerta"],
        idLugar: json["id_lugar"],
        nombre: json["nombre"],
        tipoIngreso: typeDoorValues.map[json["tipo_ingreso"]],
        estado: json["estado"],
        fechaCreacion: json["fecha_creacion"] == null
            ? null
            : DateTime.parse(json["fecha_creacion"]),
        usuarioCreacion: json["usuario_creacion"],
        fechaModificacion: json["fecha_modificacion"],
        usuarioModificacion: json["usuario_modificacion"],
      );

  Map<String, dynamic> toJson() => {
        "id_puerta": idPuerta,
        "id_lugar": idLugar,
        "nombre": nombre,
        "tipo_ingreso": tipoIngreso,
        "estado": estado,
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "usuario_creacion": usuarioCreacion,
        "fecha_modificacion": fechaModificacion,
        "usuario_modificacion": usuarioModificacion,
      };
}

enum TypeDoor {
  entrance,
  exit,
}

final typeDoorValues = EnumValues({
  "I": TypeDoor.entrance,
  "A": TypeDoor.exit,
});

extension OcrTypeExtension on TypeDoor {
  // String get value {
  //   switch (this) {
  //     case AccessType.entrance:
  //       return 'I';
  //     case AccessType.exit:
  //       return 'S';
  //     default:
  //       return '';
  //   }
  // }
}
