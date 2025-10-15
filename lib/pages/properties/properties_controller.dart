import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_managr.dart';
import 'package:qr_scaner_manrique/BRACore/models/general/error_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/auth_login.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:qr_scaner_manrique/pages/home/home_page.dart';
import 'package:qr_scaner_manrique/pages/properties/widgets/property_actions_modal.dart';
import 'package:qr_scaner_manrique/pages/school/exit_without_qr_request_form/enums/registration_type.dart';
import 'package:qr_scaner_manrique/shared/widgets/success_dialog.dart';
import 'package:qr_scaner_manrique/utils/remote_config_manager.dart';

class PropertiesController extends GetxController with WidgetsBindingObserver {
  PropertiesController();

  int currentPage = 0;
  PageController pageController = PageController(initialPage: 0);
  ApiManager activityService = ApiManager();
  List<Place> places = [];
  List<Place>? placesFilter;
  RxBool loading = false.obs;
  RxBool loadingInvitations = false.obs;
  RxBool loadingDeleting = false.obs;
  RxBool loadingInactivity = false.obs;
  List<RxBool> loadingPermissons = [];
  Timer? timer;
  RxString qrDynamicCode = ''.obs;
  bool noConecction = false;
  FocusNode seachFocusNode = FocusNode();
  bool updateAppVersion = false;
  AuthLoginModel userLogin = UserData.sharedInstance.userLogin!;
  final channel = MethodChannel('.watchkitapp');
  PackageInfo? packageInfo;
  FirebaseRemoteConfig? remoteConfig;

  bool get showNewVersionButton {
    return verifyActuallyOptionalVersion();
  }

  @override
  void onInit() async {
    super.onInit();
    try {
      remoteConfig = await RemoteConfigManager.setupRemoteConfig();
    } catch (e) {
      print(e);
    }
    packageInfo = await PackageInfo.fromPlatform();
    loading.value = true;
    getPlaces(isRefresh: true);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('EN PRIMER PLANO: ' + Get.currentRoute);
    }
  }

  getPlaces({required bool isRefresh}) async {
    try {
      places = [];
      placesFilter = null;
      loading.value = true;
      loadingPermissons = [];
      final saveProperties = await UserData.sharedInstance.getSavedProperties();
      if (saveProperties.isNotEmpty && !isRefresh) {
        loading.value = false;
        places = saveProperties;
        for (var i = 0; i < saveProperties.length; i++) {
          loadingPermissons.add(false.obs);
        }
        update();
        if (currentPage == 0) {
          pageController = PageController(initialPage: 0);
        }
        // fetchAllInvitations(isRefresh: false);
      } else {
        final res = await activityService
            .fetchService(UserData.sharedInstance.userLogin!.idUsuarioAdmin!);
        for (var i = 0; i < res.length; i++) {
          loadingPermissons.add(false.obs);
        }
        loading.value = false;
        places = res;
        UserData.sharedInstance.removePermissons(places: places);
        UserData.sharedInstance.saveProperties(places);
        update();
        // fetchAllInvitations(isRefresh: false);
        if (places.length == 1) {
          onTapPropertie(
              placeTemp: places[0], indexPropertie: 0, isFirstPlaceOnly: true);
        }
        if (currentPage == 0) {
          pageController = PageController(initialPage: 0);
        }
      }
    } on DioError catch (e) {
      loading.value = false;
      if (e.type == DioErrorType.other ||
          e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        ErrorModel _ = ErrorModel(
          httpCode: 400,
          codigoError: '700',
          mensaje: 'No tiene conexión a internet',
          causa: 'Error de conexión',
        );
        final saveProperties =
            await UserData.sharedInstance.getSavedProperties();
        if (saveProperties.isNotEmpty) {
          loading.value = false;
          places = saveProperties;
          for (var i = 0; i < saveProperties.length; i++) {
            loadingPermissons.add(false.obs);
          }
          print(loadingInvitations.value);
          update();
          if (currentPage == 0) {
            pageController = PageController(initialPage: 0);
          }
        }
      }
    }
  }

  // fetchPermisos(String idLugar, int index) async {
  //   try {
  //     UserData.sharedInstance.noConnectionPermisson = false;
  //     loadingPermissons[index].value = true;
  //     permissons = [];
  //     final res = await activityService.fetchPermissos(idLugar,
  //         UserData.sharedInstance.placeSelected!.idResidenteLugar.toString());
  //     loadingPermissons[index].value = false;
  //     permissons = res.where((element) => element.estado != 'E').toList();
  //     UserData.sharedInstance.savePermissons(permissons, idLugar);
  //     Get.to(CustomNavigationBarPage());
  //   } on DioError catch (e) {
  //     loadingPermissons[index].value = false;
  //     if (e.type == DioErrorType.other ||
  //         e.type == DioErrorType.connectTimeout ||
  //         e.type == DioErrorType.receiveTimeout) {
  //       ErrorModel errorModel = ErrorModel(
  //           httpCode: 400,
  //           codigoError: '700',
  //           mensaje: 'No tiene conexión a internet',
  //           causa: 'Error de conexión');
  //       if (errorModel.codigoError == '700') {
  //         final permissonsSaved =
  //             await UserData.sharedInstance.getSavedPermissons(idLugar);
  //         if (permissonsSaved.isNotEmpty) {
  //           loadingPermissons[index].value = false;
  //           Get.to(CustomNavigationBarPage());
  //         } else {
  //           UserData.sharedInstance.noConnectionPermisson = true;
  //           loadingPermissons[index].value = false;
  //           Get.to(CustomNavigationBarPage());
  //         }
  //       }
  //     }
  //   }
  // }

  bool verifyShowDialog(String code) {
    switch (code) {
      case '106':
        return false;
      case '212':
        return false;
      default:
        return true;
    }
  }

  filterPlace({required String query}) {
    final cleanQuery = query.toLowerCase();
    placesFilter = [];
    if (cleanQuery.isEmpty) {
      placesFilter = null;
    } else {
      placesFilter = places.where(
        (e) {
          return e.nombre!.toLowerCase().contains(cleanQuery) ||
              e.ciudad!.toLowerCase().contains(cleanQuery) ||
              (e.descripcion ?? '').toLowerCase().contains(cleanQuery);
        },
      ).toList();
    }
    update();
  }

  onTapPropertie(
      {required Place placeTemp,
      required int indexPropertie,
      bool isFirstPlaceOnly = false,
      bool isEmergency = false}) async {
    if (isEmergency) {
      print('ES UNA EMERGENCIA');
      HapticFeedback.vibrate();
    }
    String? message;
    String errorTitle = '';
    if (placeTemp.estado == 'I') {
      message = 'Propiedad inactiva, contactarse con soporte';
      errorTitle = 'Propiedad Inactiva';
    } else if (placeTemp.estado == 'P') {
      message = 'Propiedad pendiente, contactarse con soporte';
      errorTitle = 'Propiedad Pendiente';
    } else if (placeTemp.estado == 'E') {
      message = 'Propiedad eliminada, contactarse con soporte';
      errorTitle = 'Propiedad Eliminada';
    } else if (placeTemp.estado == 'R') {
      message = 'Propiedad rechazada, contactarse con soporte';
      errorTitle = 'Propiedad eliminada';
    }
    if (message != null) {
      showDialog(
          context: Get.overlayContext!,
          builder: (c) {
            return SuccessDialog(
                title: errorTitle,
                subtitle: message,
                iconSvg: 'assets/icons_svg/alert_icon.svg',
                onTapAcept: () {
                  Get.back();
                });
          });
      return;
    }
    UserData.sharedInstance.placeSelected = placeTemp;
    Get.bottomSheet(
      PropertyActionsModal(
        place: placeTemp,
        showNewVersionButton: showNewVersionButton,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    // fetchPermisos(placeTemp.idLugar.toString(), indexPropertie);
  }

  bool verifyActuallyOptionalVersion() {
    var activeVerison = false;
    final versionActual = packageInfo != null ? packageInfo!.version : '';
    final versionIosServidor = remoteConfig != null
        ? remoteConfig!.getString('version_app_bitacora_ios')
        : '';
    final versionAndoridServidor = remoteConfig != null
        ? remoteConfig!.getString('version_app_bitacora_andorid')
        : '';
    final updateOptionalAndroidActive = remoteConfig != null
        ? remoteConfig?.getBool('bitacoraUpdateOptionalAndroidActive')
        : false;
    final updateOptionalIosActive = remoteConfig != null
        ? remoteConfig?.getBool('bitacoraUpdateOptionalIosActive')
        : false;
    if (Platform.isAndroid && (updateOptionalAndroidActive ?? false)) {
      activeVerison = shouldUpdate(versionActual, versionAndoridServidor);
    } else if (Platform.isIOS && (updateOptionalIosActive ?? false)) {
      activeVerison = shouldUpdate(versionActual, versionIosServidor);
    } else {
      activeVerison = false;
    }
    return activeVerison;
  }

  bool shouldUpdate(String actualVersion, String releaseVersion) {
    List<int> actual = actualVersion.split('.').map(int.parse).toList();
    List<int> minima = releaseVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < actual.length; i++) {
      if (actual[i] > minima[i]) return false;
      if (actual[i] < minima[i]) return true;
    }
    return false;
  }
}
