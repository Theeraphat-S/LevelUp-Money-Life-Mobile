import 'package:flutter/material.dart';

class QuickActionsBar extends StatelessWidget {
  final VoidCallback onAddExpense;
  final VoidCallback onAddIncome;
  final VoidCallback onOpenQuests;
  final VoidCallback onOpenHistory;

  const QuickActionsBar({
    super.key,
    required this.onAddExpense,
    required this.onAddIncome,
    required this.onOpenQuests,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          label: 'รายจ่าย',
          icon: Icons.remove_circle_outline_rounded,
          color: const Color(0xFFEF4444),
          bgColor: const Color(0xFFFEF2F2),
          onTap: onAddExpense,
        ),
        _buildActionButton(
          label: 'รายรับ',
          icon: Icons.add_circle_outline_rounded,
          color: const Color(0xFF10B981),
          bgColor: const Color(0xFFECFDF5),
          onTap: onAddIncome,
        ),
        _buildActionButton(
          label: 'เควส & EXP',
          icon: Icons.military_tech_rounded,
          color: const Color(0xFFF59E0B),
          bgColor: const Color(0xFFFFFBEB),
          onTap: onOpenQuests,
        ),
        _buildActionButton(
          label: 'ประวัติ',
          icon: Icons.receipt_long_rounded,
          color: const Color(0xFF6366F1),
          bgColor: const Color(0xFFEEF2FF),
          onTap: onOpenHistory,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
