import 'package:flutter/material.dart';
import 'package:security_system/views/patrollingGuard/inDutyRoute.dart';
import 'package:security_system/views/login/localauthApi.dart';
import 'package:security_system/views/patrollingGuard/outDutyRoute.dart';
import 'package:security_system/views/login/loginView.dart';
import 'package:security_system/models/Guard.dart';

Guard loginGuard;
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
