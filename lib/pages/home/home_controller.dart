import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_binnacle.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_lector.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_managr.dart';
import 'package:qr_scaner_manrique/BRACore/enums/access_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/entrances_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_childs_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_page.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/invitations_page.dart';
import 'package:qr_scaner_manrique/pages/entry_historic/entry_historic_page.dart';
import 'package:qr_scaner_manrique/pages/qr_scanner/ui/scan_camera.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/enums/registration_type.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/exit_without_qr_to_school_request_form_page.dart';
import 'package:qr_scaner_manrique/pages/school/pending_school_register/pending_school_register_page.dart';
import 'package:qr_scaner_manrique/pages/school/rappresentante_seleccion/representative_selection_page.dart';

class HomeController extends GetxController {
  ApiManager apiManager = ApiManager();
  ApiLector apiLector = ApiLector();
  ApiBinnacle apiBinnacle = ApiBinnacle();
  List<GateDoor> entrances = [];
  RxBool entrancesLoading = true.obs;
  RxBool validatingQrCodeLoading = false.obs;
  RxBool entranceFormLoading = false.obs;
  RxBool exitFormLoading = false.obs;
  GateDoor? entranceIdSelected;
  RxInt currentTab = 0.obs;
  PropertyEntryType propertyEntryType;

  HomeController({required this.propertyEntryType});

  void setInitialTab(int tab) {
    currentTab.value = tab;
    if (tab == 1) {
      Future.delayed(Duration.zero, () => scanCode());
    }
    update();
  }

  @override
  void onInit() {
    fetchEntrances(
      placeId: UserData.sharedInstance.placeSelected!.idLugar.toString(),
    );
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> scanCode() async {
    try {
      final result = await Get.to(
        const ScanCamera(),
        fullscreenDialog: true,
        duration: const Duration(milliseconds: 400),
      );
      log('RESPUESTA QR: ' + result.toString());
      if (result != null) {
        validateQrCodeUsing(
          qrCode: result,
          placeId: UserData.sharedInstance.placeSelected!.idLugar.toString(),
          entranceId: entranceIdSelected!.idPuerta.toString(),
          userId: UserData.sharedInstance.userLogin!.idUsuarioAdmin.toString(),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  showCamera() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
  }

  fetchEntrances({required String placeId}) async {
    try {
      entrancesLoading.value = true;
      entrances = await apiManager.fetchEntrances(placeId, propertyEntryType.doorType);
      entrancesLoading.value = false;
      entranceIdSelected = entrances[0];
      update();
    } on DioError catch (_) {
      entrancesLoading.value = false;
    }
  }

  validateQrCodeUsing({
    required String qrCode,
    required String placeId,
    required String entranceId,
    required String userId,
  }) async {
    try {
      validatingQrCodeLoading.value = true;
      
      if (propertyEntryType == PropertyEntryType.schoolGate) {
        // Para school gate, usar el método específico que devuelve ResidentChildsResponse
        final residentChildsRes = await apiLector.validateQrCodeForSchool(
          code: qrCode,
          placeId: placeId,
          entranceId: entranceId,
          userId: userId,
        );
        validatingQrCodeLoading.value = false;
        handleNavigationUsing(
          mainActionType: MainActionType.qrScannerEntry,
          arguments: {
            'residentChildsScanned': residentChildsRes,
            'typeDoor': entranceIdSelected!.tipoIngreso
          },
        );
      } else {
        // Para otros tipos, usar el método original que devuelve LectorResponse
        final res = await apiLector.validateQrCode(
          code: qrCode,
          placeId: placeId,
          entranceId: entranceId,
          userId: userId,
        );
        validatingQrCodeLoading.value = false;
        handleNavigationUsing(
          mainActionType: MainActionType.qrScannerEntry,
          arguments: {
            'guessScanned': res,
            'typeDoor': entranceIdSelected!.tipoIngreso
          },
        );
      }
    } catch (e) {
      validatingQrCodeLoading.value = false;
    }
  }

  handleNavigationUsing({
    required MainActionType mainActionType,
    Map<String, dynamic>? arguments,
  }) {
    if (propertyEntryType == PropertyEntryType.schoolGate) {
      switch (mainActionType) {
        case MainActionType.qrScannerEntry:
          final residentChildsResponse = arguments?['residentChildsScanned'] as ResidentChildsResponse?;
          Get.to(
            () => ExitWithoutQrToSchoolRequestFormPage(
              residentChildsResponse: residentChildsResponse ?? ResidentChildsResponse(),
              registrationType: RegistrationType.withoutQR,
              mainActionType: mainActionType,
            ),
          );
          break;
        case MainActionType.gateLeave:
          Get.to(
            () => PendingSchoolRegisterPage(
              entranceIdSelected: entranceIdSelected!,
              mainActionType: mainActionType,
            ),
          );
          break;
        case MainActionType.hisotric:
          Get.to(EntryHistoricPage(propertyEntryType: propertyEntryType), arguments: arguments);
          break;
        default:
          Get.to(
            () => RepresentativeSelectionPage(
              registrationType: RegistrationType.withoutQR,
              gateSelected: entranceIdSelected!,
              mainActionType: mainActionType,
            ),
          );
          break;
      }
    } else if (propertyEntryType == PropertyEntryType.residentGate) {
      switch (mainActionType) {
        case MainActionType.qrScannerEntry:
          Get.to(AddEntryFormPage(), arguments: arguments);
          break;
        case MainActionType.gateEntryForm:
          Get.to(InvitationsPage(), arguments: arguments);
          break;
        case MainActionType.gateLeave:
          Get.to(EntryHistoricPage(propertyEntryType: propertyEntryType), arguments: arguments);
          break;
        default:
          break;
      }
    } else if (propertyEntryType == PropertyEntryType.parkingLot) {
      // Get.to(() => ExitWithoutQrToParkingLotRequestFormPage());
    }
  }
}
