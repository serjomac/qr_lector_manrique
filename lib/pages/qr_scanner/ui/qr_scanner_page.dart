import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/core/routes/app_routes.dart';
import 'package:qr_scaner_manrique/pages/qr_scanner/controller/qr_scanner_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrScannerPage extends StatelessWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QrScannerController>(builder: (_) {
      return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      size: 36,
                    ),
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove('userLogin');
                      Get.offAllNamed(AppRoutes.HOME);
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    _.userData != null ? (_.userData!.nombres ?? '') : '',
                    style: const TextStyle(fontSize: 17, color: Colors.blueGrey),
                  ),
                ],
              ),
              Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Escanear codigo QR',
                      style: TextStyle(fontSize: 17, color: Colors.blueGrey),
                    ),
                    InkWell(
                      onTap: () {
                        _.scanCode();
                      },
                      child: const Icon(
                        Icons.camera,
                        size: 90,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                )),
            ],
          ),
        ),
      );
    });
  }
}
