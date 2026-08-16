import 'dart:ui';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/shared/bloc/language/language_event.dart';
import 'package:mobile_app_standard/shared/bloc/language/language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final AppDatabase db;

  LanguageBloc(this.db) : super(const LanguageState(Locale('th'))) {
    on<InitializeLanguageEvent>(_initializeLanguage);
    on<ChangeLanguageEvent>(_changeLanguage);
    on<ToggleDropdownEvent>(_toggleDropdown);
  }

  Future<void> _initializeLanguage(
      InitializeLanguageEvent event, Emitter<LanguageState> emit) async {
    try {
      final langRow = await (db.select(db.appSettings)
            ..where((s) => s.key.equals('language')))
          .getSingleOrNull();

      Locale initialLocale;
      if (langRow != null && langRow.value.isNotEmpty) {
        initialLocale = Locale(langRow.value);
      } else {
        // Fallback to system locale if supported, else default to 'th'
        final systemLang = PlatformDispatcher.instance.locale.languageCode;
        if (systemLang == 'en' || systemLang == 'th') {
          initialLocale = Locale(systemLang);
        } else {
          initialLocale = const Locale('th');
        }
      }

      Intl.defaultLocale = initialLocale.languageCode;
      emit(state.copyWith(locale: initialLocale));
    } catch (e) {
      debugPrint('Error during language initialization: $e');
    }
  }

  Future<void> _changeLanguage(
      ChangeLanguageEvent event, Emitter<LanguageState> emit) async {
    try {
      await db.into(db.appSettings).insert(
            AppSettingsCompanion.insert(
              key: 'language',
              value: event.locale.languageCode,
            ),
            mode: InsertMode.insertOrReplace,
          );

      Intl.defaultLocale = event.locale.languageCode;
      emit(state.copyWith(locale: event.locale));
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  void _toggleDropdown(ToggleDropdownEvent event, Emitter<LanguageState> emit) {
    emit(state.copyWith(isDropdownOpen: event.isOpen));
  }
}
