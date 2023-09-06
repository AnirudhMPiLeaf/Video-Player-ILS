import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_ils/plugin/data/models.dart';
import 'package:video_player_ils/plugin/provider/video_provider.dart';

import 'components.dart';

class VideoPlayerILS extends StatefulWidget {
  const VideoPlayerILS(
      {super.key, required this.urls, this.controller, this.videoPlayerTheme});
  final List<VideoQualityModel> urls;
  final VideoPlayerController? controller;
  final VideoPlayerTheme? videoPlayerTheme;
  @override
  State<VideoPlayerILS> createState() => _VideoPlayerILSState();
}

class _VideoPlayerILSState extends State<VideoPlayerILS> {
  bool shouldShowOverlay = false;
  bool isPortrait = true;

  @override
  void initState() {
    overlayShow();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // toggleFullScreen();
    return Material(
      color: Colors.transparent,
      child: ChangeNotifierProvider(
        lazy: false,
        create: (context) => VideoProvider(widget.urls, widget.controller),
        child: Consumer<VideoProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isPortrait ? 0 : 15),
              child: AspectRatio(
                aspectRatio: isPortrait
                    ? (16 / 9)
                    : MediaQuery.of(context).size.aspectRatio,
                child: Stack(
                  fit: isPortrait ? StackFit.loose : StackFit.expand,
                  children: [
                    VideoPlayer(
                      widget.controller ?? provider.controller,
                    ),
                    Positioned.fill(
                      child: InkWell(
                        onTap: () => overlayShow(),
                        onHover: (value) => overlayShow(),
                        child: shouldShowOverlay
                            ? Row(
                                children: [
                                  Expanded(
                                    child: ButtonComponent(
                                      singleTap: () => provider.seekLeft(),
                                      doubleTap: () => provider.seekLeft(),
                                      isFlipped: true,
                                      buttonWidget: widget
                                          .videoPlayerTheme?.seekLeftWidget,
                                      color: widget.videoPlayerTheme
                                              ?.seekLeftColor ??
                                          Colors.red,
                                      icon: widget
                                              .videoPlayerTheme?.seekLeftIcon ??
                                          Icons.refresh,
                                      size: widget
                                              .videoPlayerTheme?.seekLeftSize ??
                                          40,
                                    ),
                                  ),
                                  ButtonComponent(
                                    singleTap: () => provider.togglePlay(),
                                    buttonWidget:
                                        widget.videoPlayerTheme?.playWidget,
                                    color: widget.videoPlayerTheme?.playColor ??
                                        Colors.red,
                                    icon: provider.controller.value.isPlaying
                                        ? widget.videoPlayerTheme
                                                ?.playIconInactive ??
                                            Icons.pause
                                        : widget.videoPlayerTheme
                                                ?.playIconActive ??
                                            Icons.play_arrow,
                                    size:
                                        widget.videoPlayerTheme?.playSize ?? 50,
                                  ),
                                  Expanded(
                                    child: ButtonComponent(
                                      singleTap: () => provider.seekRight(),
                                      doubleTap: () => provider.seekRight(),
                                      buttonWidget: widget
                                          .videoPlayerTheme?.seekRightWidget,
                                      color: widget.videoPlayerTheme
                                              ?.seekRightColor ??
                                          Colors.red,
                                      icon: widget.videoPlayerTheme
                                              ?.seekRightIcon ??
                                          Icons.refresh,
                                      size: widget.videoPlayerTheme
                                              ?.seekRightSize ??
                                          40,
                                    ),
                                  )
                                ],
                              )
                            : const Center(
                                child: SizedBox(
                                    height: double.infinity,
                                    width: double.infinity)),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: shouldShowOverlay
                          ? Row(
                              children: [
                                TextButton(
                                  onPressed: () => provider.toggleLoop(),
                                  child: widget.videoPlayerTheme?.loopWidget ??
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Colors.black.withAlpha(150),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(25))),
                                        child: Icon(
                                          Icons.loop,
                                          color: provider.isLooping
                                              ? widget.videoPlayerTheme
                                                      ?.loopIconColorActive ??
                                                  Colors.red
                                              : widget.videoPlayerTheme
                                                      ?.loopIconColorInactive ??
                                                  Colors.red.withAlpha(150),
                                        ),
                                      ),
                                ),
                                DropdownButton2(
                                  isDense: true,
                                  underline: null,
                                  isExpanded: false,
                                  items: List.generate(
                                      widget.urls.length,
                                      (index) => DropdownMenuItem(
                                            value: index,
                                            child:
                                                Text(widget.urls[index].name),
                                          )).toList(),
                                  // provider.qualityItems,
                                  dropdownStyleData:
                                      const DropdownStyleData(width: 100),
                                  customButton: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(150),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(25))),
                                    child: const Icon(
                                      Icons.more_horiz,
                                      color: Colors.red,
                                    ),
                                  ),
                                  onChanged: (value) =>
                                      provider.setQuality(value),
                                ),
                              ],
                            )
                          : const Center(child: SizedBox()),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: shouldShowOverlay
                          ? ColoredBox(
                              color: Colors.black.withAlpha(150),
                              child: Column(
                                children: [
                                  ProgressBar(
                                    progressBarColor: widget.videoPlayerTheme
                                            ?.seekProgressBarColor ??
                                        Colors.red,
                                    baseBarColor: widget.videoPlayerTheme
                                            ?.seekBaseBarColor ??
                                        Colors.grey.withAlpha(150),
                                    thumbColor: widget
                                            .videoPlayerTheme?.seekThumbColor ??
                                        Colors.red,
                                    thumbGlowColor: widget.videoPlayerTheme
                                            ?.seekThumbGlowColor ??
                                        Colors.red.withAlpha(100),
                                    timeLabelType: widget.videoPlayerTheme
                                            ?.seekTimeLabelType ??
                                        TimeLabelType.remainingTime,
                                    bufferedBarColor: widget.videoPlayerTheme
                                            ?.seekBufferedBarColor ??
                                        Colors.grey,
                                    timeLabelTextStyle: widget.videoPlayerTheme
                                            ?.seekTimeLabelTextStyle ??
                                        const TextStyle(color: Colors.white),
                                    progress: Duration(
                                        milliseconds: provider.controller.value
                                            .position.inMilliseconds),
                                    buffered: Duration(
                                        milliseconds: provider.controller.value
                                                .buffered.isEmpty
                                            ? 0
                                            : provider.controller.value.buffered
                                                .last.end.inMilliseconds),
                                    total: Duration(
                                        milliseconds: provider.controller.value
                                            .duration.inMilliseconds),
                                    onSeek: (duration) =>
                                        provider.seekChanged(duration),
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      ButtonComponent(
                                        singleTap: () => toggleFullScreen(),
                                        icon: Icons.fullscreen,
                                        color: Colors.red,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          : const Center(child: SizedBox()),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void toggleFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (isPortrait) {
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      );
      setState(() {
        isPortrait = false;
      });
    } else {
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      );
      setState(() {
        isPortrait = true;
      });
    }
  }

  Future<void> overlayShow() async {
    try {
      if (mounted) {
        shouldShowOverlay = true;
        setState(() {});
        await Future.delayed(const Duration(seconds: 3)).then((value) {
          setState(() {
            shouldShowOverlay = false;
          });
        });
      }
    } catch (_) {}
  }
}
