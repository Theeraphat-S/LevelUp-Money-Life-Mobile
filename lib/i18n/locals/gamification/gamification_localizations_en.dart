// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'gamification_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class GamificationLocalizationsEn extends GamificationLocalizations {
  GamificationLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get quests_title => 'Quests & Badges';

  @override
  String get hero_profile => 'Finance Hero Profile';

  @override
  String level_display(int level, String rank) {
    return 'Lv.$level · $rank';
  }

  @override
  String exp_progress(int current, int max) {
    return 'EXP: $current / $max';
  }

  @override
  String get tab_daily_quests => 'Daily Quests';

  @override
  String get tab_achievements => 'Badges & Ranks';

  @override
  String get level_up_title => 'LEVEL UP!';

  @override
  String level_up_congrats(int level) {
    return 'Congratulations! You reached Level $level!';
  }

  @override
  String new_rank_unlocked(String rank) {
    return 'New Rank: $rank';
  }

  @override
  String get awesome_btn => 'Awesome!';

  @override
  String streak_label(int days) {
    return '$days-Day Activity Streak 🔥';
  }

  @override
  String get unlocked_badge => 'Unlocked';

  @override
  String get locked_badge => 'Locked';

  @override
  String get quest_q1 => 'Record all daily expenses for today';

  @override
  String get quest_q2 => 'Review your 50/30/20 budget allocation';

  @override
  String get quest_q3 => 'Transfer savings to emergency reserve fund';
}
