import 'package:security_system/src/models/guard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:security_system/src/models/route.dart';
import 'package:security_system/src/models/station.dart';
import 'package:security_system/src/models/work.dart';

final serverUrl = 'https://c2092f1ee676.ngrok.io';

class WebService {
  Future<Guard> fetchGuard(String id, String number) async {
    var url = Uri.parse('$serverUrl/app_connection/$id/');
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
    var url = Uri.parse('$serverUrl/app_connection/Route/$id/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body.replaceAll('\\', '');
      final parsed = await json.decode(result.substring(1, result.length - 1));
      return Route.fromJson(parsed);
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<Station> fetchStation(String id) async {
    var url = Uri.parse('$serverUrl/app_connection/Station/$id/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body.replaceAll('\\', '');
      print(result.substring(1, result.length - 1));
      final parsed = await json.decode(result.substring(1, result.length - 1));
      return Station.fromJson(parsed);
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<Work> fetchWork(String id) async {
    var url = Uri.parse('$serverUrl/app_connection/startWork/$id/');
    var response = await http.get(url);
    print('res : ' + response.toString());
    if (response.statusCode == 200) {
      var result = response.body.replaceAll('\\', '');
      print(result.substring(1, result.length - 1));
      final parsed = await json.decode(result.substring(1, result.length - 1));
      return Work.fromJson(parsed);
    } else {
      throw Exception("Unable to perform request!");
    }
  }
}