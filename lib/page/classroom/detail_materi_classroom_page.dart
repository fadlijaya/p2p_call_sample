import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../theme/colors.dart';

// ignore: must_be_immutable
class DetailMateriClassRoomPage extends StatefulWidget {
  DetailMateriClassRoomPage(
      {Key? key})
      : super(key: key);

  @override
  State<DetailMateriClassRoomPage> createState() => _DetailMateriClassRoomPageState();
}

class _DetailMateriClassRoomPageState extends State<DetailMateriClassRoomPage> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    VideoPlayerController.network("https://samplelib.com/lib/preview/mp4/sample-5s.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
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
        child: Column(
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
                        Icons.screen_share,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backPage(),
          Text(
            "Pertemuan Ke-1",
            style: const TextStyle(fontWeight: FontWeight.w600),
          )
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
        children: const [
          Text(
            "File Modul",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            "Tidak Ada",
            style: TextStyle(fontSize: 12),
          )
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
        children: const [
          Text(
            "Bahan Ajar",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            "Tidak Ada",
            style: TextStyle(fontSize: 12),
          )
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
        children: const [
          Text(
            "Bahan Tayang",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            "Tidak Ada",
            style: TextStyle(fontSize: 12),
          )
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
          const Text(
            "Tidak Ada",
            style: TextStyle(fontSize: 12),
          )
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
                  "Nama Guru",
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
                  "KIMIA KELAS XII",
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
                "Kelas XII",
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
                "Semester Ganjil 2022/2023",
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
                "Sifat Koligatif Larutan",
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
                "Menganalisis penurutnan tekanan uap larutan elektrolit dan larutanelektrolit danlarutan non elektrolit",
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ],
    );
  }
}
