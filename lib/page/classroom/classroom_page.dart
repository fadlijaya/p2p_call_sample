import 'package:flutter/material.dart';
import 'package:p2p_call_sample/service/classroom_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/colors.dart';
import 'detail_materi_classroom_page.dart';

class ClassRoomPage extends StatefulWidget {

  const ClassRoomPage(
      {Key? key})
      : super(key: key);

  @override
  State<ClassRoomPage> createState() => _SmartRoomPageState();
}

class _SmartRoomPageState extends State<ClassRoomPage> {
  List pertemuanList = [];

  String? user_type, id_pelajaran, id_guru;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classroom"),
      ),
      body: guruSmartSchool(),
    );
  }

  @override
  void initState() {
    super.initState();
    _getIdentitasGuru();
  }

  _getIdentitasGuru() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_type = preferences.getString("user_type");
      if(user_type == "school_teacher") {
        id_pelajaran = preferences.getInt("pelajaran_id_guru").toString();
      }else if(user_type == "smart_teacher"){
        id_guru = preferences.getInt("id").toString();
      }
    });
    getDataClassroom();
  }

  Future getDataClassroom() async {
    var response;
    if(user_type == "school_teacher") {
      response = await ClassroomService().getPertemuanGuruSekolah(id_pelajaran!);
    }else if(user_type == "smart_teacher"){
      response = await ClassroomService().getPertemuanGuruSmartSchool(id_guru!);
    }
    if (!mounted) return;
    if(response != null) {
      setState(() {
        pertemuanList = response;
      });
    }
  }

  Future refreshClassroom() async{
    getDataClassroom();
  }

  Widget guruSmartSchool() {
    return RefreshIndicator(
      onRefresh: refreshClassroom,
      color: kCelticBlue,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
            itemCount: pertemuanList.length,
            itemBuilder: (context, i) {
              return  Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailMateriClassRoomPage(id_materi: pertemuanList[i].id,))
                      );
                    },
                    leading: const Icon(Icons.book, color: kBlack26,),
                    title: Text('Pertemuan ${pertemuanList[i].pertemuan_ke}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${pertemuanList[i].judul}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12,),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
