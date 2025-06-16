import 'dart:convert';

import 'package:get/get.dart';
import 'package:ihub/Controller/FulltourController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

import '../Model/ipadressModel.dart';
import '../Model/login_model.dart';

class SharedPrefs {
  final _getIt = GetIt.instance;
  SharedPreferences? _prefs;

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception("SharedPreferences has not been initialized.");
    }
    return _prefs!;
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _getIt.registerSingleton<SharedPrefs>(this);
  }

  Future<bool> setLoginData(LoginModel loginApi) async {
    Map<String, dynamic> api = loginApi.toJson();
    String encodedData = json.encode(api);
    final sharedPrefs = GetIt.instance<SharedPrefs>();
    final prefs = sharedPrefs.prefs;
    return await prefs.setString("loginData", encodedData);
  }

  Future<LoginModel?> getLoginData() async {
    final sharedPrefs = GetIt.instance<SharedPrefs>();
    final prefs = sharedPrefs.prefs;
    String? res = prefs.getString("loginData");
    if (res != null) {
      Map<String, dynamic> api = json.decode(res);
      LoginModel loginApiModel = LoginModel.fromJson(api);
      return loginApiModel;
    }
    return null;
  }

  Future<bool> removeLoginData() async {
    final sharedPrefs = GetIt.instance<SharedPrefs>();
    final prefs = sharedPrefs.prefs;
    FullTourControllerNew fullTourController = Get.find();
    fullTourController.clearData();

    bool done = await prefs.remove("loginData");
    return done;
  }

  Future<bool> setIPData(ipAddressModel ipAddressApi) async {
    Map<String, dynamic> api = ipAddressApi.toJson();
    String encodedData = json.encode(api);
    final sharedPrefs = GetIt.instance<SharedPrefs>();
    final prefs = sharedPrefs.prefs;
    return await prefs.setString("IpAddress", encodedData);
  }

  Future<ipAddressModel?> getIPData() async {
    final sharedPrefs = GetIt.instance<SharedPrefs>();
    final prefs = sharedPrefs.prefs;
    String? res = prefs.getString("IpAddress");
    if (res != null) {
      Map<String, dynamic> api = json.decode(res);
      ipAddressModel ben = ipAddressModel.fromJson(api);
      return ben;
    }
    return null;
  }

  Future<bool> removeIPData() async {
    final sharedPrefs = GetIt.instance<SharedPrefs>();
    final prefs = sharedPrefs.prefs;
    bool done = await prefs.remove("IpAddress");
    return done;
  }

  // store id
  Future storeRoboId(int id) async {
    final sharedPrefs = GetIt.instance<SharedPrefs>();
    final prefs = sharedPrefs.prefs;
    prefs.setInt("roboId", id);
  }

  // get robot id
  Future<int?> getRobotdId() async {
    final sharedPrefs = GetIt.instance<SharedPrefs>();
    final prefs = sharedPrefs.prefs;
    int? id = prefs.getInt("roboId");
    return id;
  }
}
