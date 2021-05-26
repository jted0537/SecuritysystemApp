import 'package:security_system/src/models/route.dart';
import 'package:security_system/src/services/web_service.dart';

class RouteViewModel {
  Route loginRoute = Route();

  Future<bool> fetchRoute(String id) async {
    try {
      final results = await WebService().fetchRoute(id);
      this.loginRoute = results;
      return true;
    } catch (e) {
      return false;
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
