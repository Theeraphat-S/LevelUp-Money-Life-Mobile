import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/feature/budget/bloc/budget_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/locator.dart';
import 'package:mobile_app_standard/shared/bloc/app/app_bloc.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class DataManagerDialog extends StatefulWidget {
  const DataManagerDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const DataManagerDialog(),
    );
  }

  @override
  State<DataManagerDialog> createState() => _DataManagerDialogState();
}

class _DataManagerDialogState extends State<DataManagerDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _importController = TextEditingController();
  String _exportedJson = 'กำลังโหลดข้อมูล...';
  bool _isLoadingExport = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadExportData();
  }

  Future<void> _loadExportData() async {
    final db = locator<AppDatabase>();
    final jsonMap = await db.exportBackupJson();
    if (mounted) {
      setState(() {
        _exportedJson = const JsonEncoder.withIndent('  ').convert(jsonMap);
        _isLoadingExport = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _importController.dispose();
    super.dispose();
  }

  void _copyExportedJson() {
    if (_isLoadingExport) return;
    Clipboard.setData(ClipboardData(text: _exportedJson));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('คัดลอกข้อมูล Backup JSON เรียบร้อยแล้ว')),
    );
  }

  void _importJson() async {
    final text = _importController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาวางข้อมูล JSON สำหรับการกู้คืน')),
      );
      return;
    }

    try {
      final map = jsonDecode(text);
      if (map is! Map<String, dynamic>) {
        throw const FormatException('Invalid JSON map structure');
      }

      final db = locator<AppDatabase>();
      final success = await db.importBackupJson(map);

      if (success && mounted) {
        context.read<AppGlobalBloc>().add(const InitializeAppEvent());
        context.read<DashboardBloc>().add(const LoadDashboardData());
        context.read<TransactionBloc>().add(const LoadTransactionsEvent());
        context.read<BudgetBloc>().add(const LoadBudgetDataEvent());
        context.read<GamificationBloc>().add(const LoadGamificationDataEvent());

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('นำเข้าข้อมูลสำเร็จเรียบร้อย!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('รูปแบบ JSON ไม่ถูกต้อง: $e')),
        );
      }
    }
  }

  void _resetData() async {
    final db = locator<AppDatabase>();
    await db.resetAllData();

    if (mounted) {
      context.read<AppGlobalBloc>().add(const InitializeAppEvent());
      context.read<DashboardBloc>().add(const LoadDashboardData());
      context.read<TransactionBloc>().add(const LoadTransactionsEvent());
      context.read<BudgetBloc>().add(const LoadBudgetDataEvent());
      context.read<GamificationBloc>().add(const LoadGamificationDataEvent());

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รีเซ็ตข้อมูลเริ่มต้นเรียบร้อยแล้ว')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = PColor.surface(context);
    final borderColor = PColor.line(context);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 520),
        child: Column(
          children: [
            // Dialog Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PColor.primarySoft(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.storage_outlined,
                      color: PColor.primary(context),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'จัดการข้อมูล (Data Manager)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: PColor.ink(context),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              indicatorColor: PColor.primary(context),
              labelColor: PColor.primary(context),
              unselectedLabelColor: PColor.inkSoft(context),
              labelStyle:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'สำรอง (Export)'),
                Tab(text: 'กู้คืน (Import)'),
                Tab(text: 'รีเซ็ต (Reset)'),
              ],
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Export
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'สำรองข้อมูล JSON (แชร์ใช้งานกับเว็บได้):',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: PColor.ink(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: PColor.surfaceSubtle(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: _isLoadingExport
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : SingleChildScrollView(
                                    child: Text(
                                      _exportedJson,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoadingExport ? null : _copyExportedJson,
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            label: const Text('คัดลอก JSON Backup'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PColor.primary(context),
                              foregroundColor:
                                  isDark ? PColor.darkBase : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab 2: Import
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'วางข้อมูล JSON ที่ Export มาจาก Web หรือ Mobile:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: PColor.ink(context),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: TextField(
                            controller: _importController,
                            maxLines: null,
                            expands: true,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  '{\n  "version": 1,\n  "transactions": [...]\n}',
                              filled: true,
                              fillColor: PColor.surfaceSubtle(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: borderColor),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _importJson,
                            icon: const Icon(Icons.download_rounded, size: 16),
                            label: const Text('นำเข้าและกู้คืนข้อมูล'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PColor.primary(context),
                              foregroundColor:
                                  isDark ? PColor.darkBase : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab 3: Reset
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 48,
                          color: PColor.rose(context),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'คุณต้องการรีเซ็ตข้อมูลทั้งหมดหรือไม่?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: PColor.ink(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'ข้อมูลธุรกรรม สถิติ และเควสจะถูกคืนค่ากลับเป็นชุดตัวอย่างเริ่มต้น',
                          style: TextStyle(
                            fontSize: 12,
                            color: PColor.inkSoft(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _resetData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PColor.rose(context),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('ยืนยันการล้างข้อมูล (Reset All)'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
