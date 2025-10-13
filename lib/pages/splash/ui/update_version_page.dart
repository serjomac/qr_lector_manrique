import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';

class UpdateVersionPage extends StatelessWidget {
  const UpdateVersionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _prefs = new PreferenciasUsuario();
    final theme = Theme.of(context);
    final _brightness = WidgetsBinding.instance.window.platformBrightness;
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                //width: 75.0,
                height: 100.0,
                image: _brightness == Brightness.dark
                    ? AssetImage('assets/images/logo_dark.png')
                    : AssetImage('assets/images/logo_dark.png'),
              ),
              SvgPicture.asset('assets/ilustations_svg/build.svg'),
              SizedBox(
                height: 30,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: BRAText(
                    text: 'Hay una nueva versión disponible.',
                    textAlign: TextAlign.center,
                    color: theme.textTheme.bodySmall!.color,
                    fontWeight: FontWeight.bold,
                    size: 18,
                  )),
              SizedBox(
                height: 20,
              ),
              BRAButton(
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: theme.primaryColor,
                  onPressed: () {
                    // _prefs.limpiarPreferencias();
                    // if (Platform.isAndroid) {
                    //   launch(
                    //       'https://play.google.com/store/apps/details?id=com.vionsolutions.qrticket&hl=es_EC&gl=US');
                    // } else if (Platform.isIOS) {
                    //   launch(
                    //       'https://apps.apple.com/ec/app/qr-ticket/id1533524491');
                    // }
                  },
                  label: 'Actualizar')
            ],
          )),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _brightness = WidgetsBinding.instance.window.platformBrightness;
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: new Image(
        image: _brightness == Brightness.dark
            ? AssetImage('assets/images/background_light.png')
            : AssetImage('assets/images/background_light.png'),
        fit: BoxFit.cover,
      ),
    );
  }
}
