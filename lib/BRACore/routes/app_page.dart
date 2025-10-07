

import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/routes/app_routes.dart';
import 'package:qr_scaner_manrique/pages/login/login_binding.dart';
import 'package:qr_scaner_manrique/pages/login/ui/login_page.dart';
import 'package:qr_scaner_manrique/pages/parking/register_parking/register_parkin_page.dart';

import 'package:qr_scaner_manrique/pages/qr_scanner/qr_scanner_binding.dart';
import 'package:qr_scaner_manrique/pages/qr_scanner/ui/qr_scanner_page.dart';
import 'package:qr_scaner_manrique/pages/salida/salida_binding.dart';
import 'package:qr_scaner_manrique/pages/salida/ui/salida_page.dart';
import 'package:qr_scaner_manrique/pages/schools_page/schools_binding.dart';
import 'package:qr_scaner_manrique/pages/schools_page/ui/schools_page.dart';

abstract class AppPages {

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => LoginPage(),
      binding: LoginBinding()
    ),
    GetPage(
      name: AppRoutes.QR_SCANNER,
      page: () => const QrScannerPage(),
      binding: QrScannerBinding()
    ),
    GetPage(
      name: AppRoutes.Schools,
      page: () => const SchoolsPage(),
      binding: SchoolBinding()
    ),
    GetPage(
      name: AppRoutes.SALIDA,
      page: () => const SalidaPage(),
      binding: SalidaBinding()
    ),
  ];
  
}