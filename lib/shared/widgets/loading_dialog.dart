import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';

void showLoadingDialog({
    required BuildContext context,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      barrierDismissible:
          false, // Usuario no puede cerrar el dialog presionando fuera de él
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0, // Quita la sombra
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 10,),
                BRAText(
                  text: message,
                  size: 17,
                  textAlign: TextAlign.center,
                  color: Colors.white,
                ),
              ],
            ), // Widget de loading
          ),
        );
      },
    );
  }