// To parse this JSON data, do
//
//     final parrkingResponse = parrkingResponseFromJson(jsonString);

import 'dart:convert';

List<ParrkingResponse> parrkingResponseFromJson(String str) => List<ParrkingResponse>.from(json.decode(str).map((x) => ParrkingResponse.fromJson(x)));

String parrkingResponseToJson(List<ParrkingResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParrkingResponse {
    int? idIngreso;
    int? idPuerta;
    int? idResidenteLugar;
    int? idLugar;
    dynamic nombreLugar;
    dynamic nombrePuerta;
    String? placa;
    String? cedula;
    dynamic celular;
    dynamic nombres;
    dynamic observacion;
    String? estado;
    Ingreso? ingreso;
    dynamic codigo;
    DateTime? fechaIngreso;
    DateTime? fechaValidacion;
    DateTime? fechaSalida;
    dynamic usuarioCreacion;
    dynamic fechaModificacion;
    dynamic usuarioModificacion;
    dynamic informacion;
    int? issetBitfield;

    ParrkingResponse({
        this.idIngreso,
        this.idPuerta,
        this.idResidenteLugar,
        this.idLugar,
        this.nombreLugar,
        this.nombrePuerta,
        this.placa,
        this.cedula,
        this.celular,
        this.nombres,
        this.observacion,
        this.estado,
        this.ingreso,
        this.codigo,
        this.fechaIngreso,
        this.fechaValidacion,
        this.fechaSalida,
        this.usuarioCreacion,
        this.fechaModificacion,
        this.usuarioModificacion,
        this.informacion,
        this.issetBitfield,
    });

    factory ParrkingResponse.fromJson(Map<String, dynamic> json) => ParrkingResponse(
        idIngreso: json["id_ingreso"],
        idPuerta: json["id_puerta"],
        idResidenteLugar: json["id_residente_lugar"],
        idLugar: json["id_lugar"],
        nombreLugar: json["nombre_lugar"],
        nombrePuerta: json["nombre_puerta"],
        placa: json["placa"],
        cedula: json["cedula"],
        celular: json["celular"],
        nombres: json["nombres"],
        observacion: json["observacion"],
        estado: json["estado"],
        ingreso: json["ingreso"] == null ? null : Ingreso.fromJson(json["ingreso"]),
        codigo: json["codigo"],
        fechaIngreso: json["fecha_ingreso"] == null ? null : DateTime.parse(json["fecha_ingreso"]),
        fechaValidacion: json["fecha_validacion"] == null ? null : DateTime.parse(json["fecha_validacion"]),
        fechaSalida: json["fecha_salida"] == null ? null : DateTime.parse(json["fecha_salida"]),
        usuarioCreacion: json["usuario_creacion"],
        fechaModificacion: json["fecha_modificacion"],
        usuarioModificacion: json["usuario_modificacion"],
        informacion: json["informacion"],
        issetBitfield: json["__isset_bitfield"],
    );

    Map<String, dynamic> toJson() => {
        "id_ingreso": idIngreso,
        "id_puerta": idPuerta,
        "id_residente_lugar": idResidenteLugar,
        "id_lugar": idLugar,
        "nombre_lugar": nombreLugar,
        "nombre_puerta": nombrePuerta,
        "placa": placa,
        "cedula": cedula,
        "celular": celular,
        "nombres": nombres,
        "observacion": observacion,
        "estado": estado,
        "ingreso": ingreso?.toJson(),
        "codigo": codigo,
        "fecha_ingreso": fechaIngreso?.toIso8601String(),
        "fecha_validacion": fechaValidacion?.toIso8601String(),
        "fecha_salida": fechaSalida?.toIso8601String(),
        "usuario_creacion": usuarioCreacion,
        "fecha_modificacion": fechaModificacion,
        "usuario_modificacion": usuarioModificacion,
        "informacion": informacion,
        "__isset_bitfield": issetBitfield,
    };
}

class Ingreso {
    int? idIngreso;
    int? idResidenteLugar;
    int? idInvitacion;
    int? idPuertaIngreso;
    int? idPuertaSalida;
    dynamic nombrePuertaIngreso;
    dynamic nombrePuertaSalida;
    int? idLugar;
    dynamic nombre;
    String? cedula;
    dynamic celular;
    dynamic nacionalidad;
    dynamic sexo;
    String? placa;
    dynamic imgIngreso;
    String? imgValidacion;
    dynamic imgSalida;
    String? tipoIngreso;
    String? tipoSalida;
    String? actividad;
    String? observacionIngreso;
    dynamic observacionValidacion;
    String? observacionSalida;
    String? estado;
    DateTime? fechaIngreso;
    DateTime? fechaValidacion;
    DateTime? fechaSalida;
    String? tarifaAplicada;
    String? tiempoTotal;
    String? valorTotal;
    String? tiempoHorasPago;
    String? mensaje;
    DateTime? fechaCreacion;
    DateTime? fechaModificacion;
    String? usuarioCreacion;
    String? usuarioModificacion;
    String? nombresResidente;
    String? apellidosResidente;
    String? cedulaResidente;
    String? celularResidente;
    String? primarioResidente;
    String? secundarioResidente;
    dynamic nombresInvitado;
    int? idIngresoVinculo;
    int? idSalidaVinculo;
    String? nombreLugar;
    int? issetBitfield;

    Ingreso({
        this.idIngreso,
        this.idResidenteLugar,
        this.idInvitacion,
        this.idPuertaIngreso,
        this.idPuertaSalida,
        this.nombrePuertaIngreso,
        this.nombrePuertaSalida,
        this.idLugar,
        this.nombre,
        this.cedula,
        this.celular,
        this.nacionalidad,
        this.sexo,
        this.placa,
        this.imgIngreso,
        this.imgValidacion,
        this.imgSalida,
        this.tipoIngreso,
        this.tipoSalida,
        this.actividad,
        this.observacionIngreso,
        this.observacionValidacion,
        this.observacionSalida,
        this.estado,
        this.fechaIngreso,
        this.fechaValidacion,
        this.fechaSalida,
        this.tarifaAplicada,
        this.tiempoTotal,
        this.valorTotal,
        this.tiempoHorasPago,
        this.mensaje,
        this.fechaCreacion,
        this.fechaModificacion,
        this.usuarioCreacion,
        this.usuarioModificacion,
        this.nombresResidente,
        this.apellidosResidente,
        this.cedulaResidente,
        this.celularResidente,
        this.primarioResidente,
        this.secundarioResidente,
        this.nombresInvitado,
        this.idIngresoVinculo,
        this.idSalidaVinculo,
        this.nombreLugar,
        this.issetBitfield,
    });

    factory Ingreso.fromJson(Map<String, dynamic> json) => Ingreso(
        idIngreso: json["id_ingreso"],
        idResidenteLugar: json["id_residente_lugar"],
        idInvitacion: json["id_invitacion"],
        idPuertaIngreso: json["id_puerta_ingreso"],
        idPuertaSalida: json["id_puerta_salida"],
        nombrePuertaIngreso: json["nombre_puerta_ingreso"],
        nombrePuertaSalida: json["nombre_puerta_salida"],
        idLugar: json["id_lugar"],
        nombre: json["nombre"],
        cedula: json["cedula"],
        celular: json["celular"],
        nacionalidad: json["nacionalidad"],
        sexo: json["sexo"],
        placa: json["placa"],
        imgIngreso: json["img_ingreso"],
        imgValidacion: json["img_validacion"],
        imgSalida: json["img_salida"],
        tipoIngreso: json["tipo_ingreso"],
        tipoSalida: json["tipo_salida"],
        actividad: json["actividad"],
        observacionIngreso: json["observacion_ingreso"],
        observacionValidacion: json["observacion_validacion"],
        observacionSalida: json["observacion_salida"],
        estado: json["estado"],
        fechaIngreso: json["fecha_ingreso"] == null ? null : DateTime.parse(json["fecha_ingreso"]),
        fechaValidacion: json["fecha_validacion"] == null ? null : DateTime.parse(json["fecha_validacion"]),
        fechaSalida: json["fecha_salida"] == null ? null : DateTime.parse(json["fecha_salida"]),
        tarifaAplicada: json["tarifa_aplicada"],
        tiempoTotal: json["tiempo_total"],
        valorTotal: json["valor_total"],
        tiempoHorasPago: json["tiempo_horas_pago"],
        mensaje: json["mensaje"],
        fechaCreacion: json["fecha_creacion"] == null ? null : DateTime.parse(json["fecha_creacion"]),
        fechaModificacion: json["fecha_modificacion"] == null ? null : DateTime.parse(json["fecha_modificacion"]),
        usuarioCreacion: json["usuario_creacion"],
        usuarioModificacion: json["usuario_modificacion"],
        nombresResidente: json["nombres_residente"],
        apellidosResidente: json["apellidos_residente"],
        cedulaResidente: json["cedula_residente"],
        celularResidente: json["celular_residente"],
        primarioResidente: json["primario_residente"],
        secundarioResidente: json["secundario_residente"],
        nombresInvitado: json["nombres_invitado"],
        idIngresoVinculo: json["id_ingreso_vinculo"],
        idSalidaVinculo: json["id_salida_vinculo"],
        nombreLugar: json["nombre_lugar"],
        issetBitfield: json["__isset_bitfield"],
    );

    Map<String, dynamic> toJson() => {
        "id_ingreso": idIngreso,
        "id_residente_lugar": idResidenteLugar,
        "id_invitacion": idInvitacion,
        "id_puerta_ingreso": idPuertaIngreso,
        "id_puerta_salida": idPuertaSalida,
        "nombre_puerta_ingreso": nombrePuertaIngreso,
        "nombre_puerta_salida": nombrePuertaSalida,
        "id_lugar": idLugar,
        "nombre": nombre,
        "cedula": cedula,
        "celular": celular,
        "nacionalidad": nacionalidad,
        "sexo": sexo,
        "placa": placa,
        "img_ingreso": imgIngreso,
        "img_validacion": imgValidacion,
        "img_salida": imgSalida,
        "tipo_ingreso": tipoIngreso,
        "tipo_salida": tipoSalida,
        "actividad": actividad,
        "observacion_ingreso": observacionIngreso,
        "observacion_validacion": observacionValidacion,
        "observacion_salida": observacionSalida,
        "estado": estado,
        "fecha_ingreso": fechaIngreso?.toIso8601String(),
        "fecha_validacion": fechaValidacion?.toIso8601String(),
        "fecha_salida": fechaSalida?.toIso8601String(),
        "tarifa_aplicada": tarifaAplicada,
        "tiempo_total": tiempoTotal,
        "valor_total": valorTotal,
        "tiempo_horas_pago": tiempoHorasPago,
        "mensaje": mensaje,
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "fecha_modificacion": fechaModificacion?.toIso8601String(),
        "usuario_creacion": usuarioCreacion,
        "usuario_modificacion": usuarioModificacion,
        "nombres_residente": nombresResidente,
        "apellidos_residente": apellidosResidente,
        "cedula_residente": cedulaResidente,
        "celular_residente": celularResidente,
        "primario_residente": primarioResidente,
        "secundario_residente": secundarioResidente,
        "nombres_invitado": nombresInvitado,
        "id_ingreso_vinculo": idIngresoVinculo,
        "id_salida_vinculo": idSalidaVinculo,
        "nombre_lugar": nombreLugar,
        "__isset_bitfield": issetBitfield,
    };
}
