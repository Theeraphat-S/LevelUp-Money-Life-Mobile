import 'package:flutter/material.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class LevelUpDialog extends StatelessWidget {
  final int level;
  final String rankTitle;

  const LevelUpDialog({
    super.key,
    required this.level,
    required this.rankTitle,
  });

  static Future<void> show(
    BuildContext context, {
    required int level,
    required String rankTitle,
  }) {
    return showDialog(
      context: context,
      builder: (context) => LevelUpDialog(
        level: level,
        rankTitle: rankTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = PColor.surface(context);
    final borderColor = PColor.line(context);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge / Icon with glow
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PColor.jadeSoft(context),
                shape: BoxShape.circle,
                border: Border.all(
                  color: PColor.jade(context).withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.military_tech_rounded,
                color: PColor.jade(context),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'LEVEL UP!',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: PColor.jadeInk(context),
              ),
            ),
            const SizedBox(height: 6),

            Text(
              'ขอแสดงความยินดี! คุณก้าวสู่เลเวล $level',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PColor.ink(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: PColor.primarySoft(context),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: PColor.primary(context).withOpacity(0.3)),
              ),
              child: Text(
                'ฉายาใหม่: $rankTitle',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: PColor.primaryInk(context),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PColor.primary(context),
                  foregroundColor: isDark ? PColor.darkBase : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'รับพลังและก้าวต่อไป',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
