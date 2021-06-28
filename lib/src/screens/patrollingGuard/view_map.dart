import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:security_system/main.dart';
import 'package:security_system/src/components/preferences.dart';
import 'package:security_system/src/models/chckpoint.dart';
import 'package:security_system/src/screens/patrollingGuard/in_duty_route.dart';

int lastHour;
int lastMinute;

class ViewMap extends StatefulWidget {
  @override
  _ViewMapState createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  // location
  StreamSubscription _locationSubscription;
  GoogleMapController _controller;
  // markers & circles
  Marker _marker;
  //Circle _circle; // circle for cur position
  Set<Circle> _checkpointCircles = Set<Circle>();
  // ids
  int _circleIdCounter = 1;

  // initializer
  @override
  void initState() {
    super.initState();
  }

  void _getCurrentLocation() async {
    try {
      Uint8List imageData = await _getMarker();
      curLocation = await locationTracker.getLocation();

      _updateMarkerAndCircle(curLocation, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  Future<Uint8List> _getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/curlocation.png");
    return byteData.buffer.asUint8List();
  }

  void _updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      // marker size는 항상 고정 -> 줌 정도 이용해서 UI 맞추기
      _marker = Marker(
          markerId: MarkerId("guard"),
          position: latlng,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.9),
          icon: BitmapDescriptor.fromBytes(imageData));

      _checkpointCircles.add(Circle(
          circleId: CircleId("cur"),
          //radius: newLocalData.accuracy,
          radius: 40,
          zIndex: 1,
          strokeWidth: 0,
          center: latlng,
          fillColor: Colors.red.withAlpha(80)));
    });
  }

  void _updateCheckMarker(double lat, double lng, double radius) {
    LatLng latlng = LatLng(lat, lng);
    final String pointId = 'checkpoint_id_$_circleIdCounter';
    _circleIdCounter++;

    print('Checkpoint: Latitude: $lat, Longitude: $lng, Radius: $radius');

    this.setState(() {
      _checkpointCircles.add(Circle(
          circleId: CircleId(pointId),
          radius: radius,
          zIndex: 1,
          strokeWidth: 0,
          center: latlng,
          fillColor: Colors.red.withAlpha(80)));
    });
  }

  void _showChecklist() {
    List<CheckPoint> curCheckpoints =
        loginRouteViewModel.loginRoute.checkpoints;
    //List<CheckPoint> curCheckpoints = [new CheckPoint(sequenceNum: 1, latitude: 37.5763, longitude: 126.9779, radius: 30.0, frequency: 4), new CheckPoint(sequenceNum: 1, latitude: 37.5664, longitude: 126.9794, radius: 30.0, frequency: 4)];
    for (var i = 0; i < curCheckpoints.length; i++) {
      _updateCheckMarker(curCheckpoints[i].latitude,
          curCheckpoints[i].longitude, curCheckpoints[i].radius);
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Container(
                    child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target:
                          LatLng(curLocation.latitude, curLocation.longitude),
                      tilt: 0,
                      zoom: 16.0),
                  markers: Set.of((_marker != null) ? [_marker] : []),
                  circles: _checkpointCircles,
                  zoomControlsEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    _getCurrentLocation();
                    _showChecklist();
                  },
                )),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Colors.grey[300],
                        width: 1.0,
                      )),
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10.0),
                          topRightDismissButton(context),
                          viewMapLogo(loginGuardViewModel.guardName,
                              loginGuardViewModel.type),
                          SizedBox(height: 15.0),
                          Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Colors.grey[200],
                                    width: 0.7,
                                  )),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('images/grey_marker.png',
                                            height: 30.0, width: 30.0),
                                        SizedBox(height: 10.0),
                                        Text('Last Checkpoint',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13.0,
                                              fontWeight: defaultFontWeight,
                                            )
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      isStartPatrol
                                          ? '${loginRouteViewModel.routeTitle} ${cpSeqNum - 1 == 0 ? loginRouteViewModel.checkPoints.length : cpSeqNum - 1}, at ${lastHour > 12 ? lastHour - 12 : lastHour}:$lastMinute ${lastHour > 12 ? 'PM' : 'AM'}'
                                          : 'You\'ve not visited any checkpoint yet.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: titleFontWeight,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      )),
                ),
              ],
            ));
  }
}
