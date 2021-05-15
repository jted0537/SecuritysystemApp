import 'package:http/http.dart' as http;

class GuardViewModel {
  Future<bool> fetchUser(String id, String number) async {
    var url = Uri.parse('https://884428985cc7.ngrok.io/app_connection/$id/');
    var response = await http.post(
      url,
      body: {
        "id": id,
        "phone_number": number,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      print(
          "Ssssnskndknqqwknwkdjqnqwdkjwdqnqwd\ndkqjwnkwjqnqdwknjwkdqnwqdjqwdjkndw");
      return true;
    } else {
      return false;
    }
  }
}
