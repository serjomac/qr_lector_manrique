import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final String icon;
  final RxBool? loading;
  final VoidCallback onTap;
  const HomeCard({
    Key? key,
    required this.title,
    required this.icon,
    this.loading,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: (loading != null && loading!.value) ? () {} : onTap,
      child: Container(
        height: 97,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.primary, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned(
                left: -70,
                top: -30,
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                      color: theme.own().component, shape: BoxShape.circle),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 31,
                  ),
                  Obx(
                    () {
                      if (loading != null && loading!.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme.primaryColor,
                          ),
                        );
                      } else {
                        return Center(
                          child: SvgPicture.asset(
                            icon,
                            width: 30,
                            height: 30,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 31,
                  ),
                  BRAText(
                    text: title,
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: theme.own().primareyTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
