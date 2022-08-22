import 'package:flutter/material.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:p2p_call_sample/theme/colors.dart';

import 'login_screen.dart';
import 'managers/call_manager.dart';
import '../src/utils/configs.dart' as config;
import 'utils/pref_util.dart';

class SelectOpsiLoginScreen extends StatefulWidget {
  const SelectOpsiLoginScreen({Key? key}) : super(key: key);

  @override
  State<SelectOpsiLoginScreen> createState() => _SelectOpsiLoginScreenState();
}

class _SelectOpsiLoginScreenState extends State<SelectOpsiLoginScreen> {
  @override
  void initState() {
    super.initState();

    initConnectycube();
    CallManager.instance.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _bodyLayout(),
      ),
    );
  }

  Widget _bodyLayout() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image(),
          _buttonOpsiLogin()
        ],
      ),
    );
  }

  Widget _image() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 200,
      margin: EdgeInsets.only(bottom: 16),
      child: Image.asset(
        "assets/splash-screen.png",
        width: 120,
      ),
    );
  }

  Widget _buttonOpsiLogin() {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: kCelticBlue),
              child: Center(
                child: Text("LOGIN GURU PROVINSI", style: TextStyle(color: kWhite),),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: kYellow),
              child: Center(
                child: Text(
                  "LOGIN GURU DAERAH", 
                  style: TextStyle(color: kWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

initConnectycube() {
  init(
    config.APP_ID,
    config.AUTH_KEY,
    config.AUTH_SECRET,
    onSessionRestore: () {
      return SharedPrefs.getUser().then((savedUser) {
        return createSession(savedUser);
      });
    },
  );
}
