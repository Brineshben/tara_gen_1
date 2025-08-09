import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ihub/Utils/api_constant.dart';

class LanguageService {
  static Future<Map<String, dynamic>> fetchLanguages() async {
    try {
      String url = "${ApiConstants.globalip}${ApiConstants.getLanguage}";
      final response = await http.get(Uri.parse(url));
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
        robotId: {"language": language},
      });
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // important for JSON body
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('updatelan $e');
    }
    throw Exception("Failed to set language");
  }
}
