import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:qr_scaner_manrique/BRACore/api/api_lector.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_school.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';
import 'package:qr_scaner_manrique/BRACore/enums/funtionality_action_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/photo_type.dart';
import 'package:qr_scaner_manrique/BRACore/enums/ocr_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/string_extensions.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/shared/widgets/loading_dialog.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/resident_childs_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/pending_school_regiter_response.dart';
import '../enums/registration_type.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/file_extensions.dart';

class ExitRequestFormController extends GetxController {
  // Registration type
  final Rx<RegistrationType> registrationType = RegistrationType.withQR.obs;
  final ResidentChildsResponse residentChildsResponse;
  final MainActionType mainActionType;
  final List<PendingSchoolRegisterResponse>? pendingRegisters;
  final PendingSchoolRegisterResponse? selectedPendingRegister;

  ExitRequestFormController({
    required this.residentChildsResponse,
    required this.mainActionType,
    this.pendingRegisters,
    this.selectedPendingRegister,
  });
  void setRegistrationType(RegistrationType type) {
    registrationType.value = type;
  }

  // Computed properties
  bool get isHistoricMode => mainActionType == MainActionType.historic;
  bool get isGateLeaveMode => mainActionType == MainActionType.gateLeave;
  
  final RxList<StudentData> students = <StudentData>[].obs;
  final RxBool selectAll = false.obs;

  // Image files
  final Rx<File?> idPhotoFile = Rx<File?>(null);
  final Rx<File?> licensePlatePhotoFile = Rx<File?>(null);
  final RxString? credentialUrlImage = ''.obs;
  final RxString? profileUrlImage = ''.obs;
  final RxList<File> additionalPhotos = <File>[].obs;

  // Required fields validation for WithoutQR form
  final RxBool isGuestNameValid = false.obs;
  final RxBool isGuestIdValid = false.obs;
  final RxBool isGuestPhoneValid = false.obs;
  final RxBool isPlateValid = false.obs;

  // Text Controllers for WithQR form
  late TextEditingController representativeController;
  late TextEditingController phoneController;
  late TextEditingController reasonController;
  late TextEditingController dateTimeController;

  // Text Controllers for WithoutQR form
  late TextEditingController guestNameController;
  late TextEditingController guestIdController;
  late TextEditingController guestPhoneController;
  late TextEditingController pinletTypeController;
  late TextEditingController primaryController;
  late TextEditingController secondaryController;
  late TextEditingController plateController;
  late TextEditingController visitReasonController;

  // Detail View Controllers
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController licensePlateController;

  // Focus Nodes
  late FocusNode reasonFocus;
  late FocusNode representativeFocus;
  late FocusNode phoneFocus;
  late FocusNode dateTimeFocus;
  late FocusNode nameFocus;
  late FocusNode idFocus;
  late FocusNode licensePlateFocus;

  // Current tab index
  final RxInt currentTabIndex = 0.obs;

  // SERVICE
  final ApiLector apiLector = ApiLector();
  final ApiSchool apiSchool = ApiSchool();
  final ApiAuth apiAuth = ApiAuth();

  // Loading state for withdraw action
  final RxBool isLoading = false.obs;

  // Variables for ID card lookup
  String _lastLookedUpId = '';
  final RxBool isLoadingPeopleData = false.obs;
  Timer? _debounceTimer;

  // Getter to determine if DetailView should be shown
  bool get shouldShowDetailView {
    // Never show DetailView for historic mode
    if (mainActionType == MainActionType.historic) {
      return false;
    }
    
    if (mainActionType != MainActionType.gateLeave) {
      return true; // Always show for non-gateLeave (except historic)
    }
    
    // For gateLeave, show only if there's data in form fields or images
    final hasFormData = nameController.text.isNotEmpty ||
                       idController.text.isNotEmpty ||
                       licensePlateController.text.isNotEmpty ||
                       reasonController.text.isNotEmpty;
                       
    final hasImages = (selectedPendingRegister?.imagenes?.isNotEmpty ?? false);
    
    final shouldShow = hasFormData || hasImages;
    
    // If shouldn't show DetailView and currently on DetailView tab, switch to first tab
    if (!shouldShow && currentTabIndex.value == 2) {
      currentTabIndex.value = 0;
    }
    
    return shouldShow;
  }

  // Getter to get images for DetailView when gateLeave
  List<String> get detailViewImages {
    if (mainActionType == MainActionType.gateLeave) {
      return selectedPendingRegister?.imagenes ?? [];
    }
    return [];
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize WithQR controllers
    reasonController = TextEditingController();
    representativeController = TextEditingController();
    phoneController = TextEditingController();
    dateTimeController = TextEditingController();

    // Initialize WithoutQR controllers
    guestNameController = TextEditingController();
    guestIdController = TextEditingController();
    guestPhoneController = TextEditingController();
    pinletTypeController = TextEditingController(text: 'Recurrente');
    primaryController = TextEditingController(text: 'SOLAR');
    secondaryController = TextEditingController(text: '1');
    plateController = TextEditingController();
    visitReasonController = TextEditingController();

    // Initialize Detail View controllers
    nameController = TextEditingController();
    idController = TextEditingController();
    licensePlateController = TextEditingController();

    // Initialize focus nodes
    reasonFocus = FocusNode();
    representativeFocus = FocusNode();
    phoneFocus = FocusNode();
    dateTimeFocus = FocusNode();
    nameFocus = FocusNode();
    idFocus = FocusNode();
    licensePlateFocus = FocusNode();

    idFocus.addListener(_handleIdFocusChange);
    students.value = [];

    // Populate controllers and students based on mainActionType
    if (mainActionType == MainActionType.gateLeave &&
        pendingRegisters != null) {
      // Populate from pendingRegisters for gateLeave action
      final dateFormatter = DateFormat('dd/MM/yyyy');
      students.value = pendingRegisters!.map((register) {
        // Create a more robust identification for pre-selection
        bool shouldBeSelected = false;

        if (selectedPendingRegister != null) {
          // Use multiple fields for more reliable comparison
          final sameIdHijo = register.idHijo == selectedPendingRegister!.idHijo;
          final sameIdHijoResidente = register.idHijoResidente == selectedPendingRegister!.idHijoResidente;
          final sameName = register.nombreHijo == selectedPendingRegister!.nombreHijo;
          
          shouldBeSelected = sameIdHijo && sameIdHijoResidente && sameName;
        }

        return StudentData(
          idChild: register.idHijo.toString(),
          name: register.nombreHijo ?? 'Nombre no disponible',
          representativeName:
              '${register.nombresResidente ?? ''} ${register.apellidosResidente ?? ''}'
                  .trim(),
          course: register.nombreCategoria ?? 'Curso no disponible',
          date: register.fechaCreacion != null
              ? dateFormatter.format(register.fechaCreacion!)
              : dateFormatter.format(DateTime.now()),
          isSelected: shouldBeSelected,
        );
      }).toList();

      // Update selectAll state based on pre-selection
      _updateSelectAllState();

      // Use selectedPendingRegister data for WithoutQR form fields when available
      if (selectedPendingRegister != null) {
        // Fill WithoutQR form controllers with pending register data
        guestNameController.text = selectedPendingRegister!.nombreRetira ?? '';
        guestIdController.text = selectedPendingRegister!.cedulaRetira ?? '';
        guestPhoneController.text = selectedPendingRegister!.celularResidente ?? '';
        plateController.text = selectedPendingRegister!.placaRetira ?? '';
        visitReasonController.text = selectedPendingRegister!.descripcion ?? '';
        
        // Keep existing pinlet and location data
        pinletTypeController.text = selectedPendingRegister!.tipo?.value ?? 'Recurrente';
        primaryController.text = selectedPendingRegister!.nombrePrimario ?? 'SOLAR';
        secondaryController.text = selectedPendingRegister!.nombreSecundario ?? '1';
        
        // Also fill WithQR form controllers for consistency
        representativeController.text =
            '${selectedPendingRegister!.nombresResidente ?? ''} ${selectedPendingRegister!.apellidosResidente ?? ''}'
                .trim();
        phoneController.text = selectedPendingRegister!.celularResidente ?? '';
        reasonController.text = selectedPendingRegister!.descripcion ?? '';
        dateTimeController.text =
            selectedPendingRegister!.fechaCreacion?.toIso8601String() ?? '';
            
        // Fill DetailView form controllers with pending register data
        nameController.text = selectedPendingRegister!.nombreRetira ?? '';
        idController.text = selectedPendingRegister!.cedulaRetira ?? '';
        licensePlateController.text = selectedPendingRegister!.placaRetira ?? '';
      } else if (pendingRegisters!.isNotEmpty) {
        // Fallback to first register if no specific selection
        final firstRegister = pendingRegisters!.first;
        guestNameController.text = firstRegister.nombreRetira ?? '';
        guestIdController.text = firstRegister.cedulaRetira ?? '';
        guestPhoneController.text = firstRegister.celularResidente ?? '';
        plateController.text = firstRegister.placaRetira ?? '';
        visitReasonController.text = firstRegister.descripcion ?? '';
        
        representativeController.text =
            '${firstRegister.nombresResidente ?? ''} ${firstRegister.apellidosResidente ?? ''}'
                .trim();
        phoneController.text = firstRegister.celularResidente ?? '';
        reasonController.text = firstRegister.descripcion ?? '';
        dateTimeController.text =
            firstRegister.fechaCreacion?.toIso8601String() ?? '';
        pinletTypeController.text = firstRegister.tipo?.value ?? 'Recurrente';
        primaryController.text = firstRegister.nombrePrimario ?? 'SOLAR';
        secondaryController.text = firstRegister.nombreSecundario ?? '1';
        
        // Fill DetailView form controllers with first register data
        nameController.text = firstRegister.nombreRetira ?? '';
        idController.text = firstRegister.cedulaRetira ?? '';
        licensePlateController.text = firstRegister.placaRetira ?? '';
      }
    } else {
      // Original logic for gateEntryForm action
      // Populate controllers with residentChildsResponse data
      guestNameController.text = residentChildsResponse.informacion?.nombreVisitante ?? '';
        guestIdController.text = residentChildsResponse.informacion?.cedulaVisitante ?? '';
        guestPhoneController.text = residentChildsResponse.informacion?.celularVisitante ?? '';

      representativeController.text =
          "${residentChildsResponse.nombresResidente?.getLastNameResp} ${residentChildsResponse.apellidosResidente}";
      phoneController.text = residentChildsResponse.celularResidente ?? '';
      pinletTypeController.text =
          residentChildsResponse.informacion?.tipoCodigo?.value ?? '';
      primaryController.text =
          residentChildsResponse.informacion?.primarioResidente ?? 'SOLAR';
      secondaryController.text =
          residentChildsResponse.informacion?.secundarioResidente ?? '1';
      reasonController.text = residentChildsResponse.descripcion ?? '';
      dateTimeController.text =
          residentChildsResponse.fechaCreacion?.toIso8601String() ?? '';

      // For historic mode, populate detail tab fields with available information
      if (isHistoricMode) {
        // Use direct fields from ResidentChildsResponse instead of informacion
        if (residentChildsResponse.nombreRetira != null && residentChildsResponse.nombreRetira!.isNotEmpty) {
          nameController.text = residentChildsResponse.nombreRetira!;
        }
        
        if (residentChildsResponse.cedulaRetira != null && residentChildsResponse.cedulaRetira!.isNotEmpty) {
          idController.text = residentChildsResponse.cedulaRetira!;
        }
        
        if (residentChildsResponse.placaRetira != null && residentChildsResponse.placaRetira!.isNotEmpty) {
          licensePlateController.text = residentChildsResponse.placaRetira!;
        }
        
        // Populate reason field with description if available
        if (residentChildsResponse.descripcion != null && residentChildsResponse.descripcion!.isNotEmpty) {
          reasonController.text = residentChildsResponse.descripcion!;
        }
        
        // Populate date/time field with creation date formatted nicely
        if (residentChildsResponse.fechaCreacion != null) {
          final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
          dateTimeController.text = formatter.format(residentChildsResponse.fechaCreacion!);
        }
      }

      // Populate students list with data from residentChildsResponse
      if (residentChildsResponse.childrens != null) {
        final dateFormatter = DateFormat('dd/MM/yyyy');
        students.value = residentChildsResponse.childrens!
            .map((hijo) => StudentData(
                  idChild: hijo.idHijo.toString(),
                  name: hijo.nombre ?? 'Nombre no disponible',
                  representativeName: residentChildsResponse.nombresResidente ??
                      'Representante no disponible',
                  course: hijo.nombreCategoria ?? 'Curso no disponible',
                  date: residentChildsResponse.fechaCreacion != null
                      ? dateFormatter
                          .format(residentChildsResponse.fechaCreacion!)
                      : dateFormatter
                          .format(DateTime.now()),
                  // In historic mode, mark all students as selected (already retired)
                  isSelected: isHistoricMode,
                ))
            .toList();
        
        // If in historic mode, set selectAll to true
        if (isHistoricMode) {
          selectAll.value = true;
        }
      }

      // Populate photos from informacion
      populatePhotos();
    }
  }

  void toggleSelectAll() {
    selectAll.value = !selectAll.value;
    for (var student in students) {
      student.isSelected = selectAll.value;
    }
    students.refresh();
  }

  void toggleStudentSelection(int index) {
    students[index].isSelected = !students[index].isSelected;
    selectAll.value = students.every((student) => student.isSelected);
    students.refresh();
  }

  void _updateSelectAllState() {
    selectAll.value =
        students.isNotEmpty && students.every((student) => student.isSelected);
  }

  // Validation methods
  // Validation methods will be added later

  // Image picking methods
  Future<void> pickImage(ImageSource source,
      {bool isIdPhoto = false, bool isLicensePlatePhoto = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final File file = File(image.path);
      additionalPhotos.insert(
          0, file); // Add the photo to the beginning of the list
      additionalPhotos.refresh(); // Refresh the list to update the UI
    }
  }

  void removeAdditionalPhoto(int index) {
    if (index >= 0 && index < additionalPhotos.length) {
      additionalPhotos.removeAt(index);
    }
  }

  void populatePhotos() {
    if (residentChildsResponse.informacion != null) {
      if (residentChildsResponse.informacion!.fotoCredencial != null) {
        credentialUrlImage?.value =
            residentChildsResponse.informacion!.fotoCredencial ?? '';
      }
      if (residentChildsResponse.informacion!.fotoPerfil != null) {
        profileUrlImage?.value =
            residentChildsResponse.informacion!.fotoPerfil ?? '';
      }
    }
  }

  Future<void> takePhotoWithOcr({required PhotoType photoType}) async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (image == null) return;
    File imageTemporary = File(image.path);
    File compressedImage = await imageTemporary.ensureFileSize(1500000);
    String newPath = path.join(
      path.dirname(compressedImage.path),
      'image-${photoType.value}-${DateTime.now().millisecondsSinceEpoch}',
    );
    compressedImage = await compressedImage.rename(newPath);

    switch (photoType) {
      case PhotoType.dni:
        idPhotoFile.value = compressedImage;
        final resOcrDni = await getOrc(
          ocrType: OcrType.dni,
          filepath: compressedImage.path,
        );
        idController.text = resOcrDni['CEDULA'] ?? '';
        nameController.text = resOcrDni['NOMBRES'] ?? '';
        break;
      case PhotoType.frontLicensePlate:
        licensePlatePhotoFile.value = compressedImage;
        final resOcrPlate = await getOrc(
          ocrType: OcrType.licensePlate,
          filepath: compressedImage.path,
        );
        licensePlateController.text = resOcrPlate['PLACA'] ?? '';
        break;
      default:
        break;
    }
  }

  Future<dynamic> getOrc(
      {required OcrType ocrType, required String filepath}) async {
    try {
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
      return res;
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  Future<void> lookupPeopleDataById(String idCard) async {
    idCard = idCard.trim().replaceAll(RegExp(r'[^0-9]'), '');
    // Don't make request if empty, too short, or same as last lookup
    if (idCard.isEmpty || idCard.length < 8 || idCard == _lastLookedUpId) {
      return;
    }

    try {
      isLoadingPeopleData.value = true;
      final peopleData = await apiAuth.getPeopleDataBy(idCard);
      if (peopleData.nombres != null && peopleData.nombres!.isNotEmpty) {
        nameController.text = peopleData.nombres!;
      } else {
        nameController.text = '';
      }
      
      // Update last looked up ID to avoid duplicate requests
      _lastLookedUpId = idCard;
      
    } catch (e) {
      // Clear name field on error
      nameController.text = '';
    } finally {
      isLoadingPeopleData.value = false;
    }
  }

  void _handleIdFocusChange() {
    lookupPeopleDataById(idController.text);
  }

  Future<void> handleWithdraw() async {
    try {
      isLoading.value = true;
      // Compose childList from selected students
      final selectedChildren =
          students.where((student) => student.isSelected).toList();
      final childList =
          selectedChildren.map((child) => child.idChild).join(',');

      if (mainActionType == MainActionType.gateLeave) {
        // Use retirarColegio service for gateLeave with data from pendingRegisters
        if (pendingRegisters != null && pendingRegisters!.isNotEmpty) {
          final firstRegister = pendingRegisters!.first;
          await apiSchool.retirarColegio(
            placeId: firstRegister.idLugar.toString(),
            doorId: firstRegister.idPuerta.toString(),
            residentPlaceId: firstRegister.idResidenteLugar.toString(),
            type: firstRegister.tipo?.description ?? '',
            childrenList: childList,
          );
          Get.back(result: true);
          Get.snackbar('Éxito', 'Retiro registrado exitosamente');
          return; // Exit early for gateLeave success
        }
      } else {
        // Use insertSchoolRegister service for gateEntryForm (default behavior)
        final images = additionalPhotos.map((file) => file.path).toList();

        await apiSchool.insertSchoolRegister(
          placeId: residentChildsResponse.idLugar.toString(),
          codeId: (residentChildsResponse.informacion?.idCodigo).toString(),
          doorId: residentChildsResponse.idPuerta.toString(),
          childList: childList,
          description: reasonController.text,
          creationDate: DateTime.now().toIso8601String(),
          name: nameController.text,
          idCard: idController.text,
          plate: licensePlateController.text,
          images: images,
          type:
              residentChildsResponse.informacion?.tipoCodigo?.description ?? '',
          residentPlaceId: residentChildsResponse.idResidenteLugar.toString(),
          guestName: guestNameController.text,
        );
      }

      // Show success message for gateEntryForm only (gateLeave handles success internally)
      if (mainActionType != MainActionType.gateLeave) {
        Get.back(result: true);
        Get.snackbar('Éxito', 'Solicitud registrada exitosamente');
      }
    } catch (e) {
      final errorMessage = mainActionType == MainActionType.gateLeave
          ? 'Error al registrar el retiro: $e'
          : 'Error al registrar la solicitud: $e';
      Get.snackbar('Error', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Cancel debounce timer
    _debounceTimer?.cancel();
    
    // Dispose WithQR controllers
    reasonController.dispose();
    representativeController.dispose();
    phoneController.dispose();
    dateTimeController.dispose();

    // Dispose WithoutQR controllers
    guestNameController.dispose();
    guestIdController.dispose();
    guestPhoneController.dispose();
    pinletTypeController.dispose();
    primaryController.dispose();
    secondaryController.dispose();
    plateController.dispose();
    visitReasonController.dispose();

    // Dispose Detail View controllers
    nameController.dispose();
    idController.dispose();
    licensePlateController.dispose();

    // Dispose focus nodes
    reasonFocus.dispose();
    representativeFocus.dispose();
    phoneFocus.dispose();
    dateTimeFocus.dispose();
    nameFocus.dispose();
    idFocus.dispose();
    licensePlateFocus.dispose();

    super.onClose();
  }
}

class StudentData {
  final String idChild;
  final String name;
  final String representativeName;
  final String course;
  final String date;
  bool isSelected;

  StudentData({
    required this.idChild,
    required this.name,
    required this.representativeName,
    required this.course,
    required this.date,
    this.isSelected = false,
  });
}
