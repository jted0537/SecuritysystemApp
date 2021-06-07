import 'package:security_system/src/models/guard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:security_system/src/models/route.dart';
import 'package:security_system/src/models/station.dart';
import 'package:security_system/src/models/work.dart';
import 'package:security_system/src/models/chckpoint.dart';
import 'package:security_system/main.dart';

final serverUrl = 'http://158.247.211.173/';
//final serverUrl = 'https://f62ce8338828.ngrok.io';

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
      print(result);
      final parsed = await json.decode(result.substring(1, result.length - 1));
      return Station.fromJson(parsed);
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<Work> fetchWork(String id) async {
    var url = Uri.parse('$serverUrl/app_connection/startWork/$id/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var result = response.body.replaceAll('\\', '');
      print(result);
      final parsed = await json.decode(result.substring(1, result.length - 1));
      return Work.fromJson(parsed);
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<String> postGPSReply(String guardType, String workId, double lat, double lng) async {
    bool isCheckPoint = true;
    // patrol인지 stationary인지 구분
    if(guardType == 'patrol'){

      var url = Uri.parse('$serverUrl/app_connection/patrolGPS/$workId/');
      var response = await http.post(url, body: {"sequence_num": "55", "latitude": lat.toString(), "longitude": lng.toString(), "checkpoint_flag": "true", "checkpoint_response": "true",});

      if (response.statusCode == 200) {
        print('response 200');
      }
      // // 1. patrol일때
      // List<CheckPoint> curCheckpoints = loginRouteViewModel.loginRoute.checkpoints;
      // // 현재 gps가 checkpoint인지 아닌지 체크(만약 checkpoint아니라면 무조건 checkpoint_response는 false)
      // for(var i = 0; i < curCheckpoints.length; i++){
      //   if(curCheckpoints[i].latitude == lat){
      //     if(curCheckpoints[i].longitude == lng){
      //       var url = Uri.parse(serverUrl + ('app_connection/patrolGPS/$workId/'));
      //       var response = await http.post(url, body: {'latitude': lat, 'longitude': lng, 'checkpoint_flag': true, 'checkpoint_response': true});
      //     }
      //   }
      // }
      // 지문인식에 대한 response
    }
    
    // 2. stationary일 때
    // 지문인식에 대한 response만 보내면 됨
  }
}

// 오차: 20m
// checkpoint에 seqnum 부여해서
// main이 아니고 induty로 해야될 듯: 가장 최근에 방문한 checkpoint seqnum 저장하고 있음
// work time assigned 후(induty view로 들어오면), frequency 마다 지문인식하라고 알림 들어옴

// viewMap: 현재 위치 track하면서, accuracy 반경 안에 들어오면 checkpoint seqnum 업데이트
// => 여기서 가능하면 checkpoint 여부 판단

// web service: 필요한 정보 보내줌

// def euclidean_distance(curGPS_lon, curGPS_lat, CPGPS_lon, CPGPS_lat, radius):

//     # approximate radius of earth in km
//     R = 6373.0

//     lat1 = radians(curGPS_lat)
//     lon1 = radians(curGPS_lon)
//     lat2 = radians(CPGPS_lat)
//     lon2 = radians(CPGPS_lon)

//     dlon = lon2 - lon1
//     dlat = lat2 - lat1

//     a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
//     c = 2 * atan2(sqrt(a), sqrt(1 - a))

//     distance = R * c

//     # change distance into meter
//     result = distance * 1000

//     if result <= radius:
//         return True
//     else:
//         return False