import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTapAcept;
  final String? secondaryButtonText;
  final String? primaryButtonText;
  final VoidCallback? onTapSecondaryButton;
  final double? height;
  final String? iconSvg;
  final RxBool? loadingButton;
  const SuccessDialog(
      {Key? key,
      required this.title,
      this.subtitle,
      required this.onTapAcept,
      this.onTapSecondaryButton,
      this.height,
      this.primaryButtonText,
      this.loadingButton,
      this.iconSvg,
      this.secondaryButtonText = 'Cancelar'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    final theme = Theme.of(context);
    return AlertDialog(
      // contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: theme.colorScheme.background,
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            SizedBox(
              height: 30,
            ),
            iconSvg != null ? SvgPicture.asset(iconSvg!) : Container(),
            SizedBox(
              height: iconSvg != null ? 30 : 0,
            ),
            BRAText(
              text: title,
              size: 22,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            subtitle != null
                ? BRAText(
                    text: subtitle!, textAlign: TextAlign.center, size: 16)
                : Container(),
            subtitle != null
                ? const SizedBox(
                    height: 22,
                  )
                : Container(),
            BRAButton(
              width: 200,
              heigth: 40,
              label: primaryButtonText != null ? primaryButtonText! : stringLocations.acceptLabel,
              loadingButton: loadingButton,
              onPressed: onTapAcept,
            ),
            const SizedBox(
              height: 15,
            ),
            onTapSecondaryButton != null
                ? InkWell(
                    child: BRAText(
                      text: secondaryButtonText!,
                      size: 16,
                      textAlign: TextAlign.center,
                      color: theme.primaryColor,
                    ),
                    onTap: onTapSecondaryButton,
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  double getHeigth({required Size size}) {
    if (iconSvg != null) {
      if (subtitle != null) {
        return size.height * 0.75;
      } else {
        return size.height * 0.50;
      }
    } else if (subtitle != null) {
      return size.height * 0.50;
    } else {
      return size.height * 0.35;
    }
  }
}
