import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:shimmer/shimmer.dart';

class LoadingInvitationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: SafeArea(
        minimum: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.center,
              child: Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    height: 25,
                    width: size.width * 0.8,
                  ),
                  baseColor: theme.own().component!,
                  highlightColor:
                      theme.own().tertiaryTextColor!.withOpacity(0.5)),
            ),
            SizedBox(
              height: 18,
            ),
            Align(
              alignment: Alignment.center,
              child: Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    height: 12,
                    width: size.width * 0.8,
                  ),
                  baseColor: theme.own().component!,
                  highlightColor:
                      theme.own().tertiaryTextColor!.withOpacity(0.5)),
            ),
            SizedBox(
              height: 9,
            ),
            Align(
              alignment: Alignment.center,
              child: Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    height: 12,
                    width: size.width * 0.8,
                  ),
                  baseColor: theme.own().component!,
                  highlightColor:
                      theme.own().tertiaryTextColor!.withOpacity(0.5)),
            ),
            SizedBox(
              height: 36,
            ),
            Align(
              alignment: Alignment.center,
              child: Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    height: 100,
                    width: size.width * 0.8,
                  ),
                  baseColor: theme.own().component!,
                  highlightColor:
                      theme.own().tertiaryTextColor!.withOpacity(0.5)),
            ),
            SizedBox(
              height: 26,
            ),
            Align(
              alignment: Alignment.center,
              child: Shimmer.fromColors(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    height: 100,
                    width: size.width * 0.8,
                  ),
                  baseColor: theme.own().component!,
                  highlightColor:
                      theme.own().tertiaryTextColor!.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
