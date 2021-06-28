import 'package:flutter/material.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/src/components/dialogs.dart';
import 'package:flutter/services.dart';
import 'package:security_system/main.dart';
import 'package:connectivity/connectivity.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// Login Page
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Login Page State
class _LoginScreenState extends State<LoginScreen> {
  // employee ID Contoller
  final TextEditingController idController = TextEditingController();
  // Deault nation: Bangladesh
  PhoneNumber number = PhoneNumber(phoneNumber: ' ', isoCode: 'BD');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Check internet connection
  var connectivityResult;

  void submit() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Fail to connect internet
      internetConnectionFailedDialog(context);
    } else {
      // Success to connect internet
      // if user doesn't type anything.
      if (number.toString().length == 0 || idController.text.length == 0) {
        loginFailedDialog(context);
        return;
      }
      // Show logging in dialog
      showLoadingDialog(context);
      print(idController.text);
      print(number.toString());
      print('mobile network or wifi');

      if (await loginGuardViewModel.fetchGuard(
          idController.text, number.toString())) {
        // if id, number is in server
        hideLoadingDialog(context);
        Navigator.pushNamed(context, '/localAuth');
      } else {
        // Fail to login
        hideLoadingDialog(context);
        loginFailedDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // For moving cursor
    final node = FocusScope.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            // Use Container -> SingleChildScrollView -> Column for scrollable full screen
            height: double.infinity,
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    SizedBox(height: 50.0),
                    // Logo Image
                    rokkhiLogoImage(),
                    // Employee ID text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Employee ID',
                          style: TextStyle(
                            fontWeight: defaultFontWeight,
                          )),
                    ),
                    SizedBox(height: 5),
                    // Employee ID textfield
                    TextField(
                        controller: idController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textfeildDesign(),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          node.nextFocus();
                          node.nextFocus();
                        }),
                    SizedBox(height: 15),

                    // Phone number text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter Phone Number',
                        style: TextStyle(
                          fontWeight: defaultFontWeight,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    // Phone number textfield
                    Form(
                      key: formKey,
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          print(number);
                          this.number = number;
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          showFlags: false,
                          trailingSpace: false,
                        ),
                        hintText: '0172345678',
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        initialValue: number,
                        formatInput: false,
                        inputDecoration: textfeildDesign(),
                        onSubmit: () {
                          submit();
                        },
                      ),
                    ),
                    SizedBox(height: 20),

                    // NEXT BUTTON(Go to local authentication)
                    Container(
                      width: double.infinity,
                      height: 55.0,
                      child: OutlinedButton(
                        style: buttonStyle(Colors.white, rokkhiColor),
                        child: Text('NEXT'),
                        onPressed: () async {
                          submit();
                        },
                      ),
                    ),
                    SizedBox(height: 8),

                    // EXIT BUTTON(Exit program)
                    Container(
                      width: double.infinity,
                      height: 55.0,
                      child: OutlinedButton(
                        style: buttonStyle(Colors.black, Colors.white),
                        child: Text('EXIT'),
                        onPressed: () {
                          // Application Exit(dispose controller and pop)
                          this.idController.dispose();
                          super.dispose();
                          SystemNavigator.pop();
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
