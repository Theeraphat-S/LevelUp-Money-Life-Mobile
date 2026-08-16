// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'transaction_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class TransactionLocalizationsTh extends TransactionLocalizations {
  TransactionLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get transactions_title => 'รายการธุรกรรม';

  @override
  String get total_income => 'รายรับรวม';

  @override
  String get total_expense => 'รายจ่ายรวม';

  @override
  String get net_flow => 'สุทธิ';

  @override
  String get filter_all => 'ทั้งหมด';

  @override
  String get filter_income => 'รายรับ';

  @override
  String get filter_expense => 'รายจ่าย';

  @override
  String get search_placeholder => 'ค้นหาชื่อรายการ...';

  @override
  String get no_transactions_found => 'ไม่พบรายการธุรกรรม';

  @override
  String get quick_add_title => 'บันทึกรายการด่วน';

  @override
  String get edit_transaction_title => 'แก้ไขรายการธุรกรรม';

  @override
  String get transaction_name => 'ชื่อรายการ';

  @override
  String get transaction_name_hint => 'เช่น ข้าวกลางวัน, กาแฟ, เงินเดือน';

  @override
  String get amount_thb => 'จำนวนเงิน (บาท)';

  @override
  String get category => 'หมวดหมู่';

  @override
  String get date => 'วันที่';

  @override
  String get notes => 'บันทึกช่วยจำ (ไม่บังคับ)';

  @override
  String get notes_hint => 'เพิ่มรายละเอียดเพิ่มเติม...';

  @override
  String get save_transaction => 'บันทึกรายการ (+15 XP)';

  @override
  String get saving => 'กำลังบันทึก...';

  @override
  String get delete_transaction => 'ลบรายการนี้';

  @override
  String get delete_confirm_title => 'ยืนยันการลบรายการ?';

  @override
  String get delete_confirm_msg => 'คุณแน่ใจหรือไม่ว่าต้องการลบรายการธุรกรรมนี้?';

  @override
  String get scan_slip_title => 'สแกนสลิปโอนเงิน';

  @override
  String get scan_slip_subtitle => 'ตรวจจับยอดเงินและหมวดหมู่อัตโนมัติ พร้อมรับ +25 XP!';

  @override
  String get select_slip_image => 'เลือกรูปภาพสลิป';

  @override
  String get use_demo_slip => 'ทดลองใช้สลิปตัวอย่าง';

  @override
  String get slip_analyzed_success => 'สแกนสลิปสำเร็จเรียบร้อย!';

  @override
  String get exp_reward_title => 'ภารกิจสำเร็จ!';

  @override
  String exp_reward_msg(int xp) {
    return 'คุณได้รับ +$xp XP!';
  }
}
