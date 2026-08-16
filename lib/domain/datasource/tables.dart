import 'package:drift/drift.dart';

@DataClassName('TransactionEntry')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get date => text()();
  TextColumn get category => text()();
  BoolColumn get cleared => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  IntColumn get expGained => integer().withDefault(const Constant(15))();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AllocationEntry')
class Allocations extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  IntColumn get percent => integer()();
  TextColumn get color => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('QuestEntry')
class Quests extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get date => text()();
  IntColumn get xp => integer()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  TextColumn get category => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserProfileEntry')
class UserProfiles extends Table {
  TextColumn get id => text().withDefault(const Constant('user_main'))();
  TextColumn get name => text().withDefault(const Constant('Finance Commander'))();
  IntColumn get totalXp => integer().withDefault(const Constant(180))();
  IntColumn get streakDays => integer().withDefault(const Constant(1))();
  TextColumn get lastActiveDate => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UnlockedAchievementEntry')
class UnlockedAchievements extends Table {
  TextColumn get id => text()();
  TextColumn get unlockedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AppSettingEntry')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
