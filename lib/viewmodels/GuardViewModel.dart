import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:security_system/models/guard.dart';
import 'package:security_system/views/login/loginView.dart';

class GuardViewModel {
  Future<bool> fetchUser(String id, String number) async {
    var url = Uri.parse('https://cc1dc96ca9d3.ngrok.io/app_connection/$id/');
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
      return true;
    } else {
      return false;
    }
  }
}
