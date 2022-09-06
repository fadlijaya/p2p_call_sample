import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../theme/colors.dart';

class Absensi extends StatefulWidget{
  Absensi({Key? key}) : super(key: key);

  double? Lat, Long;

  @override
  State<Absensi> createState() => _AbsensiStateDetail();
}

class _AbsensiStateDetail extends State<Absensi> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? mapController;
  Set<Marker> markers = Set();
  LatLng? showLocation;
  late Location location;

  late Position currentPosition;
  var geoLocator = Geolocator();

  Future<void> locationPosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState((){
      currentPosition = position;
      widget.Lat = position.latitude;
      widget.Long = position.longitude;
      LatLng latLatPosition = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 18.0);
      mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(-5.1389010027311, 119.49208931472),
  );

  @override
  void initState() {
    super.initState();
    locationPosition();
  }

  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(-5.1389010027311, 119.49208931472), //position of marker
        // infoWindow: InfoWindow( //popup info
        //   title: 'Marker Title First ',
        //   snippet: 'My Custom Subtitle',
        // ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      //add more markers here
    });
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Absensi",
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[GoogleView(), _Card()],
      ),
    );
  }

  _Card() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading: Image.asset('assets/icon/office.png',width: 35,),
                          title: Text('Lokasi kantor', style: const TextStyle(fontWeight: FontWeight.bold,),),
                          subtitle: Text('Jl. Sukamaju'),
                        ),
                        ListTile(
                          leading: Image.asset('assets/icon/location.png',width: 35,),
                          title: Text('Lokasi anda saat ini', style: const TextStyle(fontWeight: FontWeight.bold,),),
                          subtitle: Text('Jl. Sukamaju'),
                        ),
                        buildButtonLogin()
                    ],
              ),
              ),
            )
        ],
      ),
    );
  }

  Widget buildButtonLogin() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kCelticBlue),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      onPressed: () {
        double distanceInMeters = GeolocatorPlatform.instance.distanceBetween(
          widget.Lat!,
          widget.Long!,
          -5.1389010027311,
          119.49208931472,
        );
        if(distanceInMeters < 80){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Anda berada di dalam radius "+distanceInMeters.toString()+" meter")));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Anda berada di luar radius "+distanceInMeters.toString()+" meter")));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 24,
          right: 24,
        ),
        width: double.infinity,
        height: 40,
        child: Center(
          child: Text(
            "Absen".toUpperCase(),
            style: const TextStyle(color: kWhite),
          ),
        ),
      ),
    );
  }

  Widget GoogleView() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      initialCameraPosition: _kGooglePlex,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      markers: getmarkers(),
      onMapCreated: (controller) {
        _controllerGoogleMap.complete(controller);
        mapController = controller;
        locationPosition();
      },
    );
  }
}