import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';

// State
class AppGlobalState extends Equatable {
  final String activeMonth; // "YYYY-MM"
  final ThemeMode themeMode;
  final int? levelUpAlertLevel;
  final String? levelUpRank;

  const AppGlobalState({
    required this.activeMonth,
    this.themeMode = ThemeMode.system,
    this.levelUpAlertLevel,
    this.levelUpRank,
  });

  AppGlobalState copyWith({
    String? activeMonth,
    ThemeMode? themeMode,
    int? levelUpAlertLevel,
    String? levelUpRank,
    bool clearLevelUpAlert = false,
  }) {
    return AppGlobalState(
      activeMonth: activeMonth ?? this.activeMonth,
      themeMode: themeMode ?? this.themeMode,
      levelUpAlertLevel:
          clearLevelUpAlert ? null : (levelUpAlertLevel ?? this.levelUpAlertLevel),
      levelUpRank:
          clearLevelUpAlert ? null : (levelUpRank ?? this.levelUpRank),
    );
  }

  @override
  List<Object?> get props => [
        activeMonth,
        themeMode,
        levelUpAlertLevel,
        levelUpRank,
      ];
}

// Events
abstract class AppGlobalEvent extends Equatable {
  const AppGlobalEvent();
  @override
  List<Object?> get props => [];
}

class InitializeAppEvent extends AppGlobalEvent {
  const InitializeAppEvent();
}

class ChangeActiveMonthEvent extends AppGlobalEvent {
  final String month;
  const ChangeActiveMonthEvent(this.month);
  @override
  List<Object?> get props => [month];
}

class ChangeThemeModeEvent extends AppGlobalEvent {
  final ThemeMode themeMode;
  const ChangeThemeModeEvent(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

class TriggerLevelUpAlertEvent extends AppGlobalEvent {
  final int level;
  final String rank;
  const TriggerLevelUpAlertEvent({required this.level, required this.rank});
  @override
  List<Object?> get props => [level, rank];
}

class DismissLevelUpAlertEvent extends AppGlobalEvent {
  const DismissLevelUpAlertEvent();
}

// Bloc
class AppGlobalBloc extends Bloc<AppGlobalEvent, AppGlobalState> {
  final AppDatabase db;

  AppGlobalBloc(this.db)
      : super(AppGlobalState(
          activeMonth: DateFormat('yyyy-MM').format(DateTime.now()),
        )) {
    on<InitializeAppEvent>(_onInitialize);
    on<ChangeActiveMonthEvent>(_onChangeActiveMonth);
    on<ChangeThemeModeEvent>(_onChangeThemeMode);
    on<TriggerLevelUpAlertEvent>(_onTriggerLevelUpAlert);
    on<DismissLevelUpAlertEvent>(_onDismissLevelUpAlert);
  }

  Future<void> _onInitialize(
    InitializeAppEvent event,
    Emitter<AppGlobalState> emit,
  ) async {
    final monthRow = await (db.select(db.appSettings)
          ..where((s) => s.key.equals('activeMonth')))
        .getSingleOrNull();
    final themeRow = await (db.select(db.appSettings)
          ..where((s) => s.key.equals('themeMode')))
        .getSingleOrNull();

    final activeMonth = monthRow?.value ??
        DateFormat('yyyy-MM').format(DateTime.now());
    final themeStr = themeRow?.value ?? 'system';

    ThemeMode mode = ThemeMode.system;
    if (themeStr == 'light') mode = ThemeMode.light;
    if (themeStr == 'dark') mode = ThemeMode.dark;

    emit(state.copyWith(
      activeMonth: activeMonth,
      themeMode: mode,
    ));
  }

  Future<void> _onChangeActiveMonth(
    ChangeActiveMonthEvent event,
    Emitter<AppGlobalState> emit,
  ) async {
    await db.into(db.appSettings).insert(
          AppSettingsCompanion.insert(
            key: 'activeMonth',
            value: event.month,
          ),
          mode: InsertMode.insertOrReplace,
        );
    emit(state.copyWith(activeMonth: event.month));
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeModeEvent event,
    Emitter<AppGlobalState> emit,
  ) async {
    String themeStr = 'system';
    if (event.themeMode == ThemeMode.light) themeStr = 'light';
    if (event.themeMode == ThemeMode.dark) themeStr = 'dark';

    await db.into(db.appSettings).insert(
          AppSettingsCompanion.insert(
            key: 'themeMode',
            value: themeStr,
          ),
          mode: InsertMode.insertOrReplace,
        );
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onTriggerLevelUpAlert(
    TriggerLevelUpAlertEvent event,
    Emitter<AppGlobalState> emit,
  ) {
    emit(state.copyWith(
      levelUpAlertLevel: event.level,
      levelUpRank: event.rank,
    ));
  }

  void _onDismissLevelUpAlert(
    DismissLevelUpAlertEvent event,
    Emitter<AppGlobalState> emit,
  ) {
    emit(state.copyWith(clearLevelUpAlert: true));
  }
}
