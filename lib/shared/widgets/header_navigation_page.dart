import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';

class HeaderNavigatedPage extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onTapBack;
  final Widget? trailing;
  final Widget? backButton;
  final EdgeInsets? paddign;
  final EdgeInsets? marginBackButton;
  final bool isScrolled;
  final bool isHiddenBackButton;
  const HeaderNavigatedPage(
      {Key? key,
      required this.title,
      required this.child,
      required this.onTapBack,
      this.trailing,
      this.backButton,
      this.paddign,
      this.isScrolled = true,
      this.isHiddenBackButton = false,
      this.marginBackButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    return isScrolled
        ? SingleChildScrollView(
            padding: paddign ?? const EdgeInsets.all(0),
            child: Column(
              children: [
                SizedBox(
                  height: 24,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    backButton == null
                        ? isHiddenBackButton
                            ? Container()
                            : GestureDetector(
                                onTap: onTapBack,
                                child: Container(
                                  margin: marginBackButton,
                                  width: 20,
                                  height: 38,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.transparent),
                                  child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                          child: Icon(
                                        Icons.arrow_back_ios,
                                        color: theme.own().primareyTextColor,
                                        size: 20,
                                      ))),
                                ),
                              )
                        : backButton!,
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: BRAText(
                      text: title,
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.own().primareyTextColor,
                      ),
                    )),
                    trailing != null ? trailing! : Container(),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                child
              ],
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  backButton == null
                      ? isHiddenBackButton
                          ? Container()
                          : GestureDetector(
                              onTap: onTapBack,
                              child: Container(
                                margin: marginBackButton,
                                width: 20,
                                height: 38,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent),
                                child: Container(
                                    child: Center(
                                        child: Icon(
                                  Icons.arrow_back_ios,
                                  color: theme.own().primareyTextColor,
                                  size: 20,
                                ))),
                              ),
                            )
                      : backButton!,
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: BRAText(
                      text: title,
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.own().primareyTextColor,
                      ),
                    ),
                  ),
                  trailing != null ? trailing! : Container(),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              child
            ],
          );
  }
}
