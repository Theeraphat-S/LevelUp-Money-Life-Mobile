# 02: Reactive Drift SQLite Stream Subscriptions

**What to build:** Enable reactive streams in TransactionRepository using Drift SQLite `watch()` query, and update DashboardBloc, BudgetBloc, and GamificationBloc to reactively listen to database mutations, eliminating manual UI multi-Bloc dispatch calls.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] Add `watchTransactions({String? monthFilter})` in `TransactionRepository`
- [ ] Connect `DashboardBloc` to subscribe to the transaction stream and auto-refresh financial metrics
- [ ] Connect `BudgetBloc` to auto-calculate category spending upon database changes
- [ ] Connect `GamificationBloc` to update XP and quest progress reactively
- [ ] Remove redundant manual cross-Bloc dispatch chains in UI widgets
