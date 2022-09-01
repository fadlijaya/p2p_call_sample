import 'package:flutter/material.dart';
import 'package:p2p_call_sample/page/absensi.dart';
import 'package:p2p_call_sample/page/dashboard.dart';
import 'package:p2p_call_sample/page/profil.dart';
import 'package:p2p_call_sample/theme/colors.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  int currenTab = 0;
  final List<Widget> screens = [
    Dashboard(),
    Absensi(),
    Profil()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kCelticBlue,
        child: Image.asset(
              "assets/scanner.png",
              width: 30.0,
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: kCelticBlue,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   MaterialButton(
                       minWidth: 180,
                       onPressed: (){
                         setState((){
                           currentScreen = Dashboard();
                           currenTab = 0;
                         });
                       },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard,
                            color: currenTab == 0 ? kWhite : kWhite2,
                          ),
                          Text(
                            'Dashboard',
                            style: TextStyle(color: currenTab == 0 ? kWhite : kWhite2),
                          )
                        ],
                      ),
                   ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 180,
                    onPressed: (){
                      setState((){
                        currentScreen = Profil();
                        currenTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: currenTab == 2 ? kWhite : kWhite2,
                        ),
                        Text(
                          'Profil',
                          style: TextStyle(color: currenTab == 2 ? kWhite : kWhite2),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}