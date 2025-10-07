import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class GuesEntryInformativeForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    return GetBuilder<AddEntryFormController>(builder: (_) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
        child: Form(
          child: Column(
            children: [
              // const SizedBox(
              //   height: 22,
              // ),
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: BRAText(
              //     text: 'Información del invitado',
              //     size: 19,
              //   ),
              // ),
              const SizedBox(
                height: 22,
              ),
              // ======= INFORMACION VISITANTE ========
              Column(
                children: [
                  _.invitationTypeGuestController.text.isEmpty
                      ? Container()
                      : CustomTextFormField(
                          focusNode: FocusNode(),
                          onTap: () {},
                          enabled: false,
                          readOnly: true,
                          label: stringLocations.guestTypeLabel,
                          controller: _.invitationTypeGuestController,
                          onChanged: ((value) {
                            _.cardId = value;
                          }),
                        ),
                  SizedBox(
                    height: _.nameGuestController.text.isEmpty ? 0: 22,
                  ),
                  _.nameGuestController.text.isEmpty
                      ? Container()
                      : CustomTextFormField(
                          focusNode: _.nameFocusNode,
                          onTap: () {},
                          enabled: false,
                          readOnly: true,
                          label: stringLocations.nameGuestInputLabel,
                          controller: _.nameGuestController,
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
                    height: _.phoneNumberGuestController.text.isEmpty ? 0 : 22,
                  ),
                  _.phoneNumberGuestController.text.isEmpty
                      ? Container()
                      : CustomTextFormField(
                          focusNode: FocusNode(),
                          onTap: () {},
                          readOnly: true,
                          enabled: false,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return stringLocations.cellphoneGuestInputEmptyError;
                            }
                            return null;
                          },
                          label: stringLocations.cellphoneGuestLabel,
                          controller: _.phoneNumberGuestController,
                          onChanged: ((value) {
                            _.lastName = value;
                          }),
                        ),
                  SizedBox(
                    height: _.dniIdGuestController.text.isEmpty ? 0 : 22,
                  ),
                  _.dniIdGuestController.text.isEmpty
                      ? Container()
                      : CustomTextFormField(
                          focusNode: FocusNode(),
                          onTap: () {},
                          readOnly: true,
                          enabled: false,
                          label: stringLocations.dniGuestInputLabel,
                          controller: _.dniIdGuestController,
                          onChanged: ((value) {
                            _.lastName = value;
                          }),
                        ),
                  SizedBox(
                    height: _.licensePlateGuestController.text.isEmpty ? 0 : 22,
                  ),
                  _.licensePlateGuestController.text.isEmpty
                      ? Container()
                      : CustomTextFormField(
                          focusNode: _.licensePlateVisitorFocusNode,
                          onTap: () {},
                          enabled: false,
                          label: stringLocations.guestLicensePlate,
                          controller: _.licensePlateGuestController,
                          onChanged: ((value) {
                            _.lastName = value;
                          }),
                        ),
                  const SizedBox(
                    height: 22,
                  ),
                  CustomTextFormField(
                    focusNode: _.licensePlateVisitorFocusNode,
                    onTap: () {},
                    enabled: false,
                    label: stringLocations.sinceDate,
                    controller: _.startDateGuestController,
                    onChanged: ((value) {
                      _.lastName = value;
                    }),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  CustomTextFormField(
                    focusNode: _.licensePlateVisitorFocusNode,
                    onTap: () {},
                    enabled: false,
                    label: stringLocations.dueDate,
                    controller: _.endDateGuestController,
                    onChanged: ((value) {
                      _.lastName = value;
                    }),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
