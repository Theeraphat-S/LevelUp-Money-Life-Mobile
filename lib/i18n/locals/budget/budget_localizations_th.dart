// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'budget_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class BudgetLocalizationsTh extends BudgetLocalizations {
  BudgetLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get budget_title => 'แผนงบประมาณ 50/30/20';

  @override
  String get monthly_income_base => 'ฐานรายได้ต่อเดือน';

  @override
  String get needs_bucket => 'สิ่งจำเป็น Needs (50%)';

  @override
  String get needs_desc => 'ค่าเช่าบ้าน, อาหาร, ค่าน้ำไฟ, สุขภาพ, เดินทาง';

  @override
  String get wants_bucket => 'สิ่งที่ต้องการ Wants (30%)';

  @override
  String get wants_desc => 'กินข้าวนอกบ้าน, ความบันเทิง, ช้อปปิ้ง, พักผ่อน';

  @override
  String get savings_bucket => 'เงินออมและหนี้สิน Savings (20%)';

  @override
  String get savings_desc => 'เงินสำรองฉุกเฉิน, เงินลงทุน, ผ่อนชำระหนี้';

  @override
  String get allocated => 'จัดสรรแล้ว';

  @override
  String get remaining => 'คงเหลือ';

  @override
  String get spent => 'ใช้ไปแล้ว';

  @override
  String get over_budget => 'เกินงบประมาณ!';

  @override
  String get adjust_budget => 'ปรับสัดส่วนงบประมาณ';

  @override
  String get save_budget_plan => 'บันทึกแผนงบประมาณ';

  @override
  String get total_must_be_100 => 'สัดส่วนรวมต้องเท่ากับ 100%';
}
