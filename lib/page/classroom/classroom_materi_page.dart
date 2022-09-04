import 'package:flutter/material.dart';
import 'package:p2p_call_sample/page/classroom/detail_materi_classroom_page.dart';

import '../../theme/colors.dart';

class ClassRoomMateriPage extends StatefulWidget {
  const ClassRoomMateriPage({Key? key}) : super(key: key);

  @override
  State<ClassRoomMateriPage> createState() => _SmartRoomPageState();
}

class _SmartRoomPageState extends State<ClassRoomMateriPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kimia Kelas XVII"),
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
