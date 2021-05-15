import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:local_auth/local_auth.dart';
import 'package:security_system/components/preferences.dart';

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
    if (isAuthenticated == 4) {
      // Biometric authentication success
      //print ("Finger print access success");
      Navigator.pushNamed(context, '/arm');
    } else if (isAuthenticated == 2) {
      // If device has no biometric authentication information, alert message pop
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
    } else if (isAuthenticated == 1) {
      // If device has no biometric auth function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Authentication Failed"),
            content: Text("Device has no biometric authentication functions."),
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
  void initState() {
    super.initState();
    // Immediate authentication
    authentication();
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
              // For 'Submit your fingerprint button
              OutlinedButton(
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
                          fontWeight: defaultFontWeight),
                    ),
                  ],
                ),
                onPressed: () {
                  authentication();
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(60, 50, 60, 60),
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

// Authentication part
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

  static Future<int> authenticate() async {
    final isAvailable = await _auth.canCheckBiometrics;
    var result;
    if (!isAvailable) {
      // If device has no biometric authentication function
      return 1;
    }
    try {
      result = await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: false,
        biometricOnly: true, // Only use biometric
      );
      if (result) {
        // Authentiation success
        return 4;
      }
    } on PlatformException catch (e) {
      // Device has biometric authentication function, but there are no registered informations
      print(e);
      return 2;
    }
    // If user just cancel authentication
    return 3;
  }
}
