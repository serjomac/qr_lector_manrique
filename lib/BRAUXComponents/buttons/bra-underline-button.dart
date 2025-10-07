import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/Constants/size_phone.dart';

class BRAUnderlineButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final RxBool? loading;

  const BRAUnderlineButton(
      {Key? key, required this.title, required this.onTap, this.loading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Obx(() {
      if ((loading ?? false.obs).value) {
        return SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(color: theme.colorScheme.primary));
      } else {
        return Container(
          child: InkWell(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
                fontSize: size.height < SizePhone.HEGTH_M ? 15 : 17,
              ),
            ),
            onTap: onTap,
          ),
          margin: const EdgeInsets.only(bottom: 25.0),
        );
      }
    });
  }
}
