import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/main.dart';
import 'package:connectivity/connectivity.dart';

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
  PhoneNumber number = PhoneNumber(isoCode: 'BD');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Check internet connection
  var connectivityResult;

  @override
  Widget build(BuildContext context) {
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Employee ID',
                          style: TextStyle(
                            fontWeight: defaultFontWeight,
                          )),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: idController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: textfeildDesign(),
                    ),
                    SizedBox(height: 15),

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
                    SizedBox(height: 5),
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
                        //textFieldController: numberController,
                        formatInput: false,
                        inputDecoration: textfeildDesign(),
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
                          connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.none) {
                            // Fail to connect internet
                            internetConnectionFailedDialog(context);
                          } else {
                            // Success to connect internet
                            // Show logging in dialog
                            showLoadingDialog(context);
                            print(idController.text);
                            print(number.toString());
                            print('mobile network or wifi');

                            if (await loginGuardViewModel.fetchGuard(
                                idController.text, number.toString())) {
                              // if id, number is in server
                              if (loginGuardViewModel.type == 'patrol') {
                                // patrolling guard
                                await loginRouteViewModel
                                    .fetchRoute(idController.text);
                                // Success to fetch route
                                hideLoadingDialog(context);
                                Navigator.pushNamed(context, '/localAuth');
                              } else if (loginGuardViewModel.type ==
                                  'stationary') {
                                // stationary guard
                                await loginStationViewModel
                                    .fetchStation(idController.text);
                                // Success to fetch station
                                hideLoadingDialog(context);
                                Navigator.pushNamed(context, '/localAuth');
                              }
                            } else {
                              // Fail to login
                              hideLoadingDialog(context);
                              loginFailedDialog(context);
                            }
                          }
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
