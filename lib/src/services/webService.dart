import 'package:security_system/src/models/guard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:security_system/src/models/route.dart';

class WebService {
  Future<Guard> fetchGuard(String id, String number) async {
    var url = Uri.parse('https://1dc95fccbb49.ngrok.io/app_connection/$id/');
    var response = await http.post(
      url,
      body: {
        "id": id,
        "phone_number": number,
      },
    );
    if (response.statusCode == 200) {
      var temp = response.body.replaceAll('\\', '');
      var result = temp.split('/');
      final firstParsed =
          await json.decode(result[0].substring(1, result[0].length));
      final secondParsed =
          await json.decode(result[1].substring(0, result[1].length - 1));
      return Guard.fromJson(firstParsed, secondParsed);
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<Route> fetchRoute(String id) async {
    var url =
        Uri.parse('https://1dc95fccbb49.ngrok.io/app_connection/Route/$id/');
    var response = await http.post(
      url,
      body: {
        "id": id,
      },
    );
    if (response.statusCode == 200) {
      var result = response.body.replaceAll('\\', '');
      final parsed = await jsonDecode(result.substring(1, result.length - 1));
      return Route.fromJson(parsed);
    } else {
      throw Exception("Unable to perform request!");
    }
  }
}
