import 'package:flutter/material.dart';
import 'package:p2p_call_sample/service/classroom_service.dart';

import '../../theme/colors.dart';
import 'detail_materi_classroom_page.dart';

class ClassRoomPage extends StatefulWidget {
  final id_pelajaran;

  const ClassRoomPage(
      {Key? key,
        required this.id_pelajaran})
      : super(key: key);

  @override
  State<ClassRoomPage> createState() => _SmartRoomPageState();
}

class _SmartRoomPageState extends State<ClassRoomPage> {
  List pertemuanList = [];

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
    var response = await ClassroomService().getPertemuan(widget.id_pelajaran);
    if (!mounted) return;
    setState(() {
      pertemuanList = response;
    });
  }

  Widget guruSmartSchool() {
    return Container(
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
                              builder: (context) => DetailMateriClassRoomPage())
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
    );
  }
}
