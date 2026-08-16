import 'package:flutter/material.dart';
import 'package:mobile_app_standard/shared/tokens/p_radius.dart';

class ExpRewardDialog extends StatelessWidget {
  final int expAwarded;
  final bool isLevelUp;
  final int newLevel;
  final String title;

  const ExpRewardDialog({
    super.key,
    required this.expAwarded,
    this.isLevelUp = false,
    this.newLevel = 1,
    this.title = 'บันทึกสำเร็จ!',
  });

  static Future<void> show(
    BuildContext context, {
    required int expAwarded,
    bool isLevelUp = false,
    int newLevel = 1,
    String title = 'บันทึกสำเร็จ!',
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ExpRewardDialog(
        expAwarded: expAwarded,
        isLevelUp: isLevelUp,
        newLevel: newLevel,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = Localizations.localeOf(context).languageCode;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PRadius.large),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLevelUp
                    ? const Color(0xFFFEF3C7)
                    : const Color(0xFFE0F2FE),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLevelUp
                    ? Icons.military_tech_rounded
                    : Icons.bolt_rounded,
                color: isLevelUp
                    ? const Color(0xFFD97706)
                    : const Color(0xFF0284C7),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isLevelUp
                  ? (currentLang == 'th' ? '🎉 LEVEL UP! เลเวล $newLevel' : '🎉 LEVEL UP! Level $newLevel')
                  : (title == 'บันทึกสำเร็จ!' && currentLang == 'en' ? 'Saved Successfully!' : title),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isLevelUp
                    ? const Color(0xFFD97706)
                    : const Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isLevelUp
                  ? (currentLang == 'th'
                      ? 'คุณพัฒนาทักษะการเงินขึ้นอีกขั้น ปลดล็อกความสามารถใหม่!'
                      : 'Your financial mastery leveled up! New power unlocked.')
                  : (currentLang == 'th'
                      ? 'วินัยทางการเงินของคุณเพิ่มขึ้นอีกขั้น!'
                      : 'Your financial discipline is growing stronger!'),
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(PRadius.medium),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⚡ ', style: TextStyle(fontSize: 16)),
                  Text(
                    '+$expAwarded EXP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PRadius.medium),
                  ),
                ),
                child: Text(
                  currentLang == 'th' ? 'ยอดเยี่ยม! ลุยต่อ' : 'Awesome! Continue',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
