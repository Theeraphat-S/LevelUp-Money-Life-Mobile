import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/i18n/i18n.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

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
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  late String _selectedCategory;
  late String _selectedDate;
  late bool _isCleared;

  @override
  void initState() {
    super.initState();
    final tx = widget.initialTransaction;
    if (tx != null) {
      _isIncome = tx.isIncome;
      _nameController = TextEditingController(text: tx.name);
      _amountController = TextEditingController(text: tx.absAmount.toStringAsFixed(0));
      _notesController = TextEditingController(text: tx.notes ?? '');
      _selectedCategory = tx.category;
      _selectedDate = tx.date;
      _isCleared = tx.cleared;
    } else {
      _isIncome = widget.initialType == TransactionType.income;
      _nameController = TextEditingController();
      _amountController = TextEditingController();
      _notesController = TextEditingController();
      _selectedCategory = _isIncome ? 'Income' : 'Food';
      _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _isCleared = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _calculatedXpReward {
    int xp = _isIncome ? 30 : 15;
    if (_notesController.text.trim().isNotEmpty) {
      xp += 5;
    }
    return xp;
  }

  void _saveTransaction() {
    final name = _nameController.text.trim();
    final amountText = _amountController.text.trim();
    final amountVal = double.tryParse(amountText);

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกชื่อรายการ')),
      );
      return;
    }

    if (amountVal == null || amountVal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกจำนวนเงินที่ถูกต้อง')),
      );
      return;
    }

    final finalAmount = _isIncome ? amountVal : -amountVal;
    final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

    if (widget.initialTransaction != null) {
      final updated = widget.initialTransaction!.copyWith(
        name: name,
        amount: finalAmount,
        category: _isIncome ? 'Income' : _selectedCategory,
        date: _selectedDate,
        cleared: _isCleared,
        notes: notes,
      );
      context.read<TransactionBloc>().add(UpdateTransactionItemEvent(updated));
    } else {
      final newTx = TransactionItem(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        amount: finalAmount,
        category: _isIncome ? 'Income' : _selectedCategory,
        date: _selectedDate,
        cleared: _isCleared,
        notes: notes,
      );
      context.read<TransactionBloc>().add(AddTransactionItemEvent(newTx));
    }

    context.read<DashboardBloc>().add(const LoadDashboardData());
    context.read<GamificationBloc>().add(const LoadGamificationDataEvent());

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = PColor.surface(context);
    final borderColor = PColor.line(context);
    final isEditing = widget.initialTransaction != null;
    final i18n = AppLocalizations(context).transaction;
    final currentLang = Localizations.localeOf(context).languageCode;

    final categories = CategoryItem.defaultCategories
        .where((c) => _isIncome ? c.isIncome : !c.isIncome)
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : const Color(0x1A142D2B),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PColor.line(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title & Type Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEditing ? i18n.edit_transaction_title : i18n.quick_add_title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: PColor.ink(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Segmented Switcher (Expense / Income)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: PColor.surfaceSubtle(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Row(
                      children: [
                        _buildTypeButton(
                          label: i18n.filter_expense,
                          isSelected: !_isIncome,
                          activeColor: PColor.rose(context),
                          onTap: () => setState(() {
                            _isIncome = false;
                            if (_selectedCategory == 'Income') {
                              _selectedCategory = 'Food';
                            }
                          }),
                        ),
                        _buildTypeButton(
                          label: i18n.filter_income,
                          isSelected: _isIncome,
                          activeColor: PColor.jade(context),
                          onTap: () => setState(() {
                            _isIncome = true;
                            _selectedCategory = 'Income';
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Amount Input
              Text(
                i18n.amount_thb,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PColor.inkSoft(context),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _isIncome ? PColor.jadeInk(context) : PColor.roseInk(context),
                ),
                decoration: InputDecoration(
                  prefixText: '฿ ',
                  prefixStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isIncome ? PColor.jade(context) : PColor.rose(context),
                  ),
                  hintText: '0.00',
                  filled: true,
                  fillColor: PColor.surfaceSubtle(context),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: PColor.primary(context), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Transaction Name Input
              Text(
                i18n.transaction_name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PColor.inkSoft(context),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                style: TextStyle(color: PColor.ink(context)),
                decoration: InputDecoration(
                  hintText: i18n.transaction_name_hint,
                  filled: true,
                  fillColor: PColor.surfaceSubtle(context),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: PColor.primary(context), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Category & Date Selection Row
              Row(
                children: [
                  // Category Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i18n.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: PColor.inkSoft(context),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: PColor.surfaceSubtle(context),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              isExpanded: true,
                              dropdownColor: surfaceColor,
                              items: categories.map((cat) {
                                return DropdownMenuItem(
                                  value: cat.id,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: cat.color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          CategoryItem.getLocalizedCategoryName(cat.id, currentLang),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: PColor.ink(context),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedCategory = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Date Picker Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i18n.date,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: PColor.inkSoft(context),
                          ),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final initial = DateTime.tryParse(_selectedDate) ?? DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: initial,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2035),
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                            decoration: BoxDecoration(
                              color: PColor.surfaceSubtle(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 16, color: PColor.inkSoft(context)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _selectedDate,
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: PColor.ink(context),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Notes Input & Cleared Checkbox
              Text(
                i18n.notes,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PColor.inkSoft(context),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _notesController,
                maxLines: 2,
                style: TextStyle(color: PColor.ink(context), fontSize: 13),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: i18n.notes_hint,
                  filled: true,
                  fillColor: PColor.surfaceSubtle(context),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: PColor.primary(context), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Cleared Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isCleared,
                    activeColor: PColor.primary(context),
                    onChanged: (val) {
                      setState(() => _isCleared = val ?? true);
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isCleared = !_isCleared),
                      child: Text(
                        currentLang == 'th' ? 'ทำเครื่องหมายตรวจสอบแล้ว (Cleared)' : 'Mark as Cleared',
                        style: TextStyle(
                          fontSize: 13,
                          color: PColor.ink(context),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Submit Button with XP Reward Badge
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PColor.primary(context),
                    foregroundColor: isDark ? PColor.darkBase : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_rounded, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          isEditing ? i18n.edit_transaction_title : i18n.save_transaction,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: (isDark ? PColor.darkBase : Colors.white).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '+$_calculatedXpReward XP',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark ? PColor.darkBase : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
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
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : PColor.inkSoft(context),
          ),
        ),
      ),
    );
  }
}
