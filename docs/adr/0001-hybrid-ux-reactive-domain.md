# 1. Hybrid UX Overhaul & Reactive Domain Architecture

**Context & Decision**: 
The application suffered from user friction during transaction logging and visual clutter on dashboard screens, along with manual multi-Bloc synchronization calls. We decided on a dual-focus strategy: prioritize high-speed UX logging and clean UI presentation while restructuring cross-feature data flow through reactive event streams (Transaction -> Gamification -> Budget).

**Consequences**: 
- Reduces user logging time and bounce rate.
- Streamlines BLoC logic by removing redundant manual event dispatches across disparate UI widgets.
- Requires building reactive synchronization channels or domain events.
