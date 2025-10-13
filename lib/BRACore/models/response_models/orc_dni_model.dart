// To parse this JSON data, do
//
//     final ocrDniResponse = ocrDniResponseFromJson(jsonString);

import 'dart:convert';

OcrDniResponse ocrDniResponseFromJson(String str) => OcrDniResponse.fromJson(json.decode(str));

String ocrDniResponseToJson(OcrDniResponse data) => json.encode(data.toJson());

class OcrDniResponse {
    String? cedula;
    String? nombres;
    String? desSexo;
    String? desNacionalid;

    OcrDniResponse({
        this.cedula,
        this.nombres,
        this.desSexo,
        this.desNacionalid,
    });

    factory OcrDniResponse.fromJson(Map<String, dynamic> json) => OcrDniResponse(
        cedula: json["CEDULA"],
        nombres: json["NOMBRES"],
        desSexo: json["DES_SEXO"],
        desNacionalid: json["DES_NACIONALID"],
    );

    Map<String, dynamic> toJson() => {
        "CEDULA": cedula,
        "NOMBRES": nombres,
        "DES_SEXO": desSexo,
        "DES_NACIONALID": desNacionalid,
    };
}
