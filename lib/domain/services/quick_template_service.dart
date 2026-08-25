import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app_standard/domain/models/transaction/quick_template.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';

class QuickTemplateService {
  static const String boxName = 'quick_templates_box';

  static Box<dynamic>? _box;

  static Future<void> init() async {
    await _getBox();
  }

  static Future<Box<dynamic>> _getBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox(boxName);
    } else {
      _box = Hive.box(boxName);
    }
    return _box!;
  }

  static Future<List<QuickTemplate>> getTemplates({
    List<TransactionItem>? recentTransactions,
  }) async {
    try {
      final box = await _getBox();

      final List<QuickTemplate> result = [];
      final Set<String> seenKeys = {};

      // 1. Load Pinned / Custom Templates from Hive
      final rawPinned = box.get('pinned_templates');
      if (rawPinned is List) {
        for (final item in rawPinned) {
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            final tpl = QuickTemplate.fromMap(map);
            result.add(tpl);
            seenKeys.add('${tpl.name.toLowerCase()}_${tpl.category.toLowerCase()}');
          }
        }
      }

      // If no custom templates, load default templates
      if (result.isEmpty) {
        for (final template in QuickTemplate.defaultTemplates) {
          result.add(template);
          seenKeys.add('${template.name.toLowerCase()}_${template.category.toLowerCase()}');
        }
      }

      // 2. Frequency Analysis from Recent Transactions
      if (recentTransactions != null && recentTransactions.isNotEmpty) {
        // Count frequency of name + category combinations
        final Map<String, int> freqMap = {};
        final Map<String, TransactionItem> sampleMap = {};

        for (final tx in recentTransactions) {
          if (tx.name.trim().isEmpty) continue;
          final key = '${tx.name.trim().toLowerCase()}_${tx.category.toLowerCase()}';
          freqMap[key] = (freqMap[key] ?? 0) + 1;
          sampleMap[key] = tx;
        }

        // Sort by frequency descending
        final sortedKeys = freqMap.keys.toList()
          ..sort((a, b) => (freqMap[b] ?? 0).compareTo(freqMap[a] ?? 0));

        for (final key in sortedKeys.take(5)) {
          if (!seenKeys.contains(key) && sampleMap.containsKey(key)) {
            final tx = sampleMap[key]!;
            result.add(QuickTemplate(
              id: 'freq_${tx.id}',
              name: tx.name,
              category: tx.category,
              defaultAmount: tx.absAmount,
              isIncome: tx.isIncome,
              isPinned: false,
            ));
            seenKeys.add(key);
          }
        }
      }

      return result;
    } catch (_) {
      // Graceful fallback for test environments where Hive is not mounted
      return List.of(QuickTemplate.defaultTemplates);
    }
  }

  static Future<void> pinTemplate(QuickTemplate template) async {
    final box = await _getBox();

    final existing = await getTemplates();
    final updated = existing.where((t) => t.id != template.id).toList();
    updated.insert(0, template);

    final rawList = updated.map((t) => t.toMap()).toList();
    await box.put('pinned_templates', rawList);
  }

  static Future<void> removeTemplate(String id) async {
    final box = await _getBox();

    final existing = await getTemplates();
    final updated = existing.where((t) => t.id != id).toList();
    final rawList = updated.map((t) => t.toMap()).toList();
    await box.put('pinned_templates', rawList);
  }
}

