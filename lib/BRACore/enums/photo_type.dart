enum PhotoType {
  dni,
  selphi,
  frontLicensePlate,
  backLicensePlate,
}

extension OcrTypeExtension on PhotoType {

  String get value {
    switch (this) {
      case PhotoType.dni:
        return "cedula";
      case PhotoType.selphi:
        return "rostro";
      case PhotoType.frontLicensePlate:
        return "placaFrontal";
      case PhotoType.backLicensePlate:
        return "PlacaTrasera";
      default:
        return "";
    }
  }
  
}