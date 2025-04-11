// import 'package:shared_preferences/shared_preferences.dart';
//
// class ApiConstants {
//   static final ApiConstants _instance = ApiConstants._internal();
//
//   ApiConstants._internal();
//
//   factory ApiConstants() {
//     return _instance;
//   }
//
//   static String _defaultBaseUrl1 = "http://192.168.0.170:8000"; // Default IP
//   static String _baseUrl1 = _defaultBaseUrl1;
//
//   /// Load stored IP from SharedPreferences
//   static Future<void> loadBaseUrl1() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _baseUrl1 = prefs.getString('stored_text') ?? _defaultBaseUrl1;
//   }
//
//   /// Getter for baseUrl1 (always returns the latest value)
//   static String get baseUrl1 => _baseUrl1;
//
//   /// Update baseUrl1 in SharedPreferences and memory
//   static Future<void> updateBaseUrl1(String newUrl) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('stored_text', newUrl);
//     _baseUrl1 = newUrl; // Update in memory
//   }
//
//   static String baseUrl = "https://anumolm403.pythonanywhere.com";
//
//   ///offline
//   static String poweroffoffline = "/off/";
//   static String navigationoffline = "/navigation/list/";
//   static String navigationdestinationoffline = "/navigation/";
//   static String basestatusoffline = "/base/status/";
//   static String volumeoffline = "/volume/set/";
//   static String volumeinitialoffline = "/volume/get/";
//   static String deletefile = "/delete-status/";
//   static String apikey = "/api-key/upload/";
//   static String  fullTour= "/tour/update/";
//   static String reboot = "/update-reboot-status/";
//
//   ///online
//
//   static String login = "/accounts/login/";
//   static String poweroff = "/off/";
//   static String robotResponse = "/list_status/";
//   static String checkunknown = "/accounts/status/get/";
//   static String backGround = "/accounts/list/background/images/";
//   static String session = "/accounts/session_id/generate/";
//   static String sessionid = "/robot/latest-customer-session/";
//   static String customerDetails = "/robot/customer/edit/";
//   static String updateStatus = "/accounts/video/update/";
//   static String battery = "/robot/sale/user/list/";
//   static String enquiryList = "/enquiry/list/enquiries/?user_id=";
//   static String navigate = "/enquiry/navigation/list/";
//   static String destination = "/enquiry/navigation/";
//   static String addEmployee = "/robot/add/employee/";
//   static String addEmployeeDetails = "/robot/edit/employee/";
//   static String enquiryListSub = "/enquiry/subbutton/list/?user_id=";
//   static String enquiryListSubdetails = "/enquiry/create/enquiry/details/";
//   static String password = "/accounts/verify-password/";
//   static String stoptalk = "/enquiry/talk/stop/update/";
//   static String train = "/accounts/update/model/status/";
//   static String emergency = "/robot/robot/detail/";
//
//   // static String volume = "/enquiry/volume/set/";
//   // static String volumeinitial = "/enquiry/volume/get/";
//   static String robotresponsepopup = "/enquiry/robot/message/get/";
//   static String navigationSubmit = "/full_tour/create/";
//   static String robotresponsefornavpopupupdate = "/enquiry/robot/message/post/";
//   static String robotresponsefornav = "/robot/button/clicked/";
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Controller/Login_api_controller.dart';
import '../Controller/battery_Controller.dart';

class ApiConstants {
  static final ApiConstants _instance = ApiConstants._internal();

  ApiConstants._internal();

  factory ApiConstants() {
    return _instance;
  }

  static String _defaultBaseUrl1 = "http://192.168.0.170:8000"; // Default IP
  static String _baseUrl1 = _defaultBaseUrl1;

  /// Load stored IP from SharedPreferences
  static Future<void> loadBaseUrl1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _baseUrl1 = prefs.getString('stored_ip') ?? _defaultBaseUrl1;
  }

  /// Getter for baseUrl1 (always returns the latest value)
  static String get baseUrl1 => _baseUrl1;

  /// Update baseUrl1 in SharedPreferences and memory
  static Future<void> updateBaseUrl1(String newIp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newUrl = "http://$newIp:8000"; // Format base URL
    await prefs.setString('stored_ip', newUrl);
    _baseUrl1 = newUrl; // Update in memory
  }

  static String baseUrl = "https://anumolm403.pythonanywhere.com";

  ///offline
  static String poweroffoffline = "/update-reboot-status/";
  static String navigationoffline = "/navigation/list/";
  static String navigationEditoffline = "/navigation/edit/";
  static String navigationdestinationoffline = "/navigation/";
  static String basestatusoffline = "/base/status/";
  static String volumeoffline = "/volume/set/";
  static String volumeinitialoffline = "/volume/get/";
  static String deletefile = "/delete-status/";
  static String apikey = "/api-key/upload/";
  static String fullTour = "/tour/update/";
  static String reboot = "/update-reboot-status/";

  ///online

  static String login = "/accounts/login/";
  static String poweroff = "/off/";
  static String robotResponse = "/list_status/";
  static String checkunknown = "/accounts/status/get/";
  static String backGround = "/accounts/list/background/images/";
  static String session = "/accounts/session_id/generate/";
  static String sessionid = "/robot/latest-customer-session/";
  static String customerDetails = "/robot/customer/edit/";
  static String updateStatus = "/accounts/video/update/";
  static String battery = "/robot/sale/user/list/";
  static String loading = "/status/";
  static String enquiryList = "/enquiry/list/enquiries/?user_id=";
  static String navigate = "/enquiry/navigation/list/";
  static String destination = "/enquiry/navigation/";
  static String addEmployee = "/robot/add/employee/";
  static String addEmployeeDetails = "/robot/edit/employee/";
  static String enquiryListSub = "/enquiry/subbutton/list/?user_id=";
  static String enquiryListSubdetails = "/enquiry/create/enquiry/details/";
  static String password = "/accounts/verify-password/";
  static String stoptalk = "/enquiry/talk/stop/update/";
  static String train = "/accounts/update/model/status/";
  static String emergency = "/robot/robot/detail/";

  // static String volume = "/enquiry/volume/set/";
  // static String volumeinitial = "/enquiry/volume/get/";
  static String robotresponsepopup = "/enquiry/robot/message/get/";
  static String navigationSubmit = "/full_tour/create/";
  static String robotresponsefornavpopupupdate = "/enquiry/robot/message/post/";
  static String robotresponsefornav = "/robot/button/clicked/";
}

/// Function to fetch the IP address from API and update baseUrl1
Future<void> fetchAndUpdateBaseUrl() async {
  try {
    String data =Get.find<BatteryController>().background.value?.data?.first.robot?.roboId ?? "";
    print("objectresponse$data");

    String url =
        "https://anumolm403.pythonanywhere.com/robot/get-last-ip/${Get.find<BatteryController>().background.value?.data?.first.robot?.roboId ?? ""}/";
    final response = await http.get(Uri.parse(
        "https://anumolm403.pythonanywhere.com/robot/get-last-ip/${Get.find<BatteryController>().background.value?.data?.first.robot?.roboId ?? ""}/"));
    print("objectresponse$url");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      String? ipAddress = jsonResponse['data']['ip_address'];
      if (ipAddress != null) {
        await ApiConstants.updateBaseUrl1(ipAddress);
      }
    }
  } catch (e) {
    print("Error fetching IP: $e");
  }
}
