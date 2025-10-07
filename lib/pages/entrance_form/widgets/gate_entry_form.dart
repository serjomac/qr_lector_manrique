import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/string_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_respose.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/invitations_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/entry_images_control.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/resident_gate_entry_form.dart';
import 'package:qr_scaner_manrique/shared/widgets/preview_image.dart';
import 'package:qr_scaner_manrique/shared/widgets/textfield_alert.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class GateEntryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final EdgeInsets padding = MediaQuery.of(context).viewInsets;
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return GetBuilder<InvitationsControllers>(
        id: 'form',
        builder: (_) {
          return SingleChildScrollView(
            padding: padding.copyWith(bottom: 100 + padding.bottom),
            child: Form(
                key: _.formKeyVisitorGate,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Radio<EntryTypeCode>(
                                  activeColor: theme.primaryColor,
                                  value: EntryTypeCode.GA,
                                  groupValue: _.visitorType,
                                  onChanged: (value) {
                                    _.visitorType = value!;
                                  },
                                ),
                                BRAText(
                                  text: stringLocations.guestLabel,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Radio<EntryTypeCode>(
                                  activeColor: theme.primaryColor,
                                  value: EntryTypeCode.RE,
                                  groupValue: _.visitorType,
                                  onChanged: (value) {
                                    _.visitorType = value!;
                                  },
                                ),
                                BRAText(
                                  text: stringLocations.residentLabel,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    // ======= CAMPOS SOLO PARA OCASIONAL Y POR GARITA ========
                    _.visitorType == EntryTypeCode.GA
                        ? Column(
                            children: [
                              CustomTextFormField(
                                focusNode: _.dniVisitorFocusNode,
                                onTap: () {},
                                label:
                                    '${stringLocations.dniGuestInputLabel} ${stringLocations.optionalLabel}',
                                keyboardType: TextInputType.number,
                                suxffixIcon: InkWell(
                                  child: Icon(Icons.search),
                                  onTap: () {
                                    _.getPeopleData(
                                        dni: _.dniVisitorController.text);
                                    _.dniVisitorFocusNode.unfocus();
                                  },
                                ),
                                controller: _.dniVisitorController,
                                onChanged: ((value) {
                                  if (value.length < _.previewIdText.length &&
                                      _.searched) {
                                    _.dniVisitorController.clear();
                                  }
                                  _.previewIdText = value;
                                }),
                              ),
                              GetBuilder<InvitationsControllers>(
                                  id: 'dniAlertMessage',
                                  builder: (context) {
                                    return TextfieldAlertMessage(
                                      message:
                                          stringLocations.dniGuestEmptyLabel,
                                      isShowAlertMessage: _.isShowInvalidDni,
                                    );
                                  }),
                              // TextfieldAlertMessage(
                              //   message: 'Debe ingresar una cédula válida',
                              //   isShowAlertMessage: _.isShowInvalidDni,
                              // ),
                              SizedBox(
                                height: 22,
                              ),
                              CustomTextFormField(
                                focusNode: _.nameVisitorFocusNode,
                                onTap: () {},
                                label:
                                    '${stringLocations.nameGuestInputLabel} ${stringLocations.requiredLabel}',
                                controller: _.nameVisitorController,
                                validator: (value) {
                                  if (value == null) {
                                    return stringLocations
                                        .nameGuestInputEmptyError;
                                  } else if (value.isEmpty) {
                                    return stringLocations
                                        .nameGuestInputEmptyError;
                                  } else if (!value.isFullNanme) {
                                    return stringLocations
                                        .nameGuestInputIncompleteError;
                                  } else if (!value.validName) {
                                    return stringLocations
                                        .nameGuestInputInvalidError;
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: ((value) {
                                  if (value.length < _.previewNameText.length &&
                                      _.searched) {
                                    _.nameVisitorController.clear();
                                  }
                                  _.previewNameText = value;
                                }),
                              ),
                              const SizedBox(
                                height: 22,
                              ),
                              CustomTextFormField(
                                focusNode: _.focusNodeNatolionality,
                                onTap: () {},
                                label:
                                    '${stringLocations.nationalityGuestLabel} ${stringLocations.optionalLabel}',
                                controller: _.nationailtyVisitorController,
                                onChanged: ((value) {
                                  // _.lastName = value;
                                }),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              CustomTextFormField(
                                focusNode: _.focusNodeGender,
                                onTap: () {},
                                label:
                                    '${stringLocations.genderGuestLabel} ${stringLocations.optionalLabel}',
                                controller: _.genderVisitorController,
                                onChanged: ((value) {
                                  // _.lastName = value;
                                }),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                            ],
                          )
                        : Container(),
                    // ======= CAMPOS PARA OCASIONAL Y RECURRENTE ========
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
                      clearPhotos: () {
                        _.searched = false;
                        _.previewGenderText = '';
                        _.autoCompleteResdientSelected = null;
                        _.update();
                      },
                      autoCompleteResdient: (residentSelect, residentNameController, primaryController, secundaryController) {
                        _.residientNameGateResidenceController = residentNameController;
                        _.primaryGateResidenceController = primaryController;
                        _.secundaryGateResidenceController = secundaryController;
                        _.autoCompleteResdient(resident: residentSelect);
                      },
                    ),
                    CustomTextFormField(
                      focusNode: _.licensePlateVisitorFocusNode,
                      onTap: () {},
                      label: _.visitorType == EntryTypeCode.GA
                          ? '${stringLocations.guestLicensePlate} ${stringLocations.optionalLabel}'
                          : '${stringLocations.residentLicensePlate} ${stringLocations.optionalLabel}',
                      controller: _.licensePlateVisitorController,
                      onChanged: ((value) {
                        // _.lastName = value;
                      }),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    _.visitorType == EntryTypeCode.GA
                        ? CustomTextFormField(
                            focusNode: _.reasonFocusNode,
                            onTap: () {},
                            label:
                                '${stringLocations.visitReasonLabel} ${stringLocations.optionalLabel}',
                            controller: _.reasonController,
                            onChanged: ((value) {
                              // _.phoneNumber = value;
                            }),
                          )
                        : Container(),
                    _.visitorType == EntryTypeCode.GA
                        ? const SizedBox(
                            height: 22,
                          )
                        : Container(),
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
                    // _.isHiddenNextButton
                    //     ? Container()
                    BRAButton(
                      loadingButton: _.addEntryLoading,
                      label: stringLocations.continueLabel,
                      onPressed: () {
                        if (_.formKeyVisitorGate.currentState!.validate()) {
                          _.formKeyVisitorGate.currentState!.save();
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
