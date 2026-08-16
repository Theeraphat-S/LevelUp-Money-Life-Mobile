import 'package:flutter/material.dart';
import 'package:mobile_app_standard/domain/models/gamification/quest.dart';
import 'package:mobile_app_standard/shared/tokens/p_radius.dart';

class DailyQuestsSection extends StatelessWidget {
  final List<QuestItem> quests;
  final Function(String) onClaim;
  final VoidCallback onViewAll;

  const DailyQuestsSection({
    super.key,
    required this.quests,
    required this.onClaim,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  '🎯 ภารกิจวันนี้ (Daily Quests)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text(
                'ดูทั้งหมด',
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (quests.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(PRadius.medium),
            ),
            child: const Center(
              child: Text(
                'ไม่มีภารกิจค้างอยู่ในขณะนี้',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
          )
        else
          ...quests.take(2).map((quest) => _buildQuestTile(context, quest)),
      ],
    );
  }

  Widget _buildQuestTile(BuildContext context, QuestItem quest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PRadius.medium),
        border: Border.all(
          color: quest.isCompleted && !quest.isClaimed
              ? const Color(0xFFF59E0B)
              : Colors.transparent,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: quest.isClaimed
                  ? const Color(0xFFF1F5F9)
                  : (quest.isCompleted
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFEEF2FF)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              quest.isClaimed
                  ? Icons.check_circle_rounded
                  : (quest.isCompleted
                      ? Icons.card_giftcard_rounded
                      : Icons.star_rounded),
              color: quest.isClaimed
                  ? const Color(0xFF94A3B8)
                  : (quest.isCompleted
                      ? const Color(0xFFD97706)
                      : const Color(0xFF6366F1)),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quest.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: quest.isClaimed
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF1E293B),
                    decoration:
                        quest.isClaimed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '+${quest.expReward} EXP',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF0284C7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+${quest.coinReward} 🪙',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFD97706),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!quest.isClaimed && quest.isCompleted)
            ElevatedButton(
              onPressed: () => onClaim(quest.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'รับ EXP',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
          else if (quest.isClaimed)
            const Text(
              'รับแล้ว',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            Text(
              quest.done ? '1/1' : '0/1',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
