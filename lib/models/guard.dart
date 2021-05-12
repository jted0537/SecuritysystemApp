import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'dart:typed_data';

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
  final String employeeId;
  final String guardName;
  final String phoneNumber;
  final String address;
  final Uint8List guardPhoto;
  final bool status;
  final int monthWorkCnt;
  final int curWorkCnt;
  final String type;

  Guard(
      {this.employeeId,
      this.guardName,
      this.phoneNumber,
      this.address,
      this.guardPhoto,
      this.status,
      this.monthWorkCnt,
      this.curWorkCnt,
      this.type});

  factory Guard.fromJson(Map<String, dynamic> json) {
    return Guard(
      employeeId: json['employee_id'],
      guardName: json['guard_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      guardPhoto: json['guard_photo'],
      status: json['status'],
      monthWorkCnt: json['month_work_cnt'],
      curWorkCnt: json['cur_work_cnt'],
      type: json['type'],
    );
  }
}
