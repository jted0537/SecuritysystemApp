import 'package:flutter/material.dart';
import 'package:security_system/views/appointedRoute/inDutyRoute.dart';
import 'package:security_system/views/login/localauthApi.dart';
import 'package:security_system/views/appointedRoute/outDutyRoute.dart';
import 'package:security_system/views/login/loginView.dart';

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
        '/la': (context) => LocalAuth(),
        '/arm': (context) => OutDutyRoute(),
        '/ad': (context) => InDutyRoute(),
      },
      title: 'CVGM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      //home: LoginScreen(),
    );
  }
}
