import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';
import 'package:security_system/src/services/local_auth_service.dart';

// Local Authentication (iOS: Face ID, Android: Finger print)
class LocalAuth extends StatefulWidget {
  @override
  _LocalAuthState createState() => _LocalAuthState();
}

// Local Authentication State
class _LocalAuthState extends State<LocalAuth> {
  // Doing local authentication method
  void authentication() async {
    final isAuthenticated = await LocalAuthService.authenticate();

    if (isAuthenticated == BioMetricLogin.Success) {
      // If Biometric authentication success
      // Navigate to outDutyRoute(Patrolling) / inDutyStation(Stationary)
      Navigator.pushNamed(
          context,
          loginGuardViewModel.loginGuard.type == 'patrol'
              ? '/inDutyRoute'
              : '/inDutyStation');
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
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Container(
                height: 50.0,
                child: topRightDismissButton(context),
              ),
              rokkhiLogoImage(),
              SizedBox(height: 20.0),

              // For 'Submit your fingerprint button
              OutlinedButton(
                child: Column(
                  children: [
                    Image.asset('images/FingerPrint.png',
                        height: 70, width: 70),
                    SizedBox(height: 30),
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
