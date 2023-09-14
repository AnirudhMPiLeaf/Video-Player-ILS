import 'package:flutter/material.dart';
import 'package:video_player_ils/plugin/data/models.dart';

class ButtonComponent extends StatelessWidget {
  const ButtonComponent({
    super.key,
    this.singleTap,
    this.doubleTap,
    this.isFlipped,
    this.buttonWidget,
    this.icon,
    this.color,
    this.size,
  });
  final VoidCallback? singleTap;
  final VoidCallback? doubleTap;
  final bool? isFlipped;
  final Widget? buttonWidget;
  final IconData? icon;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: singleTap ?? () {},
        onDoubleTap: doubleTap ?? () {},
        child: Transform.flip(
          flipX: isFlipped ?? false,
          child: buttonWidget ??
              Icon(
                icon,
                size: size,
                color: color,
              ),
        ),
      ),
    );
  }
}

class VideoControllerILS {
  late Function(List<VideoQualityModel>)? updateUrls;

  void dispose() {
    //Remove any data that's will cause a memory leak/render errors in here
    updateUrls = null;
  }
}
