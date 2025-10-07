// To parse this JSON data, do
//
//     final lectorResponse = lectorResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

LectorResponse lectorResponseFromJson(String str) =>
    LectorResponse.fromJson(json.decode(str));

String lectorResponseToJson(LectorResponse data) => json.encode(data.toJson());

class LectorResponse {
  int? idResidente;
  int? idResidenteLugar;
  int? idLugar;
  int? idCodigo;
  int? idPrimario;
  int? idSecundario;
  int? idPuerta;
  String? codigo;
  EntryTypeCode? tipoCodigo;
  String? nombresResidente;
  String? apellidosResidente;
  String? cedulaResidente;
  String? celularResidente;
  String? correoResidente;
  String? primarioResidente;
  String? secundarioResidente;
  String? nombrePrimario;
  String? nombreSecundario;
  String? nombreLugar;
  String? nombreVisitante;
  String? cedulaVisitante;
  String? celularVisitante;
  String? placaVisitante;
  String? observacionVisitante;
  GuestType? tipoVisitante;
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  DateTime? fechaCreacion;
  InvitationStatus? estado;
  List<String>? imagenes;
  String? photo;
  String? credentialPhoto;

  LectorResponse({
    this.idResidente,
    this.idResidenteLugar,
    this.idLugar,
    this.idCodigo,
    this.idPrimario,
    this.idSecundario,
    this.idPuerta,
    this.codigo,
    this.tipoCodigo,
    this.nombresResidente,
    this.apellidosResidente,
    this.cedulaResidente,
    this.celularResidente,
    this.correoResidente,
    this.primarioResidente,
    this.secundarioResidente,
    this.nombrePrimario,
    this.nombreSecundario,
    this.nombreLugar,
    this.nombreVisitante,
    this.cedulaVisitante,
    this.celularVisitante,
    this.placaVisitante,
    this.observacionVisitante,
    this.tipoVisitante,
    this.fechaInicio,
    this.fechaTermino,
    this.fechaCreacion,
    this.estado,
    this.imagenes,
    this.photo,
    this.credentialPhoto,
  });

  factory LectorResponse.fromJson(Map<String, dynamic> json) => LectorResponse(
        idResidente: json["id_residente"],
        idResidenteLugar: json["id_residente_lugar"],
        idLugar: json["id_lugar"],
        idCodigo: json["id_codigo"],
        idPrimario: json["id_primario"],
        idSecundario: json["id_secundario"],
        idPuerta: json["id_puerta"],
        codigo: json["codigo"],
        tipoCodigo: entryTypeCodeValues.map[json["tipo_codigo"]],
        nombresResidente: json["nombres_residente"],
        apellidosResidente: json["apellidos_residente"],
        cedulaResidente: json["cedula_residente"],
        celularResidente: json["celular_residente"],
        correoResidente: json["correo_residente"],
        primarioResidente: json["primario_residente"],
        secundarioResidente: json["secundario_residente"],
        nombrePrimario: json["nombre_primario"],
        nombreSecundario: json["nombre_secundario"],
        nombreLugar: json["nombre_lugar"],
        nombreVisitante: json["nombre_visitante"],
        cedulaVisitante: json["cedula_visitante"],
        celularVisitante: json["celular_visitante"],
        placaVisitante: json["placa_visitante"],
        observacionVisitante: json["observacion_visitante"],
        photo: json["foto_perfil"],
        credentialPhoto: json["foto_credencial"],
        tipoVisitante: guestTypeValue.map[json["tipo_visitante"]],
        fechaInicio: json["fecha_inicio"] == null
            ? null
            : DateTime.parse(json["fecha_inicio"]),
        fechaTermino: json["fecha_termino"] == null
            ? null
            : DateTime.parse(json["fecha_termino"]),
        fechaCreacion: json["fecha_creacion"] == null
            ? null
            : DateTime.parse(json["fecha_creacion"]),
        estado: invitationStatusValue.map[json["estado"]],
      );

  Map<String, dynamic> toJson() => {
        "id_residente": idResidente,
        "id_residente_lugar": idResidenteLugar,
        "id_lugar": idLugar,
        "id_codigo": idCodigo,
        "id_primario": idPrimario,
        "id_secundario": idSecundario,
        "id_puerta": idPuerta,
        "codigo": codigo,
        "tipo_codigo": tipoCodigo,
        "nombres_residente": nombresResidente,
        "apellidos_residente": apellidosResidente,
        "cedula_residente": cedulaResidente,
        "celular_residente": celularResidente,
        "correo_residente": correoResidente,
        "primario_residente": primarioResidente,
        "secundario_residente": secundarioResidente,
        "nombre_primario": nombrePrimario,
        "nombre_secundario": nombreSecundario,
        "nombre_lugar": nombreLugar,
        "nombre_visitante": nombreVisitante,
        "cedula_visitante": cedulaVisitante,
        "celular_visitante": celularVisitante,
        "placa_visitante": placaVisitante,
        "observacion_visitante": observacionVisitante,
        "tipo_visitante": tipoVisitante,
        "fecha_inicio": fechaInicio?.toIso8601String(),
        "fecha_termino": fechaTermino?.toIso8601String(),
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "estado": estado,
        "foto_perfil": photo,
        "foto_credencial": credentialPhoto,
      };
}

enum EntryTypeCode { IO, IR, RE, GA, TD }

final entryTypeCodeValues = EnumValues({
  'IO': EntryTypeCode.IO,
  'IR': EntryTypeCode.IR,
  'RE': EntryTypeCode.RE,
  'GA': EntryTypeCode.GA,
});

extension EntryTypeCodeExtension on EntryTypeCode {
  bool get isEnglishLenguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }

  String get value {
    switch (this) {
      case EntryTypeCode.IO:
        return isEnglishLenguage ? 'Occasional income' : 'Ingreso ocasional';
      case EntryTypeCode.IR:
        return isEnglishLenguage ? 'Recurrent entry' : 'Ingreso recurrente';
      case EntryTypeCode.RE:
        return isEnglishLenguage ? 'Resident' : 'Residente';
      case EntryTypeCode.GA:
        return isEnglishLenguage ? 'Gate' : 'Garita';
      default:
        return '';
    }
  }

  String get addEntryEndpoint {
    switch (this) {
      case EntryTypeCode.RE:
        return '/insertIngresoResidente_bitacora';
      case EntryTypeCode.IR:
        return '/insertIngresoRecurrente_bitacora';
      case EntryTypeCode.IO:
        return '/insertIngresoNormal_bitacora';
      case EntryTypeCode.GA:
        return '/insertGarita_ingresoBitacora';
      default:
        return '';
    }
  }

  String get titlePage {
    switch (this) {
      case EntryTypeCode.RE:
        return isEnglishLenguage
            ? 'Resident entry form'
            : 'Formulario ingreso residente';
      case EntryTypeCode.IR:
        return isEnglishLenguage
            ? 'Recurring entry form'
            : 'Formulario ingreso recurrente';
      case EntryTypeCode.IO:
        return isEnglishLenguage
            ? 'Occasional entry form'
            : 'Formulario ingreso ocasional';
      default:
        return '';
    }
  }

  String get successEntryAddedTitle {
    switch (this) {
      case EntryTypeCode.RE:
        return isEnglishLenguage
            ? 'Registered resident'
            : 'Residente registrado';
      case EntryTypeCode.IR:
        return isEnglishLenguage
            ? 'Registered visitor'
            : 'Visitante registrado';
      case EntryTypeCode.IO:
        return isEnglishLenguage
            ? 'Registered visitor'
            : 'Visitante registrado';
      case EntryTypeCode.GA:
        return isEnglishLenguage
            ? 'Registered visitor'
            : 'Visitante registrado';
      default:
        return '';
    }
  }

  String get successEntryAddedMessage {
    switch (this) {
      case EntryTypeCode.RE:
        return isEnglishLenguage
            ? 'Resident entry was saved successfully'
            : 'El ingreso residente se guardó con éxito';
      case EntryTypeCode.IR:
        return isEnglishLenguage
            ? 'Guest entry was saved successfully'
            : 'El ingreso invitado se guardó con éxito';
      case EntryTypeCode.IO:
        return isEnglishLenguage
            ? 'Guest entry was saved successfully'
            : 'El ingreso invitado se guardó con éxito';
      case EntryTypeCode.GA:
        return isEnglishLenguage
            ? 'Guest entry was saved successfully'
            : 'El ingreso invitado se guardó con éxito';
      default:
        return '';
    }
  }

  String get description {
    switch (this) {
      case EntryTypeCode.RE:
        return 'RE';
      case EntryTypeCode.IR:
        return 'IR';
      case EntryTypeCode.IO:
        return 'IO';
      case EntryTypeCode.GA:
        return 'GA';
      case EntryTypeCode.TD:
        return 'T';
    }
  }

  Color get invitationCardLabelBackgroundColor {
    switch (this) {
      case EntryTypeCode.RE:
        return Color(0xFF016B8B);
      case EntryTypeCode.IR:
        return Color(0xFFBC7100);
      case EntryTypeCode.IO:
        return Color(0xFF695A92);
      case EntryTypeCode.GA:
        return Color(0xFF85736F);
      case EntryTypeCode.TD:
        return Color(0xFFB86E00);
    }
  }

  Color get invitationCardBackgroundColor {
    switch (this) {
      case EntryTypeCode.RE:
        return Color(0xFFFE7F5FA);
      case EntryTypeCode.IR:
        return Color(0xFFFFF3E7);
      case EntryTypeCode.IO:
        return Color(0xFFF1EFF7);
      case EntryTypeCode.GA:
        return Color(0xFFF6F5F5);
      case EntryTypeCode.TD:
        return Color(0xFFFEEFC8);
    }
  }
}

enum GuestType { anounce, anounceService, invitation, service }

final guestTypeValue = EnumValues({
  "A": GuestType.anounce,
  "AS": GuestType.anounceService,
  "I": GuestType.invitation,
  "S": GuestType.service
});

extension GuestTypeExtension on GuestType {
  bool get isEnglishLenguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }

  String get value {
    switch (this) {
      case GuestType.invitation:
        return isEnglishLenguage ? 'Gesut' : 'Invitado';
      case GuestType.anounce:
        return isEnglishLenguage ? 'Advertisement' : 'Anuncio';
      case GuestType.anounceService:
        return isEnglishLenguage ? 'Advertisement Service' : 'Anuncio Servicio';
      case GuestType.service:
        return isEnglishLenguage ? 'Service' :  'Servicio';
    }
  }

  Color get invitationCardLabelBackgroundColor {
    switch (this) {
      case GuestType.invitation:
        return Color(0xFFB86E00);
      case GuestType.anounce:
        return Color(0xFFB86E00);
      case GuestType.anounceService:
        return Color(0xFFB86E00);
      case GuestType.service:
        return Color(0xFFB86E00);
    }
  }

  Color get invitationCardBackgroundColor {
    switch (this) {
      case GuestType.invitation:
        return Color(0xFFFEEFC8);
      case GuestType.anounce:
        return Color(0xFFFEEFC8);
      case GuestType.anounceService:
        return Color(0xFFFEEFC8);
      case GuestType.service:
        return Color(0xFFFEEFC8);
    }
  }
}

enum InvitationStatus {
  A,
  I,
}

final invitationStatusValue = EnumValues({
  'A': InvitationStatus.A,
  'I': InvitationStatus.I,
});
