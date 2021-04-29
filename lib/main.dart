import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() => runApp(SecureApp());

class SecureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// Login Page State
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Login Page
class _LoginScreenState extends State<LoginScreen> {
  // employee ID Contoller
  final TextEditingController idController = TextEditingController();
  // Phone number Controller
  final TextEditingController numberController = TextEditingController();
  // Deault nation: Bangladesh
  PhoneNumber number = PhoneNumber(isoCode: 'BD');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isVerify = false;

  // Dispose controller method
  @override
  void dispose() {
    idController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo Image
            Padding(
              padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('images/CVGM-Azonix.png',
                        height: 150, width: 150)),
              ),
            ),

            // If not verify ID/phone number
            if (!this.isVerify)
              // Textfeild, verification button
              Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10, bottom: 0),
                  child: Column(
                    children: [
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            primary: Colors.black,
                            backgroundColor: Colors.grey,
                          ),
                          child: Text('NEXT'),
                          onPressed: () {
                            setState(() {
                              this.isVerify = true;
                            });
                            formKey.currentState.validate();
                            print(idController.text);
                            print(number);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // EXIT BUTTON(Exit program)
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                            primary: Colors.black,
                            backgroundColor: Colors.grey,
                          ),
                          child: Text('EXIT'),
                          onPressed: () {
                            // Application Exit
                            dispose();
                            SystemNavigator.pop();
                          },
                        ),
                      ),
                    ],
                  ))
            // If verified
            else
              TextButton(
                  onPressed: () {
                    setState(() {
                      this.isVerify = false;
                    });
                  },
                  child: Text('Back'))
          ],
        ),
      ),
    );
  }
}

// class LoadingScreen extends StatefulWidget {
//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen> {
//   List<CheckPoint> checkpoints = [];
//   List<dynamic> checkpointsjson = [];
//   final CheckPointViewModel viewModel = CheckPointViewModel();

//   GoogleMapController _controller;
//   StreamSubscription _positionSubscription;
//   Marker marker;
//   Circle circle;

//   @override
//   void initState() {
//     super.initState();
//     _requestCheckPoints();
//   }

//   Future<Uint8List> getMarker() async {
//     ByteData byteData =
//         await DefaultAssetBundle.of(context).load("images/marker3.png");
//     return byteData.buffer.asUint8List();
//   }

//   void getCurrentLocation() async {
//     try {
//       Uint8List imageData = await getMarker();
//       var currPosition = await Geolocator.getCurrentPosition();

//       updateMarkerAndCircle(currPosition, imageData);

//       if (_positionSubscription != null) {
//         _positionSubscription.cancel();
//       }

//       _positionSubscription =
//           Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best)
//               .listen((Position newPosition) {
//         if (_controller != null) {
//           _controller
//               .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
//                   //bearing: 192.8334901395799,
//                   target: LatLng(newPosition.latitude, newPosition.longitude),
//                   //tilt: 0,
//                   zoom: 18.00)));
//           updateMarkerAndCircle(newPosition, imageData);
//           print(newPosition.latitude.toString() +
//               newPosition.longitude.toString());
//         }
//       });
//     } on PlatformException catch (e) {
//       if (e.code == 'PERMISSION_DENIED') {
//         debugPrint("Permission Denied");
//       }
//     }
//   }

//   void stopTracking() {
//     _positionSubscription.pause();
//   }

//   void dispose() {
//     if (_positionSubscription != null) {
//       _positionSubscription.cancel();
//     }
//     super.dispose();
//   }

//   void updateMarkerAndCircle(Position newLocalData, Uint8List imageData) {
//     LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
//     this.setState(() {
//       marker = Marker(
//           markerId: MarkerId("home"),
//           position: latlng,
//           //rotation: newLocalData.,
//           draggable: false,
//           zIndex: 2,
//           flat: true,
//           anchor: Offset(0.5, 0.5),
//           icon: BitmapDescriptor.fromBytes(imageData));
//       circle = Circle(
//           circleId: CircleId("car"),
//           radius: newLocalData.accuracy,
//           zIndex: 1,
//           strokeColor: Colors.blue,
//           center: latlng,
//           fillColor: Colors.blue.withAlpha(70));
//     });
//   }

//   void _requestCheckPoints() async {
//     var tmp = await viewModel.fetchCheckPoint();
//     setState(() {
//       checkpointsjson = tmp;
//     });
//     checkpoints = checkpointsjson
//         .map((checkpoint) => CheckPoint.fromJson(checkpoint))
//         .toList();
//     print(checkpoints);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset('images/CVGM-Azonix.png', height: 150, width: 150),
//           SizedBox(
//               width: MediaQuery.of(context).size.width - 30,
//               height: MediaQuery.of(context).size.height / 2,
//               child: GoogleMap(
//                 mapType: MapType.normal,
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(37.5668919, 126.9179338),
//                   zoom: 15,
//                 ),
//                 markers: Set.of((marker != null) ? [marker] : []),
//                 circles: Set.of((circle != null) ? [circle] : []),
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller = controller;
//                 },
//               )),
//           FlatButton(
//             child: Text("Stop tracking", style: TextStyle(color: Colors.red)),
//             onPressed: () {
//               stopTracking();
//             },
//           ),
//           ListView.separated(
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             itemCount: checkpoints.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Container(
//                   height: 20,
//                   child: Center(
//                     child: Text("CheckPoint " +
//                         index.toString() +
//                         " : Latitude: ${checkpoints[index].latitude}, Longitude: ${checkpoints[index].longitude}"),
//                   ));
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return Divider();
//             },
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           getCurrentLocation();
//         },
//       ),
//     );
//   }
// }
