import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/entry_images_control.dart';
import 'package:qr_scaner_manrique/shared/widgets/preview_image.dart';
import 'package:qr_scaner_manrique/shared/widgets/take_photo_card.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class ResidentEntryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return GetBuilder<AddEntryFormController>(builder: (_) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
        child: Form(
            key: _.formKeyResident,
            child: Column(
              children: [
                // const SizedBox(
                //   height: 22,
                // ),
                // const Align(
                //   alignment: Alignment.centerLeft,
                //   child: BRAText(
                //     text: 'Información del residente',
                //     size: 19,
                //   ),
                // ),
                // ======= IMAGENES DE CONTROL PARA GARITA ========
                _.isResidentEntry
                    ? EntryImagesControl(
                        dniImagesFile: _.dniImagesFile,
                        selphiImagesFile: _.selphiImagesFile,
                        frontCarIdImagesFile: _.frontCarIdImagesFile,
                        backCarIdImagesFile: _.backCarIdImagesFile,
                        takeDniPhoto: () {
                          _.takePhoto(photoType: PhotoType.dni);
                        },
                        takeSelphiPhoto: () {
                          _.takePhoto(photoType: PhotoType.selphi);
                        },
                        takeLicensePlateFrontPhoto: () {
                          _.takePhoto(photoType: PhotoType.frontLicensePlate);
                        },
                        takeLicensePlateBackPhoto: () {
                          _.takePhoto(photoType: PhotoType.backLicensePlate);
                        },
                      )
                    : Container(),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _.isProfilePhoto
                          ? Expanded(
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: BRAText(
                                    text: stringLocations.profilePhoto,
                                    size: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (c) {
                                        return PreviewImage(
                                            imageUrl: _.guessScanned!.photo!);
                                      },
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: _.guessScanned!.photo!,
                                    fit: BoxFit.cover,
                                    height: 250,
                                  ),
                                ),
                              ],
                            ))
                          : Container(),
                      SizedBox(
                        width: 8,
                      ),
                      _.isCredentialPhoto
                          ? Expanded(
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: BRAText(
                                    text: stringLocations.credentialPhoto,
                                    size: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                CachedNetworkImage(
                                  imageUrl: _.guessScanned!.credentialPhoto!,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ))
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                // ======= INFORMACION RESIDENTE ========
                CustomTextFormField(
                  focusNode: _.nameFocusNode,
                  onTap: () {},
                  readOnly: true,
                  label: stringLocations.residentNameLabel,
                  controller: _.nameResdienteController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return stringLocations.nameGuestInputEmptyError;
                    }
                    return null;
                  },
                  onChanged: ((value) {
                    _.name = value;
                  }),
                ),
                SizedBox(
                  height:
                      (_.primaryTitle.isNotEmpty && _.secundaryTitle.isNotEmpty)
                          ? 22
                          : 0,
                ),
                Row(
                  children: [
                    _.primaryTitle.isNotEmpty
                        ? Expanded(
                            child: CustomTextFormField(
                              focusNode: FocusNode(),
                              onTap: () {},
                              readOnly: true,
                              label: _.primaryTitle,
                              controller: _.primaryResdienteController,
                              onChanged: ((value) {
                                _.name = value;
                              }),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      width: 8,
                    ),
                    _.secundaryTitle.isNotEmpty
                        ? Expanded(
                            child: CustomTextFormField(
                              focusNode: FocusNode(),
                              onTap: () {},
                              readOnly: true,
                              label: _.secundaryTitle,
                              controller: _.secundaryResdienteController,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return stringLocations
                                      .nameGuestInputEmptyError;
                                }
                                return null;
                              },
                              onChanged: ((value) {
                                _.name = value;
                              }),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  onTap: () {},
                  readOnly: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return stringLocations.cellphoneGuestInputEmptyError;
                    }
                    return null;
                  },
                  label: stringLocations.cellphoneResidentLabel,
                  controller: _.phoneNumberResdienteController,
                  onChanged: ((value) {
                    _.lastName = value;
                  }),
                ),
                SizedBox(
                  height: 22,
                ),
                CustomTextFormField(
                  focusNode: FocusNode(),
                  onTap: () {},
                  readOnly: true,
                  label: stringLocations.dniResidentLabel,
                  controller: _.dniIdController,
                  onChanged: ((value) {
                    _.lastName = value;
                  }),
                ),
                SizedBox(
                  height: 22,
                ),
                !_.isResidentEntry
                    ? Container()
                    : CustomTextFormField(
                        focusNode: _.licensePlateFocusNode,
                        onTap: () {},
                        label:
                            '${stringLocations.residentLicensePlate} ${stringLocations.optionalLabel}',
                        readOnly: !_.isResidentEntry,
                        controller: _.licensePlateResdienteController,
                        onChanged: ((value) {
                          _.lastName = value;
                        }),
                      ),
                SizedBox(
                  height: _.isResidentEntry ? 22 : 0,
                ),
                _.isResidentEntry
                    ? CustomTextFormField(
                        focusNode: _.descriptionFocusNode,
                        onTap: () {},
                        label:
                            '${stringLocations.observationsLabel} ${stringLocations.optionalLabel}',
                        controller: _.descriptionController,
                        onChanged: ((value) {
                          _.phoneNumber = value;
                        }),
                      )
                    : Container(),
                const SizedBox(
                  height: 40,
                ),
                // _.isResidentEntry
                //     ? BRAButton(
                //         loadingButton: _.addEntryLoading,
                //         label: 'Continuar',
                //         onPressed: () {
                //           if (_.isResidentEntry) {
                //             _.isResidentFormValidatedOnce = true;
                //             if (_.formKeyResident.currentState!.validate()) {
                //               _.formKeyResident.currentState!.save();
                //               _.addEntrance();
                //             }
                //           } else {
                //             _.isVisitorFormValidatedOnce = true;
                //             if (_.formKeyVisitor.currentState!.validate()) {
                //               _.formKeyVisitor.currentState!.save();
                //               _.addEntrance();
                //             }
                //           }
                //         },
                //       )
                //     : Container()
              ],
            )),
      );
    });
  }
}
