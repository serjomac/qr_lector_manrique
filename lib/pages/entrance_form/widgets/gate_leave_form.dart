import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/textField/custom_text_form_field.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/widgets/entry_images_control.dart';
import 'package:qr_scaner_manrique/shared/widgets/control_images_list.dart';
import 'package:qr_scaner_manrique/shared/widgets/take_photo_card.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';

class GateLeaveForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final stringLocations = AppLocalizationsGenerator.appLocalizations(context: context);
    return GetBuilder<AddEntryFormController>(builder: (_) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: theme.own().component,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                  // controller: _.tabController,
                  unselectedLabelColor: theme.own().primareyTextColor,
                  labelStyle: TextStyle(color: Colors.white),
                  indicatorColor: theme.colorScheme.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: theme.own().secundaryTextColor,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  dividerHeight: 0,
                  tabs: [
                    Tab(
                      text: '${stringLocations.whoLeaveLabel}',
                    ),
                    Tab(
                      text: '${stringLocations.entryImagesLabel}',
                    ),
                  ]),
            ),
          ),
          body: TabBarView(children: [
            GetBuilder<AddEntryFormController>(builder: (_) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100),
                child: Form(
                    key: _.formKeyResident,
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
                        SizedBox(
                          height: 22,
                        ),
                        CustomTextFormField(
                          focusNode: _.licensePlateFocusNode,
                          onTap: () {},
                          label: '${stringLocations.licensePlateLabel} ${stringLocations.optionalLabel}',
                          controller: _.licensePlateLeavingController,
                          onChanged: ((value) {
                            _.lastName = value;
                          }),
                        ),
                        SizedBox(
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
            }),
            ControlImagesList(imagesList: _.guessScanned?.imagenes ?? [])
          ]),
        ),
      );
    });
  }
}
