import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:security_system/localauth_api.dart';
import 'package:security_system/guardmanage.dart';

void main() => runApp(SecureApp());

class SecureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/la': (context) => LocalAuth(),
        '/gm': (context) => GuardManage(),
      },
      title: 'CVGM',
      debugShowCheckedModeBanner: false,
      //home: LoginScreen(),
    );
  }
}

// Login Page
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Login Page State
class _LoginScreenState extends State<LoginScreen> {
  // employee ID Contoller
  final TextEditingController idController = TextEditingController();
  // Phone number Controller
  final TextEditingController numberController = TextEditingController();
  // Deault nation: Bangladesh
  PhoneNumber number = PhoneNumber(isoCode: 'BD');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isVerify = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 0, bottom: 0),
              child: Column(
                children: [
                  // Logo Image
                  LogoImage(),
                  SizedBox(
                    height: 10,
                  ),
                  // Employee ID textfield part
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(' Employee ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                      controller: idController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        hintText: '0172345678',
                      )),
                  SizedBox(
                    height: 20,
                  ),

                  // Phone number textfield part
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      ' Enter Phone Number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: formKey,
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        print(number);
                        this.number = number;
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      hintText: '0172345678',
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: number,
                      textFieldController: numberController,
                      formatInput: false,
                      inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // Verification Buttons(NEXT, EXIT)
                  // NEXT BUTTON(Go to local authentication)
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        primary: Colors.black,
                        backgroundColor: Colors.grey[300],
                      ),
                      child: Text('NEXT'),
                      onPressed: () {
                        formKey.currentState.validate();
                        print(idController.text);
                        print(number);
                        // Push local Auth page
                        Navigator.pushNamed(context, '/la');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  // EXIT BUTTON(Exit program)
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        primary: Colors.black,
                        backgroundColor: Colors.grey[300],
                      ),
                      child: Text('EXIT'),
                      onPressed: () {
                        // Application Exit(dispose controller and pop)
                        this.idController.dispose();
                        this.numberController.dispose();
                        super.dispose();
                        SystemNavigator.pop();
                      },
                    ),
                  ),
                ],
              ))),
    );
  }
}

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
      Navigator.pushNamed(context, '/gm');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding:
              const EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 0),
          child: Column(
            children: [
              LogoImage(),
              OutlinedButton(
                // For 'Submit your fingerprint button
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(60, 50, 60, 60),
                  child: Column(
                    children: [
                      Image.asset('images/FingerPrint.png',
                          height: 100, width: 100),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Submit your fingerprint',
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
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
          )),
    );
  }
}

// Widget For Logo Image
class LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
      child: Center(
        child: Container(
            width: 200,
            height: 150,
            child:
                Image.asset('images/CVGM-Azonix.png', height: 150, width: 150)),
      ),
    );
  }
}
