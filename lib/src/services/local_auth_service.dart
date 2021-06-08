import 'package:flutter/services.dart';
import 'dart:async';
import 'package:local_auth/local_auth.dart';

// Type of Biometric authentication result
enum BioMetricLogin { Success, NoBioMetricInfo, DeviceNotProvide, Cancel }

class LocalAuthService {
  static final _auth = LocalAuthentication();

  // Check Device provides local auth function.
  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  // Local auth function
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

  // Local periodic auth function
  static Future<BioMetricLogin> periodicAuthenticate() async {
    final isAvailable = await _auth.canCheckBiometrics;
    var result;
    if (!isAvailable) {
      // If device has no biometric authentication function
      return BioMetricLogin.DeviceNotProvide;
    }
    try {
      result = await _auth
          .authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: false,
        biometricOnly: true, // Only use biometric
      )
          .timeout(Duration(seconds: 10), onTimeout: () {
        _auth.stopAuthentication();
        return false;
      });
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
