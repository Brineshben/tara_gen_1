import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ihub/Utils/api_constant.dart';

class PromptService {
  // static Future<Map<String, dynamic>?> fetchPrompt() async {
  //   final url = Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.promptget}");

  //   try {
  //     final response = await http.get(url);
  //     print('HTTP status: ${response.statusCode}');
  //     print('prompt body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);
  //       return jsonData;
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print('Error in fetchDescription: $e');
  //     rethrow;
  //   }
  // }
  static Future<Map<String, dynamic>>? fetchPrompt() async {
    final url = Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.promptget}");
    // final url = Uri.parse("http://192.168.1.38:8000/prompt/list/");
    var request = http.Request('GET', url);
    request.headers.addAll({'Content-Type': 'application/json'});

    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('promptbody $respString');
    return json.decode(respString);
  }

  // static Future<Map<String, dynamic>?> fetchPrompt() async {
  //   try {
  //     final response = await http.get(url);

  //     print('HTTP status: ${response.statusCode}');
  //     print('prompt body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);

  //       // Validate JSON structure
  //       if (jsonData is Map<String, dynamic> &&
  //           jsonData.containsKey("status") &&
  //           jsonData["status"] == "ok" &&
  //           jsonData.containsKey("data")) {
  //         return jsonData;
  //       } else {
  //         print("Invalid response format");
  //         return null;
  //       }
  //     } else {
  //       print("Server returned error: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error in fetchPrompt: $e');
  //     return null;
  //   }
  // }

  static Future<Map<String, dynamic>?> addPrompt({
    required String prompt,
    required String question,
    required String answer,
  }) async {
    var prommt =
        "Role:$prompt. \nIf the following question is asked: \nQuestion: $question\nAnswer: $answer";
    final url = Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.promptget}");

    try {
      final requestBody = jsonEncode({
        'command_prompt': prommt,
      });

      print('enterPromt $prommt');

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
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
    return null;
  }

  static Future<Map<String, dynamic>?> editPrompt({
    required String id,
    required String prompt,
    required String question,
    required String answer,
  }) async {
    var prommt =
        "Role:$prompt. \nIf the following question is asked: \nQuestion: $question\nAnswer:m $answer";
    final url =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.promptUpdate}");

    try {
      final requestBody = jsonEncode({
        'command_prompt': prommt,
        'command_prompt_id': id,
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
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
    return null;
  }
}
