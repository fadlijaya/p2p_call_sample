import 'package:flutter/material.dart';
import 'package:p2p_call_sample/page/izin/izin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/colors.dart';
import 'classroom/classroom_page.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>{
  String? user_type, nip, nama, jenis_user, profile_picture;

  _getIdentitasGuru() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState((){
      user_type = preferences.getString("user_type");
      nip = preferences.getString("nip");
      nama = preferences.getString("nama");
      profile_picture = preferences.getString("profile_picture");
      if(user_type == "smart_teacher"){
        jenis_user = "Guru Smart School";
      }else if(user_type == "school_teacher"){
        jenis_user = preferences.getString("sekolah_guru");
      }else if(user_type == "gov_employee"){
        jenis_user = "Dinas Pendidikan Sulawesi Selatan";
      }else if(user_type == "gov_supervisor_employee"){
        jenis_user = "Pengawas ${preferences.getString("wilayah_cabdis")}";
      }
    });
  }

  @override
  void initState(){
    super.initState();
    _getIdentitasGuru();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: <Widget>[buildHeader(), gridKategori()],
                ),
              ],
            ),
          )));
  }

  buildHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.9,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24)),
          color: kCelticBlue),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: kGrey,
              backgroundImage: NetworkImage(profile_picture.toString()),
              radius: 35,
            ), const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Halo, ${nama}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhite)),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "${jenis_user}",
                  style: const TextStyle(color: kWhite),
                ),
              ],
            ),
            Spacer(),
            if (user_type == "smart_teacher" || user_type == "school_teacher") ...[
              Image.asset(
                "assets/logo_smartschool.png",
                width: 80,
              ),
            ] else if(user_type == "gov_employee")...[
              Image.asset(
                "assets/logo_disdik_sulsel.png",
                width: 70,
              ),
            ],
          ],
        ),
      )
    );
  }

  Widget gridKategori() {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 1.9,
        child: Padding(
            padding: EdgeInsets.only(top: 170.0),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0,right: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GridView(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: (SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0)),
                          padding: EdgeInsets.all(16.0),
                          children: [
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Status Hadir",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "1 Hari"
                                  )
                                ],
                              ),
                            ),
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Status Izin",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "3 Hari"
                                  )
                                ],
                              ),
                            ),
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Status Alfa",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                      "3 Hari"
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0,right: 16.0),
                        child: const Divider(thickness: 1,),
                      ),
                      if (user_type == "smart_teacher" || user_type == "school_teacher") ...[
                        MenuGuru(),
                      ] else if(user_type == "gov_employee" || user_type == "gov_supervisor_employee")...[
                        MenuPegawai(),
                      ],
                    ],
                  ),
                ),
                ),
                ),
              ),
            );
  }

  Widget MenuGuru(){
    return Expanded(
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: (SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0)),
        padding: EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClassRoomPage())
              );
            },
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icon/classroom.png",
                    width: 36,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "\nClassroom",
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {},
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icon/absen.png",
                    width: 36,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Riwayat\nAbsensi",
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {},
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icon/izin.png",
                    width: 36,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "\nIzin",
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget MenuPegawai(){
    return Expanded(
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: (SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0)),
        padding: EdgeInsets.only(left: 16.0,right: 16.0),
        children: [
          GestureDetector(
            onTap: () => {},
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icon/absen.png",
                    width: 36,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Riwayat\nAbsensi",
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Izin())
              )
            },
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icon/izin.png",
                    width: 36,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "\nIzin",
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}