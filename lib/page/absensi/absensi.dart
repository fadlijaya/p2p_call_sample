import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geolocator;
import 'package:p2p_call_sample/face_recognition/absen_face_recognition.dart';
import 'package:p2p_call_sample/face_recognition/face_recognition.dart';
import 'package:p2p_call_sample/login_page.dart';
import 'package:p2p_call_sample/model/Absen/Absen_model.dart';
import 'package:p2p_call_sample/service/absensi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_location/trust_location.dart';

import '../../theme/colors.dart';

class Absensi extends StatefulWidget{
  int? jenis_absen;

  Absensi({Key? key, this.jenis_absen}) : super(key: key);

  double? Lat, Long;
  double? LatAbsen=-5.1389010027311, LongAbsen=119.49208931472;
  double radius = 80;
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
  Set<Circle> circles = Set();
  Set<Polyline> polyline = Set();
  late AbsenModel _absenModel;
  bool? _isMockLocation;

  void _onMapCreated(GoogleMapController _cntlr) async{
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) async {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 18),
        ),
      );
      setState((){
        widget.Lat = l.latitude!;
        widget.Long = l.longitude!;
      });
      if(_isMockLocation == true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.red,),
              SizedBox(width: 8),
              Text("Anda terditeksi menggunakan fake gps",)
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          behavior: SnackBarBehavior.floating,
          elevation: 5,));
      }
      // print("Lokasi "+widget.Lat.toString()+", "+widget.Long.toString());
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

  Future<void> _cekFakeGPS() async {
    try {
      TrustLocation.onChange.listen((values) =>
          setState(() {
            _isMockLocation = values.isMockLocation;
          })
      );
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  Future<int> _getCordinate() async{
    var response = await AbsensiService().getCordinate();
    showAlertDialogLoading(context);
    if(response != null && response != 401){
      if(response['success'] == true){
        _absenModel = AbsenModel.fromJson(response['data']);
        return 1;
      }else{
        return 2;
      }
    }else if(response == 401){
      return 3;
    }else{
      return 0;
    }
  }

  _dataCordinate() async{
    int getCordinate = await _getCordinate();
    if(getCordinate == 1) {
      setState(() {
        widget.LatAbsen = double.parse(_absenModel.lat!);
        widget.LongAbsen = double.parse(_absenModel.lng!);
        widget.radius = _absenModel.radius!.toDouble();
      });
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pop(context);
      });
    }else if(getCordinate == 2){
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pop(context);
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String notice = "lokasi absen belum diatur";
      if(preferences.getString("user_type") == "gov_supervisor_employee"){
        notice = "anda tidak memiliki jadwal";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.red,),
            SizedBox(width: 8),
            Text("Gagal! $notice",)
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        behavior: SnackBarBehavior.floating,
        elevation: 5,));
      Navigator.pop(context);
    }else if(getCordinate == 3){
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pop(context);
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false);
    }else{
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pop(context);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.red,),
            SizedBox(width: 8),
            Text("Gagal! terhubung keserver",)
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        behavior: SnackBarBehavior.floating,
        elevation: 5,));
      Navigator.pop(context);
    }
  }


  @override
  void initState(){
    super.initState();
    TrustLocation.start(5);
    _cekFakeGPS();
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

  Set<Circle> getCircler() {
    circles = Set.from([Circle(
        circleId: CircleId("1"),
        center: LatLng(widget.LatAbsen!, widget.LongAbsen!),
        radius: widget.radius,
        strokeWidth: 1,
        strokeColor: Colors.red,
        fillColor: Colors.red.withOpacity(0.1)
    )
    ]);
    return circles;
  }

  Set<Polyline> setPolyline() {
    polyline = Set.from([Polyline(
      polylineId: PolylineId('1'),
      color: Colors.red,
      width: 2,
      // patterns: [
      //   PatternItem.dash(8),
      //   PatternItem.gap(15),
      // ],
      points: [
        if(widget.Lat != null && widget.Long != null)...[
          LatLng(widget.LatAbsen!, widget.LongAbsen!),
          LatLng(widget.Lat!, widget.Long!),
        ]
      ],
    )
    ]);
    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.jenis_absen == 1) ...[
              Text(
                "Absen Apel",
              ),
            ] else if(widget.jenis_absen == 2)...[
              Text(
                "Absen Harian",
              ),
            ],
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[GoogleView(), _BottomSheet()],
      ),
      bottomNavigationBar: buildButtonAbsen(),
    );
  }

  _BottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.2,
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
                  margin: const EdgeInsets.only(top: 8.0),
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), color: kBlack26),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
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
                          leading: Image.asset('assets/icon/office.png',width: 30,),
                          title: Text('Lokasi absen', style: const TextStyle(fontWeight: FontWeight.bold,),),
                          subtitle: Text(widget.lokasiAbsen!, overflow: TextOverflow.ellipsis, maxLines: 1,),
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
                          subtitle: Text(widget.lokasiLive!, overflow: TextOverflow.ellipsis, maxLines: 1),
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

  Widget buildButtonAbsen() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kCelticBlue),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
        onPressed: () {
          double distanceInMeters = GeolocatorPlatform.instance.distanceBetween(
              widget.Lat!,
              widget.Long!,
              widget.LatAbsen!,
              widget.LongAbsen!
          );
          if(distanceInMeters < widget.radius){
            cekAbsen(1);
          }else{
            if(widget.jenis_absen == 1){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.red,),
                    SizedBox(width: 8),
                    Text("Gagal! Anda berada diluar radius",)
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                behavior: SnackBarBehavior.floating,
                elevation: 5,));
            }else if(widget.jenis_absen == 2){
              cekAbsen(2);
            }
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

  cekAbsen(int status) async{
    if(widget.Lat != null && widget.Long != null && _isMockLocation != null){
     if(_isMockLocation == false){
       showAlertDialogLoading(context);
       var response = await AbsensiService().cekAbsen();
       if(response != null){
         if(response != 401){
           if(response['schedule'] == true){
             if(response['face'] == null){
               Navigator.pop(context);
               showAlertFaceSignature(context);
             }else{
               Navigator.pop(context);
               Navigator.push(
                   context, MaterialPageRoute(builder: (context) => AbsenFaceRecognition(jenis_absen: response['schedule_type'],faceSignature: response['face'] ,lat: widget.Lat.toString(),lng: widget.Long.toString(), status: status,)));
             }
           }else{
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Row(
                 children: [
                   Icon(Icons.info_outline, size: 20, color: Colors.red,),
                   SizedBox(width: 8),
                   Text(response['message'],)
                 ],
               ),
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(8))),
               behavior: SnackBarBehavior.floating,
               elevation: 5,));
             Navigator.pop(context);
           }
         }else{
           Navigator.pop(context);
           SharedPreferences preferences = await SharedPreferences.getInstance();
           preferences.clear();
           Navigator.pushAndRemoveUntil(
               context,
               MaterialPageRoute(builder: (context) => const LoginPage()),
                   (route) => false);
         }
         // bool checkAbsen = false;
         // Navigator.push(
         //     context, MaterialPageRoute(builder: (context) => FaceRecognition(isAbsen: checkAbsen,)));
       }else{
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           content: Row(
             children: [
               Icon(Icons.info_outline, size: 20, color: Colors.red,),
               SizedBox(width: 8),
               Text("Gagal! terhubung keserver",)
             ],
           ),
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.all(Radius.circular(8))),
           behavior: SnackBarBehavior.floating,
           elevation: 5,));
         Navigator.pop(context);
       }
     }else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         content: Row(
           children: [
             Icon(Icons.info_outline, size: 20, color: Colors.red,),
             SizedBox(width: 8),
             Text("Anda terditeksi menggunakan fake gps",)
           ],
         ),
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.all(Radius.circular(8))),
         behavior: SnackBarBehavior.floating,
         elevation: 5,));
     }
    }
  }

  showAlertFaceSignature(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signature Wajah'),
            content: const Text('Signature wajah anda belum terdefatar. daftar terlebih dahulu ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => FaceRecognition()));
                  },
                  child: const Text('Ya'))
            ],
          );
        });
  }

  Widget GoogleView() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _initialcameraposition),
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      markers: getmarkers(),
      circles: getCircler(),
      polylines: setPolyline(),
    );
  }

  showAlertDialogLoading(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 15), child: const Text("Loading..." )),
        ],),
    );
    showDialog(
      barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(
          onWillPop: () async => false,
          child: alert,
        );
      },
    );
  }
}