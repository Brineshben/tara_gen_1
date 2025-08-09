import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ihub/Utils/api_constant.dart';

class ChargeService {
  static Future<Map<String, dynamic>> updateCharge({
    required String batteryEntry,
    required String homeEntry,
  }) async {
    final url = Uri.parse(
      "${ApiConstants.localIp}${ApiConstants.chargeUpdate}",
    );

    try {
      final response = await http.post(
        url,
        body: {
          "low_battery_entry": batteryEntry,
          "back_to_home_entry": homeEntry,
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      return json.decode(response.body);
    } catch (e) {
      print('UpdateCharge Exception: $e');
      return {'error': e.toString()};
    }
  }

  // Fetch current charge values (GET request)
  static Future<Map<String, dynamic>> fetchCurrentCharge() async {
    final url = Uri.parse(
      "${ApiConstants.localIp}${ApiConstants.getCurrentCharge}",
    );
    try {
      final response = await http.get(url);

      print('GET Status: ${response.statusCode}');
      print('GET Response: ${response.body}');

      return json.decode(response.body);
    } catch (e) {
      print('FetchCharge Exception: $e');
      return {'error': e.toString()};
    }
  }
}
