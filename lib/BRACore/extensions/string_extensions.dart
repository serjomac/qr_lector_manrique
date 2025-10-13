extension StringFormatter on String {
  String get getFirstName {
    final names = split(' ');
    if (names.isNotEmpty) {
      return names[0];
    } else {
      return '';
    }
  }

  String get getLastNameResp {
    final names = split(' ');
    if (names.isNotEmpty) {
      if (names.length == 2) {
        return names[1];
      } else if (names.length == 3) {
        return names[2];
      } else if (names.length == 4) {
        return names[2];
      } else {
        return names[0];
      }
    } else {
      return '';
    }
  }

  bool get isFullNanme {
    if (isEmpty) {
      return true;
    } else {
      final splitName = split(' ');
      if (splitName.length > 1) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool get validName {
    final splitName = split(' ');
    if (splitName.length > 2) {
      return true;
    }
    var valid = true;
    for (var n in splitName) {
      if (n.isEmpty) {
        return false;
      }
      if (n.length < 2) {
        return false;
      }
    }
    return valid;
  }
}
