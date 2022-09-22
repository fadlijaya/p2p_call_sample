import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:p2p_call_sample/model/Classroom/Classroom_detail_model.dart';
import 'package:p2p_call_sample/page/classroom/widget/pdf_view.dart';
import 'package:p2p_call_sample/page/classroom/widget/pdf_view.dart';
import 'package:p2p_call_sample/page/classroom/widget/pdf_view.dart';
import 'package:p2p_call_sample/page/classroom/widget/video_view.dart';
import 'package:video_player/video_player.dart';

import '../../service/classroom_service.dart';
import '../../theme/colors.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DetailMateriClassRoomPage extends StatefulWidget {
  final id_materi;

  DetailMateriClassRoomPage(
      {Key? key,
        required this.id_materi})
      : super(key: key);

  @override
  State<DetailMateriClassRoomPage> createState() => _DetailMateriClassRoomPageState();
}

class _DetailMateriClassRoomPageState extends State<DetailMateriClassRoomPage> {

  ClassroomDetailModel? classroomDetailModel;
  VideoPlayerController? _videoPlayerController;

  Future getDetailClassroom() async {
    var response = await ClassroomService().getDetail(widget.id_materi.toString());
    if(response != null) {
      if (!mounted) return;
      setState(() {
        classroomDetailModel = response;
      });
    }
  }

  @override
  void initState() {
    VideoPlayerController.network("https://samplelib.com/lib/preview/mp4/sample-5s.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
    getDetailClassroom();
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16.0),
        child: classroomDetailModel == null
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerPage(),
                        fileModul(),
                        bahanAjar(),
                        bahanTayang(),
                        bahanVideo(),
                        detailMateriLive1(),
                        detailMateriLive2(),
                        detailMateriLive3(),
                      ],
                    ),
                  )),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Visibility(
                  visible: kIsWeb || Platform.isIOS || Platform.isAndroid,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: FloatingActionButton(
                      heroTag: "ScreenSharing",
                      child: Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.teal,
                      onPressed: () async {},
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: FloatingActionButton(
                    heroTag: "VideoCall",
                    child: Icon(
                      Icons.videocam,
                      color: Colors.white,
                    ),
                    backgroundColor: kCelticBlue,
                    onPressed: () => {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: FloatingActionButton(
                      heroTag: "AudioCall",
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.green,
                      onPressed: () => {}),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget backPage() {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          size: 20,
        ));
  }

  Widget headerPage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          backPage(),
          Text(
            "Pertemuan ke- ${classroomDetailModel!.pertemuan_ke.toString()}",
            textAlign: TextAlign.start,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Spacer(),
          if (classroomDetailModel!.tanggal_tayang != null) ...[
            Text(
              "Tanggal ${DateFormat('dd/MM/yyyy').format(DateTime.parse('${classroomDetailModel!.tanggal_tayang}'))}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            )
          ]
        ],
      ),
    );
  }

  Widget fileModul() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "File Modul",
            style: TextStyle(fontSize: 12),
          ),
          classroomDetailModel!.url_file_modul == null
              ? const Text(
            "Tidak Ada",
            style: TextStyle(fontSize: 12),
          )
              : TextButton(
              onPressed: () =>  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfView(
                        url: classroomDetailModel!.url_file_modul.toString(),
                      ))),
              child: const Text(
                "Lihat",
                style: TextStyle(fontSize: 12),
              )
          ),
        ],
      ),
    );
  }

  Widget bahanAjar() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Bahan Ajar",
            style: TextStyle(fontSize: 12),
          ),
          classroomDetailModel!.bahan_ajar == null
              ? const Text(
            "Tidak Ada",
            style: TextStyle(fontSize: 12),
          )
              : TextButton(
              onPressed: () =>  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfView(
                        url: classroomDetailModel!.bahan_ajar.toString(),
                      ))),
              child: const Text(
                "Lihat",
                style: TextStyle(fontSize: 12),
              ),
          ),
        ],
      ),
    );
  }

  Widget bahanTayang() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Bahan Tayang",
            style: TextStyle(fontSize: 12),
          ),
          classroomDetailModel!.bahan_tayang == null
              ? const Text(
            "Tidak Ada",
            style: TextStyle(fontSize: 12),
          )
              : TextButton(
            onPressed: () =>  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PdfView(
                      url: classroomDetailModel!.bahan_tayang.toString(),
                    ))),
            child: const Text(
              "Lihat",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget bahanVideo() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Bahan Video",
            style: TextStyle(fontSize: 12),
          ),
          classroomDetailModel!.url_video_bahan == null
              ? const Text(
            "Tidak Ada",
            style: TextStyle(fontSize: 12),
          )
              : TextButton(
            onPressed: () =>  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoView(
                      fileVideo: classroomDetailModel!.url_video_bahan.toString(),
                    ))),
            child: const Text(
              "Lihat",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailMateriLive1() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nama Guru",
                style: TextStyle(fontSize: 12),
              ),
              Flexible(
                child: Text(
                  "${classroomDetailModel!.nama_guru_smart}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nama Mata Pelajaran",
                style: TextStyle(fontSize: 12),
              ),
              Flexible(
                child: Text(
                  "${classroomDetailModel!.nama_pelajaran}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tingkat",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                "Kelas ${classroomDetailModel!.kode_tingkat}",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tahun Akademik",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                "${classroomDetailModel!.nama_tahun_akademik}",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget detailMateriLive2() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            "Judul Materi",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 16.0),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: kGrey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${classroomDetailModel!.judul}",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailMateriLive3() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            "Deskripsi",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 16.0),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: kGrey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${classroomDetailModel!.deskripsi}",
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ],
    );
  }
}
