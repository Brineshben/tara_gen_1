import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ihub/Utils/api_constant.dart';

class UrlService {
  static Future<Map<String, dynamic>> addUrl({
    required String name,
    required String urlpage,
  }) async {
    var url = "${ApiConstants.baseUrl1}${ApiConstants.addUrl}";

    print('add-url $url');

    Map<String, dynamic> apiBody = {
      'name': name,
      'url': urlpage,
    };

    var request = http.Request('POST', Uri.parse(url));
    request.body = (json.encode(apiBody));
    request.headers.addAll({
      'Content-Type': 'application/json',
    });
    http.StreamedResponse response = await request.send();
    var respString = await response.stream.bytesToString();

    return json.decode(respString);
  }

  static Future<Map<String, dynamic>> getUrls() async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl1 + ApiConstants.getUrl),
    );
    final decodedData = jsonDecode(response.body);
    print('geturlrespo $decodedData');
    return decodedData;
  }
}
