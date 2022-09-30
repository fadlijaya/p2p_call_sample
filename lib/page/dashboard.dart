import 'package:flutter/material.dart';
import 'package:p2p_call_sample/login_page.dart';
import 'package:p2p_call_sample/page/absensi/riwayat_absensi.dart';
import 'package:p2p_call_sample/page/izin/izin.dart';
import 'package:p2p_call_sample/service/absensi_service.dart';
import 'package:p2p_call_sample/service/jadwal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/colors.dart';
import 'classroom/classroom_page.dart';

class Dashboard extends StatefulWidget{
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>{
  String? user_type, nip, nama, jenis_user, profile_picture;
  int hadir=0, izin=0, alfa=0;
  String? absenmasuk_at="--:--:--", absenmasuk_start="--:--:--", absenmasuk_end="--:--:--";
  String? absenpulang_at="--:--:--", absenpulang_start="--:--:--", absenpulang_end="--:--:--";
  String? lokasisekolah="-";


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
    _getStatusKehadiran();
    _getIdentitasGuru();
    _getJadwalHariIni();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: <Widget>[buildHeader(), gridKategori()],
                ),
                Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('Jadwal Absen Hari Ini',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: kBlack)),
                  ),
                    if(user_type == "gov_employee")...[
                      jadwalHariIniPegawai()
                    ]else if(user_type == "gov_supervisor_employee")...[
                      jadwalHariIniPengawas()
                    ]
                  ],
                )
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
              radius: 30,
            ), const SizedBox(
              width: 10,
            ),
            Container(
              width: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text("Halo, $nama",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kWhite)),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "$jenis_user",
                    style: const TextStyle(color: kWhite),
                  ),
                ],
              ),
            ),
            Spacer(),
            if (user_type == "smart_teacher" || user_type == "school_teacher") ...[
              Image.asset(
                "assets/logo_smartschool.png",
                width: 80,
              ),
            ] else if(user_type == "gov_employee" || user_type == "gov_supervisor_employee")...[
              Image.asset(
                "assets/logo_disdik_sulsel.png",
                width: 50,
              ),
            ],
          ],
        ),
      )
    );
  }

  Widget gridKategori() {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 1.8,
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
                              childAspectRatio: 1.0,
                              mainAxisSpacing: 12.0)),
                          padding: EdgeInsets.all(16.0),
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icon/timecheck.png",
                                  width: 20,
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  "Status Hadir",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                    hadir.toString()+" Hari"
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icon/info.png",
                                  width: 20,
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  "Status Izin",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                    izin.toString()+" Hari"
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icon/timex.png",
                                  width: 20,
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  "Status Alfa",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                    alfa.toString()+" Hari"
                                )
                              ],
                            )
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
            childAspectRatio: 1.0,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 12.0)),
        padding: EdgeInsets.only(left: 16.0,right: 16.0),
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
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => RiwayatAbsensi())
              )
            },
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
                    "Riwayat\nAbsens",
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
                    "\nIzin/Cuti",
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
            childAspectRatio: 1.6,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0)),
        padding: EdgeInsets.only(left: 16.0,right: 16.0),
        children: [
          GestureDetector(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RiwayatAbsensi())
              )
            },
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
                    "Riwayat\nAbsen",
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
                    "\nIzin/Cuti",
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

  Widget jadwalHariIniPegawai() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icon/timein.png",
                            width: 20,
                          ),
                          SizedBox(width: 10.0,),
                          Text("Absen Masuk"),
                        ],
                      ),
                      Text(absenmasuk_at!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                      SizedBox(
                        height: 4,
                      ),
                      Text(absenmasuk_start!+" - "+absenmasuk_end!, style: TextStyle(color: Colors.black),)
                    ],
                  ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/timeout.png",
                          width: 20,
                        ),
                        SizedBox(width: 10.0,),
                        Text("Absen Pulang"),
                      ],
                    ),
                    Text(absenpulang_at!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),),
                    SizedBox(
                      height: 4,
                    ),
                    Text(absenpulang_start!+" - "+absenpulang_end!, style: TextStyle(color: Colors.red),)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget jadwalHariIniPengawas() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined),
                SizedBox(width: 10.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Lokasi Absen"),
                    SizedBox(
                      height: 8,
                    ),
                    Text(lokasisekolah!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }

  _getJadwalHariIni() async{
    var response = await JadwalService().jadwalHariIni();
    if(response != null && response != 401){
      if(user_type == "gov_employee"){
        setState((){
          absenmasuk_at = response['absent_in_at'];
          absenmasuk_start = response['absent_in_start_at'];
          absenmasuk_end = response['absent_in_end_at'];
          absenpulang_at = response['absent_out_at'];
          absenpulang_start = response['absent_out_start_at'];
          absenpulang_end = response['absent_out_end_at'];
        });
      }else if(user_type == "gov_supervisor_employee"){
        setState((){
          lokasisekolah = response['school'];
        });
      }
    }else if(response == 401){
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pop(context);
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false);
    }
  }

  _getStatusKehadiran() async{
    var response = await AbsensiService().getStatusKehadiran();
    if(response != null && response != 401){
      setState((){
        hadir = response['hadir'];
        izin = response['izin'];
        alfa = response['alpa'];
      });
    }else if(response == 401){
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pop(context);
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false);
    }
  }

}