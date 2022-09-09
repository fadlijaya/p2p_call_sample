import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/colors.dart';
import 'classroom/classroom_page.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>{
  String? user_type, nip_guru, nama_guru, sekolah_guru, profile_picture;

  _getIdentitasGuru() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState((){
      user_type = preferences.getString("user_type");
      nip_guru = preferences.getString("nip_guru");
      nama_guru = preferences.getString("nama_guru");
      sekolah_guru = preferences.getString("sekolah_guru");
      profile_picture = preferences.getString("profile_picture");
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
                Text("Halo, ${nama_guru}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhite)),
                const SizedBox(
                  height: 4,
                ),
                Column(
                  children: [
                    if (user_type == "smart_teacher") ...[
                      Text(
                        "Guru Smart School",
                        style: const TextStyle(color: kWhite),
                      ),
                    ] else if(user_type == "school_teacher")...[
                      Text(
                        sekolah_guru.toString(),
                        style: const TextStyle(color: kWhite),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            Spacer(),
            Image.asset(
              "assets/logo.png",
              width: 80,
            ),
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
                      ),
                    ],
                  ),
                ),
                ),
                ),
              ),
            );
  }

}