import 'package:flutter/material.dart';

class Profil extends StatefulWidget{
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil'),),
      body: Center(
        child: Text('Profil Screen', style: TextStyle(fontSize: 40),),
      ),
    );
  }

}