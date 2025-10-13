// To parse this JSON data, do
//
//     final peopleData = peopleDataFromJson(jsonString);

import 'dart:convert';

PeopleData peopleDataFromJson(String str) =>
    PeopleData.fromJson(json.decode(str));

String peopleDataToJson(PeopleData data) => json.encode(data.toJson());

class PeopleData {
  PeopleData({
    required this.idRc,
    required this.cedula,
    required this.nombres,
    required this.desSexo,
    required this.desCiudadania,
    required this.fechNac,
    required this.lugNac,
    required this.desNacionalid,
    required this.desEstadoCivil,
    required this.descNivEst,
    required this.desProfesion,
    required this.nomConyug,
    required this.nomPad,
    required this.nomMad,
    required this.calle,
  });

  String? idRc;
  String? cedula;
  String? nombres;
  String? desSexo;
  String? desCiudadania;
  String? fechNac;
  String? lugNac;
  String? desNacionalid;
  String? desEstadoCivil;
  String? descNivEst;
  String? desProfesion;
  String? nomConyug;
  String? nomPad;
  String? nomMad;
  String? calle;

  factory PeopleData.fromJson(Map<String, dynamic> json) => PeopleData(
        idRc: json["ID_RC"],
        cedula: json["CEDULA"],
        nombres: json["NOMBRES"],
        desSexo: json["DES_SEXO"],
        desCiudadania: json["DES_CIUDADANIA"],
        fechNac: json["FECH_NAC"],
        lugNac: json["LUG_NAC"],
        desNacionalid: json["DES_NACIONALID"],
        desEstadoCivil: json["DES_ESTADO_CIVIL"],
        descNivEst: json["DESC_NIV_EST"],
        desProfesion: json["DES_PROFESION"],
        nomConyug: json["NOM_CONYUG"],
        nomPad: json["NOM_PAD"],
        nomMad: json["NOM_MAD"],
        calle: json["CALLE"],
      );

  Map<String, dynamic> toJson() => {
        "ID_RC": idRc,
        "CEDULA": cedula,
        "NOMBRES": nombres,
        "DES_SEXO": desSexo,
        "DES_CIUDADANIA": desCiudadania,
        "FECH_NAC": fechNac,
        "LUG_NAC": lugNac,
        "DES_NACIONALID": desNacionalid,
        "DES_ESTADO_CIVIL": desEstadoCivil,
        "DESC_NIV_EST": descNivEst,
        "DES_PROFESION": desProfesion,
        "NOM_CONYUG": nomConyug,
        "NOM_PAD": nomPad,
        "NOM_MAD": nomMad,
        "CALLE": calle,
      };
}
