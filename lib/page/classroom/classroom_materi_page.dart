import 'package:flutter/material.dart';
import 'package:p2p_call_sample/page/classroom/detail_materi_classroom_page.dart';

import '../../theme/colors.dart';

class ClassRoomMateriPage extends StatefulWidget {
  final String idKelas;
  final String kodemapel;
  final String title;

  const ClassRoomMateriPage({
    Key? key,
    required this.idKelas,
    required this.kodemapel,
    required this.title
  }) : super(key: key);

  @override
  State<ClassRoomMateriPage> createState() => _SmartRoomPageState();
}

class _SmartRoomPageState extends State<ClassRoomMateriPage> {

  List materiMapelLkist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matapelajaran ${widget.title}'),
      ),
      body: guruSmartSchool(),
    );
  }

  Widget guruSmartSchool() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        children: [
          Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailMateriClassRoomPage())
                  );
                },
                title: Text(
                  "Sifat Koligatif Larutan",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Pertemuan Ke-1",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12,),
              ),
            ],
          )
        ],
      ),
    );
  }
}
