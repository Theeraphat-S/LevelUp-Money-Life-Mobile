// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'appbar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppbarLocalizationsEn extends AppbarLocalizations {
  AppbarLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home_route_name => 'Home';

  @override
  String get todo_route_name => 'Todo';

  @override
  String get nav_overview => 'Overview';

  @override
  String get nav_transactions => 'Transactions';

  @override
  String get nav_budget => 'Budget 50/30/20';

  @override
  String get nav_analytics => 'Analytics';

  @override
  String get nav_quests => 'Quests & XP';

  @override
  String get app_title => 'LevelUp Money Life';
}
