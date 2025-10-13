import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_managr.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/auth_login.dart';
import 'package:qr_scaner_manrique/BRACore/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  AuthLoginModel? usuarioLogin;
  RxBool isLogin = false.obs;
  RxBool isShowOnboarding = false.obs;
  RxBool loadingSplash = false.obs;
  bool isLoginOnboarding = false;
  ApiManager activityService = ApiManager();

  @override
  onInit() async {
    super.onInit();
    handleOnInit();
  }

  handleOnInit() async {
    Future.delayed(const Duration(seconds: 0), (() async {
      SharedPreferences perf = await SharedPreferences.getInstance();
      final prefUser = perf.getString('userLogin');
      if (prefUser == null || prefUser == 'null') {
        isLogin.value = false;
      } else {
        Map<String, dynamic> userDataStr =
            jsonDecode(perf.getString('userLogin')!);
        usuarioLogin = authLoginModelFromJson(json.encode(userDataStr));
        UserData.sharedInstance.userLogin = usuarioLogin;
        isLogin.value = true;
      }
      loadingSplash.value = true;
      update(['slapsh']);
    }));
  }

  // Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  //   final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  //   await remoteConfig.setConfigSettings(RemoteConfigSettings(
  //     fetchTimeout: const Duration(seconds: 3),
  //     minimumFetchInterval: const Duration(seconds: 10),
  //   ));
  //   await remoteConfig.setDefaults(<String, dynamic>{
  //     'updateIosActive': false,
  //     'updateOptionalIosActive': false,
  //     'updateAndroidActive': false,
  //     'updateOptionalAndroidActive': false,
  //     'version_app_andorid': '',
  //     'version_app_ios': ''
  //   });
  //   try {
  //     await remoteConfig.fetchAndActivate();
  //     return remoteConfig;
  //   } catch (e) {
  //     return remoteConfig;
  //   }
  // }

  // bool verifyActuallyVersion() {
  //   var activeVerison = false;
  //   final versionActual = packageInfo != null ? packageInfo!.version : '';
  //   final versionIosServidor =
  //       remoteConfig != null ? remoteConfig!.getString('version_app_ios') : '';
  //   final versionAndoridServidor = remoteConfig != null
  //       ? remoteConfig!.getString('version_app_andorid')
  //       : '';
  //   final updateAndroidActive = remoteConfig != null
  //       ? remoteConfig!.getBool('updateAndroidActive')
  //       : false;
  //   final updateOptionalAndroidActive = remoteConfig != null
  //       ? remoteConfig!.getBool('updateOptionaIosActive')
  //       : false;
  //   final updateIosActive =
  //       remoteConfig != null ? remoteConfig!.getBool('updateIosActive') : false;
  //   final updateOptionalIosActive = remoteConfig != null
  //       ? remoteConfig!.getBool('updateOptionaIosActive')
  //       : false;
  //   if (Platform.isAndroid && updateAndroidActive) {
  //     if (versionActual != versionAndoridServidor) {
  //       activeVerison = false;
  //     } else {
  //       activeVerison = true;
  //     }
  //   } else if (Platform.isIOS && updateIosActive) {
  //     if (versionActual != versionIosServidor) {
  //       activeVerison = false;
  //     } else {
  //       activeVerison = true;
  //     }
  //   } else {
  //     activeVerison = true;
  //   }
  //   return activeVerison;
  // }

  // bool verifyActuallyOptionalVersion() {
  //   var activeVerison = false;
  //   final versionActual = packageInfo != null ? packageInfo!.version : '';
  //   final versionIosServidor =
  //       remoteConfig != null ? remoteConfig!.getString('version_app_ios') : '';
  //   final versionAndoridServidor = remoteConfig != null
  //       ? remoteConfig!.getString('version_app_andorid')
  //       : '';
  //   final updateOptionalAndroidActive = remoteConfig != null
  //       ? remoteConfig!.getBool('updateOptionalAndroidActive')
  //       : false;
  //   final updateOptionalIosActive = remoteConfig != null
  //       ? remoteConfig!.getBool('updateOptionalIosActive')
  //       : false;

  //   print('updateOptionalIosActive' + updateOptionalIosActive.toString());
  //   if (Platform.isAndroid && updateOptionalAndroidActive) {
  //     if (versionActual != versionAndoridServidor) {
  //       activeVerison = true;
  //     } else {
  //       activeVerison = false;
  //     }
  //   } else if (Platform.isIOS && updateOptionalIosActive) {
  //     print(versionActual);
  //     if (versionActual != versionIosServidor) {
  //       activeVerison = true;
  //     } else {
  //       activeVerison = false;
  //     }
  //   } else {
  //     activeVerison = false;
  //   }
  //   return activeVerison;
  // }

  // Future<ContentResponse> getContent() async {
  //   try {
  //     final res = await activityService.getContent();
  //     return res;
  //   } on DioError catch (e) {
  //     return Future.error(e);
  //   }
  // }
}
