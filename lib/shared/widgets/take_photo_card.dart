import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';

class TakePhotoCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double width;
  final double? height;
  final File? imageFile;
  const TakePhotoCard(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.width,
      required this.imageFile,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: BRAText(
            text: imageFile != null ? title : '',
            size: 13,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            height: height ?? 160,
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BRAText(text: title, size: 15),
                      SizedBox(height: 4),
                      SvgPicture.asset(ConstantsIcons.camera, height: 30,)
                    ],
                  ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.own().tertiaryTextColor!)),
          ),
        ),
      ],
    );
  }
}
