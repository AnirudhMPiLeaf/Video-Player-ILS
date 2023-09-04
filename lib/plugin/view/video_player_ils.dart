import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_ils/plugin/data/models.dart';
import 'package:video_player_ils/plugin/provider/video_provider.dart';

class VideoPlayerILS extends StatefulWidget {
  const VideoPlayerILS({super.key, required this.urls, this.controller});
  final List<VideoQualityModel> urls;
  final VideoPlayerController? controller;
  @override
  State<VideoPlayerILS> createState() => _VideoPlayerILSState();
}

class _VideoPlayerILSState extends State<VideoPlayerILS> {
  bool shouldShowOverlay = false;

  @override
  void initState() {
    overlayShow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider(
        lazy: false,
        create: (context) => VideoProvider(widget.urls, widget.controller),
        child: Consumer<VideoProvider>(
          builder: (context, provider, child) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
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
                                  child: InkWell(
                                    // onTap: () => provider.togglePlay(),
                                    onDoubleTap: () => provider.seekLeft(),
                                    child: Transform.flip(
                                      flipX: true,
                                      child: const Icon(
                                        Icons.refresh,
                                        size: 40,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => provider.togglePlay(),
                                  child: Icon(
                                    provider.controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 50,
                                    color: Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    // onTap: () => provider.togglePlay(),
                                    onDoubleTap: () => provider.seekRight(),
                                    child: const Icon(
                                      Icons.refresh,
                                      size: 40,
                                      color: Colors.red,
                                    ),
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
                        ? DropdownButton2(
                            isDense: true,
                            underline: null,
                            isExpanded: false,
                            items: List.generate(
                                widget.urls.length,
                                (index) => DropdownMenuItem(
                                      value: index,
                                      child: Text(widget.urls[index].name),
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
                            onChanged: (value) => provider.setQuality(value),
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
                            child: ProgressBar(
                              progressBarColor: Colors.red,
                              baseBarColor: Colors.grey.withAlpha(150),
                              thumbColor: Colors.red,
                              thumbGlowColor: Colors.red.withAlpha(100),
                              timeLabelType: TimeLabelType.remainingTime,
                              bufferedBarColor: Colors.grey,
                              timeLabelTextStyle:
                                  const TextStyle(color: Colors.white),
                              progress: Duration(
                                  milliseconds: provider.controller.value
                                      .position.inMilliseconds),
                              buffered: Duration(
                                  milliseconds:
                                      provider.controller.value.buffered.isEmpty
                                          ? 0
                                          : provider.controller.value.buffered
                                              .last.end.inMilliseconds),
                              total: Duration(
                                  milliseconds: provider.controller.value
                                      .duration.inMilliseconds),
                              onSeek: (duration) =>
                                  provider.seekChanged(duration),
                            ),
                          )
                        : const Center(child: SizedBox()),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> overlayShow() async {
    if (mounted) {
      setState(() {
        shouldShowOverlay = true;
      });
      await Future.delayed(const Duration(seconds: 3)).then((value) {
        setState(() {
          shouldShowOverlay = false;
        });
      });
    }
  }
}
