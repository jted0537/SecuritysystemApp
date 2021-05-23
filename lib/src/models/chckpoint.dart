class CheckPoint {
  final int sequenceNum;
  final double latitude;
  final double longitude;
  final double radius;
  final int frequency;

  CheckPoint(
      {this.sequenceNum,
      this.latitude,
      this.longitude,
      this.radius,
      this.frequency});

  factory CheckPoint.fromJson(Map<String, dynamic> json) {
    return CheckPoint(
      sequenceNum: json['sequence_num'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      frequency: json['frequency'],
    );
  }
}
