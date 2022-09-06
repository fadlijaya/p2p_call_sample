import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../theme/colors.dart';

class Absensi extends StatefulWidget{
  Absensi({Key? key}) : super(key: key);

  double? Lat, Long;

  @override
  State<Absensi> createState() => _AbsensiStateDetail();
}

class _AbsensiStateDetail extends State<Absensi> {

  late LatLng _initialcameraposition = LatLng(-5.1389010027311, 119.49208931472);
  late GoogleMapController _controller;
  Location _location = Location();
  Set<Marker> markers = Set();

  void _onMapCreated(GoogleMapController _cntlr){
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 18),
        ),
      );
      setState((){
        widget.Lat = l.latitude!;
        widget.Long = l.longitude!;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.Lat.toString()+", "+widget.Long.toString())));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(_initialcameraposition.toString()),
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
          119.49208931472
        );
        if(distanceInMeters < 80){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Tes 2 Anda berada di dalam radius "+distanceInMeters.toString()+" meter")));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Tes 2 Anda berada di luar radius "+distanceInMeters.toString()+" meter")));
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
      initialCameraPosition: CameraPosition(target: _initialcameraposition),
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      markers: getmarkers(),
    );
  }
}