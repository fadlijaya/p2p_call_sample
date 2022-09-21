import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:p2p_call_sample/login_page.dart';
import 'package:p2p_call_sample/service/izin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/colors.dart';

class Izin extends StatefulWidget {
  const Izin({Key? key}) : super(key: key);

  @override
  State<Izin> createState() => _IzinState();
}

class _IzinState extends State<Izin> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _controllerMulaiTanggal = TextEditingController();
  final TextEditingController _controllerSampaiTanggal = TextEditingController();
  final TextEditingController _controllerKeterangan = TextEditingController();

  PlatformFile? pickedFile;
  DateTime _dateTime = DateTime.now();
  String? MulaiTanggal, SampaiTanggal;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Izin",
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("List Izin"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kCelticBlue,
        onPressed: _bottomSheetIzin,

        child: const Icon(Icons.file_copy_rounded),
      ),
    );
  }

  void uploadFile() async{
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if(result != null){
      setState((){
        pickedFile = result.files.first;
      });
    }
  }

  _bottomSheetIzin() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, setState){
                return SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12), color: kBlack26),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,left: 23.0,right: 23.0,top: 23.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    child: Text(
                                      'Mulai Tanggal',
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Card(
                                    elevation: 1.0,
                                    margin: EdgeInsets.only(
                                      top: 5.0,
                                      bottom: 5.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0,),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.date_range,color: kDarkBlack,),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _controllerMulaiTanggal,
                                              keyboardType: TextInputType.none,
                                              textInputAction: TextInputAction.next,
                                              readOnly: true,
                                              onTap: () => selectDateMulai(context),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(vertical: 15),
                                                hintText: "Masukkan Mulai Tanggal",
                                                hintStyle: TextStyle(color: Colors.grey),
                                              ),
                                              autovalidateMode: AutovalidateMode.always,
                                              validator: (value){
                                                if(value!.isEmpty){
                                                  return "Mulai tanggal tidak boleh kosong";
                                                }else{
                                                  return null;
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 10.0
                                    ),
                                    child: Text(
                                      'Sampai Tanggal',
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Card(
                                    elevation: 1.0,
                                    margin: EdgeInsets.only(
                                      top: 5.0,
                                      bottom: 5.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0,),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.date_range,color: kDarkBlack,),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _controllerSampaiTanggal,
                                              keyboardType: TextInputType.none,
                                              textInputAction: TextInputAction.next,
                                              readOnly: true,
                                              onTap: () => selectDateSampai(context),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(vertical: 15),
                                                hintText: "Masukkan Sampai Tanggal",
                                                hintStyle: TextStyle(color: Colors.grey),
                                              ),
                                              autovalidateMode: AutovalidateMode.always,
                                              validator: (value){
                                                if(value!.isEmpty){
                                                  return "Sampai tanggal tidak boleh kosong";
                                                }else{
                                                  return null;
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      'File',
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Card(
                                    elevation: 1.0,
                                    margin: EdgeInsets.only(
                                      top: 5.0,
                                      bottom: 5.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0,),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: uploadFile,
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.file_present,color: kDarkBlack,),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Text("Upload File",style: TextStyle(
                                                    color: Colors.grey,
                                                  ),),
                                                  if(pickedFile != null)...[//Conditionally widget(s) here
                                                    Flexible(child: Padding(
                                                      padding: EdgeInsets.only(left: 10.0),
                                                      child: Text(pickedFile!.name.toString(), style: TextStyle(
                                                          color: Colors.black,fontStyle: FontStyle.italic
                                                      ),overflow: TextOverflow.ellipsis
                                                      ),
                                                    ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text("File gambar, pdf",style: TextStyle(
                                      color: Colors.grey,fontStyle: FontStyle.italic
                                  ),),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 15.0,
                                    ),
                                    child: Text(
                                      'Keterangan',
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Card(
                                    elevation: 1.0,
                                    margin: EdgeInsets.only(
                                      top: 5.0,
                                      bottom: 5.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0,),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.description_outlined,color: kDarkBlack,),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _controllerKeterangan,
                                              keyboardType: TextInputType.text,
                                              maxLines: 4,
                                              maxLength: 100,
                                              autofocus: false,
                                              textAlign: TextAlign.left,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(vertical: 15),
                                                hintText: "Masukkan Keterangan",
                                                hintStyle: TextStyle(color: Colors.grey),
                                              ),
                                              autocorrect: false,
                                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                      ),
                                      child: Container(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(kCelticBlue),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
                                          onPressed: () => submitIzin(),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              left: 24,
                                              right: 24,
                                            ),
                                            width: double.infinity,
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                "Submit".toUpperCase(),
                                                style: const TextStyle(color: kWhite),
                                              ),
                                            ),
                                          ),
                                        )
                                      )
                                  )
                                ],
                              ),
                            )
                        ),
                      ]),
                );
              }
          );
        });
  }

  Future<void> selectDateMulai(BuildContext context) async {
    DateTime today = DateTime.now();
    final DateTime? _datePicker = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_datePicker != null) {
      _dateTime = _datePicker;
      MulaiTanggal = DateFormat('yyyy-MM-dd').format(_dateTime);
      _controllerMulaiTanggal.text = DateFormat('dd/MM/yyyy').format(_dateTime);
    }
  }

  Future<void> selectDateSampai(BuildContext context) async {
    final DateTime? _datePicker = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_datePicker != null) {
      _dateTime = _datePicker;
      SampaiTanggal = DateFormat('yyyy-MM-dd').format(_dateTime);
      _controllerSampaiTanggal.text = DateFormat('dd/MM/yyyy').format(_dateTime);
    }
  }

  submitIzin() async{
    if (formKey.currentState!.validate()) {
      showAlertDialogLoading(context);
      var response;
      if (pickedFile != null){
        response = await IzinService().tambahIzin(
            MulaiTanggal.toString(), SampaiTanggal.toString(),
            File(pickedFile!.path!), _controllerKeterangan.text);
      }else{
        response = await IzinService().tambahIzin(
            MulaiTanggal.toString(), SampaiTanggal.toString(),
            null, _controllerKeterangan.text);
      }
      if(response != null){
        if(response == 200){
          Navigator.pop(context);
          _controllerMulaiTanggal.clear();
          _controllerSampaiTanggal.clear();
          pickedFile = null;
          _controllerKeterangan.clear();
          Navigator.pop(context);
        }else if(response == 401){
          Navigator.pop(context);
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false);
        }else{
          Navigator.pop(context);
          showAlert(context,response['message']);
        }
      }else{
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.red,),
              SizedBox(width: 8),
              Text("Gagal! terhubung keserver",)
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          behavior: SnackBarBehavior.floating,
          elevation: 5,));
        Navigator.pop(context);
      }
    }
  }

  showAlertDialogLoading(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 15), child: const Text("Loading..." )),
        ],),
    );
    showDialog(
      barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(
          onWillPop: () async => false,
          child: alert,
        );
      },
    );
  }

  showAlert(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
            content: Text('${message}'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ya',
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          );
        });
  }
}
