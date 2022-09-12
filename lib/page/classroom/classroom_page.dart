import 'package:flutter/material.dart';
import 'package:p2p_call_sample/model/Classroom/Kelas_model.dart';
import 'package:p2p_call_sample/page/classroom/classroom_matapelajaran_page.dart';
import 'package:p2p_call_sample/page/classroom/classroom_materi_page.dart';
import 'package:p2p_call_sample/service/classroom_service.dart';

import '../../theme/colors.dart';

class ClassRoomPage extends StatefulWidget {
  const ClassRoomPage({Key? key}) : super(key: key);

  @override
  State<ClassRoomPage> createState() => _SmartRoomPageState();
}

class _SmartRoomPageState extends State<ClassRoomPage> {
  List kelasList = [];

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
    getDataKelas();
    super.initState();
  }

  Future getDataKelas() async {
    var response = await ClassroomService().getKelas();
    if (!mounted) return;
    setState(() {
      kelasList = response;
    });
  }

  Widget guruSmartSchool() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
          itemCount: kelasList.length,
          itemBuilder: (context, i) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClassRoomMataPelajaranPage(title: kelasList[i].nama_kelas,idKelas: kelasList[i].id_kelas.toString()))
                      );
                    },
                    title: Text('Kelas ${kelasList[i].nama_kelas}', style: const TextStyle(fontWeight: FontWeight.w600),),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12,),
                  ),
                ],
              );
          }),
    );
  }
}
