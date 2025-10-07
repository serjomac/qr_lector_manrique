import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

enum InvitationType {
    normal,
    recurrent
}

final invitationTypeValues = EnumValues({
    "N": InvitationType.normal,
    "R": InvitationType.recurrent,
});

extension InvitationTypeExtension on InvitationType {

  bool get isEnglishLenguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }

  String get value {
    switch (this) {
      case InvitationType.normal:
        return isEnglishLenguage ? 'Normal invitation' : 'Invitación normal';
      case InvitationType.recurrent:
        return isEnglishLenguage ? 'Recurrent invitation' : 'Invitación recurente';
      default:
        return "";
    }
  }
}