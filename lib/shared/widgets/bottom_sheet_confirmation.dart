import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';

class BottomSheetConfirmation {
  static Future<T> buttonSheetConfirmation<T>({required BuildContext context,
      required ThemeData theme,
      required String primaryTextButton,
      required String secundaryTextButton,
      required VoidCallback primaryAction,
      required VoidCallback secundayAction,
      RxBool? primaryLoadingButton,
      Color? primaryButtonColor,
      Color? secundayButtonColor
      }) async {
    return await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        constraints: BoxConstraints.tight(Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * .20)),
        builder: (b) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                BRAButton(
                    color: theme.colorScheme.background,
                    colorLabel: primaryButtonColor ?? Colors.red,
                    label: primaryTextButton,
                    loadingButton: primaryLoadingButton,
                    onPressed: primaryAction),
                SizedBox(
                  height: 10,
                ),
                BRAButton(
                    color: theme.colorScheme.background,
                    colorLabel: secundayButtonColor ?? theme.own().primareyTextColor,
                    label: secundaryTextButton,
                    onPressed: secundayAction),
              ],
            ),
          );
        });
  }
}
