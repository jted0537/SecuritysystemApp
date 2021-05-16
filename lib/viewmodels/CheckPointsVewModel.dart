import 'package:http/http.dart' as http;

class UserViewModel {
  Future<bool> fetchUser(String id, String number) async {
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
