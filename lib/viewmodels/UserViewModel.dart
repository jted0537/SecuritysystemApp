import 'dart:io';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:security_system/models/guard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserViewModel {
  //var url = Uri.parse('https://my-json-server.typicode.com/jted0537/JSON_test/user');

  Future<bool> fetchUser(String id, String number) async {
    var bytes = utf8.encode("$id:$number");
    var credentials = base64.encode(bytes);
    var headers = {
      "Accept": "application/json",
      "Authorization": "Basic $credentials"
    };
    var url = Uri.parse(
        'https://my-json-server.typicode.com/jted0537/JSON_test/user');
    var response = await http.post(
      url,
      body: {
        "id": id,
        "number": number,
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
