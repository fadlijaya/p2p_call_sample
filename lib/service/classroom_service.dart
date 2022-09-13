import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../src/utils/configs.dart';
import '../model/Classroom/Classroom_pertemuan_model.dart';
class ClassroomService{
  getPertemuan(String id_pelajaran) async {
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
}