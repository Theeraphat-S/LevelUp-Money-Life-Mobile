// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'appbar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppbarLocalizationsTh extends AppbarLocalizations {
  AppbarLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get home_route_name => 'หน้าหลัก';

  @override
  String get todo_route_name => 'สิ่งที่ต้องทำ';

  @override
  String get nav_overview => 'ภาพรวม';

  @override
  String get nav_transactions => 'ธุรกรรม';

  @override
  String get nav_budget => 'งบ 50/30/20';

  @override
  String get nav_analytics => 'วิเคราะห์';

  @override
  String get nav_quests => 'เควส & XP';

  @override
  String get app_title => 'LevelUp Money Life';
}
