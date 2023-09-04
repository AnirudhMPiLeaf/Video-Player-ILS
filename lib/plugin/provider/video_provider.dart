import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_ils/plugin/data/models.dart';

class VideoProvider extends ChangeNotifier {
  late VideoPlayerController controller;
  late List<VideoQualityModel> url;
  int overlayTimer = 3;
  Duration currentSeekPosition = Duration.zero;
  var selectedQuality = 0;
  var qualityItems = [
    const DropdownMenuItem(
      value: 0,
      child: Text('low'),
    ),
    const DropdownMenuItem(
      value: 1,
      child: Text('medium'),
    ),
    const DropdownMenuItem(
      value: 2,
      child: Text('high'),
    )
  ];

  VideoProvider(List<VideoQualityModel> link, [VideoPlayerController? cnt]) {
    url = link;
    if (cnt == null) {
      initController();
    } else {
      controller = cnt;
    }
  }

  void initController() {
    controller = VideoPlayerController.networkUrl(
        Uri.parse(url[selectedQuality].url),
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize()
      ..addListener(() {
        notifyListeners();
      })
      ..play()
      ..setLooping(true);
  }

  void togglePlay() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    overlayDisplay();
  }

  void seekChanged(Duration seek) {
    currentSeekPosition = seek;
    controller.seekTo(seek);
    notifyListeners();
  }

  void overlayDisplay() {
    overlayTimer = 3;
    notifyListeners();
  }

  void seekLeft() {
    controller.seekTo(const Duration(seconds: -10));
    debugPrint('---left');
    overlayDisplay();
  }

  void seekRight() {
    controller.seekTo(const Duration(seconds: 10));
    debugPrint('---right');
    overlayDisplay();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void setQuality(int? value) {
    selectedQuality = value!;
    initController();
    notifyListeners();
  }
}
