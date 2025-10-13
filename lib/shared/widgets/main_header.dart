import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';

class HeaderMainPage extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? titleIcon;
  final Widget trailingOne;
  final Widget? trailingTow;
  final EdgeInsets? paddign;
  double? marginTop;
  final VoidCallback? onTapTitle;
  final bool? isScrolleable;
  HeaderMainPage(
      {Key? key,
      required this.title,
      required this.child,
      this.titleIcon,
      required this.trailingOne,
      this.trailingTow,
      this.paddign,
      this.onTapTitle,
      this.isScrolleable = true,
      this.marginTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    // marginTop = marginTop != null ? (Device.get().hasNotch ? 20 : 0) + marginTop! : marginTop;
    return SafeArea(
      child: (isScrolleable ?? true)
          ? SingleChildScrollView(
              padding: paddign ?? const EdgeInsets.all(0),
              child: Column(
                children: [
                  Container(
                    // height:
                    //     60 + (marginTop ?? (Device.get().hasNotch ? 50 : 27)),
                    // padding: EdgeInsets.only(
                    //     top: marginTop ?? (Device.get().hasNotch ? 50 : 27)),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.background,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                          )
                        ],
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              GestureDetector(
                                child: titleIcon ?? Container(),
                                onTap: onTapTitle,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: onTapTitle,
                                child: BRAText(
                                    text: title,
                                    textStyle: textTheme.headlineSmall),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            trailingOne,
                            SizedBox(
                              width: 10,
                            ),
                            trailingTow ?? Container()
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  child
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  // height:
                  //     60 + ((marginTop ?? (Device.get().hasNotch ? 50 : 27))),
                  // padding: EdgeInsets.only(
                  //     top: (marginTop ?? (Device.get().hasNotch ? 50 : 27))),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                        )
                      ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            GestureDetector(
                              child: titleIcon ?? Container(),
                              onTap: onTapTitle,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: onTapTitle,
                              child: BRAText(
                                  text: title,
                                  textStyle: textTheme.headlineSmall),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          trailingOne,
                          SizedBox(
                            width: 10,
                          ),
                          trailingTow ?? Container()
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                child
              ],
            ),
    );
  }
}
