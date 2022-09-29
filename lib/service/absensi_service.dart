import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/utils/configs.dart';
import '../model/Absen/Absen_model.dart';

class AbsensiService{
  getStatusKehadiran() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse("$API_V1/stats");
      final response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseJson['data'];
      } else if(response.statusCode == 401){
        return 401;
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }

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
      if (response.statusCode == 200) {
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

  cekAbsen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse("$API_V1/schedules");
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

  PostAbsen(String lat, String lng, File? file, int status) async {
    var url = Uri.parse("$API_V1/presence");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer ${preferences.getString("access_token")}';
      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
      request.headers['Accept'] = 'application/json';
      request.fields['lat'] = lat;
      request.fields['lng'] = lng;
      request.files.add(await http.MultipartFile.fromPath('file', file!.path));
      request.fields['status'] = status.toString();
      var res = await request.send();
      final respStr = await http.Response.fromStream(res);
      // print("DATA JSON "+jsonDecode(respStr.body).toString());
      if (res.statusCode == 200 &&  jsonDecode(respStr.body) != null) {
        return 200;
      }else if(res.statusCode == 400) {
        return jsonDecode(respStr.body);
      }else if(res.statusCode == 401){
        return 401;
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }
}