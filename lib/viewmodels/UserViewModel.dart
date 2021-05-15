import 'dart:io';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:security_system/models/guard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserViewModel {
  Future<bool> fetchUser(String id, String number) async {
    var bytes = utf8.encode("$id:$number");
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials"
    };
    var url = Uri.parse('https://884428985cc7.ngrok.io/app_connection/$id/');
    print(url);
    var response = await http.post(
      url,
      body: {
        "id": id,
        "phone_number": number,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }
}
