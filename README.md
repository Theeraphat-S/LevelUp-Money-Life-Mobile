# LevelUp Money Life (Mobile App)

> **LevelUp Money Life** — แอปพลิเคชันบันทึกและบริหารจัดการการเงินส่วนบุคคล (Personal Finance) ที่ผสานระบบ **Gamification & RPG Elements** เพื่อเปลี่ยนการสร้างวินัยทางการเงินให้สนุกและท้าทายยิ่งขึ้น พัฒนาด้วย Flutter ตามสถาปัตยกรรม Clean / Feature-Driven Architecture และ BLoC Pattern

---

## 📑 สารบัญ (Table of Contents)

- [ฟีเจอร์หลัก (Key Features)](#-ฟีเจอร์หลัก-key-features)
- [เทคโนโลยีและเครื่องมือ (Tech Stack)](#-เทคโนโลยีและเครื่องมือ-tech-stack)
- [โครงสร้างโปรเจกต์ (Project Structure)](#-โครงสร้างโปรเจกต์-project-structure)
- [เริ่มต้นพัฒนา (Getting Started)](#-เริ่มต้นพัฒนา-getting-started)
  - [ความต้องการเบื้องต้น (Prerequisites)](#ความต้องการเบื้องต้น-prerequisites)
  - [การติดตั้งและรันโปรเจกต์ (Installation & Run)](#การติดตั้งและรันโปรเจกต์-installation--run)
  - [การจัดการ Environment (.env)](#การจัดการ-environment-env)
- [การสร้างโค้ดอัตโนมัติ (Code Generation)](#-การสร้างโค้ดอัตโนมัติ-code-generation)
  - [Build Runner (Database & Routing)](#1-build-runner-database--routing)
  - [ระบบแปลภาษา (i18n / Localization)](#2-ระบบแปลภาษา-i18n--localization)
- [คำสั่งและสคริปต์สำหรับการพัฒนา (Development Scripts)](#-คำสั่งและสคริปต์สำหรับการพัฒนา-development-scripts)
  - [สร้าง Feature ใหม่ด้วย Script](#สร้าง-feature-ใหม่ด้วย-script)
  - [Flavors & การ Build แอป](#flavors--การ-build-แอป)
- [ฐานข้อมูลและการจัดเก็บข้อมูล (Storage & Database)](#-ฐานข้อมูลและการจัดเก็บข้อมูล-storage--database)
  - [Drift (SQLite)](#drift-sqlite)
  - [Hive (Local Cache / Key-Value)](#hive-local-cache--key-value)
- [แนวทางการเขียนโค้ด (Best Practices & Conventions)](#-แนวทางการเขียนโค้ด-best-practices--conventions)
- [การ Build และ Deploy สำหรับ iOS / Android](#-การ-build-และ-deploy-สำหรับ-ios--android)

---

## ✨ ฟีเจอร์หลัก (Key Features)

- 🎮 **Gamification & RPG System**
  - แสดงสถานะตัวละคร (Level, EXP bar, Status HP)
  - ระบบ Daily Quests และ Achievements ทางการเงิน
  - มอบ EXP และ Level Up เมื่อมีวินัยในการบันทึกรายรับ-รายจ่าย
- 📊 **Financial Dashboard**
  - ภาพรวมยอดเงินคงเหลือ รายรับ และรายจ่ายประจำเดือน/วัน
  - สรุปงบประมาณ (Budget Overview) และสถานะทางการเงิน
  - รายการธุรกรรมล่าสุด (Recent Transactions)
- 💸 **Transaction Management**
  - บันทึกรายรับ-รายจ่าย ระบุหมวดหมู่ จำนวนเงิน และบันทึกข้อความ
  - แสดงประวัติรายการย้อนหลังพร้อมตัวกรอง
- 🌐 **Multi-Language (i18n)**
  - รองรับทั้งภาษาไทยและภาษาอังกฤษ (Thai / English)
  - สลับภาษาได้ทันทีแบบ Dynamic ภายในแอป
- 🗄️ **Local-first Architecture**
  - ใช้งานแบบ Offline ได้ด้วย SQLite (Drift) และ Local Caching (Hive)

---

## 🛠️ เทคโนโลยีและเครื่องมือ (Tech Stack)

| ส่วนประกอบ | เทคโนโลยี / ไลบรารี | รายละเอียด |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart SDK `^3.10.8`, FVM `3.38.9`) | Multi-platform Mobile Development |
| **State Management** | `flutter_bloc` & `equatable` | BLoC Pattern สำหรับการจัดการ State |
| **Dependency Injection** | `get_it` | Service Locator & Dependency Injection |
| **Routing / Navigation** | `auto_route` & `auto_route_generator` | Strongly-typed Routing & Deep Linking |
| **Local Database** | `drift` & `drift_flutter` | SQLite ORM สำหรับตารางข้อมูลหลัก |
| **Key-Value Storage** | `hive` & `hive_flutter` | Local Storage ความเร็วสูงสำหรับ Cache |
| **Networking & HTTP** | `dio` & `web_socket_channel` | REST API Client และ WebSocket Integration |
| **Localization** | `flutter_localizations` & `intl` | จัดการภาษา i18n ด้วย `.arb` Files |
| **Design System / UI** | `flutter_tailwind_colors`, `skeletonizer`, `toastification` | Design Tokens, Skeleton Loaders, Toast Notifications |

---

## 📁 โครงสร้างโปรเจกต์ (Project Structure)

```bash
lib/
├── config/                        # การตั้งค่าแอป เช่น โหลด Environment Variables
│   └── config.dart
├── domain/                        # Data Layer / Business Logic Core
│   ├── datasource/
│   │   ├── app_datebase.dart      # Drift Database Configuration (SQLite)
│   │   ├── app_datebase.g.dart    # Generated Database Code
│   │   └── hive_config.dart       # Hive Local Storage Setup
│   ├── dto/                       # Data Transfer Objects
│   ├── http_client/
│   │   ├── api_client.dart        # Dio HTTP Client
│   │   ├── ip.dart                # IP Service Client
│   │   └── websocket.dart         # WebSocket Connection Handler
│   ├── models/                    # Data Entities & Database Tables
│   │   ├── budget/                # โมเดลงบประมาณ
│   │   ├── gamification/          # โมเดลระบบ Quest, Level, EXP
│   │   ├── todo_table.dart        # ตัวอย่างโมเดล Todo Table
│   │   └── transaction/           # โมเดลธุรกรรม รายรับ-รายจ่าย
│   └── repositories/              # Repository Interfaces & Implementations
│       ├── budget_repository.dart
│       ├── gamification_repository.dart
│       ├── todo_repo.dart
│       ├── transaction_repository.dart
│       └── user_repository.dart
├── feature/                       # Presentation Layer (แยกตาม Feature)
│   ├── dashboard/                 # หน้าหลักแสดงภาพรวมการเงินและ RPG HUD
│   │   ├── bloc/                  # DashboardBloc, Event, State
│   │   ├── pages/                 # DashboardPage
│   │   └── widgets/               # FinancialOverview, RPGHudCard, DailyQuests, RecentTransactions
│   ├── gamification/              # ระบบเควส เลเวล และความสำเร็จ
│   │   ├── bloc/                  # GamificationBloc
│   │   └── pages/                 # QuestPage
│   ├── transaction/               # ระบบบันทึกและจัดการธุรกรรม
│   │   ├── bloc/                  # TransactionBloc
│   │   ├── pages/                 # TransactionPage
│   │   └── widgets/               # AddTransactionSheet, ExpRewardDialog
│   ├── home/                      # หน้า Home & WebSocket Demo
│   │   ├── bloc/
│   │   └── pages/
│   └── todo/                      # ตัวอย่างระบบ Todo CRUD
│       ├── bloc/
│       ├── pages/
│       └── widgets/
├── i18n/                          # การจัดการภาษาและคำแปล
│   ├── i18n.dart                  # Generated Localization Aggregator
│   └── locals/                    # ไฟล์ .arb แยกตามหน้าและโมดูล
│       ├── appbar/
│       ├── general/
│       ├── home_page/
│       └── todo_page/
├── router/                        # AutoRoute Configuration
│   ├── router.dart
│   └── router.gr.dart             # Generated Route Configuration
├── shared/                        # สิ่งที่ใช้ร่วมกันทั่วทั้งแอป
│   ├── bloc/                      # Shared BLoCs (เช่น LanguageBloc)
│   ├── components/                # Reusable UI Widgets (AppBar, Dropdowns, Cards)
│   ├── styles/                    # Typography & TextStyles
│   ├── tokens/                    # Design Tokens (Colors, Spacing, Radius, Shadow, Size)
│   └── utils/                     # Utility Functions (Debouncer, Formatters)
├── locator.dart                   # GetIt Dependency Injection Registration
└── main.dart                      # App Entry Point & Provider Setup
```

---

## 🚀 เริ่มต้นพัฒนา (Getting Started)

### ความต้องการเบื้องต้น (Prerequisites)

- [Flutter Version Management (FVM)](https://fvm.app/) หรือ Flutter SDK (เวอร์ชันแนะนำ: `3.38.9`)
- Dart SDK `^3.10.8`
- Android Studio / Xcode สำหรับการรัน Emulator / Simulator

### การติดตั้งและรันโปรเจกต์ (Installation & Run)

1. **Clone repository และเข้าสู่โฟลเดอร์โปรเจกต์:**
   ```bash
   git clone https://github.com/Theeraphat-S/LevelUp-Money-Life-Mobile.git
   cd LevelUp-Money-Life-Mobile
   ```

2. **เลือกใช้เวอร์ชัน Flutter ผ่าน FVM:**
   ```bash
   fvm use 3.38.9
   ```

3. **ติดตั้ง Dependencies:**
   ```bash
   fvm flutter pub get
   ```

4. **สร้างไฟล์ Code Generation (Drift, AutoRoute):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **สร้างไฟล์ระบบภาษา (i18n):**
   ```bash
   ./generate_i18n.sh
   # หรือสำหรับ Windows PowerShell / Git Bash:
   # bash generate_i18n.sh
   ```

6. **เปิด Emulator / ต่ออุปกรณ์จริง แล้วเริ่มรันแอป:**
   ```bash
   fvm flutter run
   ```

---

### การจัดการ Environment (.env)

คัดลอกไฟล์ตัวอย่าง `.env.example` ไปเป็น `.env`:

```bash
cp .env.example .env
```

กำหนดค่าตัวแปรใน `.env`:
```env
API_CHECK_IP=https://api.ipify.org?format=json
WS_URL=wss://echo.websocket.org
```

---

## ⚙️ การสร้างโค้ดอัตโนมัติ (Code Generation)

### 1. Build Runner (Database & Routing)

เมื่อมีการแก้ไขตารางใน Drift Database (`app_datebase.dart`, `*_table.dart`) หรือเพิ่ม Route ใหม่ใน `router.dart`:

```bash
# Build รอบเดียว
dart run build_runner build --delete-conflicting-outputs

# หรือ Watch mode เพื่อ build อัตโนมัติเมื่อไฟล์เปลี่ยน
dart run build_runner watch --delete-conflicting-outputs
```

### 2. ระบบแปลภาษา (i18n / Localization)

โปรเจกต์มีสคริปต์ `generate_i18n.sh` ที่ช่วยรวบรวมไฟล์ `.arb` จากทุกโฟลเดอร์ใน `lib/i18n/locals/`:

- เมื่อต้องการเพิ่มหน้าใหม่ (เช่น `quest_page`):
  1. สร้างโฟลเดอร์ `lib/i18n/locals/quest_page/`
  2. สร้างไฟล์ `en.arb` และ `th.arb`
  3. รันคำสั่ง:
     ```bash
     ./generate_i18n.sh
     ```
  4. สคริปต์จะสร้างคลาส Localization และอัปเดตไฟล์ `lib/i18n/i18n.dart` ให้อัตโนมัติ

---

## 💻 คำสั่งและสคริปต์สำหรับการพัฒนา (Development Scripts)

### สร้าง Feature ใหม่ด้วย Script

โปรเจกต์มีสคริปต์ `create_feature.sh` สำหรับ Scaffold โครงสร้าง BLoC, Models, Page, Widgets ของ Feature ใหม่อย่างรวดเร็ว:

```bash
chmod +x create_feature.sh

# รูปแบบคำสั่ง:
# ./create_feature.sh <feature_name> [--appbar|-a] [--bottombar|-b]

# ตัวอย่างการสร้าง:
./create_feature.sh budget
./create_feature.sh profile --appbar
```

### Flavors & การ Build แอป

โปรเจกต์รองรับ 3 Flavors ได้แก่ `local`, `dev`, และ `prod`:

#### การรันตาม Flavor
```bash
# รันโหมด Dev
fvm flutter run --flavor dev -t lib/main.dart --dart-define=flavor=dev

# รันโหมด Prod
fvm flutter run --flavor prod -t lib/main.dart --dart-define=flavor=prod
```

#### การ Build ผ่าน Shell Script & Batch File

- **Android (APK):**
  ```bash
  ./build_apk_dev.sh     # Build APK สำหรับ Dev
  ./build_apk_prod.sh    # Build APK สำหรับ Production
  ```
- **Windows Desktop:**
  ```cmd
  build_windows_dev.bat
  build_windows_prod.bat
  ```
- **iOS (IPA):**
  ```bash
  ./build_ipa_dev.sh
  ```

---

## 💽 ฐานข้อมูลและการจัดเก็บข้อมูล (Storage & Database)

### Drift (SQLite)

- จัดเก็บตารางข้อมูลหลักแบบ Relation
- ไฟล์คอนฟิก: [app_datebase.dart](file:///lib/domain/datasource/app_datebase.dart)
- วิธีดึงไฟล์ฐานข้อมูลจาก Android Emulator ออกมาดู:
  ```bash
  adb exec-out run-as com.fldp.mobileApp cat /data/data/com.fldp.mobileApp.dev/app_flutter/db.sqlite > local_db.sqlite
  ```

### Hive (Local Cache / Key-Value)

- ใช้สำหรับเก็บการตั้งค่า, ข้อมูล Session, Token หรือ Cache ความเร็วสูง
- จัดการผ่าน [hive_config.dart](file:///lib/domain/datasource/hive_config.dart):
  ```dart
  import 'package:mobile_app_standard/domain/datasource/hive_config.dart';

  final box = await HiveConfig.openBox<String>('cache_box');
  await box.put('key', 'value');
  final value = box.get('key');
  ```

---

## 📐 แนวทางการเขียนโค้ด (Best Practices & Conventions)

### การตั้งชื่อ (Naming Conventions)
- **ไฟล์และโฟลเดอร์:** ใช้ `lowercase_with_underscores` เช่น `transaction_bloc.dart`, `rpg_hud_card.dart`
- **คลาสและ Type:** ใช้ `UpperCamelCase` เช่น `DashboardBloc`, `TransactionModel`
- **ตัวแปรและฟังก์ชัน:** ใช้ `lowerCamelCase` เช่น `fetchUserData()`, `dailyQuests`
- **ตัวแปร Private:** ขึ้นต้นด้วย `_` เช่น `_appRouter`, `_currentHp`
- **Constants:** ใช้ `UPPER_CASE` หรือ `lowerCamelCase` ให้สอดคล้องกัน

### การจัดการ Dependency Injection
- ทำการ Register dependencies, Blocs และ Repositories ใน [lib/locator.dart](file:///lib/locator.dart)
- สำหรับ Repository และ Client ใช้ `registerLazySingleton`
- สำหรับ BLoC ของ Feature แต่ละหน้าใช้ `registerFactory`

---

## 📱 การ Build และ Deploy สำหรับ iOS / Android

### Fastlane

ติดตั้งและตั้งค่า Fastlane สำหรับ automate การ build และ deploy:

```bash
# ติดตั้ง Fastlane (macOS)
brew install fastlane

# ตรวจสอบการติดตั้ง
fastlane --version

# เรียกใช้งานผ่าน Bundle
bundle install
bundle exec fastlane [lane_name]
```

### iOS Setup & Code Signing

1. เปิด Workspace ใน Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. ติดตั้ง CocoaPods:
   ```bash
   cd ios && pod install
   ```
3. ตั้งค่า **Signing & Capabilities** โดยเลือก Development Team และ Bundle Identifier
4. สำหรับการ Release สู่ TestFlight/App Store ใช้ `fvm flutter build ipa --release` หรืออัปโหลดผ่าน **Transporter** / `xcrun notarytool`

---

## 👥 Authors & License

- **Repository:** [LevelUp-Money-Life-Mobile](https://github.com/Theeraphat-S/LevelUp-Money-Life-Mobile)
- พัฒนาเพื่อการเรียนรู้และยกระดับการบริหารการเงินส่วนบุคคล
