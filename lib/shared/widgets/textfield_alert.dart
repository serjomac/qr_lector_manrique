import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';

class TextfieldAlertMessage extends StatelessWidget {
  final String message;
  final RxBool isShowAlertMessage;
  const TextfieldAlertMessage({
    Key? key,
    required this.message,
    required this.isShowAlertMessage,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isShowAlertMessage.value) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                SvgPicture.asset(
                  ConstantsIcons.alertIcon,
                  height: 18.5,
                  color: Colors.orange.shade800,
                ),
                const SizedBox(
                  width: 5,
                ),
                BRAText(
                  text: message,
                  size: 12.5,
                  color: Colors.orange.shade800,
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
