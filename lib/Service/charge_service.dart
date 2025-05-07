import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ihub/Utils/api_constant.dart';

class ChargeService {
  static Future<Map<String, dynamic>> updateCharge({
    required String batteryEntry,
    required String homeEntry,
  }) async {
    String url = "${ApiConstants.baseUrl1}${ApiConstants.chargeUpdate}";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          "low_battery_entry": batteryEntry,
          "back_to_home_entry": homeEntry,
        },
      );

      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');

      return json.decode(response.body);
    } catch (e) {
      print('Exception occurred: $e');
      return {'error': e.toString()};
    }
  }

  // get charge
  static Future<Map<String, dynamic>> fetchCurrentCharge() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.getCurrentCharge}"),
      );
      print('GET Status: ${response.statusCode}');
      print('GET Body: ${response.body}');
      return json.decode(response.body);
    } catch (e) {
      print('Fetch Charge Error: $e');
      return {'error': e.toString()};
    }
  }
}
