enum AccessType {
  entrance,
  exit,
}

extension OcrTypeExtension on AccessType {

  String get value {
    switch (this) {
      case AccessType.entrance:
        return 'I';
      case AccessType.exit:
        return 'S';
      default:
        return '';
    }
  }
  
}