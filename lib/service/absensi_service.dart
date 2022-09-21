import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/utils/configs.dart';
import '../model/Absen/Absen_model.dart';

class AbsensiService{
  getCordinate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse("$API_V1/cordinate");
      final response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 && responseJson['data'] != null) {
        return AbsenModel.fromJson(responseJson['data']);
      } else if(response.statusCode == 401){
        return 401;
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }

  faceSignature(List predictedData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse("$API_V1/face");
      final response = await http.post(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
          body: jsonEncode(<String, String>{
            'face_signature': predictedData.toString(),
          }));
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 && responseJson['data'] != null) {
        return 200;
      } else if(response.statusCode == 401){
        return 401;
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }

  cekAbsenPegawai() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse("$API_V1/gov/schedules");
      final response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 && responseJson != null) {
        return responseJson;
      } else if(response.statusCode == 401){
        return 401;
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }

  AbsenPegawai(String lat, String lng) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse("$API_V1/gov/presence");
      final response = await http.post(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
          body: jsonEncode(<String, String>{
            'lat': lat,
            'lng': lng,
          }));
      var responseJson = jsonDecode(response.body);
      print("JSON "+responseJson.toString());
      if (response.statusCode == 200 && responseJson != null) {
        return 200;
      }else if(response.statusCode == 400) {
        return responseJson;
      }else if(response.statusCode == 401){
        return 401;
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }
}