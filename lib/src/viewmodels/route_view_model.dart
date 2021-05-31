import 'package:security_system/src/models/route.dart';
import 'package:security_system/src/models/chckpoint.dart';
import 'package:security_system/src/services/web_service.dart';

class RouteViewModel {
  Route loginRoute = Route();

  Future<Route> fetchRoute(String id) async {
    try {
      final results = await WebService().fetchRoute(id);
      this.loginRoute = results;
      return results;
    } catch (e) {
      print(e);
    }
  }

  Future<List<CheckPoint>> fetchCheckPoints(String id) async {
    try {
      final results = await WebService().fetchRoute(id);
      this.loginRoute = results;
      return loginRoute.checkpoints;
    } catch (e) {
      print(e);
    }
  }

  String get routeId {
    return this.loginRoute.routeId;
  }

  String get routeTitle {
    return this.loginRoute.routeTitle;
  }

  int get totalCheckPointNum {
    return this.loginRoute.totalCheckpointNum;
  }
}
