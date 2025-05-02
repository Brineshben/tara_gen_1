// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:ihub/Utils/api_constant.dart';

import 'package:get/get.dart';
import 'package:ihub/Controller/RobotresponseApi_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UrlService {
//   static Future<Map<String, dynamic>> addUrl({
//     required String name,
//     required String urlpage,
//   }) async {
//     var url = "${ApiConstants.baseUrl1}${ApiConstants.addUrl}";

//     print('add-url $url');

//     Map<String, dynamic> apiBody = {
//       'name': name,
//       'url': urlpage,
//     };

//     print('passedurl $urlpage');

//     try {
//       var request = http.Request('POST', Uri.parse(url));
//       request.body = (json.encode(apiBody));
//       http.StreamedResponse response = await request.send();
//       var respString = await response.stream.bytesToString();

//       print('urlResponse ${json.decode(respString)}');

//       return json.decode(respString);
//     } catch (e) {
//       print('catcherror $e');
//       throw Exception('Failed to add URL: $e');
//     }
//   }

//   static Future<Map<String, dynamic>> getUrls() async {
//     final response = await http.get(
//       Uri.parse(ApiConstants.baseUrl1 + ApiConstants.getUrl),
//     );
//     final decodedData = jsonDecode(response.body);
//     print('geturlrespo $decodedData');
//     return decodedData;
//   }

  static storeUrl({
    required String name,
    required String urlpage,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('url');
    prefs.remove('name');

    await prefs.setString('url', urlpage);
    await prefs.setString('name', name);

    await Get.find<RobotresponseapiController>().getUrl();
  }
}
