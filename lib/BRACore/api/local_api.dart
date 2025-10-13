import 'dart:convert';

import 'package:qr_scaner_manrique/BRACore/models/response_models/area_model.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/auth_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalApi {



  saveUserData(userLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userLogin', jsonEncode(userLogin));
  }
  saveAreaSelected(Area selectedArea) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('areaSelected', jsonEncode(selectedArea));
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
  Future<Area?> getAreaselected() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    if (perf.getString('areaSelected') != null) {
      Map<String, dynamic> areastr = jsonDecode(perf.getString('areaSelected')!);
      final area = Area.fromJson(areastr);
      return area;
    } else {
      return Future.value(null);
    }
  }
}