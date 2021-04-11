import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:security_system/model/chckpoint.dart';
import 'package:security_system/viewmodels/check_points_view_model.dart';
import 'dart:async';

void main() async {
  runApp(MaterialApp(home: LoadingScreen()));
  //runApp(MyApp());
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<CheckPoint> checkpoints = [];
  List<dynamic> checkpointsjson = [];
  final CheckPointViewModel viewModel = CheckPointViewModel();

  GoogleMapController _controller;
  StreamSubscription _positionSubscription;
  Marker marker;
  Circle circle;

  @override
  void initState() {
    super.initState();
    _requestCheckPoints();
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/marker3.png");
    return byteData.buffer.asUint8List();
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var currPosition = await Geolocator.getCurrentPosition();

      updateMarkerAndCircle(currPosition, imageData);

      if (_positionSubscription != null) {
        _positionSubscription.cancel();
      }

      _positionSubscription =
          Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best)
              .listen((Position newPosition) {
        if (_controller != null) {
          _controller
              .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                  //bearing: 192.8334901395799,
                  target: LatLng(newPosition.latitude, newPosition.longitude),
                  //tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newPosition, imageData);
          print(newPosition.latitude.toString() +
              newPosition.longitude.toString());
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void stopTracking() {
    _positionSubscription.pause();
  }

  void dispose() {
    if (_positionSubscription != null) {
      _positionSubscription.cancel();
    }
    super.dispose();
  }

  void updateMarkerAndCircle(Position newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          //rotation: newLocalData.,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void _requestCheckPoints() async {
    var tmp = await viewModel.fetchCheckPoint();
    setState(() {
      checkpointsjson = tmp;
    });
    checkpoints = checkpointsjson
        .map((checkpoint) => CheckPoint.fromJson(checkpoint))
        .toList();
    print(checkpoints);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/CVGM-Azonix.png', height: 150, width: 150),
          SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.height / 2,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.5668919, 126.9179338),
                  zoom: 15,
                ),
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              )),
          FlatButton(
            child: Text("Stop tracking", style: TextStyle(color: Colors.red)),
            onPressed: () {
              stopTracking();
            },
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: checkpoints.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 20,
                  child: Center(
                    child: Text("CheckPoint " +
                        index.toString() +
                        " : Latitude: ${checkpoints[index].latitude}, Longitude: ${checkpoints[index].longitude}"),
                  ));
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();
        },
      ),
    );
  }
}
