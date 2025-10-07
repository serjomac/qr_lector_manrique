import 'package:flutter/material.dart';

class OwnThemeFields {
  final Color? primareyTextColor;
  final Color? secundaryTextColor;
  final Color? tertiaryTextColor;
  final Color? component;
  final Color? secundaryColor;

  const OwnThemeFields({
    this.primareyTextColor,
    this.secundaryTextColor,
    this.tertiaryTextColor,
    this.component,
    this.secundaryColor,
  });

  factory OwnThemeFields.empty() {
    return const OwnThemeFields(
        primareyTextColor: Colors.black,
        secundaryTextColor: Colors.black,
        tertiaryTextColor: Colors.black,
        component: Colors.black,
        secundaryColor: Colors.black);
  }
}

extension ThemeDataExtensions on ThemeData {
  static Map<InputDecorationTheme, OwnThemeFields> _own = {};

  void addOwn(OwnThemeFields own) {
    _own[inputDecorationTheme] = own;
  }

  static OwnThemeFields? empty;

  OwnThemeFields own() {
    var o = _own[inputDecorationTheme];
    if (o == null) {
      empty ??= OwnThemeFields.empty();
      o = empty;
    }
    return o!;
  }
}

OwnThemeFields ownTheme(BuildContext context) => Theme.of(context).own();
