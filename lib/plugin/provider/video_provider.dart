import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_ils/plugin/data/models.dart';

class VideoProvider extends ChangeNotifier {
  late VideoPlayerController controller;
  late List<VideoQualityModel> url;
  int overlayTimer = 3;
  Duration currentSeekPosition = Duration.zero;
  var selectedQuality = 0;
  bool isLooping = true;
  bool showLoader = false;
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

  VideoProvider(List<VideoQualityModel> link, Function(dynamic) errorCallback,
      [VideoPlayerController? cnt]) {
    url = link;
    if (cnt == null) {
      initController(errorCallback);
    } else {
      controller = cnt;
    }
  }

  void initController(Function(dynamic p1) errorCallback) {
    controller = VideoPlayerController.networkUrl(
        Uri.parse(url[selectedQuality].url),
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize()
      ..setVolume(1)
      ..addListener(() {
        try {
          if (controller.value.hasError) {
            errorCallback(controller.value.errorDescription);
            showLoader = false;
            notifyListeners();
          }
          showLoader = true;
          notifyListeners();
          if (controller.value.isInitialized) {
            showLoader = false;
            notifyListeners();
          }
          if (controller.value.isBuffering) {
            showLoader = true;
            notifyListeners();
          }
          if (controller.value.isPlaying) {
            showLoader = false;
            notifyListeners();
          }
        } catch (e) {
          debugPrint(e.toString());
        }

        notifyListeners();
      })
      // ..play()
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

  void setQuality(int? value, Function(dynamic p1) errorCallback) {
    selectedQuality = value!;
    initController(errorCallback);
    notifyListeners();
  }

  void toggleLoop() {
    if (controller.value.isLooping) {
      isLooping = false;
      controller.setLooping(isLooping);
    } else {
      isLooping = true;
      controller.setLooping(isLooping);
      controller.play();
    }
    overlayDisplay();
  }
}
