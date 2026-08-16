// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'analytics_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AnalyticsLocalizationsTh extends AnalyticsLocalizations {
  AnalyticsLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get analytics_title => 'วิเคราะห์การเงิน';

  @override
  String get expense_by_category => 'สัดส่วนรายจ่ายตามหมวดหมู่';

  @override
  String get income_vs_expense => 'เปรียบเทียบรายรับ - รายจ่าย';

  @override
  String get savings_rate => 'อัตราการออมสุทธิ';

  @override
  String get financial_health => 'คะแนนสุขภาพทางการเงิน';

  @override
  String get no_data_month => 'ยังไม่มีข้อมูลการใช้จ่ายในเดือนนี้';

  @override
  String get top_spending => 'หมวดหมู่ที่ใช้จ่ายสูงสุด';

  @override
  String get health_grade_excellent => 'วินัยการเงินยอดเยี่ยมมาก 🌟';

  @override
  String get health_grade_good => 'รักษาสมดุลการเงินได้ดี 👍';

  @override
  String get health_grade_warning => 'ระวังรายจ่ายเริ่มตึงตัว ⚠️';
}
