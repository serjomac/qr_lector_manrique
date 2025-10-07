import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewImage extends StatelessWidget {
  final String imageUrl;
  const PreviewImage({ required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 3, 3, 3),
      body: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: InteractiveViewer(
          maxScale: 250,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: Center(
                  child: Container(
                    decoration:
                      BoxDecoration(color: theme.colorScheme.background.withOpacity(0.01)),
                width: size.width * 0.98,
                child: Center(child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: CachedNetworkImage(imageUrl: imageUrl, width: size.width * 0.9,))),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
