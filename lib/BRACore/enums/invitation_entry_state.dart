import 'package:flutter/cupertino.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';

enum EstadoIngreso { s, n }

final estadoIngresoValues = EnumValues({
  "N": EstadoIngreso.n,
  "S": EstadoIngreso.s,
});

extension EstadoIngresoExtension on EstadoIngreso {
  String get value {
    switch (this) {
      case EstadoIngreso.n:
        return '';
      case EstadoIngreso.s:
        return 'Ingresado';
      default:
        return "";
    }
  }

  Color get invitationCardLabelBackgroundColor {
    switch (this) {
      case EstadoIngreso.s:
        return Color(0xFFFEC8C8);
      case EstadoIngreso.n:
        return Color(0xFFCFF9E6);
    }
  }

  Color get invitationCardLabelBorderColor {
    switch (this) {
      case EstadoIngreso.s:
        return Color(0xFFA10101);
      case EstadoIngreso.n:
        return Color(0xFF036546);
    }
  }

  Color get invitationCardLabelTextColor {
    switch (this) {
      case EstadoIngreso.n:
        return Color(0xFFA10101);
      case EstadoIngreso.s:
        return Color(0xFF036546);
    }
  }
}
