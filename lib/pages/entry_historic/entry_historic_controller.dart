import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_binnacle.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_lector.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_school.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/history_school_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_childs_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/pending_school_regiter_response.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/enums/registration_type.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/exit_without_qr_to_school_request_form_page.dart';
import 'package:qr_scaner_manrique/BRACore/constants/constants-icons.dart';
import 'package:qr_scaner_manrique/BRACore/enums/access_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/entrances_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/ocr_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/file_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/entry_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_respose.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_controller.dart';
import 'package:qr_scaner_manrique/pages/entrance_form/add_entry_form_page.dart';
import 'package:qr_scaner_manrique/pages/entry_historic/visit_information_images.dart';
import 'package:path/path.dart' as path;
import 'package:qr_scaner_manrique/pages/properties/properties_page.dart';
import 'package:qr_scaner_manrique/shared/widgets/loading_dialog.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';
import 'package:qr_scaner_manrique/utils/AppLocations.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterLastDay {
  final String title;
  final int value;
  FilterLastDay({required this.title, required this.value});
}

class EntryTypeHistoric {
  final String title;
  final EntryTypeCode value;
  EntryTypeHistoric({required this.title, required this.value});
}

class EntryHistoricController extends GetxController {
  final ApiBinnacle apiBinnacle = ApiBinnacle();
  final ApiSchool apiSchool = ApiSchool();

  final PropertyEntryType? propertyEntryType;
  
  EntryHistoricController({this.propertyEntryType});

  RxBool loadingEntries = false.obs;
  RxBool addLeaveLoading = false.obs;
  RxBool isLoadingResidents = false.obs;

  bool isFiltering = false;

  FocusNode seachFocusNode = FocusNode();

  final ApiLector apiLector = ApiLector();

  bool get isEnglishLanguage {
    return AppLocalizationsGenerator.languageCode == 'en';
  }

  List<EntryResponse> filterEntries = [];
  List<EntryResponse> entries = [];
  List<HistorySchoolResponse> schoolHistoryEntries = [];
  List<HistorySchoolResponse> filterSchoolHistoryEntries = [];
  List<ResidentResponse> residentList = [];
  
  // Lista original de entradas de escuela (sin filtrar ni agrupar)
  List<HistorySchoolResponse> _allSchoolHistoryEntries = [];
  
  // Estado de agrupación para schoolGate
  RxBool isGrouped = false.obs;

  List<EntryTypeHistoric> entryTypeCode = [];

  MainActionType mainActionType = MainActionType.hisotric;

  DateTime startDate = DateTime.now().subtract(Duration(days: 1));
  DateTime endDate = DateTime.now();
  DateTime endDateTemprary = DateTime.now();

  ResidentResponse? autoCompleteResdientSelected;

  // PickerDateRange? rangeSelectorDate;

  List<FilterLastDay> filterLastDay = [];

  String gateIdSelected = '';

  FilterLastDay? _lasDaysSelected;

  EntryTypeCode _entryTypeSelected = EntryTypeCode.TD;

  File? dniImagesFile;
  File? selphiImagesFile;
  File? frontCarIdImagesFile;
  File? backCarIdImagesFile;

  bool searched = false;
  String previewResdientName = '';
  String currentSearchQuery = ''; // Variable para mantener el query actual

  TextEditingController descriptionController = TextEditingController();
  TextEditingController licensePlateResdienteController =
      TextEditingController();
  TextEditingController residientNameGateResidenceController =
      TextEditingController();
  TextEditingController primaryGateResidenceController =
      TextEditingController();
  TextEditingController secundaryGateResidenceController =
      TextEditingController();

  FocusNode licensePlateFocusNode = new FocusNode();
  FocusNode descriptionFocusNode = new FocusNode();
  FocusNode residientNameGateResidenceFocusNode = new FocusNode();
  FocusNode primaryGateResidenceFocusNode = new FocusNode();
  FocusNode secundaryGateResidenceFocusNode = new FocusNode();

  String primaryTitle = '';
  String secundaryTitle = '';
  String name = '';
  final GlobalKey<FormState> formKeyResidentLeave = GlobalKey();

  ResidentResponse? residentSelected;

  String get tite {
    switch (mainActionType) {
      case MainActionType.hisotric:
        return isEnglishLanguage
            ? 'Entry and Exit History'
            : 'Historial de ingresos y salidas';
      default:
        return 'Registrar salida';
    }
  }

  set lasDaysSelected(FilterLastDay? filterLastDay) {
    _lasDaysSelected = filterLastDay;
    endDate = DateTime.now();
    endDateTemprary = DateTime.now();
    startDate = endDate.subtract(Duration(days: filterLastDay?.value ?? 7));
    fetchEntries();
  }

  FilterLastDay? get lasDaysSelected {
    return _lasDaysSelected;
  }

  set entryTypeSelected(EntryTypeCode entryTypeSelected) {
    filterEntries = [];
    isFiltering = false;
    _entryTypeSelected = entryTypeSelected;
    fetchEntries();
  }

  EntryTypeCode get entryTypeSelected {
    return _entryTypeSelected;
  }

  String get rangeDateDescription {
    return '${DateFormat.yMMMd('ES').format(startDate)} - ${DateFormat.yMMMd('ES').format(endDate)}';
  }

  bool get isGateLeave {
    return mainActionType == MainActionType.gateLeave;
  }

  @override
  void onInit() async {
    await initializeDateFormatting('es', '');
    entryTypeCode = [
      EntryTypeHistoric(
          title: isEnglishLanguage ? 'All' : 'Todos', value: EntryTypeCode.TD),
      EntryTypeHistoric(
          title: isEnglishLanguage ? 'Ocationals' : 'Ocasionales',
          value: EntryTypeCode.IO),
      EntryTypeHistoric(
          title: isEnglishLanguage ? 'Recurrents' : 'Recurrentes',
          value: EntryTypeCode.IR),
      EntryTypeHistoric(
          title: isEnglishLanguage ? 'Gate' : 'Garita',
          value: EntryTypeCode.GA),
    ];
    filterLastDay = [
      FilterLastDay(
          title: isEnglishLanguage ? 'Last day' : 'Último día', value: 1),
      FilterLastDay(
          title: isEnglishLanguage ? 'Last 3 days' : 'Últimos 3 días',
          value: 3),
      FilterLastDay(
          title: isEnglishLanguage ? 'Last 5 days' : 'Últimos 5 días',
          value: 5),
      FilterLastDay(
          title: isEnglishLanguage ? 'Last 7 days' : 'Últimos 7 días',
          value: 7),
    ];
    // rangeSelectorDate =
    //     PickerDateRange(startDate, startDate.add(Duration(days: 7)));
    _lasDaysSelected = filterLastDay[0];
    final arguments = Get.arguments;
    if (arguments['mainActionType'] != null) {
      mainActionType = arguments['mainActionType'] as MainActionType;
    }
    if (arguments['gateIdSelected'] != null) {
      gateIdSelected = arguments['gateIdSelected'] as String;
    }
    fetchEntries();
    getAllResidents();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  fetchEntries() async {
    try {
      loadingEntries.value = true;
      entries = [];
      schoolHistoryEntries = [];
      
      if (propertyEntryType == PropertyEntryType.schoolGate) {
        // Llamar al servicio getAllColegioHistorial para schoolGate
        final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        // Get doorId from navigation arguments
        final arguments = Get.arguments as Map<String, dynamic>?;
        final doorId = arguments?['gateIdSelected']?.toString() ?? "";
        
        _allSchoolHistoryEntries = await apiSchool.getAllColegioHistorial(
          placeId: UserData.sharedInstance.placeSelected!.idLugar.toString(),
          doorId: doorId,
          idUserAdmin: UserData.sharedInstance.userLogin!.idUsuarioAdmin.toString(),
          startDate: formatter.format(startDate),
          endDate: formatter.format(endDate),
        );
        
        // Aplicar agrupación si está habilitada
        if (isGrouped.value) {
          schoolHistoryEntries = _groupByRepresentative(_allSchoolHistoryEntries);
        } else {
          schoolHistoryEntries = List.from(_allSchoolHistoryEntries);
        }
      } else {
        // Comportamiento original para otros tipos
        entries = await apiBinnacle.fetchAllEntries(
            mainActionType: mainActionType,
            startDate: startDate,
            endDate: endDate,
            placeId: UserData.sharedInstance.placeSelected!.idLugar.toString(),
            entryTypeCode: entryTypeSelected);
      }
      
      loadingEntries.value = false;
      update();
    } on DioError catch (_) {
      loadingEntries.value = false;
    }
  }

  // Método que sigue la misma lógica que PendingSchoolRegisterController.filterRegisters()
  filterSchoolEntries({required String query}) {
    currentSearchQuery = query; // Guardar el query actual
    filterEntries = [];
    filterSchoolHistoryEntries = [];
    
    if (propertyEntryType == PropertyEntryType.schoolGate) {
      // Usar la misma lógica que PendingSchoolRegisterController.filterRegisters()
      List<HistorySchoolResponse> filteredList;
      
      if (query.isEmpty) {
        filteredList = List.from(_allSchoolHistoryEntries);
        isFiltering = false;
      } else {
        query = query.toLowerCase();
        filteredList = _allSchoolHistoryEntries.where((entry) {
          final nombreHijo = (entry.nombreHijo ?? '').toLowerCase();
          final nombreCategoria = (entry.nombreCategoria ?? '').toLowerCase();
          final nombresResidente = (entry.nombresResidente ?? '').toLowerCase();
          final apellidosResidente = (entry.apellidosResidente ?? '').toLowerCase();
          final nombreRetira = (entry.nombreRetira ?? '').toLowerCase();
          final cedulaRetira = (entry.cedulaRetira ?? '').toLowerCase();
          
          return nombreHijo.contains(query) ||
                 nombreCategoria.contains(query) ||
                 nombresResidente.contains(query) ||
                 apellidosResidente.contains(query) ||
                 nombreRetira.contains(query) ||
                 cedulaRetira.contains(query);
        }).toList();
        isFiltering = true;
      }
      
      // Apply grouping if enabled
      if (isGrouped.value) {
        filteredList = _groupByRepresentative(filteredList);
      }
      
      if (isFiltering) {
        filterSchoolHistoryEntries = filteredList;
      } else {
        schoolHistoryEntries = filteredList;
      }
    } else {
      // Lógica original para otros tipos
      query = query.toLowerCase();
      if (query.isEmpty) {
        filterEntries = [];
        isFiltering = false;
      } else {
        filterEntries = entries.where(
          (e) {
            return (e.nombreVisitante ?? '').toLowerCase().contains(query) ||
                (e.cedulaVisitante ?? '').toLowerCase().contains(query) ||
                (e.placaVisitante ?? '').toLowerCase().contains(query) ||
                (e.primarioResidente ?? '').toLowerCase().contains(query) ||
                (e.secundarioResidente ?? '').toLowerCase().contains(query);
          },
        ).toList();
        isFiltering = true;
      }
    }
    update();
  }

  // Método legacy para mantener compatibilidad
  getFilterEntries({required String query}) {
    filterSchoolEntries(query: query);
  }

  onTapInvitation(EntryResponse entry) {
    if (mainActionType == MainActionType.hisotric) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: Get.overlayContext!,
        builder: (b) {
          return VisitInformationImages(
            entry: entry,
          );
        },
      );
    } else if (mainActionType == MainActionType.gateLeave) {
      goToAddEntryForm(entry: entry);
    }
  }

  onTapSchoolEntry(HistorySchoolResponse schoolEntry) {
    if (mainActionType == MainActionType.hisotric) {
      // Obtener todos los hijos del grupo si está agrupado
      List<HistorySchoolResponse> schoolEntries;
      if (isGrouped.value) {
        schoolEntries = getGroupChildren(schoolEntry);
      } else {
        schoolEntries = getAllSchoolEntriesByGroup(schoolEntry);
      }
      
      // Create a ResidentChildsResponse from the school entry data
      ResidentChildsResponse residentChildsResponse = ResidentChildsResponse(
        idResidenteLugar: schoolEntry.idResidenteLugar,
        nombresResidente: schoolEntry.nombresResidente,
        apellidosResidente: schoolEntry.apellidosResidente,
        descripcion: schoolEntry.descripcion,
        fechaCreacion: schoolEntry.fechaCreacion,
        // Map historic withdrawal information
        nombreRetira: schoolEntry.nombreRetira,
        cedulaRetira: schoolEntry.cedulaRetira,
        placaRetira: schoolEntry.placaRetira,
        imagenes: schoolEntry.imagenes?.cast<String>(),
        // Create children entries from the school data list
        childrens: schoolEntries.map((entry) => Childen(
          idHijo: entry.idHijo,
          nombre: entry.nombreHijo,
          nombreCategoria: entry.nombreCategoria,
          estado: entry.estado,
        )).toList(),
      );
      
      // Convert HistorySchoolResponse list to PendingSchoolRegisterResponse list for compatibility
      List<PendingSchoolRegisterResponse> pendingRegisters = schoolEntries.map((entry) => 
        PendingSchoolRegisterResponse(
          idHijo: entry.idHijo,
          idResidenteLugar: entry.idResidenteLugar,
          nombreHijo: entry.nombreHijo,
          nombreCategoria: entry.nombreCategoria,
          nombresResidente: entry.nombresResidente,
          apellidosResidente: entry.apellidosResidente,
          cedulaResidente: entry.cedulaResidente,
          tipo: entry.tipo,
          estado: entry.estado,
        )
      ).toList();
      
      Get.to(() => ExitWithoutQrToSchoolRequestFormPage(
        residentChildsResponse: residentChildsResponse,
        mainActionType: MainActionType.historic,
        registrationType: RegistrationType.withQR,
        pendingRegisters: pendingRegisters,
        selectedPendingRegister: pendingRegisters.isNotEmpty ? pendingRegisters.first : null,
      ));
    }
  }

  goToAddEntryForm({required EntryResponse entry}) async {
    final guest = LectorResponse(
        apellidosResidente: entry.apellidosResidente,
        cedulaResidente: entry.celularResidente,
        cedulaVisitante: entry.cedulaVisitante,
        celularResidente: entry.celularResidente,
        celularVisitante: entry.celularResidente,
        estado:
            entry.estado == Estado.A ? InvitationStatus.A : InvitationStatus.I,
        fechaCreacion: entry.fechaCreacion,
        fechaInicio: entry.fechaInicio,
        fechaTermino: entry.fechaTermino,
        idCodigo: entry.idIngreso,
        idPuerta: int.parse(gateIdSelected),
        idResidenteLugar: entry.idResidenteLugar,
        nombreVisitante: entry.nombreVisitante,
        nombresResidente: entry.nombresResidente,
        placaVisitante: entry.placaVisitante,
        tipoCodigo: entry.tipoCodigo,
        tipoVisitante: entry.tipoVisitante,
        imagenes: entry.imagenes);
    final restul = await Get.to<bool>(AddEntryFormPage(), arguments: {
      'MainActionType': MainActionType.gateLeave,
      'guessScanned': guest
    });
    if (restul != null && restul) {
      fetchEntries();
    }
  }

  Future<void> takePhoto({required PhotoType photoType}) async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (image == null) return;
    File imageTemporary = File(image.path);
    File compressedImage = await imageTemporary.ensureFileSize(1500000);
    int fileSizeInBytes = await compressedImage.length();
    double fileSizeInMb = fileSizeInBytes / (1024 * 1024);
    String newPath = path.join(
      path.dirname(compressedImage.path),
      'image-${photoType.value}-${DateTime.now().millisecondsSinceEpoch}-${residientNameGateResidenceController.text}',
    );
    compressedImage = await compressedImage.rename(newPath);
    switch (photoType) {
      case PhotoType.dni:
        dniImagesFile = compressedImage;
        update(['form']);
        break;
      case PhotoType.selphi:
        selphiImagesFile = compressedImage;
        update(['form']);
        break;
      case PhotoType.frontLicensePlate:
        frontCarIdImagesFile = compressedImage;
        if (licensePlateResdienteController.text.isEmpty) {
          final orcLincePlate = await getOrc(
            ocrType: OcrType.licensePlate,
            filepath: compressedImage.path,
          );
          licensePlateResdienteController.text = orcLincePlate['PLACA'];
          update(['form']);
        }
        break;
      case PhotoType.backLicensePlate:
        backCarIdImagesFile = compressedImage;
        if (licensePlateResdienteController.text.isEmpty) {
          final orcLincePlate = await getOrc(
            ocrType: OcrType.licensePlate,
            filepath: compressedImage.path,
          );
          licensePlateResdienteController.text = orcLincePlate['PLACA'];
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
      // ocrLicensePlateLoading.value = true;
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
      // ocrLicensePlateLoading.value = false;
      return res;
    } catch (e) {}
    // ocrLicensePlateLoading.value = false;
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
      String? entryId;
      String? residentPlaceId;
      String? gateId;
      String? placeId;
      if (residentSelected == null) {
        showDialog(
          context: Get.overlayContext!,
          builder: (context) {
            return SuccessDialog(
              title: isEnglishLanguage ? 'Informative' : 'Informativo',
              subtitle: isEnglishLanguage
                  ? 'You must select a valid resident'
                  : 'Debe seleccionar un residente válido.',
              iconSvg: ConstantsIcons.alertIcon,
              onTapAcept: () {
                Get.back();
              },
            );
          },
        );
        return;
      }
      addLeaveLoading.value = true;
      residentPlaceId = residentSelected?.idResidenteLugar.toString();
      names = residientNameGateResidenceController.text;
      licencePlate = licensePlateResdienteController.text;
      gateId = gateIdSelected;
      placeId = UserData.sharedInstance.placeSelected!.idLugar.toString();
      await apiBinnacle.addNormalEntrances(
        normalInvitationId: normalInvitationId,
        recurrentInvitationId: recurrentInvitationId,
        mainActionType: mainActionType,
        entryId: entryId,
        entryTypeCode: EntryTypeCode.RE,
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
        accessType: AccessType.exit,
        activity: activity,
        observation: descriptionController.text,
        entranceType: RegisterEntryType.residenceGate,
        placeId: placeId,
      );
      addLeaveLoading.value = false;
      showDialog(
        context: Get.overlayContext!,
        builder: (context) {
          return SuccessDialog(
            title: isEnglishLanguage ? 'Check out' : 'Registro de salida',
            iconSvg: ConstantsIcons.success,
            subtitle: isEnglishLanguage
                ? 'Checkout was saved successfully'
                : 'La salida se guardó con éxtio',
            onTapAcept: () {
              Get.back();
              clearForm();
            },
          );
        },
      );
    } on DioError catch (_) {
      addLeaveLoading.value = false;
    }
  }

  clearForm() {
    residentSelected = null;
    dniImagesFile = null;
    selphiImagesFile = null;
    backCarIdImagesFile = null;
    frontCarIdImagesFile = null;
    descriptionController.text = '';
    primaryGateResidenceController.text = '';
    licensePlateResdienteController.text = '';
    secundaryGateResidenceController.text = '';
    residientNameGateResidenceController.text = '';
    autoCompleteResdientSelected = null;
    update();
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
              (e.apellidos ?? '').toLowerCase().contains(query.toLowerCase()) ||
              (e.nombrePrimario ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (e.nombreSecundario ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase());
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

  // Métodos para agrupación de school entries
  void toggleGrouping() {
    isGrouped.value = !isGrouped.value;
    // Re-agrupar los datos existentes sin hacer nuevos requests
    _reapplyGroupingAndFilters();
  }
  
  void _reapplyGroupingAndFilters() {
    // Re-aplicar filtros usando la misma lógica que PendingSchoolRegisterController.filterRegisters()
    filterSchoolEntries(query: currentSearchQuery);
  }

  List<HistorySchoolResponse> _groupByRepresentative(List<HistorySchoolResponse> entries) {
    // Agrupar por representante usando tipo, idResidenteLugar y fechaCreacion como clave
    Map<String, List<HistorySchoolResponse>> grouped = {};
    
    for (var entry in entries) {
      final tipo = entry.tipo?.description ?? '';
      final idResidenteLugar = entry.idResidenteLugar?.toString() ?? '';
      final fechaCreacion = entry.fechaCreacion?.toIso8601String() ?? ''; // Fecha y hora completa
      final key = '$tipo-$idResidenteLugar-$fechaCreacion';
      
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(entry);
    }
    
    // Retornar solo un representante por grupo (el primero de cada grupo)
    List<HistorySchoolResponse> result = [];
    for (var group in grouped.values) {
      if (group.isNotEmpty) {
        // Tomar la primera entrada de cada grupo para representar todo el grupo
        result.add(group.first);
      }
    }
    
    return result;
  }

  // Método helper para obtener el conteo de hijos para un representante
  int getChildrenCount(HistorySchoolResponse representative) {
    if (!isGrouped.value) return 1;
    
    final tipo = representative.tipo?.description ?? '';
    final idResidenteLugar = representative.idResidenteLugar?.toString() ?? '';
    final fechaCreacion = representative.fechaCreacion?.toIso8601String() ?? ''; // Fecha y hora completa
    final key = '$tipo-$idResidenteLugar-$fechaCreacion';
    
    return _allSchoolHistoryEntries.where((entry) {
      final entryTipo = entry.tipo?.description ?? '';
      final entryIdResidenteLugar = entry.idResidenteLugar?.toString() ?? '';
      final entryFechaCreacion = entry.fechaCreacion?.toIso8601String() ?? ''; // Fecha y hora completa
      final entryKey = '$entryTipo-$entryIdResidenteLugar-$entryFechaCreacion';
      
      return entryKey == key;
    }).length;
  }

  // Método helper para obtener todos los hijos de un grupo representativo
  List<HistorySchoolResponse> getGroupChildren(HistorySchoolResponse representative) {
    if (!isGrouped.value) return [representative];
    
    final tipo = representative.tipo?.description ?? '';
    final idResidenteLugar = representative.idResidenteLugar?.toString() ?? '';
    final fechaCreacion = representative.fechaCreacion?.toIso8601String() ?? ''; // Fecha y hora completa
    final key = '$tipo-$idResidenteLugar-$fechaCreacion';
    
    return _allSchoolHistoryEntries.where((entry) {
      final entryTipo = entry.tipo?.description ?? '';
      final entryIdResidenteLugar = entry.idResidenteLugar?.toString() ?? '';
      final entryFechaCreacion = entry.fechaCreacion?.toIso8601String() ?? ''; // Fecha y hora completa
      final entryKey = '$entryTipo-$entryIdResidenteLugar-$entryFechaCreacion';
      
      return entryKey == key;
    }).toList();
  }

  // Método helper para obtener todas las entradas por grupo
  List<HistorySchoolResponse> getAllSchoolEntriesByGroup(HistorySchoolResponse selectedEntry) {
    return _allSchoolHistoryEntries.where((entry) => 
      entry.idResidenteLugar == selectedEntry.idResidenteLugar && 
      entry.tipo == selectedEntry.tipo &&
      entry.fechaCreacion?.toIso8601String() == selectedEntry.fechaCreacion?.toIso8601String() // Fecha y hora completa
    ).toList();
  }
}
