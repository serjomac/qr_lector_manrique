import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';

class BottomSheetLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 4,
      width: 100,
      decoration: BoxDecoration(
          color: theme.own().tertiaryTextColor,
          borderRadius: BorderRadius.circular(20)),
    );
  }
}
