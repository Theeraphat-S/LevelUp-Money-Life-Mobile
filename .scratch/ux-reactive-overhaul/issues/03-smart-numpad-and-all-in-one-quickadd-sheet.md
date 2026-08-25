# 03: SmartNumpad Component & All-in-One QuickAdd Sheet

**What to build:** Build an in-app custom calculator-style numeric keypad (`SmartNumpad`) and integrate it into `QuickAddSheet` with 1-tap category selection ribbons and inline note editing, removing system virtual keyboard popups and enabling 3-second transaction logging.

**Blocked by:** 02: Reactive Drift SQLite Stream Subscriptions

**Status:** ready-for-agent

- [ ] Create `SmartNumpad` widget with digits 0-9, decimal point, operators (+, -), backspace, clear, and confirm
- [ ] Redesign `QuickAddSheet` into an All-in-One view containing amount display, category ribbon, and SmartNumpad
- [ ] Wire save action to `TransactionBloc` and verify transaction creation
