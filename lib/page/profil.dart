import 'package:flutter/material.dart';
import 'package:p2p_call_sample/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/colors.dart';
import '../theme/padding.dart';

class Profil extends StatefulWidget{
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil>{
  String? user_type, nip_guru, nama_guru, sekolah_guru, email_guru, profile_picture;

  _getIdentitas() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState((){
      user_type = preferences.getString("user_type");
      nip_guru = preferences.getString("nip_guru");
      nama_guru = preferences.getString("nama_guru");
      sekolah_guru = preferences.getString("sekolah_guru");
      email_guru = preferences.getString("email_guru");
      profile_picture = preferences.getString("profile_picture");
    });
  }

  @override
  void initState(){
    super.initState();
    _getIdentitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            buildHeader(),
            buildBody(),
          ],
        ),
      ));
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.all(padding),
      color: kCelticBlue,
      height: 200.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 12.0,
            width: double.infinity,
          ),
          const SizedBox(
            height: 12.0,
          ),
          const  CircleAvatar(
            backgroundColor: kGrey,
            backgroundImage: NetworkImage("https://ui-avatars.com/api/?name=Andi Ahonk&color=FFFFFF&background=111827"),
            radius: 35,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            '${nama_guru}',
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 18.0, color: kWhite),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Container(
      margin: const EdgeInsets.only(top: 200.0),
      child: Column(
        children: [cardNip(), cardAsalSekolah(), cardEmail(), buttonLogout()],
      ),
    );
  }

  Widget cardNip() {
    return Container(
        width: double.infinity,
        color: kWhite,
        margin: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          leading: const Icon(
            Icons.card_membership,
            color: kBlack,
          ),
          title: const Text(
            "NIP",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          subtitle: Text(
            '${nip_guru}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: kBlack),
          ),
        ));
  }

  Widget cardAsalSekolah() {
    return Container(
        width: double.infinity,
        color: kWhite,
        margin: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          leading: const Icon(
            Icons.school_outlined,
            color: kBlack,
          ),
          title: const Text(
            "Asal Sekolah",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user_type == "smart_teacher") ...[
                Text(
                  "Guru Smart School",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                ),
              ] else if(user_type == "school_teacher")...[
                Text(
                  sekolah_guru.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                ),
              ],
            ],
          ),
        ));
  }

  Widget cardEmail() {
    return Container(
        width: double.infinity,
        color: kWhite,
        margin: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          leading: const Icon(
            Icons.email_outlined,
            color: kBlack,
          ),
          title: const Text(
            "Email",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          subtitle: Text(
            '${email_guru}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: kBlack),
          ),
        ));
  }

  Widget buttonLogout() {
    return Container(
        width: double.infinity,
        color: kWhite,
        margin: const EdgeInsets.only(bottom: 4),
        child: GestureDetector(
          onTap: () {
            showAlertExit(context);
          },
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.exit_to_app,
                    color: kRed,
                  ),
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kRed),
                ),
              ],
            ),
          ),
        ));
  }

  showAlertExit(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Anda yakin ingin Keluar ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    signOut();
                  },
                  child: const Text('Ya'))
            ],
          );
        });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false);
    });
  }
}