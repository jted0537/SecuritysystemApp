import 'package:security_system/src/models/chckpoint.dart';

// For store route info. which includes list of checkpoints
class Route {
  final String routeId;
  final String routeTitle;
  int totalCheckpointNum;
  List<CheckPoint> checkpoints;

  Route({
    this.routeId,
    this.routeTitle,
    this.totalCheckpointNum,
    this.checkpoints,
  });

  // Convert json type to Route object
  factory Route.fromJson(Map<String, dynamic> json) {
    var list = json['checkpoints'] as List;
    List<CheckPoint> checkPointList =
        list.map((i) => CheckPoint.fromJson(i)).toList();
    return Route(
      routeId: json['route_id'],
      routeTitle: json['route_title'],
      totalCheckpointNum: json['total_checkpoint_num'],
      checkpoints: checkPointList,
    );
  }
}
