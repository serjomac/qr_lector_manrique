import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entry_response.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/entry_images_control.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/resident_gate_entry_form.dart';
import 'package:qr_scaner_manrique/shared/widgets/textfield_alert.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class VisitorEntryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final EdgeInsets padding = MediaQuery.of(context).viewInsets;
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    return GetBuilder<AddEntryFormController>(builder: (_) {
      return SingleChildScrollView(
        padding: padding.copyWith(bottom: 100 + padding.bottom),
        child: Form(
            key: _.formKeyVisitor,
            child: Column(
              children: [
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
                _.isInvitationOcational || _.isActionResidenceGate
                    ? Column(
                        children: [
                          CustomTextFormField(
                            focusNode: _.nameVisitorFocusNode,
                            onTap: () {},
                            label: '${stringLocations.nameGuestInputLabel} ${stringLocations.optionalLabel}',
                            controller: _.nameVisitorController,
                            // validator: (val) {
                            //   if (val!.isEmpty && _.isInvitationOcational) {
                            //     return 'Debe ingresar los nombres';
                            //   }
                            //   return null;
                            // },
                            onChanged: ((value) {
                              _.name = value;
                              _.update(['nameAlertMessage']);
                              if (_.isVisitorFormValidatedOnce) {
                                _.formKeyVisitor.currentState!.validate();
                                _.formKeyVisitor.currentState!.save();
                              }
                            }),
                          ),
                          GetBuilder<AddEntryFormController>(
                              id: 'nameAlertMessage',
                              builder: (context) {
                                return TextfieldAlertMessage(
                                  message:
                                      '${stringLocations.theGuestIsLabel} ${_.guessScanned?.nombreVisitante}',
                                  isShowAlertMessage:
                                      _.isShowDifferentNamesAlert,
                                );
                              }),
                          const SizedBox(
                            height: 22,
                          ),
                          CustomTextFormField(
                            focusNode: _.dniVisitorFocusNode,
                            onTap: () {},
                            // validator: (val) {
                            //   if (val!.isNotEmpty && val.length != 10) {
                            //     return 'Debe ingresar una cédula correcta';
                            //   }
                            //   return null;
                            // },
                            label: '${stringLocations.dniGuestInputLabel} ${stringLocations.optionalLabel}',
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
                              _.lastName = value;
                              _.update(['dniAlertMessage']);
                              if (_.isVisitorFormValidatedOnce) {
                                _.formKeyVisitor.currentState!.validate();
                                _.formKeyVisitor.currentState!.save();
                              }
                            }),
                          ),
                          GetBuilder<AddEntryFormController>(
                              id: 'invalidDniAlertMessage',
                              builder: (context) {
                                return TextfieldAlertMessage(
                                  message: stringLocations.dniGuestEmptyLabel,
                                  isShowAlertMessage: _.isInvalidDni,
                                );
                              }),
                          GetBuilder<AddEntryFormController>(
                              id: 'dniAlertMessage',
                              builder: (context) {
                                return TextfieldAlertMessage(
                                  message:
                                      '${stringLocations.theDniGuestIs} ${_.guessScanned?.cedulaVisitante}',
                                  isShowAlertMessage: _.isShowDifferentDniAlert,
                                );
                              }),
                          SizedBox(
                            height: 22,
                          ),
                          CustomTextFormField(
                            focusNode: _.focusNodeNatolionality,
                            onTap: () {},
                            label: '${stringLocations.nationalityGuestLabel} ${stringLocations.optionalLabel}',
                            controller: _.nationailtyVisitorController,
                            onChanged: ((value) {
                              _.lastName = value;
                            }),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          CustomTextFormField(
                            focusNode: _.focusNodeGender,
                            onTap: () {},
                            label: '${stringLocations.genderGuestLabel} ${stringLocations.optionalLabel}',
                            controller: _.genderVisitorController,
                            onChanged: ((value) {
                              _.lastName = value;
                            }),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                        ],
                      )
                    : Container(),
                // ======= CAMPOS PARA OCASIONAL Y RECURRENTE ========
                CustomTextFormField(
                  focusNode: _.licensePlateVisitorFocusNode,
                  onTap: () {},
                  label: '${stringLocations.guestLicensePlate} ${stringLocations.optionalLabel}',
                  controller: _.licensePlateVisitorController,
                  onChanged: ((value) {
                    _.lastName = value;
                  }),
                ),
                GetBuilder<AddEntryFormController>(
                  id: 'licensePlateAlertMessage',
                  builder: (context) {
                    return TextfieldAlertMessage(
                      message: '${stringLocations.theLicensePlateIs} ${_.guessScanned?.placaVisitante}',
                      isShowAlertMessage: _.isShowDifferentLicensePlateAlert,
                    );
                  },
                ),
                const SizedBox(
                  height: 22,
                ),
                CustomTextFormField(
                  focusNode: _.reasonFocusNode,
                  onTap: () {},
                  label: '${stringLocations.visitReasonLabel} ${stringLocations.optionalLabel}',
                  controller: _.reasonController,
                  onChanged: ((value) {
                    _.phoneNumber = value;
                  }),
                ),
                const SizedBox(
                  height: 22,
                ),
                CustomTextFormField(
                  focusNode: _.descriptionFocusNode,
                  onTap: () {},
                  label: '${stringLocations.observationsLabel} ${stringLocations.optionalLabel}',
                  controller: _.descriptionController,
                  onChanged: ((value) {
                    _.phoneNumber = value;
                  }),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            )),
      );
    });
  }
}
