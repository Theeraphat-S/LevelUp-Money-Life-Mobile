// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'gamification_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class GamificationLocalizationsTh extends GamificationLocalizations {
  GamificationLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get quests_title => 'เควสและความสำเร็จ';

  @override
  String get hero_profile => 'โปรไฟล์ฮีโร่การเงิน';

  @override
  String level_display(int level, String rank) {
    return 'Lv.$level · $rank';
  }

  @override
  String exp_progress(int current, int max) {
    return 'EXP: $current / $max';
  }

  @override
  String get tab_daily_quests => 'เควสประจำวัน';

  @override
  String get tab_achievements => 'เหรียญตราและฉายา';

  @override
  String get level_up_title => 'LEVEL UP!';

  @override
  String level_up_congrats(int level) {
    return 'ยินดีด้วย! คุณเลเวลอัปเป็น เลเวล $level!';
  }

  @override
  String new_rank_unlocked(String rank) {
    return 'ปลดล็อกฉายาใหม่: $rank';
  }

  @override
  String get awesome_btn => 'ยอดเยี่ยมมาก!';

  @override
  String streak_label(int days) {
    return 'ทำกิจกรรมต่อเนื่อง $days วัน 🔥';
  }

  @override
  String get unlocked_badge => 'ปลดล็อกแล้ว';

  @override
  String get locked_badge => 'ยังไม่ปลดล็อก';

  @override
  String get quest_q1 => 'บันทึกรายจ่ายประจำวันทุกรายการวันนี้';

  @override
  String get quest_q2 => 'ตรวจสอบสัดส่วนการจัดสรรงบประมาณ 50/30/20';

  @override
  String get quest_q3 => 'โอนเงินเก็บเข้าบัญชีเงินออมสำรองฉุกเฉิน';
}
