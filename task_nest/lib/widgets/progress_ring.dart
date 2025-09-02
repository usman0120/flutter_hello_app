import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final double radius;
  final String? centerText;
  final Color progressColor;
  final Color backgroundColor;
  final double lineWidth;
  final bool animate;

  const ProgressRing({
    super.key,
    required this.progress,
    this.radius = 40.0,
    this.centerText,
    this.progressColor = Colors.green,
    this.backgroundColor = Colors.grey,
    this.lineWidth = 8.0,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      percent: progress.clamp(0.0, 1.0),
      center: centerText != null
          ? Text(
              centerText!,
              style: TextStyle(
                fontSize: radius * 0.3,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            )
          : null,
      progressColor: progressColor,
      // ignore: deprecated_member_use
      backgroundColor: backgroundColor.withOpacity(0.3),
      animation: animate,
      animateFromLastPercent: true,
      circularStrokeCap: CircularStrokeCap.round,
      curve: Curves.easeInOut,
      animationDuration: 1000,
    );
  }
}
