import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class User {
  final String id;
  final PhoneNumber number;

  User({this.id, this.number});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      number: json['number'],
    );
  }
}

class Guard {
  final String guardName;
  final String type;
  final String timeSlot;
  final String routeId;
  final String stationId;

  Guard({
    this.guardName,
    this.type,
    this.timeSlot,
    this.routeId,
    this.stationId,
  });

  factory Guard.fromJson(Map<String, dynamic> json) {
    return Guard(
      guardName: json['guard_name'],
      type: json['type'],
      timeSlot: json['time_slot'],
      routeId: json['route_id'],
      stationId: json['station_id'],
    );
  }
}
