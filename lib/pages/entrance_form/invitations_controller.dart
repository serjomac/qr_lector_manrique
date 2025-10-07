import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_binnacle.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_lector.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_managr.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/access_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/entrances_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/invitation_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/ocr_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/file_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/invitation_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/orc_dni_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_respose.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_page.dart';
import 'package:qr_scaner_manrique/pages/home/home_page.dart';
import 'package:qr_scaner_manrique/pages/properties/properties_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/loading_dialog.dart';
import 'package:path/path.dart' as path;
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';

enum VisitorType { guest, resident }

class InvitationsControllers extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiManager apiManager = ApiManager();
  final ApiAuth apiAuth = ApiAuth();
  final ApiLector apiLector = ApiLector();
  final ApiBinnacle apiBinnacle = ApiBinnacle();

  List<InvitationResponse> invitations = [];
  List<InvitationResponse> filterInvitations = [];
  List<ResidentResponse> residentList = [];

  bool searched = false;

  String previewIdText = '';
  String previewResdientName = '';
  String previewNameText = '';
  String previewGenderText = '';
  String previewGuestNameText = '';
  String previewPrimario1Text = '';
  String previewPrimario2Text = '';

  bool isFiltering = false;
  RxBool loadingInvitations = false.obs;
  RxBool addEntryLoading = false.obs;

  String? gateIdSelected;

  ResidentResponse? residentSelected;

  final GlobalKey<FormState> formKeyVisitorGate = GlobalKey();
  final GlobalKey<FormState> formKeyResident = GlobalKey();

  RxBool ocrLicensePlateLoading = false.obs;
  RxBool isLoadingResidents = false.obs;

  EntryTypeCode _visitorType = EntryTypeCode.GA;

  FocusNode nameVisitorFocusNode = new FocusNode();
  FocusNode dniVisitorFocusNode = new FocusNode();
  FocusNode descriptionFocusNode = new FocusNode();
  FocusNode reasonFocusNode = new FocusNode();
  FocusNode descriptionVisitorFocusNode = new FocusNode();
  FocusNode licensePlateVisitorFocusNode = new FocusNode();
  FocusNode focusNodeGender = new FocusNode();
  FocusNode focusNodeNatolionality = new FocusNode();
  FocusNode seachFocusNode = FocusNode();
  FocusNode residientNameGateResidenceFocusNode = new FocusNode();
  FocusNode primaryGateResidenceFocusNode = new FocusNode();
  FocusNode secundaryGateResidenceFocusNode = new FocusNode();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameVisitorController = TextEditingController();
  TextEditingController dniVisitorController = TextEditingController();
  TextEditingController nationailtyVisitorController = TextEditingController();
  TextEditingController genderVisitorController = TextEditingController();
  TextEditingController licensePlateVisitorController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController residientNameGateResidenceController =
      TextEditingController();
  TextEditingController primaryGateResidenceController =
      TextEditingController();
  TextEditingController secundaryGateResidenceController =
      TextEditingController();
  late TabController tabController;

  File? dniImagesFile;
  File? selphiImagesFile;
  File? frontCarIdImagesFile;
  File? backCarIdImagesFile;

  ResidentResponse? autoCompleteResdientSelected;

  RxBool isShowInvalidDni = false.obs;

  String currrentDniVisitor = '';

  EntryTypeCode get visitorType {
    return _visitorType;
  }

  set visitorType(EntryTypeCode visitorType) {
    _visitorType = visitorType;
    autoCompleteResdientSelected = null;
    update(['form']);
  }

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this);
    await initializeDateFormatting('es', '');
    fetchNormalsInvitations();
    getAllResidents();
    final arguments = Get.arguments ?? {};
    if (arguments['gateIdSelected'] != null) {
      gateIdSelected = arguments['gateIdSelected'] as String;
      update();
    }
    registerListener();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  fetchNormalsInvitations() async {
    loadingInvitations.value = true;
    filterInvitations = [];
    try {
      String endpoint = '';
      final res = await apiManager.fetchNormalInvitations(
        placeId: UserData.sharedInstance.placeSelected!.idLugar.toString(),
      );
      invitations.addAll(res);
      fetchRecurrentInvitations();
      update();
    } on DioError catch (_) {
      loadingInvitations.value = false;
    }
  }

  fetchRecurrentInvitations() async {
    try {
      final res = await apiManager.fetchRecurrentInvitations(
          UserData.sharedInstance.placeSelected!.idLugar.toString());
      invitations.addAll(res);
      loadingInvitations.value = false;
      update();
    } on DioError catch (_) {
      loadingInvitations.value = false;
    }
  }

  getFilterInvitations({required String query}) {
    filterInvitations = [];
    query = query.toLowerCase();
    if (query.isEmpty) {
      filterInvitations = [];
      isFiltering = false;
    } else {
      filterInvitations = invitations.where(
        (e) {
          return e.nombreInvitado!.toLowerCase().contains(query) ||
              e.nombreResidente!.toLowerCase().contains(query) ||
              (e.cedula ?? '').toLowerCase().contains(query) ||
              // (e.celularResidente ?? '').toLowerCase().contains(query) ||
              (e.celular ?? '').toLowerCase().contains(query);
          // (e.celularResidente ?? '').toLowerCase().contains(query);
        },
      ).toList();
      isFiltering = true;
    }
    update();
  }

  registerListener() {
    dniVisitorFocusNode.addListener(() async {
      if (!dniVisitorFocusNode.hasFocus &&
          dniVisitorController.text.isNotEmpty) {
        getPeopleData(dni: dniVisitorController.text);
      }
    });
  }

  getPeopleData({required String dni}) async {
    if (currrentDniVisitor == dni || dni.isEmpty) {
      return;
    } else if (dni.length != 10) {
      isShowInvalidDni.value = true;
      update(['dniAlertMessage']);
      return;
    }
    currrentDniVisitor = dni;
    isShowInvalidDni.value = false;
    update(['dniAlertMessage']);
    showLoadingDialog(
      context: Get.overlayContext!,
      message:
          'Estamos obteniendo la infomación de la cédula, por favor espere',
    );
    final res = await apiAuth.getPeopleDataBy(dniVisitorController.text);
    Get.back();
    nameVisitorController.text = res.nombres ?? '';
    genderVisitorController.text = res.desSexo ?? '';
    nationailtyVisitorController.text = res.desNacionalid ?? '';
    previewNameText = nameVisitorController.text;
    previewGenderText = genderVisitorController.text;
    searched = true;
  }

  getAllResidents() async {
    try {
      isLoadingResidents.value = true;
      final res = await apiBinnacle.getAllResidentsByPlace(
        UserData.sharedInstance.placeSelected!.idLugar.toString(),
      );
      residentList = res;
      isLoadingResidents.value = false;
    } on DioError catch (_) {
      isLoadingResidents.value = false;
    }
  }

  Iterable<ResidentResponse> getResidentInfo(
      {required ResidnetQueryType residntQueryTyp, required String query}) {
    switch (residntQueryTyp) {
      case ResidnetQueryType.name:
        return residentList.where((e) {
          return (e.nombres ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (e.apellidos ?? '').toLowerCase().contains(query.toLowerCase());
        });
      case ResidnetQueryType.primary:
        return residentList.where((e) {
          return (e.nombrePrimario ?? '')
              .toLowerCase()
              .contains(query.toLowerCase());
        });
      case ResidnetQueryType.secundary:
        return residentList.where((e) {
          return (e.nombreSecundario ?? '')
              .toLowerCase()
              .contains(query.toLowerCase());
        });
    }
  }

  autoCompleteResdient({required ResidentResponse resident}) {
    previewResdientName = '${resident.nombres} ${resident.apellidos}';
    searched = true;
    autoCompleteResdientSelected = resident;
    residientNameGateResidenceFocusNode.unfocus();
    primaryGateResidenceFocusNode.unfocus();
    secundaryGateResidenceFocusNode.unfocus();
    residentSelected = resident;
    residientNameGateResidenceController.text =
        '${resident.nombres} ${resident.apellidos}';
    primaryGateResidenceController.text = resident.nombrePrimario ?? '';
    secundaryGateResidenceController.text = resident.nombreSecundario ?? '';
    update();
  }

  selectInvitation({required InvitationResponse invitation}) {
    final guest = LectorResponse(
        apellidosResidente: '',
        cedulaVisitante: invitation.cedula,
        celularResidente: invitation.celularResidente,
        celularVisitante: invitation.celular,
        estado: invitation.estado,
        fechaCreacion: invitation.fechaCreacion,
        fechaInicio: invitation.fechaInicio,
        fechaTermino: invitation.fechaTermino,
        idCodigo:
            invitation.idInvitacionNormal ?? invitation.idInvitacionRecurrente,
        idLugar: invitation.idLugar,
        idPuerta: int.parse(gateIdSelected ?? ''),
        idResidente: invitation.idResidente,
        idResidenteLugar: invitation.idResidenteLugar,
        nombreLugar: invitation.nombreLugar,
        nombreVisitante: invitation.nombreInvitado,
        nombresResidente: invitation.nombreResidente,
        placaVisitante: invitation.placa,
        tipoCodigo: invitation.tipo == InvitationType.normal
            ? EntryTypeCode.IO
            : EntryTypeCode.IR,
        tipoVisitante: invitation.tipoInvitado);
    Get.to(AddEntryFormPage(), arguments: {
      'MainActionType': MainActionType.gateEntryInvitation,
      'guessScanned': guest
    });
  }

  Future<void> takePhoto({required PhotoType photoType}) async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (image == null) return;
    File imageTemporary = File(image.path);
    File compressedImage = await imageTemporary.ensureFileSize(1500000);
    int fileSizeInBytes = await compressedImage.length();
    double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
    print(
        "El tamaño del archivo en MB es: ${fileSizeInMb.toStringAsFixed(2)} MB");
    String newPath = path.join(
      path.dirname(compressedImage.path),
      'image-${photoType.value}-${DateTime.now().millisecondsSinceEpoch}-${nameVisitorController.text}',
    );
    compressedImage = await compressedImage.rename(newPath);
    switch (photoType) {
      case PhotoType.dni:
        dniImagesFile = compressedImage;
        if (visitorType == EntryTypeCode.RE) {
          update(['form']);
          return;
        }
        if (dniVisitorController.text.isNotEmpty &&
            genderVisitorController.text.isNotEmpty &&
            nationailtyVisitorController.text.isNotEmpty &&
            nameVisitorController.text.isNotEmpty) {
          update(['form']);
          return;
        }
        final resOcrDni = await getOrc(
          ocrType: OcrType.dni,
          filepath: compressedImage.path,
        );
        final dniOrcResponse = ocrDniResponseFromJson(json.encode(resOcrDni));
        dniVisitorController.text = dniOrcResponse.cedula ?? '';
        nameVisitorController.text = dniOrcResponse.nombres ?? '';
        genderVisitorController.text = dniOrcResponse.desSexo ?? '';
        nationailtyVisitorController.text = dniOrcResponse.desNacionalid ?? '';
        break;
      case PhotoType.selphi:
        selphiImagesFile = compressedImage;
        update(['form']);
        break;
      case PhotoType.frontLicensePlate:
        frontCarIdImagesFile = compressedImage;
        if (licensePlateVisitorController.text.isEmpty) {
          final orcLincePlate = await getOrc(
            ocrType: OcrType.licensePlate,
            filepath: compressedImage.path,
          );
          licensePlateVisitorController.text = orcLincePlate['PLACA'];
          update(['form']);
        }
        break;
      case PhotoType.backLicensePlate:
        backCarIdImagesFile = compressedImage;
        if (licensePlateVisitorController.text.isEmpty) {
          final orcLincePlate = await getOrc(
            ocrType: OcrType.licensePlate,
            filepath: compressedImage.path,
          );
          licensePlateVisitorController.text = orcLincePlate['PLACA'];
          update(['form']);
        }
        update(['form']);
        break;
    }
    update(['form']);
  }

  Future<dynamic> getOrc(
      {required OcrType ocrType, required String filepath}) async {
    try {
      ocrLicensePlateLoading.value = true;
      showLoadingDialog(
        context: Get.overlayContext!,
        message: ocrType.dialogMessage,
      );
      final res = await apiLector.ocrLector(
        filePath: filepath,
        ocrType: ocrType,
        placeId: UserData.sharedInstance.placeSelected!.idLugar.toString(),
      );
      Get.back();
      ocrLicensePlateLoading.value = false;
      return res;
    } catch (e) {}
    ocrLicensePlateLoading.value = false;
    Get.back();
  }

  addEntrance() async {
    try {
      String names = '';
      String dni = '';
      String nationality = '';
      String gender = '';
      String licencePlate = '';
      String activity = '';
      String? normalInvitationId;
      String? recurrentInvitationId;
      String? residentPlaceId;
      String? gateId;
      String? placeId;
      if (residentSelected == null) {
        showDialog(
          context: Get.overlayContext!,
          builder: (context) {
            return SuccessDialog(
              title: 'Informativo',
              subtitle: 'Debe seleccionar un residente válido.',
              iconSvg: ConstantsIcons.alertIcon,
              onTapAcept: () {
                Get.back();
              },
            );
          },
        );
        return;
      }
      addEntryLoading.value = true;
      residentPlaceId = residentSelected?.idResidenteLugar.toString();
      gateId = gateIdSelected;
      placeId = UserData.sharedInstance.placeSelected!.idLugar.toString();
      names = nameVisitorController.text;
      dni = dniVisitorController.text;
      nationality = nationailtyVisitorController.text;
      gender = genderVisitorController.text;
      licencePlate = licensePlateVisitorController.text;
      activity = reasonController.text;
      await apiBinnacle.addNormalEntrances(
        normalInvitationId: normalInvitationId,
        recurrentInvitationId: recurrentInvitationId,
        mainActionType: MainActionType.gateEntryResident,
        carIdImageFrontI: frontCarIdImagesFile,
        carIdImageBackI: backCarIdImagesFile,
        dniImageI: dniImagesFile,
        imageSelphiI: selphiImagesFile,
        residentePlaceId: residentPlaceId,
        entryTypeCode: visitorType,
        entranceId: gateId ?? '',
        name: names,
        dni: dni,
        nationality: nationality,
        gender: gender,
        carId: licencePlate,
        accessType: AccessType.entrance,
        activity: activity,
        observation: descriptionController.text,
        entranceType: RegisterEntryType.qrCode,
        placeId: placeId,
      );
      addEntryLoading.value = false;
      await showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return SuccessDialog(
            title: visitorType.successEntryAddedTitle,
            iconSvg: ConstantsIcons.success,
            subtitle: visitorType.successEntryAddedMessage,
            onTapAcept: () {
              Get.back();
              // Get.back();
            },
          );
        },
      );
      cleanForm();
    } on DioError catch (_) {
      addEntryLoading.value = false;
    }
  }

  cleanForm() {
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        residentSelected = null;
        autoCompleteResdientSelected = null;
        residientNameGateResidenceController.text = '';
        residientNameGateResidenceController.clear();
        primaryGateResidenceController.text = '';
        secundaryGateResidenceController.text = '';
        searched = false;
        dniVisitorController.text = '';
        nameVisitorController.text = '';
        nationailtyVisitorController.text = '';
        genderVisitorController.text = '';
        reasonController.text = '';
        previewResdientName = '';
        dniImagesFile = null;
        selphiImagesFile = null;
        frontCarIdImagesFile = null;
        backCarIdImagesFile = null;
        update();
      },
    );
  }
}
