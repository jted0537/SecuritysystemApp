import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:security_system/components/preferences.dart';

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
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 0, bottom: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.0,
                      ),
                      // Logo Image
                      rokkhiLogoImage(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Employee ID',
                            style: TextStyle(
                              fontWeight: defaultFontWeight,
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: idController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textfeildDesign(),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      // Phone number textfield part
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Enter Phone Number',
                          style: TextStyle(
                            fontWeight: defaultFontWeight,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
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
                            showFlags: false,
                            trailingSpace: false,
                          ),
                          hintText: '0172345678',
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          initialValue: number,
                          textFieldController: numberController,
                          formatInput: false,
                          inputDecoration: textfeildDesign(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // Verification Buttons(NEXT, EXIT)
                      // NEXT BUTTON(Go to local authentication)
                      Container(
                        width: double.infinity,
                        height: 55.0,
                        child: OutlinedButton(
                          style: buttonStyle(Colors.white, rokkhiColor),
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
                        height: 8,
                      ),

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
                            this.numberController.dispose();
                            super.dispose();
                            SystemNavigator.pop();
                          },
                        ),
                      ),
                      // Employee ID textfield part
                    ],
                  ))),
        ));
  }
}
