import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/shared/widgets/preview_image.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:shimmer/shimmer.dart';

class ControlImagesList extends StatelessWidget {
  final List<String> imagesList;

  const ControlImagesList({
    required this.imagesList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return imagesList.isEmpty
        ? Column(
            children: [
              Image(image: AssetImage('assets/images/empty.png')),
              BRAText(
                text: stringLocations.noImageToShowLabel,
                size: 17,
              ),
            ],
          )
        : SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 80),
            child: Column(
              children: imagesList.map((currentImage) {
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (c) {
                        return PreviewImage(imageUrl: currentImage);
                      },
                    );
                  },
                  child: Container(
                    width: size.width * 0.8,
                    height: 180,
                    margin: const EdgeInsets.only(bottom: 16, top: 24),
                    child: CachedNetworkImage(
                      imageUrl: (currentImage),
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.withOpacity(0.6),
                            ),
                            height: 50,
                          ),
                          baseColor: theme.own().component!,
                          highlightColor:
                              theme.own().tertiaryTextColor!.withOpacity(0.5),
                        );
                      },
                      width: size.width * 0.8,
                      height: 140,
                      fit: BoxFit.cover,
                      errorWidget: (c, s, d) {
                        return Container(
                          height: 140,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: theme.own().tertiaryTextColor),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }
}
