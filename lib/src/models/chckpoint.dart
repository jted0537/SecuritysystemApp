class CheckPoint {
  final String checkPointId;
  final String routeId;
  final double latitude;
  final double longitude;
  final double radius;
  final int frequency;

  CheckPoint(
      {this.checkPointId,
      this.routeId,
      this.latitude,
      this.longitude,
      this.radius,
      this.frequency});

  factory CheckPoint.fromJson(Map<String, dynamic> json) {
    return CheckPoint(
      checkPointId: json['checkpoint_id'],
      routeId: json['route_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      frequency: json['frequency'],
    );
  }
}
