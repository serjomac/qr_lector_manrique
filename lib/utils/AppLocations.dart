import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppLocalizationsGenerator {
  static AppLocalizations appLocalizations({required BuildContext context}) {
    return AppLocalizations.of(context)!;
  }

  static String get languageCode {
    Locale deviceLocale = WidgetsBinding.instance.window.locale;
    return deviceLocale.languageCode;
  }
  
  static String countryIsoCode({required BuildContext context}) {
    return Localizations.localeOf(context).countryCode ?? 'N/A';
  }

}