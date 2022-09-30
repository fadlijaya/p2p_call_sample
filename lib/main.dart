import 'dart:io';

import 'package:flutter/material.dart';
import 'package:p2p_call_sample/face_recognition/locator.dart';
import 'package:p2p_call_sample/login_page.dart';
import 'package:p2p_call_sample/theme/material_colors.dart';


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