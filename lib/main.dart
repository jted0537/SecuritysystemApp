import 'package:flutter/material.dart';
import 'package:security_system/views/appointedRoute/appointedroute.dart';
import 'package:security_system/views/login/localauthApi.dart';
import 'package:security_system/views/appointedRoute/appointedRouteMenu.dart';
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
        '/arm': (context) => AppointedRouteMenu(),
        '/ad': (context) => AppointedRoute(),
      },
      title: 'CVGM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      //home: LoginScreen(),
    );
  }
}
