// import 'package:security_system/model/chckpoint.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';

// class CheckPointViewModel {
//   String url = "https://api.jsonbin.io/b/6072eb580ed6f819bea8e4ac/4";

//   Future<List<dynamic>> fetchCheckPoint() async {
//     final response = await http.get(Uri.parse(this.url));
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       String responseBody = utf8.decode(response.bodyBytes);
//       return jsonDecode(responseBody) as List;
//     } else {
//       throw Exception("failed");
//     }
//   }
// }
