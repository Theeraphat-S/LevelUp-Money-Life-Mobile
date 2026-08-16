import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/domain/repositories/gamification_repository.dart';
import 'package:mobile_app_standard/domain/repositories/user_repository.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/shared/bloc/app/app_bloc.dart';
import 'package:mobile_app_standard/shared/components/gamification_badges.dart';
import 'package:mobile_app_standard/shared/components/header_command_deck.dart';

void main() {
  late AppDatabase db;
  late GamificationRepository gamificationRepo;
  late UserRepository userRepo;
  late AppGlobalBloc appGlobalBloc;
  late GamificationBloc gamificationBloc;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.initDatabase();
    gamificationRepo = GamificationRepository(db);
    userRepo = UserRepository(db);
    appGlobalBloc = AppGlobalBloc(db);
    gamificationBloc = GamificationBloc(
      gamificationRepository: gamificationRepo,
      userRepository: userRepo,
    );
    gamificationBloc.add(const LoadGamificationDataEvent());
  });

  tearDown(() async {
    await appGlobalBloc.close();
    await gamificationBloc.close();
    await db.close();
  });

  Widget buildTestableHeader({required double width, double height = 640}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: Size(width, height),
          padding: const EdgeInsets.only(top: 24),
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppGlobalBloc>.value(value: appGlobalBloc),
            BlocProvider<GamificationBloc>.value(value: gamificationBloc),
          ],
          child: Scaffold(
            appBar: HeaderCommandDeck(
              onOpenQuests: () {},
            ),
            body: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  group('HeaderCommandDeck Layout Tests', () {
    testWidgets('Renders without overflow on 360dp width screen',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableHeader(width: 360));
      await tester.pumpAndSettle();

      expect(find.byType(HeaderCommandDeck), findsOneWidget);
      expect(find.text('LevelUp Money Life'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders without overflow on compact 320dp width screen',
        (tester) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableHeader(width: 320));
      await tester.pumpAndSettle();

      expect(find.byType(HeaderCommandDeck), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Gamification Badges Tests', () {
    testWidgets('LevelRankBadge handles long rank titles gracefully without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(300, 100);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 140,
              child: Row(
                children: [
                  Flexible(
                    child: LevelRankBadge(
                      level: 10,
                      rankTitle: 'Grandmaster Financial Sovereign of the Realm',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LevelRankBadge), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('StreakBadge displays compact streak days correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StreakBadge(streakDays: 5),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5 d streak'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
