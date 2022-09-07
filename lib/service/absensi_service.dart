import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../src/utils/configs.dart';
import '../model/Absen_model.dart';
class AbsensiService{
  getCordinate() async {
    try{
      var url = Uri.parse("$API_V2/cordinate");
      final response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2Fic2VuLmUtYW5kYWxhbi5pZC9hcGkvdjEvYXV0aC9sb2dpbiIsImlhdCI6MTY2MjU4MjE1MCwiZXhwIjoxNjYyNTg1NzUwLCJuYmYiOjE2NjI1ODIxNTAsImp0aSI6Imp1NWI5bXQ5MUNUdTdsa3EiLCJzdWIiOiI0OTkiLCJwcnYiOiJhODZkZTA4ODI1OWZkNzMzMzg5M2IwOTA0NDU5ZjA3YjA2NmJmMmIxIn0.JOgyZzPh8M6LMqprFSbToj6sijisbGEh7WV-RosXSl0',
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return AbsenModel.fromJson(responseJson['data']);
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }
}