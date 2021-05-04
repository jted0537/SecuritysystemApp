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
    } else {
      // If device has no authentication information, alert message pop
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Authentication Failed"),
            content:
                Text("You should update device biometrics and security first"),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.clear_outlined),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
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
                      Image.asset('images/FingerPrint.png',
                          height: 70, width: 70),
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
        ),
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
    if (!isAvailable) {
      return false;
    }

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
