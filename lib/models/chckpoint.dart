class CheckPoint {
  final String checkPointId;
  final double latitude;
  final double longitude;

  CheckPoint({this.checkPointId, this.latitude, this.longitude});

  CheckPoint.fromJson(Map<String, dynamic> json)
      : checkPointId = json['checkPointId'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkPointId'] = this.checkPointId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
