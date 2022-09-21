import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:p2p_call_sample/face_recognition/locator.dart';
import 'package:p2p_call_sample/face_recognition/services/camera.service.dart';
import 'package:p2p_call_sample/face_recognition/services/face_detector_service.dart';
import 'package:p2p_call_sample/face_recognition/services/ml_service.dart';
import 'package:p2p_call_sample/face_recognition/widgets/camera_detection_preview.dart';
import 'package:p2p_call_sample/face_recognition/widgets/camera_header.dart';
import 'package:p2p_call_sample/face_recognition/widgets/single_picture.dart';
import 'package:p2p_call_sample/home.dart';
import 'package:p2p_call_sample/login_page.dart';
import 'package:p2p_call_sample/service/absensi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/colors.dart';

class AbsenFaceRecognition extends StatefulWidget {
  final String jenis_absen;
  final List faceSignature;
  final String lat, lng;
  const AbsenFaceRecognition({Key? key, required this.jenis_absen, required this.faceSignature, required this.lat, required this.lng}) : super(key: key);

  @override
  AbsenFaceRecognitionState createState() => AbsenFaceRecognitionState();
}

class AbsenFaceRecognitionState extends State<AbsenFaceRecognition> {
  CameraService _cameraService = locator<CameraService>();
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  MLService _mlService = locator<MLService>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPictureTaken = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _mlService.dispose();
    _faceDetectorService.dispose();
    super.dispose();
  }

  Future _start() async {
    setState(() => _isInitializing = true);
    await _cameraService.initialize();
    setState(() => _isInitializing = false);
    _frameFaces();
  }

  _frameFaces() async {
    bool processing = false;
    _cameraService.cameraController!
        .startImageStream((CameraImage image) async {
      if (processing) return; // prevents unnecessary overprocessing.
      processing = true;
      await _predictFacesFromImage(image: image);
      processing = false;
    });
  }

  Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    await _faceDetectorService.detectFacesFromImage(image!);
    if (_faceDetectorService.faceDetected) {
      _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);
    }
    if (mounted) setState(() {});
  }

  Future<void> takePicture() async {
    if (_faceDetectorService.faceDetected) {
      await _cameraService.takePicture();
      setState(() => _isPictureTaken = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.red,),
            SizedBox(width: 8),
            Text("Gagal! Signature wajah tidak terditeksi",)
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        behavior: SnackBarBehavior.floating,
        elevation: 5,));
      _reload();
    }
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    if (mounted) setState(() => _isPictureTaken = false);
    _start();
  }

  Future<void> onTap() async {
    await takePicture();
    showAlertDialogLoading(context);
    if (_faceDetectorService.faceDetected) {
      bool face = await _mlService.predict(widget.faceSignature);
      if(face == true){
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Row(
        //     children: [
        //       Icon(Icons.info_outline, size: 20, color: Colors.white,),
        //       SizedBox(width: 8),
        //       Text("Berhasil! foto sesuai",)
        //     ],
        //   ),
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(8))),
        //   behavior: SnackBarBehavior.floating,
        //   elevation: 5,));
        var response = await AbsensiService().AbsenPegawai(widget.lat,widget.lng);
        if(response != 401){
          if(response == 200){
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pop(context);
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                    (route) => false);
          }else if(response != 200 && response != null){
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pop(context);
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                    (route) => false);
            showAlertFaceSignature(context,response['message']);
          }else{
            Future.delayed(const Duration(seconds: 3), () {
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
            _reload();
          }
        }else{
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context);
          });
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
        }
      }else{
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.red,),
              SizedBox(width: 8),
              Text("Gagal! foto anda tidak sesuai",)
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          behavior: SnackBarBehavior.floating,
          elevation: 5,));
        _reload();
      }
    }
  }

  Widget getBodyWidget() {
    if (_isInitializing) return Center(child: CircularProgressIndicator());
    if (_isPictureTaken)
      return SinglePicture(imagePath: _cameraService.imagePath!);
    return CameraDetectionPreview();
  }

  @override
  Widget build(BuildContext context) {
    Widget header = CameraHeader("Absen ${widget.jenis_absen}", onBackPressed: _onBackPressed);
    Widget body = getBodyWidget();
    Widget? fab;
    if (!_isPictureTaken) fab = InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kCelticBlue,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: kCelticBlue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [body, header],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
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

  showAlertFaceSignature(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
            content: Text('${message}'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ya',
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          );
        });
  }
}