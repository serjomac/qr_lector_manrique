import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';

class BRAButton extends StatelessWidget {
  final Color? color;
  final Color? colorLabel;
  final String label;
  final VoidCallback onPressed;
  final double? heigth;
  final double? width;
  final double sizeLabel;
  final RxBool? loadingButton;
  final BoxBorder? border;
  const BRAButton(
      {Key? key,
      this.color,
      required this.label,
      required this.onPressed,
      this.colorLabel,
      this.heigth,
      this.width,
      this.loadingButton,
      this.border,
      this.sizeLabel = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return loadingButton != null
        ? Obx(() {
            return InkWell(
              onTap: loadingButton!.value ? () {} : onPressed,
              child: Container(
                height: heigth ?? 50,
                width: width,
                decoration: BoxDecoration(
                  color: color ?? theme.primaryColor,
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BRAText(
                        text: label,
                        textStyle: TextStyle(
                            color: color ?? Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      loadingButton!.value
                          ? SizedBox(
                              width: 10,
                            )
                          : Container(),
                      loadingButton!.value
                          ? SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: color == colorScheme.background
                                    ? theme.primaryColor
                                    : Colors.white,
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            );
          })
        : InkWell(
            onTap: onPressed,
            child: Container(
              height: heigth ?? 50,
              width: width,
              decoration: BoxDecoration(
                color: color ?? theme.primaryColor,
                borderRadius: BorderRadius.circular(35.0),
                border: border,
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                      color: color ?? Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
  }
}
