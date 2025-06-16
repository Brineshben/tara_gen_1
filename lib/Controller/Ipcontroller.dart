import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/api_constant.dart';

class IpController extends GetxController {
  var ipAddress = ''.obs; // Observable IP address

  @override
  void onInit() {
    super.onInit();
    loadStoredIp(); // Load stored IP on initialization
  }

  Future<void> loadStoredIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ipAddress.value = prefs.getString('stored_text') ?? "No Data";
  }

  Future<void> updateIp(String newIp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('stored_text', newIp);
    ipAddress.value = newIp; // Automatically update UI

    // Update the API constant
    await ApiConstants.updateBaseUrl1(newIp);
  }
}
