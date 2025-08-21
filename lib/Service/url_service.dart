// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:ihub/Utils/api_constant.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ihub/Utils/api_constant.dart';

class UrlService {
  static Future<Map<String, dynamic>> addUrl({
    required String name,
    required String urlpage,
  }) async {
    var url = "${ApiConstants.localIp}${ApiConstants.addUrl}";

    print('add-url $url');

    Map<String, dynamic> apiBody = {
      'name': name,
      'url': urlpage,
    };

    print('passedurl $urlpage');

    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));

      // 🔹 Add JSON headers
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      // 🔹 Encode body as JSON
      request.body = json.encode(apiBody);

      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();

      print('urlResponse ${json.decode(respString)}');

      return json.decode(respString);
    } catch (e) {
      print('catcherror $e');
      throw Exception('Failed to add URL: $e');
    }
  }

  static getUrls() async {
    final response =
        await http.get(Uri.parse(ApiConstants.localIp + ApiConstants.getUrl));

    final jsonData = jsonDecode(response.body);
    print('get_web_link ${response.body}');
    return jsonData;
  }
}
