import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../src/utils/configs.dart';
import '../model/Absen_model.dart';
class LoginService{
  login(String nip, String password) async {
    try{
      var url = Uri.parse("$API_V2/auth/login");
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
          body: jsonEncode(<String, String>{
            'nip': nip,
            'password': password,
          }));
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseJson;
      } else if(response.statusCode == 401){
        return 401;
      }
    } on Exception catch (_) {
      return;
    }
  }
}