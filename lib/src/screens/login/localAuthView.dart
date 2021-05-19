import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:local_auth/local_auth.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';

// Local Authentication (iOS: Face ID, Android: Finger print)
class LocalAuth extends StatefulWidget {
  @override
  _LocalAuthState createState() => _LocalAuthState();
}

// Type of Biometric authentication result
enum BioMetricLogin { Success, NoBioMetricInfo, DeviceNotProvide, Cancel }

// Local Authentication State
class _LocalAuthState extends State<LocalAuth> {
  // Doing local authentication method
  void authentication() async {
    final isAuthenticated = await LocalAuthApi.authenticate();

    if (isAuthenticated == BioMetricLogin.Success) {
      // If Biometric authentication success
      if (loginGuardViewModel.loginGuard.type ==
          'patrol') // If guard is patrolling guard
        Navigator.pushNamed(context, '/outDutyRoute');
      else // If guard is stationary guard
        Navigator.pushNamed(context, '/inDutyStation');
    } else if (isAuthenticated == BioMetricLogin.NoBioMetricInfo) {
      // If device has no biometric authentication information, alert message pop
      noBioMetricInfoDialog(context);
    } else if (isAuthenticated == BioMetricLogin.DeviceNotProvide) {
      // If device has no biometric auth function
      notProvideBioMetricDialog(context);
    }
  }

  @override
  void initState() {
    super.initState();
    // Immediate authentication when login success
    authentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Use SingleChildScrollView and Column Widget for same look with login screen
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              Container(
                height: 50.0,
                child: topRightDismissButton(context),
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
                      height: 30,
                    ),
                    Text(
                      'Submit your fingerprint',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
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

  static Future<BioMetricLogin> authenticate() async {
    final isAvailable = await _auth.canCheckBiometrics;
    var result;
    if (!isAvailable) {
      // If device has no biometric authentication function
      return BioMetricLogin.DeviceNotProvide;
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
        return BioMetricLogin.Success;
      }
    } on PlatformException catch (e) {
      // Device has biometric authentication function, but there are no registered informations
      print(e);
      return BioMetricLogin.NoBioMetricInfo;
    }
    // If user just cancel authentication
    return BioMetricLogin.Cancel;
  }
}
