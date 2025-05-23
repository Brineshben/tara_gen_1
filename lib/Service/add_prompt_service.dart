import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ihub/Model/system_prompt_model.dart';
import 'package:ihub/Utils/api_constant.dart';

class PromptService {
  static Future<SystemPromptModel> fetchPrompt() async {
    final url =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.commandPrompt}");

    print('urrrrrrrrrl $url');
    try {
      final response = await http.get(url);
      print('HTTP status: ${response.statusCode}');
      print('HTTP body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('promptresponce $jsonData');
        return SystemPromptModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error in fetchDescription: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> addPrompt({
    required String prompt,
    required String question,
    required String answer,
  }) async {
    var prommt =
        "Role:$prompt. \nIf the following question is asked: \nQuestion: $question\nAnswer:m $answer";
    final url =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.commandPrompt}");

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
    required String commandPromt,
    required String id,
  }) async {
    final url = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.command_prompt_edit}");

    try {
      final requestBody = jsonEncode({
        'command_prompt': commandPromt,
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
