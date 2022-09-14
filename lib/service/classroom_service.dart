import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p2p_call_sample/model/Classroom/Classroom_detail_model.dart';

import '../../src/utils/configs.dart';
import '../model/Classroom/Classroom_pertemuan_model.dart';
class ClassroomService{
  getPertemuanGuruSekolah(String id_pelajaran) async {
    try{
      var url = Uri.parse("$API_V2/materi_live_streaming/pelajaran/"+id_pelajaran);
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 && responseJson['data'] != null) {
        var data = responseJson['data'];
        return data.map((p) => ClassroomPertemuanModel.fromJson(p)).toList();
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }

  getPertemuanGuruSmartSchool(String id_pelajaran) async {
    try{
      var url = Uri.parse("$API_V2/materi_live_streaming/guru_smart/"+id_pelajaran);
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 && responseJson['data'] != null) {
        var data = responseJson['data'];
        return data.map((p) => ClassroomPertemuanModel.fromJson(p)).toList();
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }

  getDetail(String id_materi) async {
    try{
      var url = Uri.parse("$API_V2/materi_live_streaming/detail/"+id_materi);
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 && responseJson['data'] != null) {
        var data = responseJson['data'];
        return ClassroomDetailModel.fromJson(data);
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }
}