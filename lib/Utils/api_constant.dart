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
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/battery_Controller.dart';

class ApiConstants {
  static final ApiConstants _instance = ApiConstants._internal();

  ApiConstants._internal();

  factory ApiConstants() {
    return _instance;
  }

  static String _defaultBaseUrl1 = "http://192.168.1.31:8000";
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
    String newUrl = "http://$newIp:8000"; // Format base URL

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('stored_ip', newUrl);

    print('newwwwwwwwwww $newUrl');
    _baseUrl1 = newUrl; // Update in memory
  }

  // static String baseUrl = "http://54.163.176.141/";
  // static String baseUrl = "http://54.211.212.147";
  // static String baseUrl = "http://54.152.17.211";
  static String baseUrl = "http://3.88.46.127";

  static String addUrl = "/url/add/";
  static String getUrl = "/url/list/";
  static String setHome = "/home/set/";

  ///offline
  static String poweroffoffline = "/update-reboot-status/";
  static String navigationoffline = "/navigation/list/";
  static String navigationEditoffline = "/navigation/edit/";
  static String navigationdestinationoffline = "/navigation/";
  static String basestatusoffline = "/base/status/";
  static String volumeoffline = "/volume/set/";
  static String volumeinitialoffline = "/volume/get/";
  static String deletefile = "/delete-status/";
  static String delteMap = "/stcm_files/delete/";
  static String apikey = "/api-key/upload/";
  static String fullTour = "/tour/update/";
  static String reboot = "/update-reboot-status/";

  //  description
  static String description = "/add_wishing_commands/";
  static String edit_wishing_commands = "/edit_wishing_commands/";
  static String deactivate_description = "/deactivate_description/";

  // prompt
  static String commandPrompt = "/command_prompt/";
  static String command_prompt_edit = "/command_prompt_edit/";
  static String deactivate_command_prompt = "/deactivate_command_prompt/";

  // map kill
  // static String fetch_refresh_status = "/fetch_refresh_status/";
  static String fetch_refresh_status = "/start_stop_button_press/";

  // speed
  static String updateSpeed = "/speed/value/";
  static String getSpeed = "/current_speed/";

  // charging dock
  static String chargingDock = "/charging/set/";

  //  get language
  static String getLanguage = "/robot/languages/list/";
  static String setLanguage = "/robot/languages/edit/";

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
  static String batteryOffline = "/robot-battery/list/";
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

  // update charge / get current charge
  static String chargeUpdate = "/charge/update/";
  static String getCurrentCharge = "/charge/current/";

  // static String volume = "/enquiry/volume/set/";
  // static String volumeinitial = "/enquiry/volume/get/";
  static String robotresponsepopup = "/enquiry/robot/message/get/";
  static String navigationSubmit = "/full_tour/create/";
  static String robotresponsefornavpopupupdate = "/enquiry/robot/message/post/";
  static String robotresponsefornav = "/robot/button/clicked/";
}

/// Function to fetch the IP address from API and update baseUrl1
/// Function to fetch the IP address from API and update baseUrl1
/// Function to fetch the IP address from API and update baseUrl1
Future<void> fetchAndUpdateBaseUrl() async {
  try {
    String data = Get.find<BatteryController>()
            .background
            .value
            ?.data
            ?.first
            .robot
            ?.roboId ??
        "";
    print("objectresponse$data");

    String url =
        "${ApiConstants.baseUrl}/robot/get-last-ip/${Get.find<BatteryController>().background.value?.data?.first.robot?.roboId ?? ""}/";

    print("url${url}");
    final response = await http.get(Uri.parse(
        "${ApiConstants.baseUrl}/robot/get-last-ip/${Get.find<BatteryController>().background.value?.data?.first.robot?.roboId ?? ""}/"));
    print(
        'robo id ${Get.find<BatteryController>().background.value?.data?.first.robot?.roboId}');
    // print("objectresfgdfghponse$url");
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
