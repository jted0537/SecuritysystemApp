import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:local_auth/local_auth.dart';
import 'package:security_system/preferences.dart';

// Local Authentication (iOS: Face ID, Android: Finger print)
class LocalAuth extends StatefulWidget {
  @override
  _LocalAuthState createState() => _LocalAuthState();
}

// Local Authentication State
class _LocalAuthState extends State<LocalAuth> {
  // Doing local authentication method
  void authentication() async {
    // This is main part of authentication
    final isAuthenticated = await LocalAuthApi.authenticate();
    if (isAuthenticated) {
      print("Finger print access success");
      Navigator.pushNamed(context, '/rl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          rokkhiLogoImage(),
          SizedBox(
            height: 20.0,
          ),
          OutlinedButton(
            // For 'Submit your fingerprint button
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60, 50, 60, 60),
              child: Column(
                children: [
                  Image.asset('images/FingerPrint.png', height: 70, width: 70),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Submit your fingerprint',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: defalutFont),
                  ),
                ],
              ),
            ),
            onPressed: () {
              authentication();
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
