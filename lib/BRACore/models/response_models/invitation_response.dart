// To parse this JSON data, do
//
//     final invitationResponse = invitationResponseFromJson(jsonString);

import 'dart:convert';

import 'package:qr_scaner_manrique/BRACore/enums/invitation_entry_state.dart';
import 'package:qr_scaner_manrique/BRACore/enums/invitation_type.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';

List<InvitationResponse> invitationResponseFromJson(String str) =>
    List<InvitationResponse>.from(
        json.decode(str).map((x) => InvitationResponse.fromJson(x)));

String invitationResponseToJson(List<InvitationResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvitationResponse {
  int? idInvitacionRecurrente;
  int? idInvitacionNormal;
  int? idResidenteLugar;
  int? idGrupo;
  int? idResidente;
  int? idLugar;
  String? nombreInvitado;
  String? nombreResidente;
  String? celular;
  String? celularResidente;
  String? cedula;
  String? placa;
  String? descripcion;
  InvitationType? tipo;
  GuestType? tipoInvitado;
  InvitationStatus? estado;
  String? cantidadIngreso;
  EstadoIngreso? estadoIngreso;
  String? nombreLugar;
  String? imagenLugar;
  DateTime? fechaInicio;
  DateTime? fechaTermino;
  DateTime? fechaCreacion;
  String? usuarioCreacion;
  DateTime? fechaModificacion;
  String? usuarioModificacion;

  InvitationResponse({
    this.idInvitacionNormal,
    this.idInvitacionRecurrente,
    this.idResidenteLugar,
    this.idGrupo,
    this.idResidente,
    this.idLugar,
    this.nombreInvitado,
    this.nombreResidente,
    this.celular,
    this.celularResidente,
    this.cedula,
    this.placa,
    this.descripcion,
    this.tipo,
    this.tipoInvitado,
    this.estado,
    this.cantidadIngreso,
    this.estadoIngreso,
    this.nombreLugar,
    this.imagenLugar,
    this.fechaInicio,
    this.fechaTermino,
    this.fechaCreacion,
    this.usuarioCreacion,
    this.fechaModificacion,
    this.usuarioModificacion,
  });

  factory InvitationResponse.fromJson(Map<String, dynamic> json) =>
      InvitationResponse(
        idInvitacionNormal: json["id_invitacion_normal"],
        idInvitacionRecurrente: json["id_invitacion_recurrente"],
        idResidenteLugar: json["id_residente_lugar"],
        idGrupo: json["id_grupo"],
        idResidente: json["id_residente"],
        idLugar: json["id_lugar"],
        nombreInvitado: json["nombre_invitado"],
        cantidadIngreso: json["cantidad_ingreso"],
        nombreResidente: json["nombre_residente"],
        celular: json["celular"],
        celularResidente: json["celular_residente"],
        cedula: json["cedula"],
        placa: json["placa"],
        descripcion: json["descripcion"],
        tipo: invitationTypeValues.map[json["tipo"]],
        tipoInvitado: guestTypeValue.map[json["tipo_invitado"]],
        estado: invitationStatusValue.map[json["estado"]],
        estadoIngreso: estadoIngresoValues.map[json["estado_ingreso"]],
        nombreLugar: json["nombre_lugar"],
        imagenLugar: json["imagen_lugar"],
        fechaInicio: json["fecha_inicio"] == null
            ? null
            : DateTime.parse(json["fecha_inicio"]),
        fechaTermino: json["fecha_termino"] == null
            ? null
            : DateTime.parse(json["fecha_termino"]),
        fechaCreacion: json["fecha_creacion"] == null
            ? null
            : DateTime.parse(json["fecha_creacion"]),
        usuarioCreacion: json["usuario_creacion"],
        fechaModificacion: json["fecha_modificacion"] == null
            ? null
            : DateTime.parse(json["fecha_modificacion"]),
        usuarioModificacion: json["usuario_modificacion"],
      );

  Map<String, dynamic> toJson() => {
        "id_invitacion_normal": idInvitacionNormal,
        "id_invitacion_recurrente": idInvitacionRecurrente,
        "id_residente_lugar": idResidenteLugar,
        "id_grupo": idGrupo,
        "id_residente": idResidente,
        "id_lugar": idLugar,
        "nombre_invitado": nombreInvitado,
        "nombre_residente": nombreResidente,
        "celular": celular,
        "celular_residente": celularResidente,
        "cedula": cedula,
        "placa": placa,
        "descripcion": descripcion,
        "tipo": tipo,
        "tipo_invitado": tipoInvitado,
        "estado": estado,
        "estado_ingreso": estadoIngreso,
        "nombre_lugar": nombreLugar,
        "imagen_lugar": imagenLugar,
        "fecha_inicio": fechaInicio?.toIso8601String(),
        "fecha_termino": fechaTermino?.toIso8601String(),
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "usuario_creacion": usuarioCreacion,
        "fecha_modificacion": fechaModificacion,
        "usuario_modificacion": usuarioModificacion,
      };
}
