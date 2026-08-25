# 05: FloatingXpToast & Haptic Gamification Feedback Loop

**What to build:** Create a non-blocking animated FloatingXpToast notification with subtle device haptic feedback upon logging transactions, removing blocking popup dialogs to allow continuous fast logging.

**Blocked by:** 03: SmartNumpad Component & All-in-One QuickAdd Sheet

**Status:** ready-for-agent

- [ ] Build `FloatingXpToast` component with XP gain animation
- [ ] Trigger `HapticFeedback.lightImpact()` on transaction creation
- [ ] Deprecate blocking ExpRewardDialog on routine transaction logging while keeping LevelUpDialog for milestones
