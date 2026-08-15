import 'package:mobile_app_standard/domain/http_client/api_client.dart';
import 'package:mobile_app_standard/domain/models/gamification/user_profile.dart';

abstract class UserRepositoryInterface {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> addExp(int expToAdd, {int coinsToAdd = 0});
  Future<UserProfile> checkInDaily();
}

class UserRepository implements UserRepositoryInterface {
  final ApiClient apiClient;

  // Local state cache for seamless offline / demo fallback
  UserProfile _cachedUser = UserProfile(
    id: 'user_hero_1',
    name: 'นักผจญภัยการเงิน',
    title: 'Novice Saver 🛡️',
    avatarUrl: '',
    level: 3,
    currentExp: 140,
    maxExp: 300,
    goldCoins: 350,
    streakDays: 4,
    lastCheckIn: DateTime.now().subtract(const Duration(hours: 3)),
    healthPoint: 92,
    manaPoint: 80,
  );

  UserRepository(this.apiClient);

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await apiClient.dio.get('/user/profile');
      if (response.statusCode == 200 && response.data != null) {
        _cachedUser = UserProfile.fromJson(response.data);
        return _cachedUser;
      }
    } catch (_) {
      // Graceful fallback to cached state
    }
    return _cachedUser;
  }

  @override
  Future<UserProfile> addExp(int expToAdd, {int coinsToAdd = 0}) async {
    int newExp = _cachedUser.currentExp + expToAdd;
    int newLevel = _cachedUser.level;
    int maxExp = _cachedUser.maxExp;

    while (newExp >= maxExp) {
      newExp -= maxExp;
      newLevel += 1;
      maxExp = (maxExp * 1.5).round();
    }

    String title = _cachedUser.title;
    if (newLevel >= 10) {
      title = 'Grand Finance Master 👑';
    } else if (newLevel >= 5) {
      title = 'Smart Investor ⚔️';
    } else if (newLevel >= 3) {
      title = 'Budget Explorer 🏹';
    }

    _cachedUser = _cachedUser.copyWith(
      level: newLevel,
      currentExp: newExp,
      maxExp: maxExp,
      goldCoins: _cachedUser.goldCoins + coinsToAdd,
      title: title,
    );

    try {
      await apiClient.dio.post('/user/exp', data: {
        'exp': expToAdd,
        'coins': coinsToAdd,
      });
    } catch (_) {}

    return _cachedUser;
  }

  @override
  Future<UserProfile> checkInDaily() async {
    final now = DateTime.now();
    final isNewDay = now.day != _cachedUser.lastCheckIn.day ||
        now.month != _cachedUser.lastCheckIn.month;

    int newStreak = isNewDay ? _cachedUser.streakDays + 1 : _cachedUser.streakDays;
    _cachedUser = _cachedUser.copyWith(
      streakDays: newStreak,
      lastCheckIn: now,
    );

    await addExp(20, coinsToAdd: 15);
    return _cachedUser;
  }
}
