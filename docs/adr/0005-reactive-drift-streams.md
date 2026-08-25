# 5. Reactive Drift Database Streams for Cross-Feature State

**Context & Decision**: 
Manually chaining multiple Bloc event dispatches from the UI led to tight coupling and potential state inconsistency across Dashboard, Gamification, and Budget. We decided to use Drift SQLite reactive streams (watch()) in the repository layer to propagate updates automatically to all subscribing Blocs.

**Consequences**: 
- Guarantees Single Source of Truth from the local SQLite database.
- Blocs stay lean and decoupled from one another.
- Automatic updates when background sync or batch operations occur.
