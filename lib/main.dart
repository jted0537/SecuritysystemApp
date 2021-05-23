import 'package:flutter/material.dart';
import 'package:security_system/src/screens/patrollingGuard/inDutyRoute.dart';
import 'package:security_system/src/screens/login/localAuthView.dart';
import 'package:security_system/src/screens/patrollingGuard/outDutyRoute.dart';
import 'package:security_system/src/screens/stationaryGuard/inDutyStation.dart';
import 'package:security_system/src/screens/login/loginView.dart';
import 'package:security_system/src/viewmodels/guardViewModel.dart';
import 'package:security_system/src/viewmodels/routeViewModel.dart';

final loginGuardViewModel = GuardViewModel();
final loginRouteViewModel = RouteViewModel();
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
        // TODO '/outDutyStation': (context) => OutDutyStation(),
      },
      title: 'CVGM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      //home: LoginScreen(),
    );
  }
}
