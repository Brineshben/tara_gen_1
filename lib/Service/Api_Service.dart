import 'dart:convert';
import 'dart:io';

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
    String url = "${ApiConstants.globalip}${ApiConstants.login}";
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
  static Future<Map<String, dynamic>> poweroff() async {
    String url = "${ApiConstants.localIp}${ApiConstants.poweroff}";
    var request = http.Request('POST', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///Reboot
  static Future<Map<String, dynamic>> Reboot(bool data) async {
    String url = "${ApiConstants.localIp}${ApiConstants.reboot}";
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


    static Future<Map<String, dynamic>> checkTeachingMode() async {
    try {
      String url = "${ApiConstants.localIp}${ApiConstants.getModeStatus}";

      final response = await http.get(Uri.parse(url));

      print('checkTeachingMode response: ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print('checkTeachingMode error: $e');
      throw Exception("Failed to check teaching mode");
    }
  }


    // change Teaching Mode
  static Future<Map<String, dynamic>> changeTeachingMode(
      {required bool status}) async {
    try {
      String url = "${ApiConstants.localIp}${ApiConstants.changeTeachingmode}";

      final body = jsonEncode({"status": status});

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('changeTeachingMode error: $e');
      throw Exception("Failed to update teaching mode");
    }
  }



  
  static Future<Map<String, dynamic>> uploadPDF(File file) async {
    try {
      String url = "${ApiConstants.localIp}${ApiConstants.uploadTeachingPdf}";

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      final response = await request.send();

      final res = await response.stream.bytesToString();
      print('pdf $res');
      return jsonDecode(res);
    } catch (e) {
      print('uploadPDF error: $e');
      throw Exception("PDF upload failed");
    }
  }

  static Future<Map<String, dynamic>> getLatestPDF() async {
    try {
      String url = "${ApiConstants.localIp}${ApiConstants.getTeachingPdf}";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );
      print('getLatestPDF response: ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print('getLatestPDF error: $e');
      throw Exception("Failed to get latest PDF");
    }
  }

  ///logoutoffline
  static Future<Map<String, dynamic>> restart(bool data) async {
    String url = "${ApiConstants.localIp}${ApiConstants.restart}";
    print("logoutofflinelogoutoffline$url");
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

  ///destination
  static Future<Map<String, dynamic>> destination({required int id}) async {
    String url =
        "${ApiConstants.localIp}${ApiConstants.navigationdestinationoffline}$id/";

    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('Api destination---url $url-----${respString}--------------');
    return json.decode(respString);
  }

  ///robotbasestatus
  static Future<Map<String, dynamic>> robotbasestatus() async {
    String url = "${ApiConstants.localIp}${ApiConstants.basestatusoffline}";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('Api destination-----url $url---${respString}');
    return json.decode(respString);
  }

  ///robotResponsee offline
  static Future<Map<String, dynamic>> robotResponsee() async {
    String url = "${ApiConstants.localIp}${ApiConstants.robotResponse}";
    print("urlspeaking$url");
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print("robotresponce$respString");
    return json.decode(respString);
  }

  ///check unknown user
  static Future<Map<String, dynamic>> checkUnknown() async {
    String url = "${ApiConstants.globalip}${ApiConstants.checkunknown}";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Session

  static Future<Map<String, dynamic>> session() async {
    String url = "${ApiConstants.globalip}${ApiConstants.session}";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check sessionid
  static Future<Map<String, dynamic>> sessionid() async {
    String url = "${ApiConstants.globalip}${ApiConstants.sessionid}";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check background
  // static Future<Map<String, dynamic>> background({
  //   required int userId,
  // }) async {
  //   try {
  //     String url = "${ApiConstants.baseUrl}${ApiConstants.backGround}$userId/";
  //     print("backgrounddata$url");
  //     var request = http.Request('GET', Uri.parse(url));
  //     request.headers.addAll(
  //       {'Content-Type': 'application/json'},
  //     );
  //     var response = await request.send();
  //     print("response---------------- $response");
  //     var respString = await response.stream.bytesToString();
  //     // print('bbbbbbbbbbbbbbbb ${json.decode(respString)}');
  //     return json.decode(respString);
  //   } catch (e) {
  //     print('bgerror $e');
  //     throw (e);
  //   }
  // }try {
//       var request = http.Request('GET', Uri.parse(url));
//       request.headers.addAll({'Authorization': "Bearer $token"});
//       http.StreamedResponse response = await request.send();
//       print('consultDoctorList------>${response}');

//       var respString = await response.stream.bytesToString();
//       return json.decode(respString);
//     } catch (e) {
//       throw Exception("Service Error consultDoctorList");
//     }

  static Future<Map<String, dynamic>> background({required int userId}) async {
    String url = "${ApiConstants.globalip}${ApiConstants.backGround}$userId/";
    print("backgrounddata $url");
    try {
      var request = http.Request('GET', Uri.parse(url));
      http.StreamedResponse response = await request.send();
      print('backgroung------>${response}');
      var respString = await response.stream.bytesToString();
      return json.decode(respString);
    } catch (e) {
      print('bgerror $e');
      throw (e);
    }
  }

  ///check Customerdetails
  static Future<Map<String, dynamic>> customerDetails({
    required String sessionId,
    required String userName,
    required String purPose,
  }) async {
    String url =
        "${ApiConstants.globalip}${ApiConstants.customerDetails}$sessionId/";
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
    String url = "${ApiConstants.globalip}${ApiConstants.updateStatus}";
    Map apiBody = {"status": status};
    // try {
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  // delete map from server
  // static Future<Map<String, dynamic>> deleteFileServer({
  //   required bool status,
  // }) async {
  //   String url = "http://54.211.212.147${ApiConstants.deletefile}";
  //   print("urlurlurlurlurlurlurl:$url");
  //   Map apiBody = {"status": status};
  //   // try {
  //   print("apibody:$apiBody");
  //   var request = http.Request('POST', Uri.parse(url));
  //   request.body = (json.encode(apiBody));
  //   request.headers.addAll({'Content-Type': 'application/json'});
  //   http.StreamedResponse response = await request.send();
  //   var respString = await response.stream.bytesToString();
  //   print('filedelete ${respString}');
  //   print(json.decode(respString));
  //   return json.decode(respString);
  // }

// delete map from local
  static Future<Map<String, dynamic>> deleteFileLocal({
    required String robotId,
  }) async {
    try {
      String url = "${ApiConstants.localIp}${ApiConstants.delteMap}$robotId/";
      print("DELETE URL: $url");

      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.body.trim().isEmpty) {
        return {'status': 'ok', 'detail': 'Map deleted successfully'};
      }

      return json.decode(response.body);
    } catch (e) {
      print('Error in deleteFileLocal: $e');
      return {'status': 'error', 'detail': e.toString()};
    }
  }

  ///check battery
  static Future<Map<String, dynamic>> battery({
    required int userId,
  }) async {
    String url = "${ApiConstants.globalip}${ApiConstants.battery}$userId/";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();

    print('batteryurl $url');

    print('service ressssssssspo ${respString}');
    return json.decode(respString);
  }

  ///check battery offline
  static Future<Map<String, dynamic>> batteryOffline() async {
    String url = "${ApiConstants.localIp}${ApiConstants.batteryOffline}";
    print("urlllllsddlll$url");
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print("offlinebatteryresponse$respString");
    return json.decode(respString);
  }

  ///check loading
  static Future<Map<String, dynamic>> loading() async {
    try {
      String url = "${ApiConstants.localIp}${ApiConstants.loading}";
      print("urllllllll  $url");
      var request = http.Request('GET', Uri.parse(url));
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      print('robotresponce ${json.decode(respString)}');
      return json.decode(respString);
    } catch (e) {
      throw (e);
    }
  }

  static Future<Map<String, dynamic>> getBatteryStatus() async {
    String url = "${ApiConstants.localIp}${ApiConstants.getBatteryStatus}";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('offline battery response ${respString}');
    return json.decode(respString);
  }

// map restart
  static Future<Map<String, dynamic>> mapRestart() async {
    String url = "${ApiConstants.localIp}${ApiConstants.fetch_refresh_status}";

    Map apiBody = {"status": true};
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('maprestatr ${json.decode(respString)}');
    return json.decode(respString);
  }

  ///check EnquiryList

  static Future<Map<String, dynamic>> EnquiryList({
    required int userId,
  }) async {
    String url = "${ApiConstants.globalip}${ApiConstants.enquiryList}$userId";
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
        "${ApiConstants.globalip}${ApiConstants.enquiryListSub}${userId}&enquiry_id=$enquiry";
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
        "${ApiConstants.localIp}${ApiConstants.volumeoffline}${roboid}/${volume}/";
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
        "${ApiConstants.localIp}${ApiConstants.volumeinitialoffline}${roboid}/";

        print('volume_url $url');
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
    String url = "${ApiConstants.globalip}${ApiConstants.enquiryListSubdetails}";
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
    String url = "${ApiConstants.globalip}${ApiConstants.navigate}$userId";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///check Navigationoffline

  static Future<Map<String, dynamic>> navigateoffline() async {
    String url = "${ApiConstants.localIp}${ApiConstants.navigationoffline}";
    print("Navigationoffline$url");
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('navigation list $respString');
    return json.decode(respString);
  }

  ///check Navigationoffline

  static Future<Map<String, dynamic>> setHOme() async {
    String url = "${ApiConstants.localIp}${ApiConstants.setHome}";
    Map apiBody = {
      "status": true,
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('homeButtonresponcse $respString');
    return json.decode(respString);
  }

  ///check navigateDescriptionSubmit
  static Future<Map<String, dynamic>> navigateDescriptionSubmit({
    required int userId,
    required String description,
  }) async {
    // String url =
    //     "http://192.168.1.36:8000/${ApiConstants.navigationEditoffline}$userId/";
    String url =
        "${ApiConstants.localIp}${ApiConstants.navigationEditoffline}$userId/";
    Map apiBody = {
      "description": description,
    };
    print("Navigationoffline$url");
    var request = http.Request('PUT', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();

    var respString = await response.stream.bytesToString();
    print('placedesresponcse $respString');
    return json.decode(respString);
  }

  ///check Navigationpopup

  static Future<Map<String, dynamic>> navigatePopup({
    required String userId,
    required String message,
  }) async {
    String url =
        "${ApiConstants.globalip}${ApiConstants.robotresponsefornavpopupupdate}$userId/";
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
    String url = "${ApiConstants.globalip}${ApiConstants.password}$userId/";
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
    String url = "${ApiConstants.globalip}${ApiConstants.addEmployee}$userId/";
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
        "${ApiConstants.globalip}${ApiConstants.addEmployeeDetails}$employeeID/";
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
    String url = "${ApiConstants.globalip}${ApiConstants.stoptalk}";
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
    String url = "${ApiConstants.globalip}${ApiConstants.stoptalk}";
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
  static Future<Map<String, dynamic>> resposefornav({
    required String userId,
  }) async {
    String url =
        "${ApiConstants.localIp}${ApiConstants.robotresponsepopup}$userId/";
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('navigationListdata $respString');
    return json.decode(respString);
  }

  ///Send Responseadta
  static Future<Map<String, dynamic>> sendResponseData({
    required String RobotID,
    required bool status,
  }) async {
    String url =
        "${ApiConstants.localIp}${ApiConstants.robotresponsefornav}/$RobotID/";
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
    String url = "${ApiConstants.localIp}${ApiConstants.navigationSubmit}";

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
    String url = "${ApiConstants.localIp}${ApiConstants.apikey}";
    Map apiBody = {"key": Data};
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

  ///Send Fulltour

  static Future<Map<String, dynamic>> fulltourNavigation({
    required bool status,
  }) async {
    String url = "${ApiConstants.localIp}${ApiConstants.fullTour}";

    Map apiBody = {"status": status};
    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({'Content-Type': 'application/json'});
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    return json.decode(respString);
  }

// GO CHARGING DOK
  static setChargingStatus(bool status) async {
    String url = "${ApiConstants.localIp}${ApiConstants.chargingDock}";
    final response = await http.post(
      headers: {
        'Content-Type': 'application/json',
      },
      Uri.parse(url),
      body: jsonEncode({'status': status}),
    );
    print(' chargingdock ${response.body}');
    return jsonDecode(response.body);
  }

// DELETE DESCRIPTION
  static deleteDescription(int id) async {
    String url =
        "${ApiConstants.localIp}${ApiConstants.deactivate_description}";
    final response = await http.post(
      Uri.parse(url),
      body: {'pk': id.toString()},
    );
    print('deleteresponce ${response.body}');
    return jsonDecode(response.body);
  }

// DELETE PROMPT
  // static deletePrompt(int id) async {
  //   String url =
  //       "${ApiConstants.baseUrl1}${ApiConstants.deactivate_command_prompt}";
  //   final response = await http.post(
  //     Uri.parse(url),
  //     body: {'pk': id.toString()},
  //   );
  //   print('deleteresponce ${response.body}');
  //   return jsonDecode(response.body);
  // }

  // get language
  static Future<Map<String, dynamic>> fetchLanguages() async {
    try {
      String url = "${ApiConstants.globalip}${ApiConstants.getLanguage}";
      final response = await http.get(Uri.parse(url));
      print('getlanguagelist${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  static Future<Map<String, dynamic>> fetchUploadedMap({required String robotId}) async {
    try {
      String url = "${ApiConstants.localIp}${ApiConstants.uploadedMap}$robotId/";
      final response = await http.get(Uri.parse(url));

      print('map_response ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Map<String, dynamic>> setLanguage({
    required String language,
    required String robotId,
  }) async {
    try {
      String url = "${ApiConstants.globalip}${ApiConstants.setLanguage}";
      final body = jsonEncode({
        robotId: {
          "language": language,
        }
      });
      print('body $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // important for JSON body
        },
        body: body,
      );

      print('language response: ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print('updatelan $e');
    }

    throw Exception("Failed to set language");  
  }
}
