// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'dashboard_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class DashboardLocalizationsTh extends DashboardLocalizations {
  DashboardLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get monthly_income => 'รายรับเดือนนี้';

  @override
  String get monthly_expense => 'รายจ่ายเดือนนี้';

  @override
  String get net_savings => 'กระแสเงินสดสุทธิ (NET SAVINGS)';

  @override
  String get status_healthy => 'สถานะปกติ';

  @override
  String get status_overspent => 'ใช้เกินรายรับ';

  @override
  String day_streak(int days) {
    return 'ต่อเนื่อง $days วัน 🔥';
  }

  @override
  String total_xp_score(int xp) {
    return 'คะแนนสะสมรวม: $xp XP';
  }

  @override
  String get view_quests_achievements => 'ดูเควส & ความสำเร็จ →';

  @override
  String get add_expense => 'เพิ่มรายจ่าย';

  @override
  String get add_income => 'เพิ่มรายรับ';

  @override
  String get scan_slip => 'สแกนสลิป';

  @override
  String get daily_quests => 'เควสประจำวัน (Daily Quests)';

  @override
  String get view_all => 'ดูทั้งหมด';

  @override
  String get recent_transactions => 'รายการล่าสุด (Recent Transactions)';

  @override
  String get no_transactions_month => 'ยังไม่มีรายการในเดือนนี้';

  @override
  String get slip_scan_tooltip => 'สแกนสลิปโอนเงิน (+25 XP)';

  @override
  String get quick_add_tooltip => 'เพิ่มรายการด่วน';

  @override
  String get theme_toggle_tooltip => 'สลับ Light/Dark Mode';

  @override
  String get data_manager_tooltip => 'สำรอง/กู้คืนข้อมูล (JSON)';

  @override
  String get language_toggle_tooltip => 'เปลี่ยนภาษา';
}
