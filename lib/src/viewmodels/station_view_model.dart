import 'package:security_system/src/models/station.dart';
import 'package:security_system/src/services/web_service.dart';

// viewmodel for Station object
class StationViewModel {
  Station loginStation = Station();

  Future<Station> fetchStation(String id) async {
    try {
      final results = await WebService().fetchStation(id);
      this.loginStation = results;
      return results;
    } catch (e) {
      print(e);
      return loginStation;
    }
  }

  String get stationId {
    return this.loginStation.stationId;
  }

  String get stationTitle {
    return this.loginStation.stationTitle;
  }

  double get radius {
    return this.loginStation.radius;
  }

  double get latitude {
    return this.loginStation.latitude;
  }

  double get longitude {
    return this.loginStation.longitude;
  }

  String get stationAddress {
    return this.loginStation.stationAddress;
  }
}
