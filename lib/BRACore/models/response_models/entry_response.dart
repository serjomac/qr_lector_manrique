// To parse this JSON data, do
//
//     final entryResponse = entryResponseFromJson(jsonString);

import 'dart:convert';

import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

List<EntryResponse> entryResponseFromJson(String str) =>
    List<EntryResponse>.from(
        json.decode(str).map((x) => EntryResponse.fromJson(x)));

String entryResponseToJson(List<EntryResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EntryResponse {
  int? idIngreso;
  int? idResidenteLugar;
  int? idInvitacion;
  EntryTypeCode? tipoCodigo;
  String? nombresResidente;
  String? apellidosResidente;
  String? celularResidente;
  String? primarioResidente;
  String? secundarioResidente;
  String? nombrePrimario;
  String? nombreSecundario;
  String? nombrePuerta;
  String? nombreVisitante;
  String? cedulaVisitante;
  String? nacionalidadVisitante;
  GeenderGuest? sexoVisitante;
  String? placaVisitante;
  List<String>? imagenes;
  String? actividad;
  String? observacion;
  GuestType? tipoVisitante;
  EntryAccessType? tipoAcceso;
  Estado? estado;
  DateTime? fechaCreacion;
  DateTime? fechaInicio;
  DateTime? fechaTermino;

  EntryResponse({
    this.idIngreso,
    this.idResidenteLugar,
    this.idInvitacion,
    this.tipoCodigo,
    this.nombresResidente,
    this.apellidosResidente,
    this.celularResidente,
    this.primarioResidente,
    this.secundarioResidente,
    this.nombrePrimario,
    this.nombreSecundario,
    this.nombrePuerta,
    this.nombreVisitante,
    this.cedulaVisitante,
    this.nacionalidadVisitante,
    this.sexoVisitante,
    this.placaVisitante,
    this.imagenes,
    this.actividad,
    this.observacion,
    this.tipoVisitante,
    this.tipoAcceso,
    this.estado,
    this.fechaCreacion,
    this.fechaInicio,
    this.fechaTermino,
  });

  factory EntryResponse.fromJson(Map<String, dynamic> json) => EntryResponse(
        idIngreso: json["id_ingreso"],
        idResidenteLugar: json["id_residente_lugar"],
        idInvitacion: json["id_invitacion"],
        tipoCodigo: entryTypeCodeValues.map[json["tipo_codigo"]],
        nombresResidente: json["nombres_residente"],
        apellidosResidente: json["apellidos_residente"],
        celularResidente: json["celular_residente"],
        primarioResidente: json["primario_residente"],
        secundarioResidente: json["secundario_residente"],
        nombrePrimario: json["nombre_primario"],
        nombreSecundario: json["nombre_secundario"],
        nombrePuerta: json["nombre_puerta"],
        nombreVisitante: json["nombre_visitante"],
        cedulaVisitante: json["cedula_visitante"],
        nacionalidadVisitante: json["nacionalidad_visitante"],
        sexoVisitante: genderGuestValues.map[json["sexo_visitante"]],
        placaVisitante: json["placa_visitante"],
        imagenes: json["imagenes"] == null
            ? []
            : List<String>.from(json["imagenes"]!.map((x) => x)),
        actividad: json["actividad"],
        observacion: json["observacion"],
        tipoVisitante: guestTypeValue.map[json["tipo_visitante"]],
        tipoAcceso: entryAccessTypeValues.map[json["tipo_acceso"]],
        estado: estadoValues.map[json["estado"]]!,
        fechaCreacion: json["fecha_creacion"] == null
            ? null
            : DateTime.parse(json["fecha_creacion"]),
        fechaInicio: json["fecha_inicio"] == null
            ? null
            : DateTime.parse(json["fecha_inicio"]),
        fechaTermino: json["fecha_termino"] == null
            ? null
            : DateTime.parse(json["fecha_termino"]),
      );

  Map<String, dynamic> toJson() => {
        "id_ingreso": idIngreso,
        "id_residente_lugar": idResidenteLugar,
        "id_invitacion": idInvitacion,
        "tipo_codigo": entryTypeCodeValues.reverse[tipoCodigo],
        "nombres_residente": nombresResidente,
        "apellidos_residente": apellidosResidente,
        "celular_residente": celularResidente,
        "primario_residente": primarioResidente,
        "secundario_residente": secundarioResidente,
        "nombre_primario": nombrePrimario,
        "nombre_secundario": nombreSecundario,
        "nombre_puerta": nombrePuerta,
        "nombre_visitante": nombreVisitante,
        "cedula_visitante": cedulaVisitante,
        "nacionalidad_visitante": nacionalidadVisitante,
        "sexo_visitante": genderGuestValues.reverse[sexoVisitante],
        "placa_visitante": placaVisitante,
        "imagenes":
            imagenes == null ? [] : List<dynamic>.from(imagenes!.map((x) => x)),
        "actividad": actividad,
        "observacion": observacion,
        "tipo_visitante": guestTypeValue.reverse[tipoVisitante],
        "tipo_acceso": entryAccessTypeValues.reverse[tipoAcceso],
        "estado": estadoValues.reverse[estado],
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "fecha_inicio": fechaInicio?.toIso8601String(),
        "fecha_termino": fechaTermino?.toIso8601String(),
      };
}

enum GeenderGuest { FEMENINO, MASCULINO }

final genderGuestValues = EnumValues(
    {"FEMENINO": GeenderGuest.FEMENINO, "MASCULINO": GeenderGuest.MASCULINO});

extension GeenderGuestExtension on GeenderGuest {
  String get value {
    switch (this) {
      case GeenderGuest.MASCULINO:
        return 'Masculino';
      case GeenderGuest.FEMENINO:
        return 'Femenino';
    }
  }
}

enum EntryAccessType { ingreso, salida }

final entryAccessTypeValues = EnumValues({
  "I": EntryAccessType.ingreso,
  "S": EntryAccessType.salida,
});

extension EntryAccessTypeExtension on EntryAccessType {

  bool get isEnglishLenguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }
  
  String get value {
    switch (this) {
      case EntryAccessType.ingreso:
        return isEnglishLenguage ? 'Entry' : 'Ingreso';
      case EntryAccessType.salida:
        return isEnglishLenguage ? 'Check out' : 'Salida';
      default:
        return "";
    }
  }
}
