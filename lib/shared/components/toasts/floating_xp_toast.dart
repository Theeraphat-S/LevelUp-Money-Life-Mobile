import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:levelup_money_life/shared/tokens/p_colors.dart';
import 'package:toastification/toastification.dart';

void showFloatingXpToast({
  required BuildContext context,
  required int xpGained,
  String? message,
  IconData icon = Icons.bolt_rounded,
}) {
  HapticFeedback.mediumImpact();

  final isDark = Theme.of(context).brightness == Brightness.dark;
  final surface = isDark ? const Color(0xFF1E293B) : Colors.white;
  final inkColor = isDark ? Colors.white : const Color(0xFF0F172A);

  toastification.showCustom(
    context: context,
    alignment: Alignment.topCenter,
    autoCloseDuration: const Duration(milliseconds: 2400),
    animationDuration: const Duration(milliseconds: 350),
    builder: (context, holder) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        tween: Tween(begin: 0.8, end: 1.0),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: PColor.jadeLight.withValues(alpha: 0.7),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: PColor.jadeLight.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: PColor.jadeSoft(context),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: PColor.jadeInk(context),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      message ?? 'บันทึกสำเร็จ!',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: inkColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: PColor.jadeLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: PColor.jadeLight.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '+$xpGained XP',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: PColor.jadeInk(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

