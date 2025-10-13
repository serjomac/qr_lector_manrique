// To parse this JSON data, do
//
//     final historySchoolResponse = historySchoolResponseFromJson(jsonString);

import 'dart:convert';

import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';

List<HistorySchoolResponse> historySchoolResponseFromJson(String str) => List<HistorySchoolResponse>.from(json.decode(str).map((x) => HistorySchoolResponse.fromJson(x)));

String historySchoolResponseToJson(List<HistorySchoolResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistorySchoolResponse {
    int? idHijo;
    int? idHijoResidente;
    int? idResidenteLugar;
    int? idCategoriaHijo;
    int? idLugar;
    int? idPuerta;
    String? nombreHijo;
    String? nombrePuerta;
    String? descripcion;
    String? nombreCategoria;
    String? nombresResidente;
    String? apellidosResidente;
    String? cedulaResidente;
    String? celularResidente;
    String? correoResidente;
    String? nombrePrimario;
    String? nombreSecundario;
    EntryTypeCode? tipo;
    String? estado;
    dynamic lista;
    String? nombreRetira;
    String? cedulaRetira;
    String? placaRetira;
    List<dynamic>? imagenes;
    dynamic fechaRetiro;
    DateTime? fechaCreacion;
    String? usuarioCreacion;
    dynamic fechaModificacion;
    dynamic usuarioModificacion;
    int? issetBitfield;

    HistorySchoolResponse({
        this.idHijo,
        this.idHijoResidente,
        this.idResidenteLugar,
        this.idCategoriaHijo,
        this.idLugar,
        this.idPuerta,
        this.nombreHijo,
        this.nombrePuerta,
        this.descripcion,
        this.nombreCategoria,
        this.nombresResidente,
        this.apellidosResidente,
        this.cedulaResidente,
        this.celularResidente,
        this.correoResidente,
        this.nombrePrimario,
        this.nombreSecundario,
        this.tipo,
        this.estado,
        this.lista,
        this.nombreRetira,
        this.cedulaRetira,
        this.placaRetira,
        this.imagenes,
        this.fechaRetiro,
        this.fechaCreacion,
        this.usuarioCreacion,
        this.fechaModificacion,
        this.usuarioModificacion,
        this.issetBitfield,
    });

    factory HistorySchoolResponse.fromJson(Map<String, dynamic> json) => HistorySchoolResponse(
        idHijo: json["id_hijo"],
        idHijoResidente: json["id_hijo_residente"],
        idResidenteLugar: json["id_residente_lugar"],
        idCategoriaHijo: json["id_categoria_hijo"],
        idLugar: json["id_lugar"],
        idPuerta: json["id_puerta"],
        nombreHijo: json["nombre_hijo"],
        nombrePuerta: json["nombre_puerta"],
        descripcion: json["descripcion"],
        nombreCategoria: json["nombre_categoria"],
        nombresResidente: json["nombres_residente"],
        apellidosResidente: json["apellidos_residente"],
        cedulaResidente: json["cedula_residente"],
        celularResidente: json["celular_residente"],
        correoResidente: json["correo_residente"],
        nombrePrimario: json["nombre_primario"],
        nombreSecundario: json["nombre_secundario"],
        tipo: entryTypeCodeValues.map[json["tipo"]],
        estado: json["estado"],
        lista: json["lista"],
        nombreRetira: json["nombre_retira"],
        cedulaRetira: json["cedula_retira"],
        placaRetira: json["placa_retira"],
        imagenes: json["imagenes"] == null ? [] : List<dynamic>.from(json["imagenes"]!.map((x) => x)),
        fechaRetiro: json["fecha_retiro"],
        fechaCreacion: json["fecha_creacion"] == null ? null : DateTime.parse(json["fecha_creacion"]),
        usuarioCreacion: json["usuario_creacion"],
        fechaModificacion: json["fecha_modificacion"],
        usuarioModificacion: json["usuario_modificacion"],
        issetBitfield: json["__isset_bitfield"],
    );

    Map<String, dynamic> toJson() => {
        "id_hijo": idHijo,
        "id_hijo_residente": idHijoResidente,
        "id_residente_lugar": idResidenteLugar,
        "id_categoria_hijo": idCategoriaHijo,
        "id_lugar": idLugar,
        "id_puerta": idPuerta,
        "nombre_hijo": nombreHijo,
        "nombre_puerta": nombrePuerta,
        "descripcion": descripcion,
        "nombre_categoria": nombreCategoria,
        "nombres_residente": nombresResidente,
        "apellidos_residente": apellidosResidente,
        "cedula_residente": cedulaResidente,
        "celular_residente": celularResidente,
        "correo_residente": correoResidente,
        "nombre_primario": nombrePrimario,
        "nombre_secundario": nombreSecundario,
        "tipo": tipo,
        "estado": estado,
        "lista": lista,
        "nombre_retira": nombreRetira,
        "cedula_retira": cedulaRetira,
        "placa_retira": placaRetira,
        "imagenes": imagenes == null ? [] : List<dynamic>.from(imagenes!.map((x) => x)),
        "fecha_retiro": fechaRetiro,
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "usuario_creacion": usuarioCreacion,
        "fecha_modificacion": fechaModificacion,
        "usuario_modificacion": usuarioModificacion,
        "__isset_bitfield": issetBitfield,
    };
}
