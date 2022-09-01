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
                child: Stack(
                  children: [
                    gridKeterangan(),
                  ],
                ),
                ),
              ),
            )
        );
  }

  Widget gridKeterangan() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => {},
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hadir",
                      style: TextStyle(
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "1 Hari",
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
                    const Text(
                      "Izin",
                      style: TextStyle(
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "3 Hari",
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
                    const Text(
                      "Alpha",
                      style: TextStyle(
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "1 Hari",
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40.0,
        ),
        Text('Menu Utama',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: kBlack)),
        SizedBox(
          height: 10.0,
        ),
        gridMenu(),
      ],
    );
  }

  Widget gridMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  "Classroom",
                  style: TextStyle(
                      fontWeight: FontWeight.w600),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w600),
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
                  "Keterangan\nIzin",
                  style: TextStyle(
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

}