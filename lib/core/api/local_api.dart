import 'dart:convert';

import 'package:qr_scaner_manrique/core/models/response_models/auth_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalApi {



  saveUserData(userLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userLogin', jsonEncode(userLogin));
  }

  Future<AuthLoginModel?> getUserData() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    if (perf.getString('userLogin') != null) {
      Map<String, dynamic> userDataStr = jsonDecode(perf.getString('userLogin')!);
      final userData = AuthLoginModel.fromJson(userDataStr);
      return userData;
    } else {
      return Future.value(null);
    }
  }
}