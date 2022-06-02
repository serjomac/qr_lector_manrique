import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/core/routes/app_page.dart';
import 'package:qr_scaner_manrique/pages/login/login_binding.dart';
import 'package:qr_scaner_manrique/pages/login/ui/login_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lecto QR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      getPages: AppPages.pages,
      initialBinding: LoginBinding(),
    );
  }
}
