import 'package:security_system/src/models/guard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WebService {
  Future<Guard> fetchGuard(String id, String number) async {
    var url = Uri.parse('http://158.247.211.173:80/app_connection/$id/');
    var response = await http.post(
      url,
      body: {
        "id": id,
        "phone_number": number,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      final parsed = await json.decode(response.body);
      return Guard.fromJson(parsed);
    } else {
      throw Exception("Unable to perform request!");
    }
  }
}
