
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class CheckConnectivity {
  Future<bool> check() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> goodConnection() async {
    try {
      http.Response response =
      await http.get(Uri.parse("https://www.google.com/"));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String> connectionType() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi) {
      return "Connected to wifi";
    } else if (connectivityResult == ConnectivityResult.mobile) {
      return "Connected to mobile network";
    } else {
      return "User not connected to any network";
    }
  }

// Future<String?> wifiName() async {
//   final connectivityResult = await (Connectivity().checkConnectivity());
//
//   if (connectivityResult == ConnectivityResult.wifi) {
//     String? wifiName = await NetworkInfo().getWifiName();
//     return wifiName;
//   } else {
//     return null;
//   }
// }
}