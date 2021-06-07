import 'package:flutter/material.dart';
import 'package:security_system/src/screens/login/local_auth_view.dart';
import 'package:security_system/src/screens/patrollingGuard/in_duty_route.dart';
import 'package:security_system/src/screens/patrollingGuard/out_duty_route.dart';
import 'package:security_system/src/screens/stationaryGuard/in_duty_station.dart';
import 'package:security_system/src/screens/stationaryGuard/out_duty_station.dart';
import 'package:security_system/src/screens/login/login_view.dart';
import 'package:security_system/src/viewmodels/guard_view_model.dart';
import 'package:security_system/src/viewmodels/route_view_model.dart';
import 'package:security_system/src/viewmodels/station_view_model.dart';
import 'package:security_system/src/viewmodels/work_view_model.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:security_system/src/services/web_service.dart';
import 'src/screens/patrollingGuard/viewMap.dart';


final loginGuardViewModel = GuardViewModel();
final loginRouteViewModel = RouteViewModel();
final loginStationViewModel = StationViewModel();
final currentWorkViewModel = WorkViewModel();
DateTime now;
DateTime date;
String formattedDate;
String loginId;
PhoneNumber loginNumber = PhoneNumber(isoCode: 'BD');
// Application Entry Point

void main() => runApp(SecureApp());

class SecureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // For Navigator
        '/': (context) => LoginScreen(),
        '/localAuth': (context) => LocalAuth(),
        '/inDutyRoute': (context) => InDutyRoute(),
        '/outDutyRoute': (context) => OutDutyRoute(),
        '/inDutyStation': (context) => InDutyStation(),
        '/outDutyStation': (context) => OutDutyStation(),
        '/viewMap': (context) => ViewMap(),
      },
      title: 'CVGM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      //home: LoginScreen(),
    );
  }
}
