class Station {
  final String stationId;
  final String stationTitle;
  final double radius;
  final double latitude;
  final double longitude;
  final String stationAddress;

  Station({
    this.stationId,
    this.stationTitle,
    this.radius,
    this.latitude,
    this.longitude,
    this.stationAddress,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationId: json['station_id'],
      stationTitle: json['station_title'],
      radius: json['radius'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      stationAddress: json['station_address'],
    );
  }
}
