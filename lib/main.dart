import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google maps',
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  //LoadingScreen({Key key, this.title}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Position _currentPosition;
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor pinLocationIcon;

  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(5, 5)), "images/marker3.png")
        .then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              // SizedBox(
              //     width: MediaQuery.of(context).size.width - 10,
              //     height: MediaQuery.of(context).size.height / 2,
              //     child: GoogleMap(
              //       mapType: MapType.normal,
              //       initialCameraPosition: CameraPosition(
              //         target: LatLng(_currentPosition.latitude,
              //             _currentPosition.longitude),
              //         zoom: 15,
              //       ),
              //       markers: _createMarker(
              //           _currentPosition.latitude, _currentPosition.longitude),
              //     )),
              if (_currentPosition != null)
                Text(
                    "위도: ${_currentPosition.latitude}, 경도: ${_currentPosition.longitude}"),
            FlatButton(
              child: Text("Get location"),
              onPressed: () {
                _determinePosition();
              },
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Set<Marker> _createMarker(double latitude, double longitude) {
    return <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(latitude, longitude),
        icon: pinLocationIcon,
        infoWindow: InfoWindow(
          title: "d",
        ),
      ),
    ].toSet();
  }

  // Get User location after check service enablement and permission
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("service : " + serviceEnabled.toString());
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    print("permission : " + permission.toString());

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
    //return _currentPosition;
  }
}

// Widget _buildGoogleMap(
//         BuildContext context, double latitude, double longitude) =>
//     SizedBox(
//         width: MediaQuery.of(context).size.width - 10,
//         height: MediaQuery.of(context).size.height / 2,
//         child: GoogleMap(
//           mapType: MapType.normal,
//           initialCameraPosition: CameraPosition(
//             target: LatLng(latitude, longitude),
//             zoom: 15,
//           ),
//           markers: _createMarker(latitude, longitude),
//         ));
