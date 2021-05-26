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

  int get startTimeHour {
    return int.parse(this.loginGuard.startTime.split(':')[0]);
  }

  int get startTimeMinute {
    return int.parse(this.loginGuard.startTime.split(':')[1]);
  }

  int get endTimeHour {
    return int.parse(this.loginGuard.endTime.split(':')[0]);
  }

  int get endTimeMinute {
    return int.parse(this.loginGuard.endTime.split(':')[1]);
  }

  String get endTime {
    return this.loginGuard.endTime;
  }

  int get frequency {
    return this.loginGuard.frequency;
  }

  int get workCount {
    return ((this.endTimeHour - this.startTimeHour) * 60 +
                (this.endTimeMinute - this.startTimeMinute)) ~/
            this.loginGuard.frequency +
        1;
  }
}
