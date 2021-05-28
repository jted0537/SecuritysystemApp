import 'package:security_system/src/models/work.dart';
import 'package:security_system/src/services/web_service.dart';

class WorkViewModel {
  Work currentWork = Work();

  Future<Work> fetchWork(String id) async {
    try {
      final results = await WebService().fetchWork(id);
      this.currentWork = results;
      return results;
    } catch (e) {
      print(e);
    }
  }
}
