import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:levelup_money_life/feature/gamification/bloc/gamification_bloc.dart';
import 'package:levelup_money_life/feature/gamification/bloc/gamification_state.dart';
import 'package:levelup_money_life/shared/bloc/app/app_bloc.dart';
import 'package:levelup_money_life/shared/bloc/language/language_bloc.dart';
import 'package:levelup_money_life/shared/bloc/language/language_event.dart';
import 'package:levelup_money_life/shared/bloc/language/language_state.dart';
import 'package:levelup_money_life/shared/components/data_manager_dialog.dart';
import 'package:levelup_money_life/shared/components/xp_progress_bar.dart';
import 'package:levelup_money_life/shared/tokens/p_colors.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = PColor.surface(context);
    final borderColor = PColor.line(context);
    final currentLang = Localizations.localeOf(context).languageCode;
    final isThai = currentLang == 'th';

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: borderColor),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: PColor.inkFaint(context).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header: Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PColor.primarySoft(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.settings_suggest_rounded,
                      color: PColor.primary(context),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isThai ? 'การตั้งค่า & โปรไฟล์' : 'Settings & Profile',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: PColor.ink(context),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                color: PColor.inkSoft(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Section 1: User Gamification Stats Summary
          BlocBuilder<GamificationBloc, GamificationState>(
            builder: (context, gState) {
              final user = gState.userProfile;
              if (user == null) return const SizedBox.shrink();

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: PColor.surfaceSubtle(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: PColor.primary(context),
                          child: Text(
                            'Lv.${user.level}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isThai ? user.rankTitle : user.rankTitleEn,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: PColor.ink(context),
                                ),
                              ),
                              Text(
                                '${user.totalXp} XP · ${user.streakDays} ${isThai ? 'วันต่อเนื่อง' : 'Day Streak'}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: PColor.inkSoft(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    XPProgressBar(
                      currentXp: user.currentExp,
                      xpForNextLevel: user.maxExp,
                      progressPercent: user.expProgress * 100.0,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Section 2: Preferences
          Text(
            isThai ? 'การตั้งค่าทั่วไป' : 'General Preferences',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: PColor.inkSoft(context),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          // Language Setting Tile
          BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, langState) {
              final isTh = langState.locale.languageCode == 'th';
              return _buildSettingTile(
                context: context,
                icon: Icons.translate_rounded,
                title: isThai ? 'ภาษา (Language)' : 'Language',
                subtitle: isTh ? 'ภาษาไทย' : 'English',
                trailing: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'th', label: Text('TH')),
                    ButtonSegment(value: 'en', label: Text('EN')),
                  ],
                  selected: {isTh ? 'th' : 'en'},
                  onSelectionChanged: (set) {
                    final code = set.first;
                    context
                        .read<LanguageBloc>()
                        .add(ChangeLanguageEvent(Locale(code)));
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          // Theme Setting Tile (3-Way: System / Light / Dark)
          BlocBuilder<AppGlobalBloc, AppGlobalState>(
            builder: (context, appState) {
              final currentMode = appState.themeMode;
              String modeSubtitle = isThai ? 'ตามระบบ' : 'System';
              if (currentMode == ThemeMode.light) {
                modeSubtitle = isThai ? 'โหมดสว่าง' : 'Light Mode';
              } else if (currentMode == ThemeMode.dark) {
                modeSubtitle = isThai ? 'โหมดมืด' : 'Dark Mode';
              }

              IconData modeIcon = Icons.brightness_auto_rounded;
              if (currentMode == ThemeMode.light) {
                modeIcon = Icons.light_mode_rounded;
              } else if (currentMode == ThemeMode.dark) {
                modeIcon = Icons.dark_mode_rounded;
              }

              return _buildSettingTile(
                context: context,
                icon: modeIcon,
                title: isThai ? 'ธีมการแสดงผล' : 'Appearance',
                subtitle: modeSubtitle,
                trailing: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto_rounded, size: 14),
                      label: Text('Auto', style: TextStyle(fontSize: 10)),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_rounded, size: 14),
                      label: Text('Light', style: TextStyle(fontSize: 10)),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_rounded, size: 14),
                      label: Text('Dark', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                  selected: {currentMode},
                  onSelectionChanged: (set) {
                    final newMode = set.first;
                    context.read<AppGlobalBloc>().add(ChangeThemeModeEvent(newMode));
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),

          // Data Manager Tile (Backup & Restore)
          _buildSettingTile(
            context: context,
            icon: Icons.storage_rounded,
            title: isThai ? 'สำรอง & กู้คืนข้อมูล' : 'Backup & Data Management',
            subtitle: isThai ? 'ส่งออก / นำเข้าไฟล์ JSON' : 'Export / Import JSON Data',
            trailing: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                DataManagerDialog.show(context);
              },
              icon: const Icon(Icons.folder_open_rounded, size: 14),
              label: Text(isThai ? 'จัดการ' : 'Manage', style: const TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: PColor.surfaceSubtle(context),
                foregroundColor: PColor.ink(context),
                elevation: 0,
                side: BorderSide(color: borderColor),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    final borderColor = PColor.line(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: PColor.surfaceSubtle(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: PColor.primary(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: PColor.primary(context)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: PColor.ink(context),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: PColor.inkSoft(context),
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

