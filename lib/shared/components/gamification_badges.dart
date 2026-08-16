import 'package:flutter/material.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class LevelRankBadge extends StatelessWidget {
  final int level;
  final String rankTitle;
  final VoidCallback? onTap;

  const LevelRankBadge({
    super.key,
    required this.level,
    required this.rankTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final jadeColor = PColor.jade(context);
    final jadeSoft = PColor.jadeSoft(context);
    final jadeInk = PColor.jadeInk(context);

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: jadeSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: jadeColor.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.military_tech_rounded,
            color: jadeColor,
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            'Lv.$level · $rankTitle',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: jadeInk,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: badge,
      );
    }
    return badge;
  }
}

class StreakBadge extends StatelessWidget {
  final int streakDays;
  final VoidCallback? onTap;

  const StreakBadge({
    super.key,
    required this.streakDays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final amberColor = PColor.amber(context);
    final amberSoft = PColor.amberSoft(context);
    final amberInk = PColor.amberInk(context);

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: amberSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: amberColor.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: amberColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '$streakDays-Day Streak',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: amberInk,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: badge,
      );
    }
    return badge;
  }
}
