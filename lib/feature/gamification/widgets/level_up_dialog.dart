import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:levelup_money_life/i18n/i18n.dart';
import 'package:levelup_money_life/shared/tokens/p_colors.dart';

class LevelUpDialog extends StatefulWidget {
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
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = PColor.surface(context);
    final borderColor = PColor.line(context);
    final i18n = AppLocalizations(context).gamification;
    final currentLang = Localizations.localeOf(context).languageCode;

    return Stack(
      alignment: Alignment.center,
      children: [
        Dialog(
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
                // Badge / Icon with glow & bounce
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: PColor.jadeSoft(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: PColor.jade(context).withValues(alpha: 0.5),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: PColor.jadeLight.withValues(alpha: 0.35),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.military_tech_rounded,
                          color: PColor.jade(context),
                          size: 52,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),

                Text(
                  'LEVEL UP!',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                    color: PColor.jadeInk(context),
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  currentLang == 'th'
                      ? 'ขอแสดงความยินดี! คุณก้าวสู่เลเวล ${widget.level}'
                      : 'Congratulations! You reached Level ${widget.level}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: PColor.ink(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: PColor.primarySoft(context),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: PColor.primary(context).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${i18n.hero_profile}: ${widget.rankTitle}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: PColor.primaryInk(context),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PColor.primary(context),
                      foregroundColor: isDark ? PColor.darkBase : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      currentLang == 'th' ? 'รับพลังและก้าวต่อไป 🚀' : 'Claim & Continue 🚀',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Color(0xFFFFD700), // Gold
              Color(0xFFF59E0B), // Amber
              Color(0xFF10B981), // Emerald
              Color(0xFF059669), // Jade
              Color(0xFF34D399), // Mint Jade
              Color(0xFFFBBF24), // Warm Gold
            ],
            numberOfParticles: 35,
            gravity: 0.25,
            emissionFrequency: 0.05,
          ),
        ),
      ],
    );
  }
}
