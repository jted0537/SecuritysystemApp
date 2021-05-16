import 'package:http/http.dart' as http;
import 'package:security_system/main.dart';
import 'dart:convert';
import 'package:security_system/models/Guard.dart';

class GuardViewModel {
  Future<bool> fetchUser(String id, String number) async {
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
      loginGuard = Guard.fromJson(parsed);
      print(loginGuard.type);
      return true;
    } else {
      return false;
    }
  }
}
