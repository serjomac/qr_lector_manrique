enum RegisterEntryType {
  qrCode,
  securityCheckpoint,
  residenceGate
}

extension RegisterEntryExtension on RegisterEntryType {

  String get value {
    switch (this) {
      case RegisterEntryType.qrCode:
        return 'B';
      case RegisterEntryType.securityCheckpoint:
        return 'B';
      case RegisterEntryType.residenceGate:
        return 'B';
      default:
        return "";
    }
  }
  
}