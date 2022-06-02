import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/core/routes/app_routes.dart';
import 'package:qr_scaner_manrique/pages/qr_scanner/controller/qr_scanner_controller.dart';
import 'package:qr_scaner_manrique/pages/salida/ui/salida_page.dart';
import 'package:qr_scaner_manrique/pages/schools_page/ui/schools_page.dart';
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
              IconButton(
                    icon: const Icon(
                      Icons.logout,
                      size: 36,
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('userLogin');
                      Get.offAllNamed(AppRoutes.HOME);
                    },
                  ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Get.offAllNamed(AppRoutes.Schools, arguments: {
                          'idUser': _.userData!.id
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            (_.area?.area ?? ''),
                            style:
                                const TextStyle(fontSize: 17, color: Colors.blueGrey),
                          ),
                          Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.blueGrey,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    if (_.loadingValidateQrCode.value) {
                      return Text(
                        'Validando código QR',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      );
                    } else {
                      return Text(
                        'Escanear codigo QR',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      );
                    }
                  }),
                  Obx(() {
                    if (_.loadingValidateQrCode.value) {
                      return CircularProgressIndicator();
                    } else {
                      return InkWell(
                        onTap: () {
                          _.scanCode();
                        },
                        child: const Icon(
                          Icons.camera,
                          size: 90,
                          color: Colors.blueGrey,
                        ),
                      );
                    }
                  }),
                  SizedBox(height: 10),
                  InkWell(
                    child: const Text('Estudiantes por retirar', style: TextStyle(fontSize: 17, color: Colors.black),),
                    onTap: () {
                      Get.toNamed(AppRoutes.SALIDA, arguments: {
                        'areaSelected': _.area
                      });
                    },
                  ),
                  Obx(() {
                    if (_.loadingValidateQrCode.value) {
                      return Container();
                    } else {
                      return InkWell(
                        onTap: () {
                         Get.toNamed(AppRoutes.SALIDA, arguments: {
                        'areaSelected': _.area
                      });
                        },
                        child: const Icon(
                          Icons.supervisor_account_rounded,
                          size: 90,
                          color: Colors.blueGrey,
                        ),
                      );
                    }
                  }),
                ],
              )),
            ],
          ),
        ),
      );
    });
  }

  _showListAreas(BuildContext context, ) {
    showDialog(context: context, builder: (context) {
      return SchoolsPage();
    });
  }
}
