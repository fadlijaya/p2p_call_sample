import 'dart:convert';

import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p2p_call_sample/service/login_service.dart';
import 'package:p2p_call_sample/src/select_opponents_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'src/managers/call_manager.dart';
import 'src/utils/consts.dart';
import 'src/utils/pref_util.dart';
import 'theme/colors.dart';
import 'src/utils/configs.dart' as config;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerNip = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  late bool _showPassword = true;
  late bool _isLoading = false;

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  cekIDGuru() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString("access_token") != null){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
            (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    cekIDGuru();
  }

  login() async {
    var response = await LoginService().login(_controllerNip.text,_controllerPassword.text);
    if(response != null && response != 401) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("access_token", response['access_token']);
      await preferences.setString("user_type", response['user_type']);
      await preferences.setString("nip_guru", response['user']['nip']);
      if(response['user_type'] == "smart_teacher") {
        await preferences.setInt("id_guru", response['user']['id']);
        await preferences.setString("nama_guru", response['user']['nama']);
        await preferences.setInt("pelajaran_id_guru", response['user']['pelajaran_id']);
      }else if(response['user_type'] == "school_teacher"){
        await preferences.setInt("id_guru", response['user']['id_guru']);
        await preferences.setString("nama_guru", response['user']['nama_guru']);
        await preferences.setInt("id_sekolah_guru", response['user']['id_identitas_sekolah']);
        await preferences.setString("sekolah_guru", response['user']['nama_sekolah']);
        await preferences.setInt("pelajaran_id_guru", response['user']['pelajaran_id']);
      }
      await preferences.setString("email_guru", response['user']['email']);
      await preferences.setString("profile_picture", response['user']['profile_picture']);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
            (route) => false,
      );
    }else if(response == 401){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.red,),
            SizedBox(width: 8),
            Text("Gagal! NIP atau password salah",)
          ],
        ),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),behavior: SnackBarBehavior.floating,
        elevation: 5,));
      Navigator.pop(context);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.red,),
            SizedBox(width: 8),
            Text("Gagal! terhubung keserver",)
          ],
        ),shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),behavior: SnackBarBehavior.floating,
        elevation: 5,));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildIconLogo(),
                    buildTextLogin(),
                    buildFormLogin(),
                    buildButtonLogin()
                  ],
                ),
              ),
            )));
  }

  Widget buildIconLogo() {
    return Padding(padding: EdgeInsets.only(top: 60.0),
    child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40),
        child: Image.asset(
        'assets/logo.png',
        width: 160,
        ),
      )
    );
  }

  Widget buildTextLogin() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                titleLoginApp,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600, color: kBlack),
              ),
            ],
          ),
          Row(
            children: const [
              Text(
                subtitleLoginApp,
                style: TextStyle(fontSize: 12, color: kBlack54),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildFormLogin() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 40),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _controllerNip,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.account_circle_rounded,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                labelText: 'NIP',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Lengkapi!';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _controllerPassword,
              obscureText: _showPassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: GestureDetector(
                  onTap: togglePasswordVisibility,
                  child: _showPassword
                      ? const Icon(
                          Icons.visibility_off,
                          color: kCelticBlue,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: kCelticBlue,
                        ),
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                labelText: 'Password',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Lengkapi!';
                }
                return null;
              },
            ),
          ],
        ),
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
        if (!_isLoading) {
          if (_formKey.currentState!.validate()) {
            showAlertDialogLoading(context);
            login();
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 24,
          right: 24,
        ),
        width: double.infinity,
        height: 48,
        child: Center(
          child: Text(
            titleLoginApp.toUpperCase(),
            style: const TextStyle(color: kWhite, fontSize: 16.0),
          ),
        ),
      ),
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