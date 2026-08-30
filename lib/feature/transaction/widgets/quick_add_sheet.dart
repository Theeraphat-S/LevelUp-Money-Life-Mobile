import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:levelup_money_life/domain/models/transaction/category_item.dart';
import 'package:levelup_money_life/domain/models/transaction/quick_template.dart';
import 'package:levelup_money_life/domain/models/transaction/transaction_item.dart';
import 'package:levelup_money_life/domain/services/gamification_engine.dart';
import 'package:levelup_money_life/domain/services/quick_template_service.dart';
import 'package:levelup_money_life/feature/transaction/bloc/transaction_bloc.dart';
import 'package:levelup_money_life/feature/transaction/bloc/transaction_event.dart';
import 'package:levelup_money_life/shared/components/smart_numpad.dart';
import 'package:levelup_money_life/shared/components/toasts/floating_xp_toast.dart';
import 'package:levelup_money_life/shared/tokens/p_colors.dart';

class QuickAddSheet extends StatefulWidget {
  final TransactionItem? initialTransaction;
  final TransactionType initialType;

  const QuickAddSheet({
    super.key,
    this.initialTransaction,
    this.initialType = TransactionType.expense,
  });

  static Future<void> show(
    BuildContext context, {
    TransactionItem? initialTransaction,
    TransactionType initialType = TransactionType.expense,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickAddSheet(
        initialTransaction: initialTransaction,
        initialType: initialType,
      ),
    );
  }

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  late bool _isIncome;
  late String _amountInput;
  late String _name;
  late String _notes;
  late String _selectedCategory;
  late String _selectedDate;
  late bool _isCleared;
  bool _isEditingName = false;
  bool _showNoteInput = false;
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  List<QuickTemplate> _templates = [];

  @override
  void initState() {
    super.initState();
    final tx = widget.initialTransaction;
    if (tx != null) {
      _isIncome = tx.isIncome;
      _amountInput = tx.absAmount == tx.absAmount.roundToDouble()
          ? tx.absAmount.toInt().toString()
          : tx.absAmount.toStringAsFixed(2);
      _name = tx.name;
      _notes = tx.notes ?? '';
      _selectedCategory = tx.category;
      _selectedDate = tx.date;
      _isCleared = tx.cleared;
      _showNoteInput = _notes.isNotEmpty;
    } else {
      _isIncome = widget.initialType == TransactionType.income;
      _amountInput = '';
      _name = '';
      _notes = '';
      _selectedCategory = _isIncome ? 'Income' : 'Food';
      _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _isCleared = true;
      _showNoteInput = false;
    }

    _nameController = TextEditingController(text: _name);
    _notesController = TextEditingController(text: _notes);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadTemplates();
      }
    });
  }

  Future<void> _loadTemplates() async {
    try {
      final recent = context.read<TransactionBloc>().state.allTransactions;
      final tpls = await QuickTemplateService.getTemplates(recentTransactions: recent);
      if (mounted) {
        setState(() {
          _templates = tpls.where((t) => t.isIncome == _isIncome).toList();
        });
      }
    } catch (_) {
      final tpls = await QuickTemplateService.getTemplates();
      if (mounted) {
        setState(() {
          _templates = tpls.where((t) => t.isIncome == _isIncome).toList();
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _calculatedXpReward {
    return GamificationEngine.calculateTransactionXp(
      isIncome: _isIncome,
      hasNotes: _notes.trim().isNotEmpty,
    );
  }

  void _applyTemplate(QuickTemplate template) {
    HapticFeedback.lightImpact();
    setState(() {
      _name = template.name;
      _nameController.text = template.name;
      _selectedCategory = template.category;
      _amountInput = template.defaultAmount == template.defaultAmount.roundToDouble()
          ? template.defaultAmount.toInt().toString()
          : template.defaultAmount.toStringAsFixed(2);
    });
  }

  Future<void> _pinCurrentAsTemplate() async {
    final currentLang = Localizations.localeOf(context).languageCode;
    final isThai = currentLang == 'th';
    final name = _name.trim().isNotEmpty
        ? _name.trim()
        : CategoryItem.getLocalizedCategoryName(_selectedCategory, currentLang);
    final amountVal = SmartNumpad.parseEvaluatedAmount(_amountInput);

    final newTpl = QuickTemplate(
      id: 'template_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      category: _selectedCategory,
      defaultAmount: amountVal > 0 ? amountVal : (_isIncome ? 100.0 : 50.0),
      isIncome: _isIncome,
      isPinned: true,
    );

    await QuickTemplateService.pinTemplate(newTpl);
    HapticFeedback.mediumImpact();
    await _loadTemplates();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isThai
                ? 'ปักหมุด "$name" เป็นแม่แบบด่วนแล้ว ⭐'
                : 'Pinned "$name" as QuickTemplate ⭐',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _saveTransaction() {
    final amountVal = SmartNumpad.parseEvaluatedAmount(_amountInput);
    if (amountVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาระบุจำนวนเงิน'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final currentLang = Localizations.localeOf(context).languageCode;
    final categoryDisplayName = CategoryItem.getLocalizedCategoryName(
      _selectedCategory,
      currentLang,
    );

    final finalName = _name.trim().isNotEmpty
        ? _name.trim()
        : categoryDisplayName;

    final id = widget.initialTransaction?.id ??
        'tx_${DateTime.now().millisecondsSinceEpoch}';

    final finalAmount = _isIncome ? amountVal : -amountVal;

    final tx = TransactionItem(
      id: id,
      name: finalName,
      amount: finalAmount,
      date: _selectedDate,
      category: _selectedCategory,
      cleared: _isCleared,
      notes: _notes.trim().isNotEmpty ? _notes.trim() : null,
      expGained: _calculatedXpReward,
    );

    if (widget.initialTransaction != null) {
      context.read<TransactionBloc>().add(UpdateTransactionItemEvent(tx));
    } else {
      context.read<TransactionBloc>().add(AddTransactionItemEvent(tx));
    }

    Navigator.of(context).pop();

    showFloatingXpToast(
      context: context,
      xpGained: _calculatedXpReward,
      message: _isIncome ? 'บันทึกรายรับสำเร็จ' : 'บันทึกรายจ่ายสำเร็จ',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = PColor.surface(context);
    final borderColor = PColor.line(context);
    final currentLang = Localizations.localeOf(context).languageCode;
    final isThai = currentLang == 'th';

    final categories = CategoryItem.defaultCategories
        .where((c) => _isIncome ? c.isIncome : !c.isIncome)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: borderColor),
      ),
      padding: EdgeInsets.only(
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: PColor.inkFaint(context).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Header Row: Type Toggle (Expense / Income) & Date Pill & Close
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                // Type Segmented Control
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: PColor.surfaceSubtle(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTypeButton(
                        label: isThai ? 'รายจ่าย' : 'Expense',
                        isSelected: !_isIncome,
                        activeColor: PColor.rose(context),
                        onTap: () {
                          setState(() {
                            _isIncome = false;
                            _selectedCategory = 'Food';
                            _loadTemplates();
                          });
                        },
                      ),
                      _buildTypeButton(
                        label: isThai ? 'รายรับ' : 'Income',
                        isSelected: _isIncome,
                        activeColor: PColor.jade(context),
                        onTap: () {
                          setState(() {
                            _isIncome = true;
                            _selectedCategory = 'Income';
                            _loadTemplates();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Date Picker Pill
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.tryParse(_selectedDate) ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    decoration: BoxDecoration(
                      color: PColor.surfaceSubtle(context),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 10, color: PColor.inkSoft(context)),
                        const SizedBox(width: 2),
                        Text(
                          _selectedDate,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: PColor.ink(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 2),

                // Close Button
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(Icons.close_rounded, size: 16, color: PColor.inkSoft(context)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // QuickTemplate Chips Ribbon
          if (_templates.isNotEmpty)
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _templates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, idx) {
                  final tpl = _templates[idx];
                  return ActionChip(
                    avatar: Icon(
                      tpl.isPinned ? Icons.star_rounded : Icons.flash_on_rounded,
                      size: 13,
                      color: PColor.amberInk(context),
                    ),
                    label: Text(
                      '${tpl.name} ฿${tpl.defaultAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: PColor.ink(context),
                      ),
                    ),
                    backgroundColor: PColor.surfaceSubtle(context),
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    onPressed: () => _applyTemplate(tpl),
                  );
                },
              ),
            ),
          const SizedBox(height: 10),

          // Amount & Title Display Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: PColor.surfaceSubtle(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                // Top: Item Name / Note & Action buttons & XP Reward Badge
                Row(
                  children: [
                    Expanded(
                      child: _isEditingName
                          ? TextField(
                              controller: _nameController,
                              autofocus: true,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: PColor.ink(context),
                              ),
                              decoration: InputDecoration(
                                hintText: isThai ? 'ชื่อรายการ (เช่น กาแฟ)' : 'Transaction name',
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              onSubmitted: (val) {
                                setState(() {
                                  _name = val;
                                  _isEditingName = false;
                                });
                              },
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  _isEditingName = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      _name.isNotEmpty
                                          ? _name
                                          : CategoryItem.getLocalizedCategoryName(_selectedCategory, currentLang),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: PColor.ink(context),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.edit_outlined, size: 13, color: PColor.inkSoft(context)),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(width: 6),

                    // Pin as QuickTemplate Action Button
                    Tooltip(
                      message: isThai ? 'ปักหมุดเป็นแม่แบบด่วน' : 'Pin as QuickTemplate',
                      child: InkWell(
                        onTap: _pinCurrentAsTemplate,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.star_border_rounded,
                            size: 17,
                            color: PColor.amberInk(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Note Input Toggle Button
                    Tooltip(
                      message: isThai ? 'เพิ่มบันทึกช่วยจำ' : 'Add Note',
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showNoteInput = !_showNoteInput;
                          });
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            _notes.isNotEmpty ? Icons.sticky_note_2_rounded : Icons.note_add_outlined,
                            size: 16,
                            color: _notes.isNotEmpty ? PColor.primary(context) : PColor.inkSoft(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // XP Reward Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: PColor.jadeSoft(context),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '+$_calculatedXpReward XP',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: PColor.jadeInk(context),
                        ),
                      ),
                    ),
                  ],
                ),

                // Expandable Note Input Row
                if (_showNoteInput || _notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.edit_note_rounded, size: 16, color: PColor.primary(context)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: _notesController,
                            style: TextStyle(fontSize: 12, color: PColor.ink(context)),
                            decoration: InputDecoration(
                              hintText: isThai ? 'บันทึกช่วยจำ (+5 XP)' : 'Add note (+5 XP)',
                              hintStyle: TextStyle(fontSize: 11, color: PColor.inkFaint(context)),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _notes = val;
                              });
                            },
                          ),
                        ),
                        if (_notes.isNotEmpty)
                          InkWell(
                            onTap: () {
                              _notesController.clear();
                              setState(() {
                                _notes = '';
                              });
                            },
                            child: Icon(Icons.clear_rounded, size: 14, color: PColor.inkSoft(context)),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 6),

                // Large Amount Typography Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '฿',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _isIncome ? PColor.jadeInk(context) : PColor.roseInk(context),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _amountInput.isEmpty ? '0.00' : _amountInput,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: _amountInput.isEmpty
                              ? PColor.inkFaint(context)
                              : (_isIncome ? PColor.jadeInk(context) : PColor.roseInk(context)),
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Category Ribbon Selector
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, idx) {
                final cat = categories[idx];
                final isSelected = cat.name == _selectedCategory;
                final catName = cat.getLocalizedName(context);

                return ChoiceChip(
                  label: Text(
                    catName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? (isDark ? PColor.darkBase : Colors.white)
                          : PColor.ink(context),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: PColor.primary(context),
                  backgroundColor: PColor.surfaceSubtle(context),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : borderColor,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = cat.name;
                        if (!_isEditingName && _name.isEmpty) {
                          _nameController.text = '';
                        }
                      });
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 4),

          // SmartNumpad Keyboard
          SmartNumpad(
            rawInput: _amountInput,
            onInputChanged: (val) {
              setState(() {
                _amountInput = val;
              });
            },
            onSubmit: _saveTransaction,
            canSubmit: SmartNumpad.parseEvaluatedAmount(_amountInput) > 0,
          ),
        ],
      ),
    ),
  );
}

  Widget _buildTypeButton({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? activeColor : PColor.inkSoft(context),
          ),
        ),
      ),
    );
  }
}
