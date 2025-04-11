import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Utils/api_constant.dart';

class ApiServices {
  static final ApiServices _instance = ApiServices._internal();

  ApiServices._internal();

  factory ApiServices() {
    return _instance;
  }

  ///login
  static Future<Map<String, dynamic>> userLogin({
    required String userName,
    required String psw,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.login}";
    print(url);
    Map apiBody = {
      "username": userName,
      "password": psw,
    };
    // try {
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    print('Api body---------------------->${request.body}');
    http.StreamedResponse response = await request.send();
    print('Api bodybenenen---------------------->${response}');

    var respString = await response.stream.bytesToString();
    print('Api body---------------------->${json.decode(respString)}');
    return json.decode(respString);

    // } catch (e) {
    //   throw Exception("Service Error");
    // }
  }

  ///logout
  static Future<Map<String, dynamic>> logout() async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.poweroff}";
    var request = http.Request('POST', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///Reboot
  static Future<Map<String, dynamic>> Reboot(bool data) async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.reboot}";
    print("reboot$url");
    Map apiBody = {
      "status": data,
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///logoutoffline
  static Future<Map<String, dynamic>> logoutoffline(bool data) async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.poweroffoffline}";
    print("logoutofflinelogoutoffline$url");
    Map apiBody = {
      "status": data,
    };
    print("logoutofflinelogoutoffline$apiBody");

    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    print("logoutofflinelogoutben$response");

    var respString = await response.stream.bytesToString();
    print("logoutofflinelogoutoffline$respString");

    return json.decode(respString);
  }

  ///destination

  static Future<Map<String, dynamic>> destination({required int id}) async {
    String url =
        "${ApiConstants.baseUrl1}${ApiConstants.navigationdestinationoffline}$id/";
    print('Api destination--------${url}--------------');

    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('Api destination--------${respString}--------------');

    return json.decode(respString);
  }

  ///robotbasestatus

  static Future<Map<String, dynamic>> robotbasestatus() async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.basestatusoffline}";
    print('Api robotbasestatus--------${url}--------------');

    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///robotResponsee offline

  static Future<Map<String, dynamic>> robotResponsee() async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.robotResponse}";
    print("urlspeaking$url");
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check unknown user
  static Future<Map<String, dynamic>> checkUnknown() async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.checkunknown}";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Session

  static Future<Map<String, dynamic>> session() async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.session}";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check sessionid
  static Future<Map<String, dynamic>> sessionid() async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.sessionid}";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check background

  static Future<Map<String, dynamic>> background({
    required int userId,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.backGround}$userId/";
    print("backgrounddata$url");
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Customerdetails

  static Future<Map<String, dynamic>> customerDetails({
    required String sessionId,
    required String userName,
    required String purPose,
  }) async {
    String url =
        "${ApiConstants.baseUrl}${ApiConstants.customerDetails}$sessionId/";
    Map apiBody = {"username": userName, "purpose": purPose};
    var request = http.Request('PATCH', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check UpdateStatus

  static Future<Map<String, dynamic>> updateStatus({
    required bool status,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.updateStatus}";
    Map apiBody = {"status": status};
    // try {
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check deleteFile

  static Future<Map<String, dynamic>> deleteFile({
    required bool status,
  }) async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.deletefile}";
    Map apiBody = {"status": status};
    // try {
    print("apibody:$apiBody");
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check battery

  static Future<Map<String, dynamic>> battery({
    required int userId,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.battery}$userId/";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check loading

  static Future<Map<String, dynamic>> loading() async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.loading}";
    print("urllllllll$url");
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check EnquiryList

  static Future<Map<String, dynamic>> EnquiryList({
    required int userId,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.enquiryList}$userId";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check EnquirySubList

  static Future<List<dynamic>> EnquiryListSub({
    required int userId,
    required int enquiry,
  }) async {
    String url =
        "${ApiConstants.baseUrl}${ApiConstants.enquiryListSub}${userId}&enquiry_id=$enquiry";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Volume
  static Future<Map<String, dynamic>> volume({
    required String roboid,
    required int volume,
  }) async {
    String url =
        "${ApiConstants.baseUrl1}${ApiConstants.volumeoffline}${roboid}/${volume}/";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check InitialVolume

  static Future<Map<String, dynamic>> volumeinitial({
    required String roboid,
  }) async {
    String url =
        "${ApiConstants.baseUrl1}${ApiConstants.volumeinitialoffline}${roboid}/";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check EnquirylistSubDetails

  static Future<Map<String, dynamic>> EnquiryListSubDetails({
    required int subheading,
    required String heading,
    required String description,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.enquiryListSubdetails}";
    Map apiBody = {
      "subheading": subheading,
      "heading": heading,
      "description": description
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Navigation

  static Future<Map<String, dynamic>> navigate({
    required int userId,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.navigate}$userId";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Navigationoffline

  static Future<Map<String, dynamic>> navigateoffline() async {
    // String url = "http://192.168.1.36:8000/${ApiConstants.navigationoffline}";
    String url = "${ApiConstants.baseUrl1}${ApiConstants.navigationoffline}";
    print("Navigationoffline$url");
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check navigateDescriptionSubmit

  static Future<Map<String, dynamic>> navigateDescriptionSubmit({
    required int userId,
    required String data,
  }) async {
    // String url =
    //     "http://192.168.1.36:8000/${ApiConstants.navigationEditoffline}$userId/";
    String url = "${ApiConstants.baseUrl1}${ApiConstants.navigationEditoffline}$userId/";
    Map apiBody = {
      "description": data,
    };
    print("Navigationoffline$url");
    var request = http.Request('PUT', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Navigationpopup

  static Future<Map<String, dynamic>> navigatePopup({
    required String userId,
    required String message,
  }) async {
    String url =
        "${ApiConstants.baseUrl}${ApiConstants.robotresponsefornavpopupupdate}$userId/";
    Map apiBody = {
      "message": message,
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check password

  static Future<Map<String, dynamic>> password({
    required int userId,
    required String Password,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.password}$userId/";
    Map apiBody = {
      "password": Password,
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();

    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check UpdateEmployee

  static Future<Map<String, dynamic>> updateEmployee({
    required String userId,
    required String employeeID,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.addEmployee}$userId/";
    Map apiBody = {"employee_id": employeeID};
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Update Employee details

  static Future<Map<String, dynamic>> updateEmployeeDetails({
    required String userId,
    required String employeeID,
    required String employeeName,
    required String designatioon,
  }) async {
    String url =
        "${ApiConstants.baseUrl}${ApiConstants.addEmployeeDetails}$employeeID/";
    Map apiBody = {
      "employee_name": employeeName,
      "designation": designatioon,
    };
    var request = http.Request('PUT', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Stop talk

  static Future<Map<String, dynamic>> stopTalk({
    required bool status,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.stoptalk}";
    Map apiBody = {"status": status};
    // try {
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///Train
  static Future<Map<String, dynamic>> train({
    required bool status,
  }) async {
    String url = "${ApiConstants.baseUrl}${ApiConstants.stoptalk}";
    Map apiBody = {"status": status};
    // try {
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///Responsefornav

  static Future<Map<String, dynamic>> Resposefornav({
    required String userId,
  }) async {
    String url =
        "${ApiConstants.baseUrl}${ApiConstants.robotresponsepopup}$userId/";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///Send Responseadta

  static Future<Map<String, dynamic>> sendResponseData({
    required String RobotID,
    required bool status,
  }) async {
    String url =
        "${ApiConstants.baseUrl1}${ApiConstants.robotresponsefornav}/$RobotID/";
    Map apiBody = {"status": status};
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///Send NavigationSubmit

  static Future<Map<String, dynamic>> navigationSubmit({
    required List<int> navigationData,
  }) async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.navigationSubmit}";

    print("navigations...$url");
    Map apiBody = {"navigations": navigationData};
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///Send Apikey

  static Future<Map<String, dynamic>> ApiKey({
    required String Data,
  }) async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.apikey}";

    Map apiBody = {"key": Data};
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///Send Fulltour

  static Future<Map<String, dynamic>> FulltourNavigation({
    required bool Data,
  }) async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.fullTour}";

    Map apiBody = {"status": Data};
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }
}
