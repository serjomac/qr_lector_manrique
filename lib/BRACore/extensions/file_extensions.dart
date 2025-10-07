import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

extension FileExtensions on File {
  Future<File> ensureFileSize(int maxSizeInBytes) async {
    File? compressedFile = await compressFile(this);
    int quality = 88;
    while (compressedFile != null &&
        await compressedFile.length() > maxSizeInBytes &&
        quality > 0) {
      quality -= 10; // Reduce la calidad en pasos del 10%.
      final compressedXFile = await FlutterImageCompress.compressAndGetFile(
        absolute.path,
        compressedFile.absolute.path,
        quality: quality,
      );
      compressedFile =
          compressedXFile != null ? File(compressedXFile.path) : null;
    }
    return compressedFile ?? this;
  }

  Future<File?> compressFile(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 50,
    );
    final compresedFile = result != null ? File(result.path) : null;
    return compresedFile;
  }
}
