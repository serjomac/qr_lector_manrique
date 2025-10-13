import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/Constants/constants-icons.dart';
import 'package:qr_scaner_manrique/pages/login/ui/login_page.dart';
import 'package:qr_scaner_manrique/pages/properties/properties_page.dart';
import 'package:qr_scaner_manrique/pages/splash/controller/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.put(SplashController());
    final isLigthTheme =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GetBuilder<SplashController>(
        id: 'userLogin',
        init: splashController,
        builder: (_) {
          return Obx(() {
            if (_.loadingSplash.value) {
              if (_.isLogin.value) {
                return PropertiesPage();
              } else {
                return LoginPage();
              }
            } else {
              return Center(
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  child:
                      SvgPicture.asset(ConstantsIcons.mainLogoWhite),
                ),
              );
            }
          });
        },
      ),
    );
  }
}
