// To parse this JSON data, do
//
//     final place = placeFromJson(jsonString);

import 'dart:convert';

List<Place> placeFromJson(String str) =>
    List<Place>.from(json.decode(str).map((x) => Place.fromJson(x)));

String placeToJson(List<Place> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Place {
  int? idLugar;
  int? idTipo;
  int? idCiudad;
  int? idProvincia;
  int? idPais;
  String? ciudad;
  String? provincia;
  String? pais;
  String? tipo;
  String? nombre;
  String? latitud;
  String? longitud;
  String? imagen;
  String? token;
  String? tokenFcm;
  String? descripcion;
  String? primario;
  String? secundario;
  String? dominio;
  Estado? estado;
  List<dynamic>? opciones;
  DateTime? fechaCreacion;
  String? usuarioCreacion;
  DateTime? fechaModificacion;
  String? usuarioModificacion;
  PermisosBitacora? permisosBitacora;

  Place({
    this.idLugar,
    this.idTipo,
    this.idCiudad,
    this.idProvincia,
    this.idPais,
    this.ciudad,
    this.provincia,
    this.pais,
    this.tipo,
    this.nombre,
    this.latitud,
    this.longitud,
    this.imagen,
    this.token,
    this.tokenFcm,
    this.descripcion,
    this.primario,
    this.secundario,
    this.dominio,
    this.estado,
    this.opciones,
    this.fechaCreacion,
    this.usuarioCreacion,
    this.fechaModificacion,
    this.usuarioModificacion,
    this.permisosBitacora,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        idLugar: json["id_lugar"],
        idTipo: json["id_tipo"],
        idCiudad: json["id_ciudad"],
        idProvincia: json["id_provincia"],
        idPais: json["id_pais"],
        ciudad: json["ciudad"],
        provincia: json["provincia"],
        pais: json["pais"],
        tipo: json["tipo"],
        nombre: json["nombre"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        imagen: json["imagen"],
        token: json["token"],
        tokenFcm: json["tokenFCM"],
        descripcion: json["descripcion"],
        primario: json["primario"],
        secundario: json["secundario"],
        dominio: json["dominio"],
        estado: estadoValues.map[json["estado"]]!,
        opciones: json["opciones"],
        fechaCreacion: json["fecha_creacion"] == null
            ? null
            : DateTime.parse(json["fecha_creacion"]),
        usuarioCreacion: json["usuario_creacion"],
        fechaModificacion: json["fecha_modificacion"] == null
            ? null
            : DateTime.parse(json["fecha_modificacion"]),
        usuarioModificacion: json["usuario_modificacion"],
        permisosBitacora: json["permisosBitacora"] == null
            ? null
            : PermisosBitacora.fromJsonString(json["permisosBitacora"]),
      );

  Map<String, dynamic> toJson() => {
        "id_lugar": idLugar,
        "id_tipo": idTipo,
        "id_ciudad": idCiudad,
        "id_provincia": idProvincia,
        "id_pais": idPais,
        "ciudad": ciudad,
        "provincia": provincia,
        "pais": pais,
        "tipo": tipo,
        "nombre": nombre,
        "latitud": latitud,
        "longitud": longitud,
        "imagen": imagen,
        "token": token,
        "tokenFCM": tokenFcm,
        "descripcion": descripcion,
        "primario": primario,
        "secundario": secundario,
        "dominio": dominio,
        "estado": estadoValues.reverse[estado],
        "opciones": opciones,
        "fecha_creacion": fechaCreacion?.toIso8601String(),
        "usuario_creacion": usuarioCreacion,
        "fecha_modificacion": fechaModificacion?.toIso8601String(),
        "usuario_modificacion": usuarioModificacion,
        "permisosBitacora": permisosBitacora?.toJsonString(),
      };
}

class PermisosBitacora {
  bool bitacora;
  bool parqueo;
  bool colegio;

  PermisosBitacora({
    required this.bitacora,
    required this.parqueo,
    required this.colegio,
  });

  factory PermisosBitacora.fromJsonString(String jsonString) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return PermisosBitacora.fromJson(json);
    } catch (e) {
      // En caso de error, devolver permisos por defecto (todos false)
      return PermisosBitacora(bitacora: false, parqueo: false, colegio: false);
    }
  }

  factory PermisosBitacora.fromJson(Map<String, dynamic> json) => PermisosBitacora(
        bitacora: json["bitacora"] ?? false,
        parqueo: json["parqueo"] ?? false,
        colegio: json["colegio"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "bitacora": bitacora,
        "parqueo": parqueo,
        "colegio": colegio,
      };

  String toJsonString() => jsonEncode(toJson());

  // Método helper para obtener los permisos activos
  List<String> getActivePermissions() {
    List<String> activePermissions = [];
    if (bitacora) activePermissions.add('bitacora');
    if (parqueo) activePermissions.add('parqueo');
    if (colegio) activePermissions.add('colegio');
    return activePermissions;
  }
}

enum Estado { A, I, P }

final estadoValues = EnumValues({"A": Estado.A, "I": Estado.I, "P": Estado.P});

extension EstadoExtension on Estado {
  String get description {
    switch (this) {
      case Estado.A:
        return 'A';
      case Estado.I:
        return 'I';
      default:
        return '';
    }
  }
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
