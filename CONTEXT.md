# Domain Context: LevelUp Money Life

## Language & Terminology

**Transaction (รายการธุรกรรม)**:
A discrete financial event recording income or expense, attributed to a date, category, amount, and status.
_Avoid_: Record, Entry, Todo

**SmartNumpad (แป้นตัวเลขอัจฉริยะ)**:
An embedded numeric keypad within the input sheet providing tactile amount entry, basic arithmetic operators, and instant submit actions.
_Avoid_: Native Keyboard, PinPad

**QuickTemplate (แม่แบบบันทึกด่วน)**:
Pre-configured transaction shortcuts (Name, Category, Default Amount) generated dynamically from recent frequency analysis and user-pinned favorites in Hive.
_Avoid_: Preset, Macro, Bookmark

**GamificationEngine (ระบบเกมและแรงจูงใจ)**:
The subsystem calculating experience points (XP), player levels, rank badges, streak multipliers, and quest completions based on financial activities.
_Avoid_: Score, Points, Rating

**FloatingXpToast (การแจ้งเตือน XP ลอย)**:
A lightweight, non-blocking toast notification accompanied by haptic feedback that animates XP gain without interrupting the user'\''s flow.
_Avoid_: Popup, Dialog, Alert

**CommandDeck (แถบควบคุมส่วนบน)**:
A slim, context-aware top navigation bar (~56-64px) displaying the active month filter and a top-right profile avatar.
_Avoid_: Overloaded AppBar, Navbar

**BentoCard (การ์ดข้อมูลแบบเบนโตะ)**:
A modular, high-contrast, rounded container used throughout dashboard views to group metrics, quests, and summaries.
_Avoid_: Tile, Box, Panel

**SettingsSheet (ศูนย์การตั้งค่าและโปรไฟล์)**:
A unified bottom modal panel accessible via the top-right profile avatar housing theme switching, language preferences, database backup/import, and user progression stats.
_Avoid_: Popup Menu, Config Modal, SettingsDrawer
