import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:security_system/components/preferences.dart';
import 'package:security_system/viewmodels/UserViewModel.dart';

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
  //final TextEditingController numberController = TextEditingController();
  // Deault nation: Bangladesh
  PhoneNumber number = PhoneNumber(isoCode: 'BD');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isVerify = false;
  bool isLoading = false;

  final GuardViewModel guardViewModel = GuardViewModel();

  // Alert Dialog when user failed to login.
  void loginFailed() {
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

  // Logging in Dialog
  void showLoadingIndicator() {
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
                child: CircularProgressIndicator(),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Please wait",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),
              Text('Logging in...'),
            ],
          ),
        );
      },
    );
  }

  // Pop Dialog
  void hideOpenDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                        //textFieldController: numberController,
                        formatInput: false,
                        inputDecoration: textfeildDesign(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // NEXT BUTTON(Go to local authentication)
                    Container(
                      width: double.infinity,
                      height: 55.0,
                      child: OutlinedButton(
                        style: buttonStyle(Colors.white, rokkhiColor),
                        child: Text('NEXT'),
                        onPressed: () async {
                          // Show logging in dialog
                          showLoadingIndicator();
                          print(idController.text);
                          print(number.toString());
                          if (await this.guardViewModel.fetchUser(
                              idController.text, number.toString())) {
                            // Pop logging in dialog
                            hideOpenDialog();
                            // Push local Auth page
                            Navigator.pushNamed(context, '/localAuth');
                          } else {
                            hideOpenDialog();
                            Navigator.pushNamed(context, '/localAuth');
                          }
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
                          //this.numberController.dispose();
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
