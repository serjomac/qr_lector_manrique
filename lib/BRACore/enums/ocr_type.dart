import 'package:qr_scaner_manrique/BRACore/enums/entry_type.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

enum OcrType {
  licensePlate,
  dni,
}

extension OcrTypeExtension on OcrType {
  bool get isEnglishLenguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }

  String get value {
    switch (this) {
      case OcrType.licensePlate:
        return isEnglishLenguage ? 'License plate' : "placa";
      case OcrType.dni:
        return isEnglishLenguage ? 'Id' : "cedula";
      default:
        return "";
    }
  }
  
  String get valueOrc {
    switch (this) {
      case OcrType.licensePlate:
        return "placa";
      case OcrType.dni:
        return "cedula";
      default:
        return "";
    }
  }

  String get dialogMessage {
    switch (this) {
      case OcrType.licensePlate:
        return isEnglishLenguage
            ? 'We are getting license plate information, please wait'
            : "Estamos obteniendo la información de la placa, por favor espere";
      case OcrType.dni:
        return isEnglishLenguage
            ? 'We are obtaining the ID information, please wait'
            : "Estamos obteniendo la información de la cédula, por favor espere";
      default:
        return "";
    }
  }
}
