import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p2p_call_sample/model/Classroom/Kelas_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/utils/configs.dart';
import '../model/Absen/Absen_model.dart';
import '../model/Classroom/Matapalajaran_model.dart';
class ClassroomService{
  getKelas() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse("$API_V1/rooms");
      final response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 && responseJson['data'] != null) {
        var data = responseJson['data'];
        return data.map((p) => KelasModel.fromJson(p)).toList();
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }

  getMatapelajaran(String idKelas) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse("$API_V1/live-schedules/"+idKelas);
      final response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 && responseJson['data'] != null) {
        var data = responseJson['data'];
        return data.map((p) => MatapelajaranModel.fromJson(p)).toList();
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }
}