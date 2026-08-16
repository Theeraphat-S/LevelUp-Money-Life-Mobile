import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class SlipScanPreset {
  final String title;
  final String bankName;
  final double amount;
  final String category;
  final String note;

  const SlipScanPreset({
    required this.title,
    required this.bankName,
    required this.amount,
    required this.category,
    required this.note,
  });
}

class SlipScanSheet extends StatefulWidget {
  const SlipScanSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SlipScanSheet(),
    );
  }

  @override
  State<SlipScanSheet> createState() => _SlipScanSheetState();
}

class _SlipScanSheetState extends State<SlipScanSheet> {
  bool _isProcessing = false;
  SlipScanPreset? _detectedSlip;

  static const List<SlipScanPreset> _presets = [
    SlipScanPreset(
      title: '7-Eleven มินิมาร์ท',
      bankName: 'KBank (กสิกรไทย)',
      amount: 145.0,
      category: 'Food',
      note: 'โอนชำระเงินผ่าน PromptPay QR Code (สลิป KBank)',
    ),
    SlipScanPreset(
      title: 'Cafe Amazon กาแฟ & ชา',
      bankName: 'SCB (ไทยพาณิชย์)',
      amount: 75.0,
      category: 'Food',
      note: 'โอนชำระค่าเครื่องดื่ม (สลิป SCB Easy)',
    ),
    SlipScanPreset(
      title: 'เติมเงินบัตร BTS รถไฟฟ้า',
      bankName: 'KBank (กสิกรไทย)',
      amount: 500.0,
      category: 'Transport',
      note: 'เติมเที่ยวเดินทางรถไฟฟ้า BTS',
    ),
    SlipScanPreset(
      title: 'ค่ายา & วิตามิน Boots Pharmacy',
      bankName: 'BBL (กรุงเทพ)',
      amount: 320.0,
      category: 'Health',
      note: 'ชำระค่ายาประจำเดือน',
    ),
  ];

  void _scanSlip(SlipScanPreset preset) async {
    setState(() {
      _isProcessing = true;
      _detectedSlip = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _detectedSlip = preset;
      });
    }
  }

  void _confirmAndSave() {
    if (_detectedSlip == null) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final tx = TransactionItem(
      id: 'tx_slip_${DateTime.now().millisecondsSinceEpoch}',
      name: _detectedSlip!.title,
      amount: -_detectedSlip!.amount,
      category: _detectedSlip!.category,
      date: today,
      cleared: true,
      notes: '[Slip OCR Scan] ${_detectedSlip!.note} (${_detectedSlip!.bankName})',
    );

    // Award +25 XP bonus for scanning bank slip
    context
        .read<TransactionBloc>()
        .add(AddTransactionItemEvent(tx, bonusExp: 25));
    context.read<DashboardBloc>().add(const LoadDashboardData());
    context.read<GamificationBloc>().add(const LoadGamificationDataEvent());

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('สแกนสลิปสำเร็จ! บันทึกรายการ +40 XP'),
          ],
        ),
        backgroundColor: PColor.jadeLight,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = PColor.surface(context);
    final borderColor = PColor.line(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: borderColor, width: 1),
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

              // Sheet Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PColor.primarySoft(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.document_scanner_outlined,
                      color: PColor.primary(context),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สแกนสลิปโอนเงิน (OCR)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: PColor.ink(context),
                        ),
                      ),
                      Text(
                        'ดึงยอดเงิน วันที่ และหมวดหมู่อัตโนมัติ (+25 XP Bonus)',
                        style: TextStyle(
                          fontSize: 11,
                          color: PColor.jadeInk(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Upload Dropzone / Camera Simulation Area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: PColor.surfaceSubtle(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: PColor.primary(context).withOpacity(0.35),
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 42,
                      color: PColor.primary(context),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'เลือกรูปสลิปจากอัลบั้ม หรือเลือกเทมเพลตตัวอย่าง',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: PColor.ink(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'รองรับสลิปทุกธนาคาร (KBank, SCB, BBL, KTB, TrueMoney)',
                      style: TextStyle(
                        fontSize: 11,
                        color: PColor.inkFaint(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'เลือกสลิปตัวอย่างเพื่อทดสอบสแกน (Demo OCR):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: PColor.inkSoft(context),
                ),
              ),
              const SizedBox(height: 10),

              // Preset Bank Slip Items
              ..._presets.map((preset) {
                final isSelected = _detectedSlip == preset;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? PColor.primarySoft(context)
                        : PColor.surfaceSubtle(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? PColor.primary(context)
                          : borderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: PColor.surface(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.receipt_outlined,
                        color: PColor.primary(context),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      preset.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: PColor.ink(context),
                      ),
                    ),
                    subtitle: Text(
                      '${preset.bankName} • ฿${preset.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: PColor.inkSoft(context),
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _scanSlip(preset),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? PColor.primary(context)
                            : PColor.surface(context),
                        foregroundColor: isSelected
                            ? (isDark ? PColor.darkBase : Colors.white)
                            : PColor.primary(context),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: PColor.line(context)),
                        ),
                      ),
                      child: const Text('สแกน',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }),

              if (_isProcessing) ...[
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: PColor.primary(context)),
                      const SizedBox(height: 8),
                      Text(
                        'กำลังวิเคราะห์ข้อความบนสลิป...',
                        style: TextStyle(fontSize: 12, color: PColor.inkSoft(context)),
                      ),
                    ],
                  ),
                ),
              ],

              if (_detectedSlip != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: PColor.jadeSoft(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: PColor.jade(context).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: PColor.jade(context), size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'ผลการวิเคราะห์ข้อมูลสลิป:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: PColor.jadeInk(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('• รายการ: ${_detectedSlip!.title}',
                          style: TextStyle(fontSize: 12, color: PColor.ink(context))),
                      Text('• จำนวนเงิน: ฿${_detectedSlip!.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w700,
                              color: PColor.roseInk(context))),
                      Text('• หมวดหมู่: ${_detectedSlip!.category}',
                          style: TextStyle(fontSize: 12, color: PColor.ink(context))),
                      Text('• ธนาคาร: ${_detectedSlip!.bankName}',
                          style: TextStyle(fontSize: 12, color: PColor.inkSoft(context))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmAndSave,
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
                      children: [
                        const Icon(Icons.save_outlined, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          'ยืนยันและบันทึกรายการ',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (isDark ? PColor.darkBase : Colors.white)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '+40 XP',
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
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
