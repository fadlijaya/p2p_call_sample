import 'package:flutter/material.dart';
import 'package:p2p_call_sample/theme/colors.dart';

class RiwayatAbsensi extends StatefulWidget {
  const RiwayatAbsensi({Key? key}) : super(key: key);

  @override
  State<RiwayatAbsensi> createState() => _RiwayatAbsensiState();
}

class _RiwayatAbsensiState extends State<RiwayatAbsensi> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: kWhite,
              labelColor: kWhite,
              tabs: [
                Tab(text: "Absen Apel"),
                Tab(text: "Absen Apel"),
              ],
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Riwayat Absen",
                ),
              ],
            ),
          ),
          body: Center(
            child: Text("List Info Kehadiran"),
          ),
        )
    );
  }
}
