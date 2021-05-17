import 'package:security_system/src/models/guard.dart';
import 'package:security_system/src/services/web_service.dart';

class GuardViewModel {
  Guard loginGuard = Guard();

  //GuardViewModel({this.loginGuard});

  Future<bool> fetchGuard(String id, String number) async {
    try {
      final results = await WebService().fetchGuard(id, number);
      this.loginGuard = results;
      return true;
    } catch (e) {
      return false;
    }
    //notifyListeners();
  }

  String get guardName {
    return this.loginGuard.guardName;
  }

  String get type {
    return this.loginGuard.type;
  }

  String get routeId {
    return this.loginGuard.routeId;
  }

  String get stationId {
    return this.loginGuard.stationId;
  }
}
