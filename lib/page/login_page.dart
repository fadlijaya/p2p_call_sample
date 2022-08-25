import 'dart:convert';

import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p2p_call_sample/src/select_opponents_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';
import '../src/managers/call_manager.dart';
import '../src/utils/consts.dart';
import '../src/utils/pref_util.dart';
import '../theme/colors.dart';
import '../src/utils/configs.dart' as config;

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
  int? kode;
  int? idGuru;
  bool _isLoginContinues = false;
  int? _selectedUserId;

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void initState() {
    super.initState();
    initConnectycube();
    CallManager.instance.init(context);
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

  login() async {
    var url = Uri.parse('${ApiService.baseURL}/guru/login');
    final response = await http.post(
      url,
      body: {'nip': _controllerNip.text, 'password': _controllerPassword.text},
    );

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      int kode = data['code'];
      String pesan = data['message'];

      if (kode == 200) {
        Map<String, dynamic> user = data['data'];
        Map<String, dynamic> auth = data['authorization'];

        savePref(200, user['id_guru'], user['id_identitas_sekolah'],
            user['sekolah'], user['email'], user['nip'], user['nama_guru']);

        saveAuth(
          200,
          auth['access_token'],
          auth['token_type'],
        );

        displaySnackBar(pesan);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setInt("idGuru", user['id_guru']);
        await preferences.setInt("idIdentitasSekolah", user['id_identitas_sekolah']);
        await preferences.setString("sekolah", user['sekolah']);
        await preferences.setString("email", user['email']);
        await preferences.setString("nip", user['nip']);
        await preferences.setString("namaGuru", user['nama_guru']);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => loginToCC(context, user['id_guru']),
          ),
          (route) => false,
        );
      } else {
        displaySnackBar(pesan);
      }
    } else {
      return displaySnackBar("Login gagal");
    }
  }

  savePref(int kode, int idGuru, int idIdentitasSekolah, String sekolah,
      String email, String nip, String namaGuru) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("code", kode);
    await preferences.setInt("id_guru", idGuru);
    await preferences.setInt("id_identitas_sekolah", idIdentitasSekolah);
    await preferences.setString("sekolah", sekolah);
    await preferences.setString("email", email);
    await preferences.setString("nip", nip);
    await preferences.setString("nama_guru", namaGuru);
    // ignore: deprecated_member_use
    await preferences.commit();
  }

  saveAuth(int kode, String token, String tokentype) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("code", kode);
    await preferences.setString("access_token", token);
    await preferences.setString("token_type", tokentype);
    // ignore: deprecated_member_use
    await preferences.commit();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      kode = preferences.getInt("code");
      idGuru = preferences.getInt("id_guru");

      kode == 200
          ? WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(),
                ),
                (route) => false,
              );
            })
          : const LoginPage();
    });
  }

  loginToCC(BuildContext context, CubeUser user) {
    if (_isLoginContinues) return;

    setState(() {
      _isLoginContinues = true;
      _selectedUserId = user.id;
    });

    if (CubeSessionManager.instance.isActiveSessionValid() &&
        CubeSessionManager.instance.activeSession!.user != null) {
      if (CubeChatConnection.instance.isAuthenticated()) {
        setState(() {
          _isLoginContinues = false;
          _selectedUserId = 0;
        });
        _goSelectOpponentsScreen(context, user);
      } else {
        _loginToCubeChat(context, user);
      }
    } else {
      createSession(user).then((cubeSession) {
        _loginToCubeChat(context, user);
      }).catchError((exception) {
        _processLoginError(exception);
      });
    }
  }

  void _loginToCubeChat(BuildContext context, CubeUser user) {
    CubeChatConnection.instance.login(user).then((cubeUser) {
      SharedPrefs.saveNewUser(user);
      setState(() {
        _isLoginContinues = false;
        _selectedUserId = 0;
      });
      _goSelectOpponentsScreen(context, cubeUser);
    }).catchError((exception) {
      _processLoginError(exception);
    });
  }

  void _processLoginError(exception) {
    //log("Login error $exception", TAG);

    setState(() {
      _isLoginContinues = false;
      _selectedUserId = 0;
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Error"),
            content: Text("Ada yang salah saat masuk ke ConnectyCube"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  void _goSelectOpponentsScreen(BuildContext context, CubeUser cubeUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectOpponentsScreen(cubeUser),
      ),
    );
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      child: Image.asset(
        'assets/logo.png',
        width: 160,
      ),
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
            displaySnackBar('Loading...');
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
}