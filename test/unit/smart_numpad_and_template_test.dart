import 'package:flutter_test/flutter_test.dart';
import 'package:levelup_money_life/domain/models/transaction/quick_template.dart';
import 'package:levelup_money_life/domain/services/gamification_engine.dart';
import 'package:levelup_money_life/shared/components/smart_numpad.dart';

void main() {
  group('SmartNumpad Arithmetic & Expression Parsing Tests', () {
    test('Plain integer strings parse accurately', () {
      expect(SmartNumpad.parseEvaluatedAmount('50'), 50.0);
      expect(SmartNumpad.parseEvaluatedAmount('1200'), 1200.0);
      expect(SmartNumpad.parseEvaluatedAmount('0'), 0.0);
      expect(SmartNumpad.parseEvaluatedAmount(''), 0.0);
    });

    test('Decimal strings parse correctly', () {
      expect(SmartNumpad.parseEvaluatedAmount('65.50'), 65.50);
      expect(SmartNumpad.parseEvaluatedAmount('0.25'), 0.25);
    });

    test('Addition expressions evaluate accurately', () {
      expect(SmartNumpad.parseEvaluatedAmount('50+20'), 70.0);
      expect(SmartNumpad.parseEvaluatedAmount('100+50+25'), 175.0);
    });

    test('Subtraction and combined expressions evaluate accurately', () {
      expect(SmartNumpad.parseEvaluatedAmount('100-35'), 65.0);
      expect(SmartNumpad.parseEvaluatedAmount('50+20-10'), 60.0);
    });
  });

  group('QuickTemplate Model Tests', () {
    test('Default templates contain expected items', () {
      final templates = QuickTemplate.defaultTemplates;
      expect(templates.length, greaterThanOrEqualTo(3));
      expect(templates.any((p) => p.name == 'กาแฟ'), true);
      expect(templates.any((p) => p.name == 'ข้าวกลางวัน'), true);
    });

    test('QuickTemplate serializes and deserializes to Map cleanly', () {
      const tpl = QuickTemplate(
        id: 'template_1',
        name: 'ชานมไข่มุก',
        category: 'Food',
        defaultAmount: 55.0,
        isIncome: false,
        isPinned: true,
      );

      final map = tpl.toMap();
      final fromMap = QuickTemplate.fromMap(map);

      expect(fromMap, equals(tpl));
      expect(fromMap.name, 'ชานมไข่มุก');
      expect(fromMap.defaultAmount, 55.0);
      expect(fromMap.isPinned, true);
    });
  });

  group('GamificationEngine Transaction XP Tests', () {
    test('Calculates XP accurately for Expense and Income with and without notes', () {
      expect(GamificationEngine.calculateTransactionXp(isIncome: false, hasNotes: false), 15);
      expect(GamificationEngine.calculateTransactionXp(isIncome: false, hasNotes: true), 20);
      expect(GamificationEngine.calculateTransactionXp(isIncome: true, hasNotes: false), 30);
      expect(GamificationEngine.calculateTransactionXp(isIncome: true, hasNotes: true), 35);
    });
  });
}

