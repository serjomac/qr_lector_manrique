// To parse this JSON data, do
//
//     final area = areaFromJson(jsonString);

import 'dart:convert';

List<Area> areaFromJson(String str) => List<Area>.from(json.decode(str).map((x) => Area.fromJson(x)));

String areaToJson(List<Area> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Area {
    Area({
        this.id,
        this.area,
    });

    String? id;
    String? area;

    factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["id"],
        area: json["area"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "area": area,
    };
}
