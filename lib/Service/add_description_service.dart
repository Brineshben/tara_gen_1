import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ihub/Model/description_model.dart';
import 'package:ihub/Utils/api_constant.dart';

class DescriptionService {
  static Future<DescriptionModel> fetchDescription() async {
    final url =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.description}");

    print('urrrrrrrrrl $url');
    try {
      final response = await http.get(url);
      print('HTTP status: ${response.statusCode}');
      print('HTTP body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('descriptionrespinse $jsonData');
        return DescriptionModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error in fetchDescription: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> submitDescription({
    required String timeOfDay,
    required String description,
  }) async {
    final url =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.description}");

    try {
      final requestBody = jsonEncode({
        'time_of_day': timeOfDay,
        'description': description,
      });

      print('URL: $url');
      print('Request Body: $requestBody');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Exception in submitDescription: $e');
    }
    return null;
  }

  // delete

  static Future<Map<String, dynamic>?> editDescription({
    required String timeOfDay,
    required String description,
    required String id,
  }) async {
    final url = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.edit_wishing_commands}");

    try {
      final requestBody = jsonEncode({
        'time_of_day': timeOfDay,
        'description': description,
        'description_id': id,
      });

      print('URL: $url');
      print('Request Body: $requestBody');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Exception in submitDescription: $e');
    }
    return null;
  }
}
