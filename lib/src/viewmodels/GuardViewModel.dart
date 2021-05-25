import 'package:security_system/src/models/guard.dart';
import 'package:security_system/src/services/webService.dart';

class GuardViewModel {
  Guard loginGuard = Guard();

  Future<bool> fetchGuard(String id, String number) async {
    try {
      final results = await WebService().fetchGuard(id, number);
      this.loginGuard = results;
      return true;
    } catch (e) {
      return false;
    }
  }

  String get guardName {
    return this.loginGuard.guardName;
  }

  String get type {
    return this.loginGuard.type;
  }

  String get slotTitle {
    return this.loginGuard.slotTitle;
  }

  String get startTime {
    return this.loginGuard.startTime;
  }

  String get endTime {
    return this.loginGuard.endTime;
  }

  int get frequency {
    return this.loginGuard.frequency;
  }

  int get workCount {
    final endHour = int.parse(this.loginGuard.endTime.split(':')[0]);
    final startHour = int.parse(this.loginGuard.startTime.split(':')[0]);
    final endMinute = int.parse(this.loginGuard.endTime.split(':')[1]);
    final startMinute = int.parse(this.loginGuard.startTime.split(':')[0]);
    return ((endHour - startHour) * 60 + (endMinute - startMinute)) ~/
            this.loginGuard.frequency +
        1;
  }
}
