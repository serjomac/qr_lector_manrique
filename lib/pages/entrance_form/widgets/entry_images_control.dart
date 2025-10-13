import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/shared/widgets/take_photo_card.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class EntryImagesControl extends StatelessWidget {
  final File? dniImagesFile;
  final File? selphiImagesFile;
  final File? frontCarIdImagesFile;
  final File? backCarIdImagesFile ;
  final VoidCallback takeDniPhoto;
  final VoidCallback takeSelphiPhoto;
  final VoidCallback takeLicensePlateFrontPhoto;
  final VoidCallback takeLicensePlateBackPhoto;
  const EntryImagesControl({
    Key? key,
    required this.dniImagesFile,
    required this.selphiImagesFile,
    required this.frontCarIdImagesFile,
    required this.backCarIdImagesFile, 
    required this.takeDniPhoto,
    required this.takeSelphiPhoto,
    required this.takeLicensePlateFrontPhoto,
    required this.takeLicensePlateBackPhoto,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TakePhotoCard(
              title: stringLocations.dniLabel,
              imageFile: dniImagesFile,
              onTap: takeDniPhoto,
              // () {
              //   _.takePhoto(photoType: PhotoType.dni);
              // },
              width: size.width * 0.42,
            ),
            TakePhotoCard(
              title: stringLocations.selphiLabel,
              imageFile: selphiImagesFile,
              onTap: takeSelphiPhoto,
              // () {
              //   _.takePhoto(photoType: PhotoType.selphi);
              // },
              width: size.width * 0.42,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TakePhotoCard(
              title: stringLocations.licensePlateFrontLabel,
              imageFile: frontCarIdImagesFile,
              onTap: takeLicensePlateFrontPhoto,
              // () {
              //   _.takePhoto(photoType: PhotoType.frontLicensePlate);
              // },
              width: size.width * 0.42,
            ),
            TakePhotoCard(
              title: stringLocations.licensePlateBackLabel,
              imageFile: backCarIdImagesFile,
              onTap: takeLicensePlateBackPhoto,
              // () {
              //   _.takePhoto(photoType: PhotoType.backLicensePlate);
              // },
              width: size.width * 0.42,
            ),
          ],
        ),
      ],
    );
  }
}
