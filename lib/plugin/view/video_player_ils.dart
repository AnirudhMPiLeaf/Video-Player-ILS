import 'dart:async';

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
  const VideoPlayerILS({
    super.key,
    required this.urls,
    this.controller,
    this.videoPlayerTheme,
    this.thumbWidget,
    this.errorWidget,
    required this.errorCallback,
  });
  final List<VideoQualityModel> urls;
  final VideoPlayerController? controller;
  final VideoPlayerTheme? videoPlayerTheme;
  final Function(dynamic) errorCallback;
  final Widget? thumbWidget;
  final Widget? errorWidget;
  @override
  State<VideoPlayerILS> createState() => _VideoPlayerILSState();
}

class _VideoPlayerILSState extends State<VideoPlayerILS> {
  bool shouldShowOverlay = false;
  bool isPortrait = true;
  late Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(Duration.zero, (timer) {});
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
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ChangeNotifierProvider(
        lazy: false,
        create: (context) => VideoProvider(
          widget.urls,
          widget.errorCallback,
          widget.controller,
        ),
        child: Consumer<VideoProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isPortrait ? 0 : 0),
              child: FittedBox(
                child: SizedBox(
                  height:
                      isPortrait ? null : MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                    aspectRatio: provider.controller.value.aspectRatio,
                    child: Stack(
                      // fit: isPortrait ? StackFit.loose : StackFit.expand,
                      children: [
                        VideoPlayer(
                          widget.controller ?? provider.controller,
                        ),
                        if (!provider.controller.value.isPlaying &&
                            (provider.controller.value.position ==
                                Duration.zero))
                          Positioned.fill(
                              child: widget.thumbWidget ?? const SizedBox()),
                        Positioned.fill(
                          child: InkWell(
                            onTap: () {
                              if (provider.controller.value.errorDescription
                                      ?.isEmpty ??
                                  true &&
                                      provider.controller.value.isInitialized) {
                                overlayShow();
                              }
                            },
                            onHover: (value) {
                              if (provider.controller.value.errorDescription
                                      ?.isEmpty ??
                                  true &&
                                      provider.controller.value.isInitialized) {
                                overlayShow();
                              }
                            },
                            child: shouldShowOverlay
                                ? Center(
                                    child: Row(
                                      children: [
                                        if (provider
                                            .controller.value.isInitialized)
                                          Expanded(
                                            flex: 2,
                                            child: ButtonComponent(
                                              singleTap: () =>
                                                  provider.seekLeft(),
                                              doubleTap: () =>
                                                  provider.seekLeft(),
                                              isFlipped: true,
                                              buttonWidget: widget
                                                  .videoPlayerTheme
                                                  ?.seekLeftWidget,
                                              color: widget.videoPlayerTheme
                                                      ?.seekLeftColor ??
                                                  Colors.red,
                                              icon: widget.videoPlayerTheme
                                                      ?.seekLeftIcon ??
                                                  Icons.refresh,
                                              size: widget.videoPlayerTheme
                                                      ?.seekLeftSize ??
                                                  40,
                                            ),
                                          ),
                                        Expanded(
                                          child: ButtonComponent(
                                            singleTap: () =>
                                                provider.togglePlay(),
                                            buttonWidget: widget
                                                .videoPlayerTheme?.playWidget,
                                            color: widget.videoPlayerTheme
                                                    ?.playColor ??
                                                Colors.red,
                                            icon: provider
                                                    .controller.value.isPlaying
                                                ? widget.videoPlayerTheme
                                                        ?.playIconInactive ??
                                                    Icons.pause
                                                : widget.videoPlayerTheme
                                                        ?.playIconActive ??
                                                    Icons.play_arrow,
                                            size: widget.videoPlayerTheme
                                                    ?.playSize ??
                                                50,
                                          ),
                                        ),
                                        if (provider
                                            .controller.value.isInitialized)
                                          Expanded(
                                            flex: 2,
                                            child: ButtonComponent(
                                              singleTap: () =>
                                                  provider.seekRight(),
                                              doubleTap: () =>
                                                  provider.seekRight(),
                                              buttonWidget: widget
                                                  .videoPlayerTheme
                                                  ?.seekRightWidget,
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
                                    ),
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
                              ? (provider.controller.value.errorDescription
                                          ?.isEmpty ??
                                      true)
                                  ? Row(
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              provider.toggleLoop(),
                                          child: widget.videoPlayerTheme
                                                  ?.loopWidget ??
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withAlpha(150),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                25))),
                                                child: Icon(
                                                  Icons.loop,
                                                  color: provider.isLooping
                                                      ? widget.videoPlayerTheme
                                                              ?.loopIconColorActive ??
                                                          Colors.red
                                                      : widget.videoPlayerTheme
                                                              ?.loopIconColorInactive ??
                                                          Colors.red
                                                              .withAlpha(150),
                                                ),
                                              ),
                                        ),
                                        DropdownButton2(
                                          isDense: true,
                                          underline: const SizedBox(),
                                          isExpanded: false,
                                          items: List.generate(
                                              widget.urls.length,
                                              (index) => DropdownMenuItem(
                                                    value: index,
                                                    child: Text(widget
                                                        .urls[index].name),
                                                  )).toList(),
                                          // provider.qualityItems,
                                          dropdownStyleData:
                                              const DropdownStyleData(
                                                  width: 100),
                                          customButton: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.black.withAlpha(150),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(25))),
                                            child: const Icon(
                                              Icons.more_horiz,
                                              color: Colors.red,
                                            ),
                                          ),
                                          onMenuStateChange: (isOpen) =>
                                              overlayShow(seconds: 15),
                                          onChanged: (value) {
                                            provider.setQuality(
                                                value, widget.errorCallback);
                                            overlayShow(seconds: 0);
                                            setState(() {
                                              provider.showLoader = true;
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: shouldShowOverlay
                              ? ColoredBox(
                                  color: Colors.black.withAlpha(150),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ProgressBar(
                                          progressBarColor: widget
                                                  .videoPlayerTheme
                                                  ?.seekProgressBarColor ??
                                              Colors.red,
                                          baseBarColor: widget.videoPlayerTheme
                                                  ?.seekBaseBarColor ??
                                              Colors.grey.withAlpha(150),
                                          thumbColor: widget.videoPlayerTheme
                                                  ?.seekThumbColor ??
                                              Colors.red,
                                          thumbGlowColor: widget
                                                  .videoPlayerTheme
                                                  ?.seekThumbGlowColor ??
                                              Colors.red.withAlpha(100),
                                          timeLabelType: widget.videoPlayerTheme
                                                  ?.seekTimeLabelType ??
                                              TimeLabelType.remainingTime,
                                          bufferedBarColor: widget
                                                  .videoPlayerTheme
                                                  ?.seekBufferedBarColor ??
                                              Colors.grey,
                                          timeLabelTextStyle: widget
                                                  .videoPlayerTheme
                                                  ?.seekTimeLabelTextStyle ??
                                              const TextStyle(
                                                  color: Colors.white),
                                          progress: Duration(
                                              milliseconds: provider
                                                  .controller
                                                  .value
                                                  .position
                                                  .inMilliseconds),
                                          buffered: Duration(
                                              milliseconds: provider.controller
                                                      .value.buffered.isEmpty
                                                  ? 0
                                                  : provider
                                                      .controller
                                                      .value
                                                      .buffered
                                                      .last
                                                      .end
                                                      .inMilliseconds),
                                          total: Duration(
                                              milliseconds: provider
                                                  .controller
                                                  .value
                                                  .duration
                                                  .inMilliseconds),
                                          onSeek: (duration) =>
                                              provider.seekChanged(duration),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      ButtonComponent(
                                        singleTap: () => toggleFullScreen(),
                                        icon: Icons.fullscreen,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                )
                              : const Center(child: SizedBox()),
                        ),
                        if (provider.controller.value.errorDescription
                                ?.isNotEmpty ??
                            false)
                          Positioned.fill(
                              child: widget.errorWidget ??
                                  Column(
                                    children: [
                                      const Spacer(),
                                      const Row(
                                        children: [
                                          Spacer(),
                                          Icon(
                                            Icons.warning,
                                            color: Colors.yellow,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Error Loading Video. Try again!',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      ButtonComponent(
                                        singleTap: () =>
                                            provider.initController(
                                                widget.errorCallback),
                                        isFlipped: true,
                                        color: Colors.red,
                                        icon: Icons.refresh,
                                        size: 40,
                                      ),
                                      const Spacer(),
                                    ],
                                  )),
                        if (provider.showLoader &&
                            (provider.controller.value.errorDescription
                                    ?.isEmpty ??
                                true))
                          const Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.red,
                            )),
                          )
                      ],
                    ),
                  ),
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

  Future<void> overlayShow({int seconds = 3}) async {
    try {
      if (mounted) {
        shouldShowOverlay = true;
        setState(() {});
        if (timer.isActive) {
          timer.cancel();
        }
        timer = Timer.periodic(Duration(seconds: seconds), (timer) {
          setState(() {
            shouldShowOverlay = false;
          });
        });
        // Future.delayed().then((value) {});
      }
    } catch (_) {}
  }
}
