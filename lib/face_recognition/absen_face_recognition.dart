import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:p2p_call_sample/face_recognition/locator.dart';
import 'package:p2p_call_sample/face_recognition/services/camera.service.dart';
import 'package:p2p_call_sample/face_recognition/services/face_detector_service.dart';
import 'package:p2p_call_sample/face_recognition/services/ml_service.dart';
import 'package:p2p_call_sample/face_recognition/widgets/FacePainter.dart';
import 'package:p2p_call_sample/face_recognition/widgets/camera_header.dart';
import 'package:p2p_call_sample/home.dart';
import 'package:p2p_call_sample/login_page.dart';
import 'package:p2p_call_sample/service/absensi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/colors.dart';

class AbsenFaceRecognition extends StatefulWidget {
  final String jenis_absen;
  final List faceSignature;
  const AbsenFaceRecognition({Key? key, required this.jenis_absen, required this.faceSignature}) : super(key: key);

  @override
  AbsenFaceRecognitionState createState() => AbsenFaceRecognitionState();
}

class AbsenFaceRecognitionState extends State<AbsenFaceRecognition> {
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;

  bool _detectingFaces = false;
  bool pictureTaken = false;

  bool _initializing = false;

  bool _saving = false;

  // service injection
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  MLService _mlService = locator<MLService>();

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);
    await _cameraService.initialize();
    setState(() => _initializing = false);

    _frameFaces();
  }

  Future<bool> onShot() async {
    if (faceDetected == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.red,),
            SizedBox(width: 8),
            Text("Gagal! Tidak ada wajah yang terdeteksi",)
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        behavior: SnackBarBehavior.floating,
        elevation: 5,));

      return false;
    } else {
      _saving = true;
      await Future.delayed(Duration(milliseconds: 500));
      // await _cameraService.cameraController?.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
      XFile? file = await _cameraService.takePicture();
      imagePath = file?.path;

      setState(() {
        pictureTaken = true;
      });

      return true;
    }
  }

  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          await _faceDetectorService.detectFacesFromImage(image);

          if (_faceDetectorService.faces.isNotEmpty) {
            setState(() {
              faceDetected = _faceDetectorService.faces[0];
            });
            if (_saving) {
              _mlService.setCurrentPrediction(image, faceDetected);
              setState(() {
                _saving = false;
              });
            }
          } else {
            setState(() {
              faceDetected = null;
            });
          }

          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    setState(() {
      pictureTaken = false;
    });
    this._start();
  }

  Future _faceSignature(context) async {
    List predictedData = _mlService.predictedData;
    log('Absen Face : $predictedData');
    if(!predictedData.isEmpty) {
      checkFaceSignature();
    }else{
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

  checkFaceSignature() async{
    // showAlertDialogLoading(context);
    this._mlService.setFaceSignatureData(widget.faceSignature);
    bool face = await _mlService.predict();
    if(face == true){
      this._mlService.setPredictedData([]);
      this._mlService.setFaceSignatureData([]);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.white,),
            SizedBox(width: 8),
            Text("Berhasil! foto sesuai",)
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        behavior: SnackBarBehavior.floating,
        elevation: 5,));

      // Future.delayed(const Duration(seconds: 3), () {
      //   Navigator.pop(context);
      // });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
    }else{
      this._mlService.setPredictedData([]);
      this._mlService.setFaceSignatureData([]);
      _reload();
      // Future.delayed(const Duration(seconds: 3), () {
      //   Navigator.pop(context);
      // });
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
    }
  }

  Future onTap() async {
    try {
      bool faceDetected = await onShot();
      if (faceDetected) {
        _faceSignature(context);
      }
    } catch (e) {
      print("ERROR ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    late Widget body;
    if (_initializing) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_initializing && pictureTaken) {
      body = Container(
        width: width,
        height: height,
        child: Transform(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(imagePath!)),
            ),
            transform: Matrix4.rotationY(mirror)),
      );
    }

    if (!_initializing && !pictureTaken) {
      body = Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                width: width,
                height:
                width * _cameraService.cameraController!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(_cameraService.cameraController!),
                    CustomPaint(
                      painter: FacePainter(
                          face: faceDetected, imageSize: imageSize!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        body: Stack(
          children: [
            body,
            CameraHeader(
              "Absen ${widget.jenis_absen}",
              onBackPressed: _onBackPressed,
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
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
        ));
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
