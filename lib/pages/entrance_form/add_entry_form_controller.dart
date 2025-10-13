import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_binnacle.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_lector.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_managr.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/access_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/entrances_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/invitation_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/ocr_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/file_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entrance.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/invitation_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:path/path.dart' as path;
import 'package:qr_scaner_manrique/BRACore/models/response_models/orc_dni_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_respose.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/properties/properties_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/loading_dialog.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddEntryFormController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Datos del lector (opcional, cuando viene desde QR)
  final LectorResponse? lectorResponse;

  AddEntryFormController({this.lectorResponse});
  String name = '';
  String lastName = '';
  String email = '';
  String cardId = '';
  String phoneNumber = '';
  FocusNode nameFocusNode = new FocusNode();
  FocusNode nameVisitorFocusNode = new FocusNode();
  FocusNode dniVisitorFocusNode = new FocusNode();
  FocusNode lastnameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode cardIdFocusNode = new FocusNode();
  FocusNode descriptionFocusNode = new FocusNode();
  FocusNode reasonFocusNode = new FocusNode();
  FocusNode descriptionVisitorFocusNode = new FocusNode();
  FocusNode licensePlateFocusNode = new FocusNode();
  FocusNode licensePlateVisitorFocusNode = new FocusNode();
  FocusNode startDatePlateGuessFocusNode = new FocusNode();
  FocusNode endDatePlateGuessFocusNode = new FocusNode();
  FocusNode phoneNumerFocusNode = new FocusNode();
  FocusNode focusNodeGender = new FocusNode();
  FocusNode focusNodeNatolionality = new FocusNode();
  TextEditingController invitationTypeGuestController = TextEditingController();
  TextEditingController nameGuestController = TextEditingController();
  TextEditingController dniIdGuestController = TextEditingController();
  TextEditingController phoneNumberGuestController = TextEditingController();
  TextEditingController licensePlateGuestController = TextEditingController();
  TextEditingController descriptionGuestController = TextEditingController();
  TextEditingController startDateGuestController = TextEditingController();
  TextEditingController endDateGuestController = TextEditingController();
  TextEditingController dniIdController = TextEditingController();
  TextEditingController nameResdienteController = TextEditingController();
  TextEditingController primaryResdienteController = TextEditingController();
  TextEditingController secundaryResdienteController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController invitationTypeController = TextEditingController();
  TextEditingController phoneNumberResdienteController =
      TextEditingController();
  TextEditingController licensePlateResdienteController =
      TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TextEditingController nameVisitorController = TextEditingController();
  TextEditingController dniVisitorController = TextEditingController();
  TextEditingController nationailtyVisitorController = TextEditingController();
  TextEditingController genderVisitorController = TextEditingController();
  TextEditingController phoneNumberVisitorController = TextEditingController();
  TextEditingController licensePlateVisitorController = TextEditingController();
  TextEditingController licensePlateLeavingController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController residientNameGateResidenceController =
      TextEditingController();
  TextEditingController primaryGateResidenceController =
      TextEditingController();
  TextEditingController secundaryGateResidenceController =
      TextEditingController();
  FocusNode residientNameGateResidenceFocusNode = new FocusNode();
  FocusNode primaryGateResidenceFocusNode = new FocusNode();
  FocusNode secundaryGateResidenceFocusNode = new FocusNode();
  late TabController tabController;

  final GlobalKey<FormState> formKeyVisitor = GlobalKey();
  final GlobalKey<FormState> formKeyResident = GlobalKey();
  bool isVisitorFormValidatedOnce = false;
  bool isResidentFormValidatedOnce = false;
  LectorResponse? guessScanned;
  final ApiManager activityService = ApiManager();
  final ApiAuth apiAuth = ApiAuth();
  final ApiLector apiLector = ApiLector();
  RxBool loading = false.obs;
  RxBool validatingQrCodeLoading = false.obs;
  RxBool ocrLicensePlateLoading = false.obs;
  RxBool addEntryLoading = false.obs;
  RxBool isLoadingResidents = false.obs;
  RxBool isInvalidDni = false.obs;
  ApiBinnacle apiBinnacle = ApiBinnacle();
  bool invitationTypeIsHidden = false;
  String primaryTitle = '';
  String secundaryTitle = '';
  bool isHiddenNextButton = false;
  List<ResidentResponse> residentList = [];
  MainActionType mainActionType = MainActionType.qrScannerEntry;
  ResidentResponse? residentSelected;
  String gateIdSelected = '';
  TypeDoor typeDoor = TypeDoor.entrance;
  ApiManager apiManager = ApiManager();
  List<InvitationResponse> invitations = [];
  List<InvitationResponse> filterInvitations = [];
  bool isFiltering = false;
  RxBool loadingInvitations = false.obs;
  RxBool isShowInvalidDni = false.obs;
  FocusNode seachFocusNode = FocusNode();
  LectorResponse? savedGuest;
  MainActionType? savedMainActionType;
  String currrentDniVisitor = '';

  @override
  void onInit() async {
    final arguments = Get.arguments ?? {};
    await initializeDateFormatting('es', '');
    if (arguments['MainActionType'] != null) {
      mainActionType = arguments['MainActionType'] as MainActionType;
      update();
    }
    if (arguments['gateIdSelected'] != null) {
      gateIdSelected = arguments['gateIdSelected'] as String;
      update();
    }
    if (arguments['typeDoor'] != null) {
      typeDoor = arguments['typeDoor'] as TypeDoor;
    }
    
    // Si hay lectorResponse del constructor (viene de QR), úsalo
    if (lectorResponse != null) {
      guessScanned = lectorResponse;
    } else if (arguments['guessScanned'] != null) {
      guessScanned = arguments['guessScanned'] as LectorResponse;
    } else if (mainActionType == MainActionType.qrScannerEntry) {
      guessScanned = LectorResponse(
          apellidosResidente: 'Macias',
          cedulaResidente: '',
          cedulaVisitante: '',
          celularResidente: '',
          celularVisitante: '',
          codigo: '',
          correoResidente: '',
          estado: InvitationStatus.A,
          fechaCreacion: DateTime.now(),
          fechaInicio: DateTime.now(),
          fechaTermino: DateTime.now(),
          idCodigo: 0,
          idLugar: 0,
          idPrimario: 0,
          idPuerta: 0,
          idResidente: 0,
          idResidenteLugar: 0,
          idSecundario: 0,
          nombreLugar: '',
          nombrePrimario: '',
          nombreSecundario: '',
          nombreVisitante: 'Jonathan',
          nombresResidente: 'Jonathan',
          observacionVisitante: '',
          placaVisitante: '',
          primarioResidente: '',
          secundarioResidente: '',
          tipoCodigo: EntryTypeCode.IO,
          tipoVisitante: GuestType.anounce);
    }
    tabController =
        TabController(length: isActionResidenceGate ? 2 : 3, vsync: this);
    // tabController.addListener(() {
    //   // tabController.animateTo(2);
    // });
    setupView();
    if (isActionResidenceGate) {
      getAllResidents();
    }
    loadData();
    if (guessScanned?.tipoCodigo == EntryTypeCode.IO) {
      registerListener();
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if (mainActionType == MainActionType.gateEntryForm || isGateLeave) {
      return;
    }
    if (guessScanned!.tipoCodigo != EntryTypeCode.RE) {
      if (guessScanned!.estado != InvitationStatus.A) {
        showDialog(
          context: Get.overlayContext!,
          builder: (context) {
            return SuccessDialog(
              title: 'Informativo',
              subtitle:
                  'La invitactión ya ha sido usada, presione continuar si desea volver a usarla.',
              iconSvg: ConstantsIcons.alertIcon,
              primaryButtonText: 'Continuar',
              secondaryButtonText: 'Cancelar',
              onTapSecondaryButton: () {
                Get.back();
                Get.back();
              },
              onTapAcept: () {
                Get.back();
              },
            );
          },
        );
      } else {
        if (guessScanned!.fechaInicio!.isAfter(DateTime.now())) {
          showDialog(
            context: Get.overlayContext!,
            builder: (context) {
              return SuccessDialog(
                title: 'Informativo',
                subtitle:
                    'La invitactión aún no inicia, presione continuar si desea usarla antes de tiempo.',
                iconSvg: ConstantsIcons.alertIcon,
                primaryButtonText: 'Continuar',
                secondaryButtonText: 'Cancelar',
                onTapSecondaryButton: () {
                  Get.back();
                  Get.back();
                },
                onTapAcept: () {
                  Get.back();
                },
              );
            },
          );
        } else if (guessScanned!.fechaTermino!.isBefore(DateTime.now())) {
          showDialog(
            context: Get.overlayContext!,
            builder: (context) {
              return SuccessDialog(
                title: 'Informativo',
                subtitle:
                    'La invitactión ya está caducada, presione continuar si desea usarla.',
                iconSvg: ConstantsIcons.alertIcon,
                primaryButtonText: 'Continuar',
                secondaryButtonText: 'Cancelar',
                onTapSecondaryButton: () {
                  Get.back();
                  Get.back();
                },
                onTapAcept: () {
                  Get.back();
                },
              );
            },
          );
        }
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    dniVisitorFocusNode.removeListener(() {});
  }

  bool get isInvitationRecurrent {
    return guessScanned?.tipoCodigo == EntryTypeCode.IR;
  }

  bool get isInvitationOcational {
    return guessScanned?.tipoCodigo == EntryTypeCode.IO;
  }

  bool get isResidentEntry {
    return guessScanned?.tipoCodigo == EntryTypeCode.RE;
  }

  bool get isGateLeave {
    return mainActionType == MainActionType.gateLeave;
  }

  bool get isInvitationOcationalOrRecurrent {
    return guessScanned?.tipoCodigo == EntryTypeCode.IO ||
        guessScanned?.tipoCodigo == EntryTypeCode.IR;
  }
  
  bool get isProfilePhoto {
    return guessScanned?.photo != null;
  }
  
  bool get isCredentialPhoto {
    return guessScanned?.credentialPhoto != null;
  }

  bool get isActionResidenceGate {
    return mainActionType == MainActionType.gateEntryForm;
  }

  String get title {
    if (isActionResidenceGate) {
      return guessScanned?.tipoCodigo?.titlePage ?? '';
    } else if (isGateLeave) {
      return 'Formulario de salida';
    } else {
      return '';
    }
  }

  RxBool get isShowDifferentNamesAlert {
    if (isInvitationOcational &&
        nameVisitorController.text.isNotEmpty &&
        guessScanned!.nombreVisitante!.isNotEmpty) {
      final res =
          (nameVisitorController.text != (guessScanned!.nombreVisitante ?? ''))
              .obs;
      return res;
    } else {
      return false.obs;
    }
  }

  RxBool get isShowDifferentDniAlert {
    if (isInvitationOcational &&
        dniVisitorController.text.isNotEmpty &&
        guessScanned!.cedulaVisitante!.isNotEmpty) {
      final res =
          (dniVisitorController.text != (guessScanned!.cedulaVisitante ?? ''))
              .obs;
      return res;
    } else {
      return false.obs;
    }
  }

  RxBool get isShowDifferentLicensePlateAlert {
    if (isInvitationOcationalOrRecurrent &&
        licensePlateVisitorController.text.isNotEmpty &&
        guessScanned!.placaVisitante!.isNotEmpty) {
      final res = (licensePlateVisitorController.text !=
              (guessScanned!.placaVisitante ?? ''))
          .obs;
      return res;
    } else {
      return false.obs;
    }
  }

  registerListener() {
    dniVisitorFocusNode.addListener(() async {
      if (dniVisitorFocusNode.hasFocus) {
        isHiddenNextButton = true;
      } else {
        isHiddenNextButton = false;
      }
      if (!dniVisitorFocusNode.hasFocus &&
          dniVisitorController.text.isNotEmpty) {
        getPeopleData(dni: dniVisitorController.text);
      }
    });
  }

  loadData() {
    if (mainActionType == MainActionType.gateLeave) {
      licensePlateLeavingController.text = guessScanned?.placaVisitante ?? '';
    }
    if (isInvitationRecurrent || isInvitationOcational) {
      nameGuestController.text = guessScanned?.nombreVisitante ?? '';
      dniIdGuestController.text = guessScanned?.cedulaVisitante ?? '';
      phoneNumberGuestController.text = guessScanned?.celularVisitante ?? '';
      invitationTypeGuestController.text =
          guessScanned?.tipoVisitante?.value ?? '';
      licensePlateGuestController.text = guessScanned?.placaVisitante ?? '';
      startDateGuestController.text = DateFormat.yMMMMd('es')
              .format(guessScanned?.fechaInicio ?? DateTime.now()) +
          ' - ' +
          DateFormat.Hm().format(guessScanned?.fechaInicio ?? DateTime.now());
      endDateGuestController.text = DateFormat.yMMMMd('es')
              .format(guessScanned?.fechaTermino ?? DateTime.now()) +
          ' - ' +
          DateFormat.Hm().format(guessScanned?.fechaTermino ?? DateTime.now());
    }
    invitationTypeController.text = 'Residente';
    primaryTitle = guessScanned?.nombrePrimario ?? '';
    secundaryTitle = guessScanned?.nombreSecundario ?? '';
    primaryResdienteController.text = guessScanned?.primarioResidente ?? '';
    secundaryResdienteController.text = guessScanned?.secundarioResidente ?? '';
    name = guessScanned?.nombresResidente ?? '';
    lastName = guessScanned?.apellidosResidente ?? '';
    cardId = guessScanned?.cedulaVisitante ?? '';
    phoneNumber = guessScanned?.celularResidente ?? '';
    dniIdController.text = guessScanned?.cedulaResidente ?? '';
    nameResdienteController.text =
        '${guessScanned?.nombresResidente} ${guessScanned?.apellidosResidente}';
    nationalityController.text = '';
    phoneNumberResdienteController.text = guessScanned?.celularResidente ?? '';
    sexController.text = '';
    update();
  }

  getPeopleData({required String dni}) async {
    isInvalidDni.value = false;
    if (currrentDniVisitor == dni || dni.isEmpty) {
      return;
    } else if (dni.length != 10) {
      isInvalidDni.value = true;
      update(['invalidDniAlertMessage']);
      return;
    }
    currrentDniVisitor = dni;
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
  }

  updateUser() async {}

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
      String? entryId;
      String? residentPlaceId;
      EntryTypeCode? guessTypeCode;
      String? gateId;
      String? placeId;
      addEntryLoading.value = true;
      if (isActionResidenceGate) {
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
        names = nameVisitorController.text;
        dni = dniVisitorController.text;
        nationality = nationailtyVisitorController.text;
        gender = genderVisitorController.text;
        licencePlate = licensePlateVisitorController.text;
        activity = reasonController.text;
        gateId = gateIdSelected;
        placeId = UserData.sharedInstance.placeSelected!.idLugar.toString();
      } else if (isGateLeave) {
        addEntryLoading.value = true;
        guessTypeCode = guessScanned!.tipoCodigo;
        gateId = guessScanned!.idPuerta.toString();
        placeId = UserData.sharedInstance.placeSelected!.idLugar.toString();
        licencePlate = licensePlateLeavingController.text;
        entryId = guessScanned!.idCodigo.toString();
      } else {
        guessTypeCode = guessScanned!.tipoCodigo;
        gateId = guessScanned!.idPuerta.toString();
        placeId = guessScanned!.idLugar.toString();
        switch (guessScanned!.tipoCodigo) {
          case EntryTypeCode.IO:
            normalInvitationId = guessScanned!.idCodigo.toString();
            names = nameVisitorController.text;
            dni = dniVisitorController.text;
            nationality = nationailtyVisitorController.text;
            gender = genderVisitorController.text;
            licencePlate = licensePlateVisitorController.text;
            activity = reasonController.text;
            break;
          case EntryTypeCode.IR:
            recurrentInvitationId = guessScanned!.idCodigo.toString();
            names = nameGuestController.text;
            dni = dniIdGuestController.text;
            licencePlate = licensePlateGuestController.text;
            activity = reasonController.text;
            break;
          case EntryTypeCode.RE:
            residentPlaceId = guessScanned?.idResidenteLugar.toString();
            names = nameResdienteController.text;
            dni = dniIdController.text;
            licencePlate = licensePlateResdienteController.text;
            activity = reasonController.text;
            break;
          default:
            break;
        }
      }
      await apiBinnacle.addNormalEntrances(
        normalInvitationId: normalInvitationId,
        recurrentInvitationId: recurrentInvitationId,
        mainActionType: mainActionType,
        entryId: entryId,
        entryTypeCode: guessTypeCode,
        carIdImageFrontI: frontCarIdImagesFile,
        carIdImageBackI: backCarIdImagesFile,
        dniImageI: dniImagesFile,
        imageSelphiI: selphiImagesFile,
        residentePlaceId: residentPlaceId,
        entranceId: gateId,
        name: names,
        dni: dni,
        nationality: nationality,
        gender: gender,
        carId: licencePlate,
        accessType: (mainActionType == MainActionType.qrScannerEntry &&
                typeDoor == TypeDoor.entrance)
            ? AccessType.exit
            : AccessType.entrance,
        activity: activity,
        observation: descriptionController.text,
        entranceType: RegisterEntryType.qrCode,
        placeId: placeId,
      );
      addEntryLoading.value = false;
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return SuccessDialog(
            title: isActionResidenceGate
                ? 'Visitante registrado'
                : isGateLeave
                    ? 'Registro de salida'
                    : guessScanned?.tipoCodigo?.successEntryAddedTitle ?? '',
            iconSvg: ConstantsIcons.success,
            subtitle: isGateLeave
                ? 'La salida se guardó con éxtio'
                : guessScanned?.tipoCodigo?.successEntryAddedMessage,
            onTapAcept: () {
              Get.back();
              Get.back(result: isGateLeave);
            },
          );
        },
      );
    } on DioError catch (_) {
      addEntryLoading.value = false;
    }
  }

  File? dniImagesFile;
  File? selphiImagesFile;
  File? frontCarIdImagesFile;
  File? backCarIdImagesFile;

  Future<void> takePhoto({required PhotoType photoType}) async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (image == null) return;
    File imageTemporary = File(image.path);
    File compressedImage = await imageTemporary.ensureFileSize(1500000);
    int fileSizeInBytes = await compressedImage.length();
    double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
    log("El tamaño del archivo en MB es: ${fileSizeInMb.toStringAsFixed(2)} MB");
    String newPath = path.join(
      path.dirname(compressedImage.path),
      'image-${photoType.value}-${DateTime.now().millisecondsSinceEpoch}-${guessScanned?.nombreVisitante}',
    );
    compressedImage = await compressedImage.rename(newPath);
    switch (photoType) {
      case PhotoType.dni:
        dniImagesFile = compressedImage;
        if (dniVisitorController.text.isNotEmpty &&
            genderVisitorController.text.isNotEmpty &&
            nationailtyVisitorController.text.isNotEmpty &&
            nameVisitorController.text.isNotEmpty) {
          update(['form']);
          return;
        }
        if (isInvitationOcational && !isGateLeave) {
          final resOcrDni = await getOrc(
            ocrType: OcrType.dni,
            filepath: compressedImage.path,
          );
          final dniOrcResponse = ocrDniResponseFromJson(json.encode(resOcrDni));
          dniVisitorController.text = dniOrcResponse.cedula ?? '';
          nameVisitorController.text = dniOrcResponse.nombres ?? '';
          genderVisitorController.text = dniOrcResponse.desSexo ?? '';
          nationailtyVisitorController.text =
              dniOrcResponse.desNacionalid ?? '';
        }
        break;
      case PhotoType.selphi:
        selphiImagesFile = compressedImage;
        update(['form']);
        break;
      case PhotoType.frontLicensePlate:
        frontCarIdImagesFile = compressedImage;
        if (isResidentEntry) {
          if (licensePlateResdienteController.text.isEmpty) {
            final orcLincePlate = await getOrc(
              ocrType: OcrType.licensePlate,
              filepath: compressedImage.path,
            );
            licensePlateResdienteController.text = orcLincePlate['PLACA'];
            update(['form']);
          }
        } else {
          if (licensePlateVisitorController.text.isEmpty) {
            final orcLincePlate = await getOrc(
              ocrType: OcrType.licensePlate,
              filepath: compressedImage.path,
            );
            licensePlateVisitorController.text = orcLincePlate['PLACA'];
            update(['form']);
          }
        }
        break;
      case PhotoType.backLicensePlate:
        backCarIdImagesFile = compressedImage;
        if (isResidentEntry) {
          if (licensePlateResdienteController.text.isEmpty) {
            final orcLincePlate = await getOrc(
              ocrType: OcrType.licensePlate,
              filepath: compressedImage.path,
            );
            licensePlateResdienteController.text = orcLincePlate['PLACA'];
            update(['form']);
          }
        } else {
          if (licensePlateVisitorController.text.isEmpty) {
            final orcLincePlate = await getOrc(
              ocrType: OcrType.licensePlate,
              filepath: compressedImage.path,
            );
            licensePlateVisitorController.text = orcLincePlate['PLACA'];
            update(['form']);
          }
        }
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

  setupView() {
    invitationTypeIsHidden = true;
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
          return (e.nombres ?? '').toLowerCase().contains(query.toLowerCase());
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
    residientNameGateResidenceFocusNode.unfocus();
    primaryGateResidenceFocusNode.unfocus();
    secundaryGateResidenceFocusNode.unfocus();
    residentSelected = resident;
    residientNameGateResidenceController.text = resident.nombres ?? '';
    primaryGateResidenceController.text = resident.nombrePrimario ?? '';
    secundaryGateResidenceController.text = resident.nombreSecundario ?? '';
    update(['residentGateEntryForm']);
  }

  fetchNormalsInvitations() async {
    loadingInvitations.value = true;
    try {
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

  selectInvitation({required InvitationResponse invitation}) {
    savedMainActionType = mainActionType;
    final guest = LectorResponse(
        apellidosResidente: invitation.nombreResidente,
        cedulaResidente: invitation.celularResidente,
        cedulaVisitante: invitation.celular,
        celularResidente: invitation.celularResidente,
        celularVisitante: invitation.celular,
        estado: invitation.estado,
        fechaCreacion: invitation.fechaCreacion,
        fechaInicio: invitation.fechaInicio,
        fechaTermino: invitation.fechaTermino,
        idCodigo:
            invitation.idInvitacionNormal ?? invitation.idInvitacionRecurrente,
        idLugar: invitation.idLugar,
        idPuerta: int.parse(gateIdSelected),
        idResidente: invitation.idResidente,
        idResidenteLugar: invitation.idResidenteLugar,
        nombreLugar: invitation.nombreLugar,
        nombreVisitante: invitation.nombreInvitado,
        nombresResidente: invitation.nombreResidente,
        placaVisitante: invitation.placa,
        tipoCodigo: invitation.tipo == InvitationType.normal
            ? EntryTypeCode.IO
            : EntryTypeCode.IR,
        tipoVisitante: GuestType.anounce);
    guessScanned = guest;
    savedGuest = guessScanned;
    update();
    mainActionType = MainActionType.gateEntryInvitation;
    loadData();
  }

  back() {
    if (savedGuest != null && savedMainActionType != null) {
      guessScanned = savedGuest;
      mainActionType = savedMainActionType ?? MainActionType.gateEntryForm;
      savedGuest = null;
      savedMainActionType = null;
      // update();
      loadData();
      update();
    } else {
      Get.back();
    }
  }
}

enum ResidnetQueryType { name, primary, secundary }
