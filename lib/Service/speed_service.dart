import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ihub/Utils/api_constant.dart';

class SpeedService {
  // get speed
  static Future<Map<String, dynamic>?> speedGet() async {
    try {
      String url = "${ApiConstants.localIp}${ApiConstants.getSpeed}";
      final response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } catch (e) {
      throw (e);
    }
  }

  // set volume
  static Future<Map<String, dynamic>> speedUpdate({
    required double speed,
  }) async {
    String url = "${ApiConstants.localIp}${ApiConstants.updateSpeed}";
    final response = await http.post(
      Uri.parse(url),
      body: {"value": speed.toString()},
    );
    return json.decode(response.body);
  }
}
