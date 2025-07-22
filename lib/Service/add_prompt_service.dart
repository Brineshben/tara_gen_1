import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ihub/Model/qa_model.dart';
import 'package:ihub/Utils/api_constant.dart';

class PromptService {
  // FETCH PROMTP
  static Future<Map<String, dynamic>>? fetchPrompt() async {
    final url = Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.promptget}");
    var request = http.Request('GET', url);
    request.headers.addAll({'Content-Type': 'application/json'});

    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();
    print('promptbody $respString');
    return json.decode(respString);
  }

// ADD PROMT
  static Future<Map<String, dynamic>>? addPrompt({
    required String prompt,
  }) async {
    final url =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.promptcreate}");
    final response = await http.post(
      url,
      body: jsonEncode({'command_prompt': prompt}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print('deleteresponce ${response.body}');
    return jsonDecode(response.body);
  }

// UPDATE PROMPT
  static Future<Map<String, dynamic>>? editPrompt({
    required String prompt,
    required String id,
  }) async {
    print('promtpID $id');
    final url =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.promptUpdate}$id/");

    try {
      final response = await http.put(
        url,
        body: jsonEncode({'command_prompt': prompt}), // ✅ proper JSON body
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('editresponcepromtp ${response.body}');
      return jsonDecode(response.body);
    } catch (e) {
      print("Edit prompt error: $e");
      return {'status': 'error', 'message': e.toString()};
    }
  }

// GET QA LIST
  static Future<QAmodel?> fetchQAList(String promptId) async {
    try {
      print('promptId $promptId');
      final url = Uri.parse(
          "${ApiConstants.baseUrl1}${ApiConstants.getqaLsit}$promptId/");
      print('qalistl $url');

      var request = http.Request('GET', url);
      request.headers.addAll({'Content-Type': 'application/json'});

      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      print('qalist $respString');

      final jsonData = json.decode(respString);
      return QAmodel.fromJson(jsonData);
    } catch (e) {
      print("❌ Error in fetchQAList: $e");
      return null;
    }
  }

// CREATE QA
  static Future<Map<String, dynamic>?> createQA({
    required String promptId,
    required String question,
    required String answer,
  }) async {
    final url = Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.createQA}");

    final response = await http.post(
      url,
      body: {
        'prompt': promptId,
        'question': question,
        'answer': answer,
      },
    );
    return jsonDecode(response.body);
  }

// UPDATE QA
  static Future<Map<String, dynamic>?> updateQA({
    required String id,
    required String question,
    required String answer,
  }) async {
    final url =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.updateQA}$id/");

    final response = await http.put(
      url,
      body: {
        'question': question,
        'answer': answer,
      },
    );
    return jsonDecode(response.body);
  }

  // DELETE QA
  static Future<Map<String, dynamic>?> deleteQA(String id) async {
    final url =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.deleteQA}$id/");
    print('Delete URL: $url');

    var request = http.Request('DELETE', url);
    request.headers.addAll({'Content-Type': 'application/json'});

    try {
      http.StreamedResponse response = await request.send();
      final respString = await response.stream.bytesToString();

      if (respString.trim().isEmpty) {
        return {'status': 'ok', 'message': 'Deleted successfully'};
      }

      return json.decode(respString);
    } catch (e) {
      print("Error deleting QA: $e");
      return {'status': 'error', 'message': 'Something went wrong'};
    }
  }
}
