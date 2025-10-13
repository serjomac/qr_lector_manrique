import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_respose.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/invitations_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/entry_images_control.dart';
import 'package:qr_scaner_manrique/shared/widgets/option_autocomplete.dart';
import 'package:qr_scaner_manrique/shared/widgets/textfield_alert.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

// class ResidentGateEntryForm extends StatefulWidget {
//   final Function(ResidentResponse residentSelect) autoCompleteResident;
//   ResidentGateEntryForm({required this.autoCompleteResident});

//   @override
//   _ResidentGateEntryFormState createState() => _ResidentGateEntryFormState();
// }

class ResidentGateEntryForm extends StatelessWidget {
  Function(ResidentResponse residentSelect, TextEditingController nameResidenteTextEdditingController, TextEditingController primaryTextEdditingController, TextEditingController secundaryTextEdditingController) autoCompleteResdient;
  Function() clearPhotos;
  FutureOr<Iterable<ResidentResponse>> Function(TextEditingValue)
      optionsBuilderName;
  FutureOr<Iterable<ResidentResponse>> Function(TextEditingValue)
      optionsBuilderPrimary;
  FutureOr<Iterable<ResidentResponse>> Function(TextEditingValue)
      optionsBuilderSecundary;
  TextEditingController residientNameGateResidenceController =
      TextEditingController();
  TextEditingController primaryGateResidenceController =
      TextEditingController();
  TextEditingController secundaryGateResidenceController =
      TextEditingController();
  String previewResidentName;
  bool searched;
  // final TextEditingController residientNameGateResidenceController;
  // final TextEditingController primaryGateResidenceController;
  // final TextEditingController secundaryGateResidenceController;
  FocusNode residientNameGateResidenceFocusNode;
  FocusNode primaryGateResidenceFocusNode;
  FocusNode secundaryGateResidenceFocusNode;
  ResidentGateEntryForm(
      {required this.autoCompleteResdient,
      required this.primaryGateResidenceController,
      required this.clearPhotos,
      required this.secundaryGateResidenceController,
      required this.residientNameGateResidenceController,
      required this.primaryGateResidenceFocusNode,
      required this.previewResidentName,
      required this.searched,
      required this.secundaryGateResidenceFocusNode,
      required this.residientNameGateResidenceFocusNode,
      required this.optionsBuilderName,
      required this.optionsBuilderPrimary,
      required this.optionsBuilderSecundary});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final EdgeInsets padding = MediaQuery.of(context).viewInsets;
    final stringLocations =
        AppLocalizationsGenerator.appLocalizations(context: context);
    return Column(
      children: [
        Autocomplete<ResidentResponse>(
          optionsMaxHeight: 150,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            residientNameGateResidenceController = textEditingController;
            residientNameGateResidenceFocusNode = focusNode;
            return CustomTextFormField(
              focusNode: focusNode,
              controller: residientNameGateResidenceController,
              onTap: () {},
              validator: (val) {
                if (val!.isEmpty) {
                  return stringLocations.residentNameInputEmptyError;
                }
                return null;
              },
              label: stringLocations.residentNameLabel,
              onChanged: (value) {
                if (value.length < previewResidentName.length && searched) {
                  residientNameGateResidenceController.clear();
                  clearPhotos();
                }
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return OptionAutocomplete(
              options: options.toList(),
              onSelected: onSelected,
              listView: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: BRAText(
                        text: '${option.nombres} ${option.apellidos}',
                        size: 13,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          // optionsBuilder: (textEditingValue) {
          //   if (textEditingValue.text == '') {
          //     return const Iterable<ResidentResponse>.empty();
          //   } else {
          //     final residentFilter = _.getResidentInfo(
          //         residntQueryTyp: ResidnetQueryType.name,
          //         query: textEditingValue.text);
          //     return residentFilter;
          //   }
          // },
          optionsBuilder: optionsBuilderName,
          onSelected: (resident) {
            previewResidentName = '${resident.nombres} ${resident.apellidos}';
            searched = true;
            residientNameGateResidenceFocusNode.unfocus();
            primaryGateResidenceFocusNode.unfocus();
            secundaryGateResidenceFocusNode.unfocus();
            autoCompleteResdient(resident, residientNameGateResidenceController, primaryGateResidenceController, secundaryGateResidenceController);
            residientNameGateResidenceController.text =
                '${resident.nombres} ${resident.apellidos}';
            searched = true;
            primaryGateResidenceController.text = resident.nombrePrimario ?? '';
            secundaryGateResidenceController.text =
                resident.nombreSecundario ?? '';
          },
        ),
        SizedBox(
          height: 24,
        ),
        Autocomplete<ResidentResponse>(
          optionsMaxHeight: 150,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            primaryGateResidenceController = textEditingController;
            primaryGateResidenceFocusNode = focusNode;
            return CustomTextFormField(
                focusNode: focusNode,
                controller: textEditingController,
                onTap: () {},
                validator: (val) {
                  if (val!.isEmpty) {
                    return '${stringLocations.enterLabel} ${UserData.sharedInstance.placeSelected!.primario ?? ''}';
                  }
                  return null;
                },
                label: UserData.sharedInstance.placeSelected!.primario ?? '',
                onChanged: (val) {
                  primaryGateResidenceController.text = val;
                });
          },
          // displayStringForOption: (option) {
          //   return '${option.nombrePrimario} - ${option.firstName} ${option.firstLastName}';
          // },
          optionsViewBuilder: (context, onSelected, options) {
            return OptionAutocomplete(
              options: options.toList(),
              onSelected: onSelected,
              listView: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: BRAText(
                        text:
                            '${option.nombrePrimario} - ${option.firstName} ${option.firstLastName}',
                        size: 13,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          // optionsBuilder: (textEditingValue) {
          //   if (textEditingValue.text == '') {
          //     return const Iterable<ResidentResponse>.empty();
          //   } else {
          //     final residentFilter = _.getResidentInfo(
          //         residntQueryTyp: ResidnetQueryType.primary,
          //         query: textEditingValue.text);
          //     return residentFilter;
          //   }
          // },
          optionsBuilder: optionsBuilderPrimary,
          onSelected: (resident) {
            residientNameGateResidenceFocusNode.unfocus();
            primaryGateResidenceFocusNode.unfocus();
            secundaryGateResidenceFocusNode.unfocus();
            autoCompleteResdient(resident, residientNameGateResidenceController, primaryGateResidenceController, secundaryGateResidenceController);
            residientNameGateResidenceController.text =
                '${resident.nombres} ${resident.apellidos}';
            primaryGateResidenceController.text = resident.nombrePrimario ?? '';
            secundaryGateResidenceController.text =
                resident.nombreSecundario ?? '';
          },
        ),
        const SizedBox(
          height: 24,
        ),
        Autocomplete<ResidentResponse>(
          optionsMaxHeight: 150,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            secundaryGateResidenceController = textEditingController;
            secundaryGateResidenceFocusNode = focusNode;
            return CustomTextFormField(
                focusNode: focusNode,
                controller: textEditingController,
                onTap: () {},
                validator: (val) {
                  if (val!.isEmpty) {
                    return '${stringLocations.enterLabel} ${UserData.sharedInstance.placeSelected!.secundario ?? ''}';
                  }
                  return null;
                },
                label: UserData.sharedInstance.placeSelected!.secundario ?? '',
                onChanged: (val) {
                  secundaryGateResidenceController.text = val;
                });
          },
          optionsViewBuilder: (context, onSelected, options) {
            return OptionAutocomplete(
              options: options.toList(),
              onSelected: onSelected,
              listView: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: BRAText(
                        text:
                            '${option.nombreSecundario} - ${option.firstName} ${option.firstLastName}',
                        size: 13,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          // optionsBuilder: (textEditingValue) {
          //   if (textEditingValue.text == '') {
          //     return const Iterable<ResidentResponse>.empty();
          //   } else {
          //     final residentFilter = _.getResidentInfo(
          //         residntQueryTyp: ResidnetQueryType.secundary,
          //         query: textEditingValue.text);
          //     return residentFilter;
          //   }
          // },
          optionsBuilder: optionsBuilderSecundary,
          onSelected: (resident) {
            residientNameGateResidenceFocusNode.unfocus();
            primaryGateResidenceFocusNode.unfocus();
            secundaryGateResidenceFocusNode.unfocus();
            autoCompleteResdient(resident, residientNameGateResidenceController, primaryGateResidenceController, secundaryGateResidenceController);
            residientNameGateResidenceController.text =
                '${resident.nombres} ${resident.apellidos}';
            primaryGateResidenceController.text = resident.nombrePrimario ?? '';
            secundaryGateResidenceController.text =
                resident.nombreSecundario ?? '';
          },
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
