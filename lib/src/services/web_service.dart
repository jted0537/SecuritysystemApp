import 'package:security_system/src/models/guard.dart';
import 'package:security_system/src/models/route.dart';
import 'package:security_system/src/models/station.dart';
import 'package:security_system/src/models/work.dart';
import 'package:security_system/src/models/chckpoint.dart';
import 'package:security_system/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final serverUrl = 'http://158.247.211.173';

class WebService {
  // Fetch Guard
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

  // Fetch Checkpoint
  Future<Route> fetchRoute(String id) async {
    var url = Uri.parse('$serverUrl/app_connection/Route/$id/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body.replaceAll('\\', '');
      final parsed = await json.decode(result.substring(1, result.length - 1));
      return Route.fromJson(parsed);
    } else {
      throw Exception("Unable to perform fetch route request!");
    }
  }

  // Fetch Station
  Future<Station> fetchStation(String id) async {
    var url = Uri.parse('$serverUrl/app_connection/Station/$id/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body.replaceAll('\\', '');
      final parsed = await json.decode(result.substring(1, result.length - 1));
      return Station.fromJson(parsed);
    } else {
      throw Exception("Unable to perform fetch station request!");
    }
  }

  // Fetch(start) work
  Future<Work> fetchWork(String id) async {
    var url = Uri.parse('$serverUrl/app_connection/startWork/$id/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body.replaceAll('\\', '');
      final parsed = await json.decode(result.substring(1, result.length - 1));
      return Work.fromJson(parsed);
    } else {
      throw Exception("Unable to perform fetch work request!");
    }
  }

  Future<String> postGPSReply( String guardType, int seqNum, String workId, double lat, double lng, bool isCP, bool isRes ) async {
    bool isCheckPoint = true;
    // patrol인지 stationary인지 구분
    if (guardType == 'patrol') {
      var url = Uri.parse('$serverUrl/app_connection/patrolGPS/$workId/');
      var response = await http.post(url, body: {
        "sequence_num": seqNum.toString(),
        "latitude": lat.toString(),
        "longitude": lng.toString(),
        "checkpoint_flag": isCP.toString(),
        "checkpoint_response": isRes.toString(),
      });

      if (response.statusCode == 200) {
        print('response 200');
      }
    }
   }

    // 2. stationary일 때
    // 지문인식에 대한 response만 보내면 됨
    // Go to work
    Future<Work> updateWork(String id) async {
      var url = Uri.parse('$serverUrl/app_connection/getWork/$id/');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var result = response.body.replaceAll('\\', '');
        final parsed =
            await json.decode(result.substring(1, result.length - 1));
        return Work.fromJson(parsed);
      } else {
        throw Exception("Unable to perform update work request!");
      }
    }

    Future<void> stationaryResponse(String workId) async {
      var url =
          Uri.parse('$serverUrl/app_connection/StationaryResponse/$workId/');
      var response = await http.get(url);
      print(response.statusCode);
    }

    Future<void> endWork(String workId) async {
      var url =
          Uri.parse('$serverUrl/app_connection/endStationaryWork/$workId/');
      var response = await http.get(url);
      print(response.statusCode);
    }
  }