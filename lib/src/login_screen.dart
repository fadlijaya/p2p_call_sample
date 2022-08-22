import 'package:flutter/material.dart';

import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:p2p_call_sample/theme/colors.dart';

import 'select_opponents_screen.dart';
import 'utils/configs.dart' as utils;
import 'utils/pref_util.dart';

class LoginScreen extends StatelessWidget {
  static const String TAG = "LoginScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BodyState();
  }
}

class BodyState extends State<BodyLayout> {
  static const String TAG = "LoginScreen.BodyState";

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool _showPassword = true;

  bool _isLoginContinues = false;
  int? _selectedUserId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Login Guru Daerah",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kCelticBlue
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              //_formLogin(),
              //SizedBox(height: 24,),
              //_buttonLogin(),
              Expanded(
                child: _getUsersList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SharedPrefs.getUser().then((loggedUser) {
      if (loggedUser != null) {
        _loginToCC(context, loggedUser);
      }
    });
  }

  Widget _formLogin() {
    return Form(
      key: _formKey,
      child: Column(
       children: [
         TextFormField(
           controller: _controllerEmail,
           decoration: InputDecoration(
             labelText: 'Email',
             border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(8)
             )
           ),
           validator: (value) {
             if (value!.isEmpty) {
               return "Masukkan Email";
             }
             return null;
           },
         ),
         SizedBox(height: 8,),
         TextFormField(
           controller: _controllerPassword,
           obscureText: _showPassword,
           decoration: InputDecoration(
             labelText: 'Password',
             border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(8)
             ),
             suffixIcon: GestureDetector(
               onTap: _togglePasswordVisibility,
               child: _showPassword
                 ? Icon(Icons.visibility_off, color: Colors.grey,)
                   : Icon(Icons.visibility, color: Colors.blue,)
             )
           ),
           validator: (value) {
             if (value!.isEmpty) {
               return "Masukkan Password";
             }
             return null;
           },
         ),
       ],
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget _buttonLogin() {
    return  ElevatedButton(onPressed: (){
      if (_formKey.currentState!.validate()) {
          CubeUser user = CubeUser(email: _controllerEmail.text, password: _controllerPassword.text);
          
          signIn(user).then((cubeUser) {
            _loginToCubeChat(context, user);
          }).catchError((error){

          });
      }
    },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))
        ),
        child: Container(
          width: double.infinity,
          height: 48,
          child: Center(
            child: Text("LOGIN"),
          ),
        ));
  }

  Widget _getUsersList(BuildContext context) {
    final users = utils.users;

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Card(
          color: _isLoginContinues ? Colors.white70 : Colors.white,
          child: ListTile(
            title: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    users[index].fullName!,
                    style: TextStyle(
                        color: _isLoginContinues
                            ? Colors.black26
                            : Colors.black87),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    height: 18,
                    width: 18,
                    child: Visibility(
                      visible: _isLoginContinues &&
                          users[index].id == _selectedUserId,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => _loginToCC(
              context,
              users[index],
            ),
          ),
        );
      },
    );
  }

  _loginToCC(BuildContext context, CubeUser user) {
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
    log("Login error $exception", TAG);

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
}
