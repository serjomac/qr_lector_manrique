import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/auth_login.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/lector_response.dart';
import 'package:qr_scaner_manrique/BRACore/models/response_models/place.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  UserData._internal();
  static final UserData _instance = UserData._internal();
  static UserData get sharedInstance => _instance;
  AuthLoginModel? _userLogin;
  Place? _placeSelected;
  List<Place>? _properties;
  // List<Invitation>? _invitations;
  // List<Permisos>? _permissons;
  bool isNonConnectionDialogPresented = false;
  bool _noConnectionPermisson = false;
  String tokenFCM = '';
  LectorResponse? savedGuest;

  // GETTER AND SETTERS

  AuthLoginModel? get userLogin {
    return _userLogin;
  }

  Place? get placeSelected {
    return _placeSelected;
  }

  // List<Permisos>? get permissons {
  //   return _permissons;
  // }

  List<Place>? get properties {
    return _properties;
  }

  bool get noConnectionPermisson {
    return _noConnectionPermisson;
  }

  set userLogin(AuthLoginModel? userLogin) {
    _userLogin = userLogin;
    saveUserData(userLogin);
  }

  set placeSelected(Place? place) {
    _placeSelected = place;
  }

  // set permissons(List<Permisos>? permissons) {
  //   _permissons = permissons;
  // }

  saveProperties(List<Place>? properties) async {
    _properties = properties;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('properties', json.encode(_properties));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Place>> getSavedProperties() async {
    SharedPreferences perf = await SharedPreferences.getInstance();
    List<Place> propertiesTmp = [];
    if (perf.getString('properties') != null) {
      propertiesTmp = placeFromJson(perf.getString('properties')!);
      _properties = propertiesTmp;
    }
    return propertiesTmp;
  }

  saveUserData(userLogin) async {
    _userLogin = userLogin;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userLogin', jsonEncode(userLogin));
    } catch (e) {
      log(e.toString());
    }
  }

  removeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('onboardingPresented') == null) {
      await prefs.clear();
    } else {
      await prefs.clear();
      await prefs.setBool('onboardingPresented', true);
    }
    _userLogin = null;
    _placeSelected = null;
  }

  // savePermissons(List<Permisos> permissons, String placeId) async {
  //   try {
  //     _permissons = permissons;
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('permissons$placeId', json.encode(permissons));
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  removePermissons({required List<Place> places}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      for (var place in places) {
        await prefs.remove('permissons${place.idLugar}');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<List<Permisos>> getSavedPermissons(String placeId) async {
  //   SharedPreferences perf = await SharedPreferences.getInstance();
  //   List<Permisos> permissonsTmp = [];
  //   if (perf.getString('permissons$placeId') != null) {
  //     permissonsTmp = permisosFromJson(perf.getString('permissons$placeId')!);
  //     _permissons = permissonsTmp;
  //   }
  //   return permissonsTmp;
  // }

}
