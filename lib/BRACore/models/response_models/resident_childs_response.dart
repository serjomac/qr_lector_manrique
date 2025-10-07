// To parse this JSON data, do
//
//     final residentResponse = residentResponseFromJson(jsonString);

import 'dart:convert';

import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';

List<ResidentChildsResponse> residentChildsResponseFromJson(String str) =>
    List<ResidentChildsResponse>.from(
        json.decode(str).map((x) => ResidentChildsResponse.fromJson(x)));

String residentChildsResponseToJson(List<ResidentChildsResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResidentChildsResponse {
  int? idPuerta;
  int? idResidenteLugar;
  int? idLugar;
  dynamic nombreLugar;
  String? nombresResidente;
  String? apellidosResidente;
  String? cedulaResidente;
  String? celularResidente;
  String? correoResidente;
  String? nombrePrimario;
  String? nombreSecundario;
  String? estado;
  String? descripcion;
  dynamic codigo;
  List<Childen>? childrens;
  DateTime? fechaCreacion;
  String? usuarioCreacion;
  DateTime? fechaModificacion;
  String? usuarioModificacion;
  Informacion? informacion;
  // Campos para información de retiro del historial
  String? nombreRetira;
  String? cedulaRetira;
  String? placaRetira;
  List<String>? imagenes;
  int? issetBitfield;

  ResidentChildsResponse({
    this.idPuerta,
    this.idResidenteLugar,
    this.idLugar,
    this.nombreLugar,
    this.nombresResidente,
    this.apellidosResidente,
    this.cedulaResidente,
    this.celularResidente,
    this.correoResidente,
    this.nombrePrimario,
    this.nombreSecundario,
    this.estado,
    this.descripcion,
    this.codigo,
    this.childrens,
    this.fechaCreacion,
    this.usuarioCreacion,
    this.fechaModificacion,
    this.usuarioModificacion,
    this.informacion,
    this.nombreRetira,
    this.cedulaRetira,
    this.placaRetira,
    this.imagenes,
    this.issetBitfield,
  });

  factory ResidentChildsResponse.fromJson(Map<String, dynamic> json) =>
      ResidentChildsResponse(
        idPuerta: json["id_puerta"],
        idResidenteLugar: json["id_residente_lugar"],
        idLugar: json["id_lugar"],
        nombreLugar: json["nombre_lugar"],
        nombresResidente: json["nombres_residente"],
        apellidosResidente: json["apellidos_residente"],
        cedulaResidente: json["cedula_residente"],
        celularResidente: json["celular_residente"],
        correoResidente: json["correo_residente"],
        nombrePrimario: json["nombre_primario"],
        nombreSecundario: json["nombre_secundario"],
        estado: json["estado"],
        descripcion: json["descripcion"],
        codigo: json["codigo"],
        childrens: json["hijos"] == null
            ? []
            : List<Childen>.from(
                json["hijos"]!.map((x) => Childen.fromJson(x))),
        fechaCreacion: json["fecha_creacion"] == null
            ? null
            : DateTime.parse(json["fecha_creacion"]),
        usuarioCreacion: json["usuario_creacion"],
        fechaModificacion: json["fecha_modificacion"] == null
            ? null
            : DateTime.parse(json["fecha_modificacion"]),
        usuarioModificacion: json["usuario_modificacion"],
        informacion: json["informacion"] == null
            ? null
            : Informacion.fromJson(json["informacion"]),
        nombreRetira: json["nombre_retira"],
        cedulaRetira: json["cedula_retira"],
        placaRetira: json["placa_retira"],
        imagenes: json["imagenes"] == null
            ? null
            : List<String>.from(json["imagenes"]),
        issetBitfield: json["__isset_bitfield"],
      );

  Map<String, dynamic> toJson() => {
        "id_puerta": idPuerta,
        "id_residente_lugar": idResidenteLugar,
        "id_lugar": idLugar,
        "nombre_lugar": nombreLugar,
        "nombres_residente": nombresResidente,
        "apellidos_residente": apellidosResidente,
        "cedula_residente": cedulaResidente,
        "celular_residente": celularResidente,
        "correo_residente": correoResidente,
        "nombre_primario": nombrePrimario,
        "nombre_secundario": nombreSecundario,
        "estado": estado,
        "descripcion": descripcion,
        "codigo": codigo,
        "hijos": childrens == null
            ? []
            : List<dynamic>.from(childrens!.map((x) => x.toJson())),
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "usuario_creacion": usuarioCreacion,
        "fecha_modificacion": fechaModificacion?.toIso8601String(),
        "usuario_modificacion": usuarioModificacion,
        "informacion": informacion?.toJson(),
        "nombre_retira": nombreRetira,
        "cedula_retira": cedulaRetira,
        "placa_retira": placaRetira,
        "imagenes": imagenes,
        "__isset_bitfield": issetBitfield,
      };
}

class Childen {
  int? idHijo;
  int? idVinculo;
  int? idTipo;
  int? idCategoriaHijo;
  int? idLugar;
  String? nombre;
  String? descripcion;
  String? nombreCategoria;
  String? estado;
  int? issetBitfield;

  Childen({
    this.idHijo,
    this.idVinculo,
    this.idTipo,
    this.idCategoriaHijo,
    this.idLugar,
    this.nombre,
    this.descripcion,
    this.nombreCategoria,
    this.estado,
    this.issetBitfield,
  });

  factory Childen.fromJson(Map<String, dynamic> json) => Childen(
        idHijo: json["id_hijo"],
        idVinculo: json["id_vinculo"],
        idTipo: json["id_tipo"],
        idCategoriaHijo: json["id_categoria_hijo"],
        idLugar: json["id_lugar"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        nombreCategoria: json["nombre_categoria"],
        estado: json["estado"],
        issetBitfield: json["__isset_bitfield"],
      );

  Map<String, dynamic> toJson() => {
        "id_hijo": idHijo,
        "id_vinculo": idVinculo,
        "id_tipo": idTipo,
        "id_categoria_hijo": idCategoriaHijo,
        "id_lugar": idLugar,
        "nombre": nombre,
        "descripcion": descripcion,
        "nombre_categoria": nombreCategoria,
        "estado": estado,
        "__isset_bitfield": issetBitfield,
      };
}

class Informacion {
  int? idResidente;
  int? idResidenteLugar;
  int? idLugar;
  int? idCodigo;
  int? idPrimario;
  int? idSecundario;
  int? idPuerta;
  dynamic codigo;
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
  dynamic nombreVisitante;
  dynamic cedulaVisitante;
  dynamic celularVisitante;
  dynamic placaVisitante;
  dynamic observacionVisitante;
  dynamic tipoVisitante;
  dynamic fechaInicio;
  dynamic fechaTermino;
  dynamic fechaCreacion;
  String? estado;
  String? fotoPerfil;
  String? fotoCredencial;
  int? issetBitfield;

  Informacion({
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
    this.fotoPerfil,
    this.fotoCredencial,
    this.issetBitfield,
  });

  factory Informacion.fromJson(Map<String, dynamic> json) => Informacion(
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
        tipoVisitante: json["tipo_visitante"],
        fechaInicio: json["fecha_inicio"],
        fechaTermino: json["fecha_termino"],
        fechaCreacion: json["fecha_creacion"],
        estado: json["estado"],
        fotoPerfil: json["foto_perfil"],
        fotoCredencial: json["foto_credencial"],
        issetBitfield: json["__isset_bitfield"],
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
        "tipo_codigo": entryTypeCodeValues.reverse[tipoCodigo],
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
        "fecha_inicio": fechaInicio,
        "fecha_termino": fechaTermino,
        "fecha_creacion": fechaCreacion,
        "estado": estado,
        "foto_perfil": fotoPerfil,
        "foto_credencial": fotoCredencial,
        "__isset_bitfield": issetBitfield,
      };
}
