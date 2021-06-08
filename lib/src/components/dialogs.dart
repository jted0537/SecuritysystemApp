import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';

//------------------------------------Show Dialogs
// Alert Dialog when user failed to login.
void loginFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Login Failed"),
        content: Text("Incorrect Employee ID or Phone number."),
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

// Alert Dialog when user failed to login.
void internetConnectionFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("No internet connection"),
        content: Text("Please check your internet connection and try again."),
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

// Logging in Dialog
void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(rokkhiColor),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text("Please wait",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                )),
            Text('Loading...'),
          ],
        ),
      );
    },
  );
}

// Pop Dialog
void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}

// If device has no biometric authentication information
void noBioMetricInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text("Authentication Failed"),
        content: Text("You should update device biometrics and security first"),
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

// If device has no function for Biometric authentication
void notProvideBioMetricDialog(BuildContext context) {
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
