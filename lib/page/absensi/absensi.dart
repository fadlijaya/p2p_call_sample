import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geolocator;
import 'package:p2p_call_sample/model/Absen_model.dart';
import 'package:p2p_call_sample/service/absensi_service.dart';

import '../../theme/colors.dart';

class Absensi extends StatefulWidget{
  Absensi({Key? key}) : super(key: key);

  double? Lat, Long;
  double? LatAbsen=-5.1389010027311, LongAbsen=119.49208931472;
  String? lokasiAbsen="";
  String? lokasiLive="";

  @override
  State<Absensi> createState() => _AbsensiStateDetail();
}

class _AbsensiStateDetail extends State<Absensi> {

  late LatLng _initialcameraposition = LatLng(widget.LatAbsen!, widget.LongAbsen!);
  late GoogleMapController _controller;
  Location _location = Location();
  Set<Marker> markers = Set();
  late AbsenModel _absenModel;

  void _onMapCreated(GoogleMapController _cntlr) async{
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) async {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 18),
        ),
      );
      setState((){
        widget.Lat = l.latitude!;
        widget.Long = l.longitude!;
      });
      if(widget.Lat != null && widget.Long != null){
        await geolocator.placemarkFromCoordinates(widget.Lat!, widget.Long!).then((List<geolocator.Placemark> placemarks){
          geolocator.Placemark place = placemarks[0];
          setState((){
            widget.lokasiLive = "${place.street}, ${place.subLocality},${place.subAdministrativeArea}";
          });
        });
      }
      await geolocator.placemarkFromCoordinates(widget.LatAbsen!, widget.LongAbsen!).then((List<geolocator.Placemark> placemarks){
        geolocator.Placemark place = placemarks[0];
        setState((){
          widget.lokasiAbsen = "${place.street}, ${place.subLocality},${place.subAdministrativeArea}";
        });
      });
    });
  }

  Future<bool> _getCordinate() async{
    var response = await AbsensiService().getCordinate();
    if(response != null){
      _absenModel = response;
      if (_absenModel.id != null) {
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  _dataCordinate() async{
    bool getCordinate = await _getCordinate();
    if(getCordinate != true){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung keserver")));
      Navigator.pop(context);
    }else{
      setState((){
        widget.LatAbsen = double.parse(_absenModel.lat!);
        widget.LongAbsen = double.parse(_absenModel.lng!);
      });
    }
  }

  @override
  void initState(){
    super.initState();
    _dataCordinate();
  }

  Set<Marker> getmarkers(){ //markers to place on map
    setState(() {
      markers.add(Marker( //add first marker
        markerId: MarkerId(_initialcameraposition.toString()),
        position: LatLng(widget.LatAbsen!, widget.LongAbsen!), //position of marker
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
        children: <Widget>[GoogleView(), _BottomSheet()],
      ),
      bottomNavigationBar: buildButtonLogin(),
    );
  }

  _BottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.5,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 60,
                  height: 8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), color: kBlack26),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0, bottom: 18.0),
                    controller: scrollController,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(target: LatLng(widget.LatAbsen!, widget.LongAbsen!),zoom: 18),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Image.asset('assets/icon/office.png',width: 35,),
                          title: Text('Lokasi absen', style: const TextStyle(fontWeight: FontWeight.bold,),),
                          subtitle: Text(widget.lokasiAbsen!),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(target: LatLng(widget.Lat!, widget.Long!),zoom: 18),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Image.asset('assets/icon/location.png',width: 35,),
                          title: Text('Lokasi anda saat ini', style: const TextStyle(fontWeight: FontWeight.bold,),),
                          subtitle: Text(widget.lokasiLive!),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
        );
      },
    );
  }

  Widget buildButtonLogin() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kCelticBlue),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
        onPressed: () {
          double distanceInMeters = GeolocatorPlatform.instance.distanceBetween(
              widget.Lat!,
              widget.Long!,
              widget.LatAbsen!,
              widget.LongAbsen!
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
      ),),
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