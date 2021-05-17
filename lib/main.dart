import 'package:flutter/material.dart';
import 'package:security_system/src/screens/patrollingGuard/inDutyRoute.dart';
import 'package:security_system/src/screens/login/localAuthView.dart';
import 'package:security_system/src/screens/patrollingGuard/outDutyRoute.dart';
import 'package:security_system/src/screens/login/loginView.dart';
import 'package:security_system/src/viewmodels/GuardViewModel.dart';

final loginGuardViewModel = GuardViewModel();
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
        '/a': (context) => OutDutyRoute(),
        '/b': (context) => InDutyRoute(),
      },
      title: 'CVGM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      //home: LoginScreen(),
    );
  }
}
