import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:p2p_call_sample/face_recognition/locator.dart';
import 'package:p2p_call_sample/login_page.dart';
import 'package:p2p_call_sample/src/login_screen.dart';
import 'package:p2p_call_sample/src/select_opsi_login_screen.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:p2p_call_sample/theme/material_colors.dart';

import 'home.dart';
import 'src/managers/call_manager.dart';
import 'src/utils/pref_util.dart';
import '../src/utils/configs.dart' as config;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  setupServices();

  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: colorCelticBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage()
    );
  }
}