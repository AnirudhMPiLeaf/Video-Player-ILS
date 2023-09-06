import 'package:flutter/material.dart';

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
