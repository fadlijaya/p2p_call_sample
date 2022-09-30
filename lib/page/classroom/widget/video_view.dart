import 'package:flutter/material.dart';
import 'package:p2p_call_sample/page/classroom/widget/video_player_both_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../../theme/colors.dart';

// ignore: must_be_immutable
class VideoView extends StatefulWidget {
  String? fileVideo;
  VideoView({Key? key, required this.fileVideo}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: VideoPlayerBothWidget(controller: _videoPlayerController),
      ),
    );
  }
}
