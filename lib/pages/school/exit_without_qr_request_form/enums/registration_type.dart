enum RegistrationType { withQR, withoutQR }

enum PropertyEntryType { residentGate, schoolGate, parkingLot }

extension PropertyEntryTypeExtension on PropertyEntryType {
  String get doorType {
    switch (this) {
      case PropertyEntryType.residentGate:
        return 'G';
      case PropertyEntryType.schoolGate:
        return 'H';
      case PropertyEntryType.parkingLot:
        return 'P';
    }
  }
}
