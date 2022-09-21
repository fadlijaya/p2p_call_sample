import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:p2p_call_sample/src/utils/configs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IzinService{
  tambahIzin(String daritanggal, String sampaitanggal, File? file, String keterangan) async{
    var url = Uri.parse("$API_V1/gov/permit");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer ${preferences.getString("access_token")}';
      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
      request.headers['Accept'] = 'application/json';
      request.fields['start_at'] = daritanggal;
      request.fields['end_at'] = sampaitanggal;
      if(file != null) {
        request.files.add(
            await http.MultipartFile.fromPath('file', file.path));
      }
      request.fields['reason'] = keterangan;
      var res = await request.send();
      final respStr = await http.Response.fromStream(res);
      if(res.statusCode == 200) {
        return 200;
      }else if(res.statusCode == 422 || res.statusCode == 400){
        return jsonDecode(respStr.body);
      }else if(res.statusCode == 401){
        return 401;
      }else{
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }
}