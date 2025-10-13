import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_respose.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/entry_images_control.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/resident_entry_form.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/resident_gate_entry_form.dart';
import 'package:qr_scaner_manrique/pages/entry_historic/entry_historic_controller.dart';
import 'package:qr_scaner_manrique/shared/widgets/preview_image.dart';
import 'package:qr_scaner_manrique/shared/widgets/take_photo_card.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class ResidentLeaveForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return GetBuilder<EntryHistoricController>(
        id: 'form',
        builder: (_) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Form(
                key: _.formKeyResidentLeave,
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
                    EntryImagesControl(
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
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    // ======= INFORMACION RESIDENTE ========
                    _.autoCompleteResdientSelected != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _.autoCompleteResdientSelected!.foto != null
                                  ? Expanded(
                                      child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: BRAText(
                                            text: stringLocations.residentPhoto,
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
                                                    imageUrl:
                                                        'https://storage.googleapis.com/pinlet/Residentes/' +
                                                            _.autoCompleteResdientSelected!
                                                                .foto!);
                                              },
                                            );
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://storage.googleapis.com/pinlet/Residentes/' +
                                                    _.autoCompleteResdientSelected!
                                                        .foto!,
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
                              _.autoCompleteResdientSelected!.fotoCredencial !=
                                      null
                                  ? Expanded(
                                      child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: BRAText(
                                            text:
                                                stringLocations.credentialPhoto,
                                            size: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        CachedNetworkImage(
                                          imageUrl:
                                              'https://storage.googleapis.com/pinlet/Credenciales/' +
                                                  _.autoCompleteResdientSelected!
                                                      .fotoCredencial!,
                                          height: 250,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ))
                                  : Container(),
                            ],
                          )
                        : Container(),
                    _.autoCompleteResdientSelected != null
                        ? SizedBox(
                            height:
                                (_.autoCompleteResdientSelected!.foto != null ||
                                        _.autoCompleteResdientSelected!
                                                .fotoCredencial !=
                                            null)
                                    ? 24
                                    : 0,
                          )
                        : Container(),
                    ResidentGateEntryForm(
                      residientNameGateResidenceController:
                          _.residientNameGateResidenceController,
                      residientNameGateResidenceFocusNode:
                          _.residientNameGateResidenceFocusNode,
                      primaryGateResidenceController:
                          _.primaryGateResidenceController,
                      previewResidentName: _.previewResdientName,
                      searched: _.searched,
                      clearPhotos: () {
                        _.searched = false;
                        _.previewResdientName = '';
                        _.autoCompleteResdientSelected = null;
                        _.update();
                      },
                      primaryGateResidenceFocusNode:
                          _.primaryGateResidenceFocusNode,
                      secundaryGateResidenceController:
                          _.secundaryGateResidenceController,
                      secundaryGateResidenceFocusNode:
                          _.secundaryGateResidenceFocusNode,
                      optionsBuilderName: (textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<ResidentResponse>.empty();
                        } else {
                          final residentFilter = _.getResidentInfo(
                              residntQueryTyp: ResidnetQueryType.name,
                              query: textEditingValue.text);
                          return residentFilter;
                        }
                      },
                      optionsBuilderPrimary: (textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<ResidentResponse>.empty();
                        } else {
                          final residentFilter = _.getResidentInfo(
                              residntQueryTyp: ResidnetQueryType.primary,
                              query: textEditingValue.text);
                          return residentFilter;
                        }
                      },
                      optionsBuilderSecundary: (textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<ResidentResponse>.empty();
                        } else {
                          final residentFilter = _.getResidentInfo(
                              residntQueryTyp: ResidnetQueryType.secundary,
                              query: textEditingValue.text);
                          return residentFilter;
                        }
                      },
                      autoCompleteResdient: (residentSelect,
                          residentNameController,
                          primaryController,
                          secundaryController) {
                        _.residientNameGateResidenceController =
                            residentNameController;
                        _.primaryGateResidenceController = primaryController;
                        _.secundaryGateResidenceController =
                            secundaryController;
                        _.autoCompleteResdient(resident: residentSelect);
                      },
                    ),
                    CustomTextFormField(
                      focusNode: _.licensePlateFocusNode,
                      onTap: () {},
                      label:
                          '${stringLocations.residentLicensePlate} ${stringLocations.optionalLabel}',
                      controller: _.licensePlateResdienteController,
                      onChanged: ((value) {
                        // _.lastName = value;
                      }),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    CustomTextFormField(
                      focusNode: _.descriptionFocusNode,
                      onTap: () {},
                      label:
                          '${stringLocations.observationsLabel} ${stringLocations.optionalLabel}',
                      controller: _.descriptionController,
                      onChanged: ((value) {
                        // _.phoneNumber = value;
                      }),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    BRAButton(
                      loadingButton: _.addLeaveLoading,
                      label: stringLocations.continueLabel,
                      onPressed: () {
                        if (_.formKeyResidentLeave.currentState!.validate()) {
                          _.formKeyResidentLeave.currentState!.save();
                          _.addEntrance();
                        }
                      },
                    )
                  ],
                )),
          );
        });
  }
}
