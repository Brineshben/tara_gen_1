import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ihub/Utils/api_constant.dart';

class SpeedService {
  // get speed
  static Future<Map<String, dynamic>?> speedGet() async {
    try {
      String url = "${ApiConstants.baseUrl1}${ApiConstants.getSpeed}";
      print("speed url $url");
      final response = await http.get(Uri.parse(url));
      print('rsponse body ${response.body}');
      final jsonData = jsonDecode(response.body);
      print('decoded data ${response.body}');
      return jsonData;
    } catch (e) {
      throw (e);
    }
  }

  // set volume
  static Future<Map<String, dynamic>> speedUpdate({
    required double speed,
  }) async {
    print('speed $speed');
    String url = "${ApiConstants.baseUrl1}${ApiConstants.updateSpeed}";
    print('post url $url');
    final response = await http.post(
      Uri.parse(url),
      body: {"value": speed.toString()},
    );
    print('speedresponce ${response.body}');
    return json.decode(response.body);
  }
}
