import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:security_system/model/chckpoint.dart';
import 'package:security_system/viewmodels/check_points_view_model.dart';
import 'dart:async';

void main() async {
  runApp(MaterialApp(home: Scaffold(body: LoadingScreen())));

  //runApp(MyApp());
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<dynamic> checkpoints = [];
  final CheckPointViewModel viewModel = CheckPointViewModel();

  BitmapDescriptor pinLocationIcon;
  Position _currentPosition;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(5, 5)), "images/marker3.png")
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    _requestCheckPoints();
  }

  _requestCheckPoints() async {
    var tmp = await viewModel.fetchCheckPoint();
    print(tmp);
    setState(() {
      checkpoints = tmp;
    });
    print(checkpoints[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //scrollDirection: Axis.vertical,
      //shrinkWrap: true,
      children: [
        //Image.asset('images/CVGM-Azonix.png', height: 150, width: 150),
        //ListWidget(),
        // if (_currentPosition != null)
        //   SizedBox(
        //       width: MediaQuery.of(context).size.width / 2,
        //       height: MediaQuery.of(context).size.height / 4,
        //       child: GoogleMap(
        //         mapType: MapType.normal,
        //         initialCameraPosition: CameraPosition(
        //           target: LatLng(
        //               _currentPosition.latitude, _currentPosition.longitude),
        //           zoom: 15,
        //         ),
        //         // markers: _createMarker(
        //         //     _currentPosition.latitude, _currentPosition.longitude),
        //       )),
        if (_currentPosition != null)
          Text(
              "위도: ${_currentPosition.latitude}, 경도: ${_currentPosition.longitude}"),
        FlatButton(
          child: Text("Get location"),
          onPressed: () async {
            await Geolocator.getCurrentPosition()
                .then((position) => _currentPosition = position);
            setState(() {});
          },
        ),
      ],
    );
  }
}

// class ListWidget extends StatelessWidget {
//   final CheckPointViewModel viewModel = CheckPointViewModel();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<CheckPoint>>(
//         future: this.viewModel.fetchCheckPoint(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(snapshot.data[index].checkPointId),
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Text(snapshot.error);
//           }
//           return CircularProgressIndicator();
//         });
//   }
// }

// class MapWidget extends State<LoadingScreen> {
//   BitmapDescriptor pinLocationIcon;
//   Position _currentPosition;
//   Completer<GoogleMapController> _controller = Completer();

//   void initState() {
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration(size: Size(5, 5)), "images/marker3.png")
//         .then((onValue) {
//       pinLocationIcon = onValue;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_currentPosition != null)
//               SizedBox(
//                   width: MediaQuery.of(context).size.width - 20,
//                   height: MediaQuery.of(context).size.height / 2,
//                   child: GoogleMap(
//                     mapType: MapType.normal,
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(_currentPosition.latitude,
//                           _currentPosition.longitude),
//                       zoom: 15,
//                     ),
//                     // markers: _createMarker(
//                     //     _currentPosition.latitude, _currentPosition.longitude),
//                   )),
//             if (_currentPosition != null)
//               Text(
//                   "위도: ${_currentPosition.latitude}, 경도: ${_currentPosition.longitude}"),
//             FlatButton(
//               child: Text("Get location"),
//               onPressed: () async {
//                 await Geolocator.getCurrentPosition()
//                     .then((position) => _currentPosition = position);
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Set<Marker> _createMarker(double latitude, double longitude) {
// //   return <Marker>[
// //     Marker(
// //       markerId: MarkerId("marker_1"),
// //       position: LatLng(latitude, longitude),
// //       icon: pinLocation,
// //       infoWindow: InfoWindow(
// //         title: "d",
// //       ),
// //     ),
// //   ].toSet();
// // }
