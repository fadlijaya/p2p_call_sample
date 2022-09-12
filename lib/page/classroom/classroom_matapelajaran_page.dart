import 'package:flutter/material.dart';
import 'package:p2p_call_sample/page/classroom/detail_materi_classroom_page.dart';

import '../../service/classroom_service.dart';
import '../../theme/colors.dart';

class ClassRoomMataPelajaranPage extends StatefulWidget {
  final String idKelas;
  final String title;

  const ClassRoomMataPelajaranPage({
    Key? key,
    required this.idKelas,
    required this.title
  }) : super(key: key);

  @override
  State<ClassRoomMataPelajaranPage> createState() => _ClassRoomMataPelajaranPageState();
}

class _ClassRoomMataPelajaranPageState extends State<ClassRoomMataPelajaranPage> {
  List matapelajaranList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelas ${widget.title}'),
      ),
      body: guruSmartSchool(),
    );
  }

  @override
  void initState() {
    getMataPelajaran();
    super.initState();
  }

  Future getMataPelajaran() async {
    var response = await ClassroomService().getMatapelajaran(widget.idKelas.toString());
    if (!mounted) return;
    setState(() {
      matapelajaranList = response;
    });
  }

  Widget guruSmartSchool() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
          itemCount: matapelajaranList.length,
          itemBuilder: (context, i) {
            return Column(
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
                  title: Text(
                    '${matapelajaranList[i].mapel}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${matapelajaranList[i].teacher}',
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
