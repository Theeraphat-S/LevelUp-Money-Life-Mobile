import 'package:flutter/material.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class XPProgressBar extends StatelessWidget {
  final int currentXp;
  final int xpForNextLevel;
  final double progressPercent;
  final double height;
  final bool showLabel;

  const XPProgressBar({
    super.key,
    required this.currentXp,
    required this.xpForNextLevel,
    required this.progressPercent,
    this.height = 8.0,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clampedRatio = (progressPercent / 100.0).clamp(0.0, 1.0);

    final gradientColors = isDark
        ? const [Color(0xFF8BB999), Color(0xFF76AA9D)]
        : const [Color(0xFF4D8E75), Color(0xFF1C5954)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESSION',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: PColor.inkFaint(context),
                ),
              ),
              Text(
                '$currentXp / $xpForNextLevel XP (${progressPercent.round()}%)',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: PColor.jadeInk(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: PColor.line(context),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * clampedRatio,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
