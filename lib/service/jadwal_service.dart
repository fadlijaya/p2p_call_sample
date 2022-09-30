import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/utils/configs.dart';

class JadwalService{
  jadwalHariIni() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try{
      var url = Uri.parse("$API_V1/schedule/lists");
      final response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 && responseJson['data'] != null) {
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
}