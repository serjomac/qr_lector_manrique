import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';

class BRAText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextStyle? textStyle;
  final TextOverflow? textOverflow;
  const BRAText(
      {Key? key,
      required this.text,
      this.size = 10.0,
      this.color,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.left,
      this.maxLines,
      this.textOverflow,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      overflow: textOverflow,
      style: textStyle ??
          TextStyle(
            fontSize: size,
            color: color ?? theme.own().secundaryTextColor,
            fontWeight: fontWeight,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
