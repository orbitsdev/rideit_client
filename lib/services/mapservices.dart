import 'dart:convert';

import 'package:http/http.dart' as http;

class Mapservices {
  static Future<dynamic> mapRequest(String requesturl) async {
    var url = Uri.parse(requesturl);
    http.Response response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return 'failed ';
      }
    } catch (e) {
      return 'failed';
    }

  }
}
