import 'package:flutter/material.dart';

class Absensi extends StatefulWidget{
  @override
  _AbsensiState createState() => _AbsensiState();
}

class _AbsensiState extends State<Absensi>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absensi'),),
      body: Center(
        child: Text('Absensi Screen', style: TextStyle(fontSize: 40),),
      ),
    );
  }

}