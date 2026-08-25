# 7. Quick Template Storage and Frequent Detection

**Context & Decision**: 
To provide rapid 1-tap logging without tedious manual configuration, we decided to combine dynamic frequency analysis (querying top recurring transactions) with a local Hive Box for user-pinned favorites.

**Consequences**: 
- Instant zero-setup convenience for new and existing users based on past transaction patterns.
- Fast read/write via Hive for pinned custom templates without SQLite schema migrations.
