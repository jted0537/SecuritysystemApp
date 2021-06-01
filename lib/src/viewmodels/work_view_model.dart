import 'package:security_system/src/models/work.dart';
import 'package:security_system/src/services/web_service.dart';

class WorkViewModel {
  Work currentWork = Work();

  Future<void> fetchNewWork(String id) async {
    try {
      final results = await WebService().fetchWork(id);
      this.currentWork = results;
      //return results;
    } catch (e) {
      print(e);
    }
  }

  Future<Work> updateWork(String id) async {
    try {
      final results = await WebService().updateWork(id);
      this.currentWork = results;
      return results;
    } catch (e) {
      print(e);
    }
  }

  String get workID {
    return this.currentWork.workId;
  }

  List<bool> get responseCntList {
    return this.currentWork.responseCntList;
  }

  List<String> get alarmTimeList {
    return this.currentWork.alarmTimeList;
  }
}
