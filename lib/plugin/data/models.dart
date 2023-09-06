import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

class VideoQualityModel {
  final String name;
  final String url;

  VideoQualityModel({required this.name, required this.url});
}

/// left seek icon is always set to be flipped by default
///
class VideoPlayerTheme {
  final Color? seekLeftColor;
  final Color? seekRightColor;
  final IconData? seekLeftIcon;
  final IconData? seekRightIcon;
  final Widget? seekLeftWidget;
  final Widget? seekRightWidget;
  final double? seekLeftSize;
  final double? seekRightSize;
  final Color? playColor;
  final IconData? playIconActive;
  final IconData? playIconInactive;
  final Widget? playWidget;
  final double? playSize;
  final Color? seekProgressBarColor;
  final Color? seekBaseBarColor;
  final Color? seekThumbColor;
  final Color? seekThumbGlowColor;
  final TimeLabelType? seekTimeLabelType;
  final Color? seekBufferedBarColor;
  final TextStyle? seekTimeLabelTextStyle;
  final Widget? loopWidget;
  final Color? loopIconColorActive;
  final Color? loopIconColorInactive;

  VideoPlayerTheme({
    this.seekLeftColor,
    this.seekRightColor,
    this.seekLeftIcon,
    this.seekRightIcon,
    this.seekLeftWidget,
    this.seekRightWidget,
    this.seekLeftSize,
    this.seekRightSize,
    this.playColor,
    this.playIconActive,
    this.playIconInactive,
    this.playWidget,
    this.playSize,
    this.seekProgressBarColor,
    this.seekBaseBarColor,
    this.seekThumbColor,
    this.seekThumbGlowColor,
    this.seekTimeLabelType,
    this.seekBufferedBarColor,
    this.seekTimeLabelTextStyle,
    this.loopWidget,
    this.loopIconColorActive,
    this.loopIconColorInactive,
  });
}
