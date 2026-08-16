import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_state.dart';
import 'package:mobile_app_standard/router/router.dart';
import 'package:mobile_app_standard/shared/components/appbar/bottombar_custom.dart';
import 'package:mobile_app_standard/shared/components/bento_card.dart';
import 'package:mobile_app_standard/shared/components/header_command_deck.dart';
import 'package:mobile_app_standard/shared/components/xp_progress_bar.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

@RoutePage()
class QuestPage extends StatelessWidget {
  const QuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<GamificationBloc>().add(const LoadGamificationDataEvent());
    return const _QuestPageView();
  }
}

class _QuestPageView extends StatelessWidget {
  const _QuestPageView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: PColor.base(context),
        appBar: const HeaderCommandDeck(),
        bottomNavigationBar: const BottomBarCustom(
          currentRouteName: QuestRoute.name,
        ),
        body: Column(
          children: [
            // Tab Selector Strip
            Container(
              color: PColor.surface(context),
              child: TabBar(
                indicatorColor: PColor.primary(context),
                labelColor: PColor.primary(context),
                unselectedLabelColor: PColor.inkSoft(context),
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                tabs: const [
                  Tab(icon: Icon(Icons.checklist_rounded), text: 'ภารกิจ (Quests)'),
                  Tab(icon: Icon(Icons.military_tech_rounded), text: 'ความสำเร็จ (Achievements)'),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Tab Views
            Expanded(
              child: BlocConsumer<GamificationBloc, GamificationState>(
                listener: (context, state) {
                  if (state.message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message!),
                        backgroundColor: PColor.jadeLight,
                      ),
                    );
                    context.read<DashboardBloc>().add(const LoadDashboardData());
                  }
                },
                builder: (context, state) {
                  if (state.status == GamificationStatus.loading &&
                      state.dailyQuests.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final user = state.userProfile;

                  return TabBarView(
                    children: [
                      // Tab 1: Daily Quests
                      RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<GamificationBloc>()
                              .add(const LoadGamificationDataEvent());
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User Status Snapshot Card
                              if (user != null) ...[
                                BentoCard(
                                  header: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'สถานะวินัยการเงิน',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: PColor.ink(context),
                                        ),
                                      ),
                                      Text(
                                        '${user.streakDays}-Day Streak 🔥',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: PColor.amberInk(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      XPProgressBar(
                                        currentXp: user.currentExp,
                                        xpForNextLevel: user.maxExp,
                                        progressPercent: user.expProgress * 100.0,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              Text(
                                'ภารกิจประจำวัน (Daily Checklist):',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: PColor.ink(context),
                                ),
                              ),
                              const SizedBox(height: 10),

                              ...state.dailyQuests.map((quest) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: BentoCard(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Checkbox(
                                        value: quest.done,
                                        activeColor: PColor.primary(context),
                                        onChanged: (_) {
                                          context
                                              .read<GamificationBloc>()
                                              .add(ToggleQuestEvent(quest.id));
                                          context
                                              .read<DashboardBloc>()
                                              .add(const LoadDashboardData());
                                        },
                                      ),
                                      title: Text(
                                        quest.title,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: quest.done
                                              ? PColor.inkFaint(context)
                                              : PColor.ink(context),
                                          decoration: quest.done
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                      subtitle: Text(
                                        quest.done
                                            ? 'ทำสำเร็จแล้ว ✓'
                                            : 'ยังไม่เสร็จสิ้น',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: quest.done
                                              ? PColor.jadeInk(context)
                                              : PColor.inkFaint(context),
                                        ),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: quest.done
                                              ? PColor.jadeSoft(context)
                                              : PColor.primarySoft(context),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '+${quest.xp} XP',
                                          style: TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: quest.done
                                                ? PColor.jadeInk(context)
                                                : PColor.primaryInk(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),

                      // Tab 2: Achievements
                      RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<GamificationBloc>()
                              .add(const LoadGamificationDataEvent());
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.achievements.length,
                          itemBuilder: (context, index) {
                            final ach = state.achievements[index];
                            final isUnlocked = ach.unlocked;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: BentoCard(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isUnlocked
                                            ? PColor.jadeSoft(context)
                                            : PColor.surfaceSubtle(context),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isUnlocked
                                              ? PColor.jade(context)
                                                  .withValues(alpha: 0.4)
                                              : PColor.line(context),
                                        ),
                                      ),
                                      child: Icon(
                                        isUnlocked
                                            ? Icons.military_tech_rounded
                                            : Icons.lock_outline_rounded,
                                        color: isUnlocked
                                            ? PColor.jade(context)
                                            : PColor.inkFaint(context),
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  ach.title,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: isUnlocked
                                                        ? PColor.ink(context)
                                                        : PColor.inkSoft(
                                                            context),
                                                  ),
                                                ),
                                              ),
                                              if (isUnlocked)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: PColor.jadeSoft(
                                                        context),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    'ปลดล็อกแล้ว ✓',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: PColor.jadeInk(
                                                          context),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            ach.description,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: PColor.inkSoft(context),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '⚡ +${ach.xpReward} XP Reward',
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: PColor.primary(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
