import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigManager {
  FirebaseRemoteConfig? remoteConfig;

  static Future<FirebaseRemoteConfig> setupRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 3),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await remoteConfig.setDefaults(<String, dynamic>{
      'bitacoraUpdateOptionalIosActive': false,
      'bitacoraUpdateOptionalAndroidActive': false,
      'version_app_bitacora_andorid': '1.0.0',
      'version_app_bitacora_ios': '1.0.0'
    });
    try {
      await remoteConfig.fetchAndActivate();
      print('LOS VAMORES DE REMOTE CONFIG: ' +
          remoteConfig.getString('debugUsers'));
      return remoteConfig;
    } catch (e) {
      print('LOS VAMORES DE REMOTE CONFIG: ' +
          remoteConfig.getString('debugUsers'));
      return remoteConfig;
    }
  }

}