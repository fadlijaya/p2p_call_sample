import 'package:flutter/material.dart';
import 'package:p2p_call_sample/page/classroom/classroom_materi_page.dart';

import '../../theme/colors.dart';

class ClassRoomPage extends StatefulWidget {
  const ClassRoomPage({Key? key}) : super(key: key);

  @override
  State<ClassRoomPage> createState() => _SmartRoomPageState();
}

class _SmartRoomPageState extends State<ClassRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classroom"),
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
                          builder: (context) => ClassRoomMateriPage())
                  );
                },
                leading: const Icon(Icons.book, color: kBlack26,),
                title: Text("Kimia Kelas XII", style: const TextStyle(fontWeight: FontWeight.w600),),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12,),
              ),
            ],
          )
        ],
      ),
    );
  }
}
