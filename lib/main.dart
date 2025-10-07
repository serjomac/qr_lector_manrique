import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRACore/routes/app_page.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_page.dart';
import 'package:qr_scaner_manrique/pages/login/login_binding.dart';
import 'package:qr_scaner_manrique/pages/login/ui/login_page.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/pages/parking/historic_parking/historic_parkin_page.dart';
import 'package:qr_scaner_manrique/pages/parking/register_parking/register_parkin_page.dart';

import 'package:qr_scaner_manrique/pages/school/exit_with_qr_request_form/exit_with_qr_request_form_page.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/enums/registration_type.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/exit_without_qr_to_school_request_form_page.dart';
import 'package:qr_scaner_manrique/pages/school/rappresentante_seleccion/representative_selection_page.dart';
import 'package:qr_scaner_manrique/pages/splash/ui/splash_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    Firebase.initializeApp().then((value) {
      print(value);
    }, onError: (error) {
      print(error);
    });
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final appTheme = ThemeData(
    primaryColor: const Color(0xFFEB472A),
    primaryColorDark: const Color(0xFFEB472A),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFEB472A),
      onPrimary: Color(0xFFEB472A),
      secondary: Color(0xFFEB472A),
      onSecondary: Color(0xFFEB472A),
      error: Colors.red,
      onError: Colors.red,
      background: Colors.white,
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFFEB472A),
    ),
  )..addOwn(
      const OwnThemeFields(
        primareyTextColor: Color(0xFF202023),
        secundaryTextColor: Color(0xFF5B5856),
        tertiaryTextColor: Color(0xFFC3C3C3),
        component: Color(0xFFF5F5F5),
        secundaryColor: Color(0xFF0085F9),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      debugShowCheckedModeBanner: false,
      title: 'Bitacora Pinlet',
      supportedLocales: [
        const Locale('es'),
        const Locale('en'),
      ],
      // locale: const Locale('es'),
      theme: appTheme,
      home: SplashPage(),
      // getPages: AppPages.pages,
      // initialBinding: LoginBinding(),
    );
  }
}
