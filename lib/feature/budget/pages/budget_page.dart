import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/models/budget/allocation_item.dart';
import 'package:mobile_app_standard/feature/budget/bloc/budget_bloc.dart';
import 'package:mobile_app_standard/router/router.dart';
import 'package:mobile_app_standard/shared/components/appbar/bottombar_custom.dart';
import 'package:mobile_app_standard/shared/components/bento_card.dart';
import 'package:mobile_app_standard/shared/components/header_command_deck.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

@RoutePage()
class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final TextEditingController _incomeController = TextEditingController();
  int _needsPercent = 50;
  int _wantsPercent = 30;
  int _savingsPercent = 20;

  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(const LoadBudgetDataEvent());
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  void _syncStateWithBloc(BudgetState state) {
    if (_incomeController.text.isEmpty) {
      _incomeController.text = state.monthlyIncome.toStringAsFixed(0);
    }
    for (final a in state.allocations) {
      if (a.id == 'needs') _needsPercent = a.percent;
      if (a.id == 'wants') _wantsPercent = a.percent;
      if (a.id == 'savings') _savingsPercent = a.percent;
    }
  }

  void _saveAllocations() {
    final income = double.tryParse(_incomeController.text) ?? 48000.0;
    context.read<BudgetBloc>().add(UpdateMonthlyIncomeEvent(income));

    final updatedAllocs = [
      AllocationItem(id: 'needs', label: 'Needs', percent: _needsPercent, color: '#1C5954'),
      AllocationItem(id: 'wants', label: 'Wants', percent: _wantsPercent, color: '#879B62'),
      AllocationItem(id: 'savings', label: 'Savings', percent: _savingsPercent, color: '#4D8E75'),
    ];
    context.read<BudgetBloc>().add(UpdateAllocationsEvent(updatedAllocs));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('บันทึกแผนการจัดสรรงบประมาณ 50/30/20 สำเร็จ!'),
        backgroundColor: PColor.jadeLight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat('#,##0.00', 'en_US');
    final totalPercent = _needsPercent + _wantsPercent + _savingsPercent;
    final isBalanced = totalPercent == 100;

    return Scaffold(
      backgroundColor: PColor.base(context),
      appBar: HeaderCommandDeck(
        onOpenQuests: () => context.router.push(const QuestRoute()),
      ),
      bottomNavigationBar: const BottomBarCustom(
        currentRouteName: BudgetRoute.name,
      ),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        listener: (context, state) {
          _syncStateWithBloc(state);
        },
        builder: (context, state) {
          if (state.status == BudgetStatus.loading && state.allocations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BudgetBloc>().add(const LoadBudgetDataEvent());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Monthly Income Input Card
                  BentoCard(
                    header: Row(
                      children: [
                        Icon(Icons.monetization_on_outlined,
                            size: 16, color: PColor.jade(context)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'รายได้ต่อเดือน (Monthly Income)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: PColor.ink(context),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'กำหนดฐานรายรับต่อเดือนเพื่อคำนวณสัดส่วนงบประมาณ 50/30/20:',
                          style: TextStyle(fontSize: 11, color: PColor.inkSoft(context)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _incomeController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: PColor.jadeInk(context),
                                ),
                                decoration: InputDecoration(
                                  prefixText: '฿ ',
                                  prefixStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: PColor.jade(context),
                                  ),
                                  filled: true,
                                  fillColor: PColor.surfaceSubtle(context),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: PColor.line(context)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _saveAllocations,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: PColor.primary(context),
                                foregroundColor: isDark ? PColor.darkBase : Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('บันทึก', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. 50/30/20 Allocation Sliders Bento Card
                  BentoCard(
                    header: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pie_chart_outline_rounded,
                                  size: 16, color: PColor.primary(context)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'สัดส่วนงบประมาณ (50/30/20)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: PColor.ink(context),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isBalanced ? PColor.jadeSoft(context) : PColor.roseSoft(context),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$totalPercent% ${isBalanced ? '✓ สมดุล' : '⚠️ ไม่ครบ 100%'}',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isBalanced ? PColor.jadeInk(context) : PColor.roseInk(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Needs Slider
                        _buildSliderRow(
                          title: 'Needs (จำเป็น 50%)',
                          subtitle: 'อาหาร, เดินทาง, บ้าน, สุขภาพ',
                          value: _needsPercent,
                          color: PColor.primary(context),
                          onChanged: (val) => setState(() => _needsPercent = val.round()),
                        ),
                        const SizedBox(height: 12),

                        // Wants Slider
                        _buildSliderRow(
                          title: 'Wants (ความสุข 30%)',
                          subtitle: 'พัฒนาตนเอง, บันเทิง & ช้อปปิ้ง',
                          value: _wantsPercent,
                          color: PColor.moss(context),
                          onChanged: (val) => setState(() => _wantsPercent = val.round()),
                        ),
                        const SizedBox(height: 12),

                        // Savings Slider
                        _buildSliderRow(
                          title: 'Savings (เงินออม & หนี้ 20%)',
                          subtitle: 'เงินออมฉุกเฉิน, ลงทุน, ปลดหนี้',
                          value: _savingsPercent,
                          color: PColor.jade(context),
                          onChanged: (val) => setState(() => _savingsPercent = val.round()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Bucket Spending Breakdown
                  Text(
                    'ติดตามการใช้จ่ายจริงเทียบกับงบประมาณ (Bucket Progress):',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: PColor.ink(context),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ...state.summaries.map((summary) {
                    final isOverBudget = summary.spentAmount > summary.budgetAmount;
                    Color bucketColor;
                    if (summary.id == 'needs') {
                      bucketColor = PColor.primary(context);
                    } else if (summary.id == 'wants') {
                      bucketColor = PColor.moss(context);
                    } else {
                      bucketColor = PColor.jade(context);
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: BentoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: bucketColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${summary.label} (${summary.percent}%)',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: PColor.ink(context),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isOverBudget
                                        ? PColor.roseSoft(context)
                                        : PColor.jadeSoft(context),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isOverBudget ? 'เกินงบประมาณ!' : 'อยู่ในงบ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isOverBudget
                                          ? PColor.roseInk(context)
                                          : PColor.jadeInk(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (summary.progressPercent / 100.0).clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: PColor.line(context),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isOverBudget ? PColor.rose(context) : bucketColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Numbers Row
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'ใช้ไป: ฿${currencyFormat.format(summary.spentAmount)} / ฿${currencyFormat.format(summary.budgetAmount)}',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 11,
                                      color: PColor.inkSoft(context),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'คงเหลือ: ฿${currencyFormat.format(summary.remainingAmount)}',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: summary.remainingAmount >= 0
                                        ? PColor.jadeInk(context)
                                        : PColor.roseInk(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliderRow({
    required String title,
    required String subtitle,
    required int value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: PColor.ink(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: PColor.inkFaint(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$value%',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: PColor.line(context),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.15),
            trackHeight: 6,
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
