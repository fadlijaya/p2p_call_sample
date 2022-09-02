import 'package:flutter/material.dart';

import '../theme/colors.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>{
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
              backgroundImage: NetworkImage("https://e-andalan.id/images/siswa/default.jpg"),
              radius: 30,
            ), const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Halo, Muhammad Rizky",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhite)),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Kelas Satu",
                  style: const TextStyle(color: kWhite),
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
        height: MediaQuery.of(context).size.height / 2.2,
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
                              onTap: () => {},
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icon/class_room.png",
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
                                      "assets/icon/class_room.png",
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
                                      "assets/icon/class_room.png",
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