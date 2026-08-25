# Specification: LevelUp Money Life - UX Usability Overhaul & Reactive Architecture

## Problem Statement

Users of personal finance applications face high friction and cognitive load when recording daily transactions. Currently in LevelUp Money Life:
1. Entering a single transaction requires switching focus between multiple form inputs and invoking the system virtual keyboard, taking upwards of 15–20 seconds per entry.
2. The persistent top navigation bar (CommandDeck) is vertically bloated (~108px), cluttering every screen with infrequently used system toggles (Theme, Language, Database Management) and stealing valuable screen space from financial insights and BentoCards.
3. Transaction creation does not reactively sync across all sub-domains; UI widgets must manually trigger multi-Bloc reloads across Dashboard, Budget, and Gamification.
4. After logging an expense or income, blocking dialog popups interrupt the user experience, making rapid back-to-back logging tedious.

## Solution

A high-speed, frictionless personal finance tracking experience powered by:
1. An **All-in-One SmartNumpad** bottom sheet featuring an embedded tactile calculator-style numeric pad, horizontal **QuickTemplate** shortcut chips, and one-tap category assignment to complete any entry in under 3 seconds.
2. A **Compact CommandDeck** (~56px) dedicated strictly to month navigation and app identity, with system preferences consolidated into a sleek **SettingsSheet** accessed via a top-right profile avatar.
3. An **Autonomous Reactive Drift Database Layer** using SQLite streams (`watch()`) that automatically propagates data mutations to all domain state managers without manual cross-Bloc dispatch chains.
4. A **Non-blocking FloatingXpToast** coupled with light tactile haptic feedback for instant reward feedback without stopping user workflow.

---

## User Stories

1. As a daily app user, I want to tap an "Add Expense" or "Add Income" button and immediately see an in-app SmartNumpad, so that I do not have to wait for the mobile device keyboard to slide up.
2. As a daily app user, I want to type numbers and perform basic math directly on the SmartNumpad, so that I can calculate split bills or combined costs before saving.
3. As a frequent buyer, I want to see QuickTemplate chips (e.g., Coffee, Lunch, Transportation) at the top of the input sheet, so that I can log recurring expenses in a single tap.
4. As a user, I want my top 5 most frequent transactions to be automatically suggested as QuickTemplates, so that I do not need to configure templates manually.
5. As a user, I want to pin custom favorite transaction templates to my QuickTemplates list, so that my personal recurring transactions are always available.
6. As a user, I want to select a category with a single tap from a clean horizontal ribbon without leaving the numeric input view, so that I can categorize transactions effortlessly.
7. As a gamer, I want to receive instant XP rewards and haptic feedback via a FloatingXpToast upon logging a transaction, so that I feel rewarded without having to dismiss a popup dialog.
8. As a user reviewing finances, I want a compact top navigation bar that maximizes vertical screen space, so that I can view my balance, net savings, quests, and recent transactions without excessive scrolling.
9. As a user, I want to access Theme switching, Language preferences, and Data Backup/Restore from a single SettingsSheet via the top-right avatar, so that the main screen remains clean and uncluttered.
10. As a multi-screen user, I want any newly added transaction to instantly update the Dashboard metrics, Budget limits, and Gamification level across all tabs simultaneously, so that financial data is always synchronized and reliable.
11. As an offline user, I want all transactions, template preferences, and gamification state stored locally on-device, so that the app works instantly without network connectivity.

---

## Implementation Decisions

### 1. SmartNumpad & QuickAdd Sheet Architecture
- Consolidate input into an all-in-one bottom sheet containing:
  - Header: Transaction type toggle (Expense / Income) & date selector.
  - QuickTemplate Ribbon: Horizontal scrollable chips showing pinned and frequent transactions.
  - Amount & Note Display: Large currency typography with an integrated note badge.
  - Category Selector: Scrollable category icons with active state indicators.
  - Custom SmartNumpad: 4x4 grid containing digits `0-9`, decimal point `.`, backspace `⌫`, clear `C`, arithmetic operators `+`, `-`, and a primary confirm `✓` button.

### 2. QuickTemplate Engine & Storage
- Pinned favorites are stored in a persistent Hive key-value box (`quick_templates_box`).
- Dynamic frequent templates are evaluated by querying the local database for highest frequency name/category pairs over the past 30 days.

### 3. Compact CommandDeck & SettingsSheet Consolidation
- Reduce `HeaderCommandDeck` preferred height from 108px to ~56px.
- Retain only App Branding, Month Navigation Selector, and Top-Right Profile Avatar.
- Create a dedicated `SettingsSheet` containing:
  - User Rank & XP Progress Summary.
  - Language Selector (Thai / English).
  - Theme Mode Toggle (System / Light / Dark).
  - Data Management triggers (Export JSON, Import JSON, Clear Cache).

### 4. Reactive State Synchronization (Drift SQLite Watchers)
- TransactionRepository exposes reactive Dart streams (`Stream<List<TransactionItem>>`) driven by Drift query `watch()`.
- Feature BLoCs (DashboardBloc, BudgetBloc, GamificationBloc) subscribe to repository streams on initialization and emit updated states reactively whenever database changes occur.
- Eliminate manual multi-Bloc dispatch calls in UI event handlers.

### 5. Gamification Micro-Interactions & Feedback
- Replace blocking modal reward dialogs with an animated FloatingXpToast overlay.
- Trigger standard device haptic feedback upon successful transaction entry.
- Reserve full celebratory modal dialogs strictly for Level-Up events.

---

## Testing Decisions

### Good Test Criteria
- Tests must verify observable user behavior and state outputs rather than internal class implementations.
- Tests should operate at the highest possible integration seam.

### Testing Seams & Targets
- **Seam 1: Repository Reactive Stream Seam**:
  - Test that inserting a transaction into SQLite triggers the `TransactionRepository.watchTransactions()` stream with the updated transaction list.
- **Seam 2: BLoC State Reaction Seam**:
  - Test that `DashboardBloc`, `BudgetBloc`, and `GamificationBloc` emit updated summaries and XP progression automatically when the underlying repository stream emits.
- **Seam 3: SmartNumpad & QuickAdd Interaction Seam**:
  - Widget test verifying that tapping numpad digits 5, 0, selecting Food, and tapping confirm saves a transaction of ฿50.00 and triggers success state.

### Prior Art
- Standard Flutter Bloc testing via `bloc_test` package.
- Drift database testing with in-memory SQLite database executor.

---

## Out of Scope

- Cloud database backend synchronization (Firebase / Supabase) and user authentication (OAuth).
- Camera hardware OCR scanning engine (current slip scanner remains a structured parser).
- Multiplayer leaderboards or social sharing features.

---

## Further Notes

- All design decisions in this spec adhere to ADRs 0001 through 0008 located in `docs/adr/`.
- Domain terminology strictly follows `CONTEXT.md`.
