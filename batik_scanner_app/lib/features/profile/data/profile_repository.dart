import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/gamification/xp_system.dart';
import '../../../core/supabase/supabase_provider.dart';
import '../../../core/utils/app_dates.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/user_profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(supabaseClientProvider));
});

final currentProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return null;
  }
  return ref.watch(profileRepositoryProvider).fetchOrCreate(user);
});

class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;

  Future<UserProfile?> fetchProfile(String userId) async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (row == null) {
      return null;
    }
    return UserProfile.fromJson(Map<String, dynamic>.from(row));
  }

  Future<UserProfile> fetchOrCreate(User user) async {
    final existing = await fetchProfile(user.id);
    if (existing != null) {
      return existing;
    }

    final metadata = user.userMetadata ?? <String, dynamic>{};
    final fallbackName = user.email?.split('@').first ?? 'Batik Learner';
    final row = await _client
        .from('profiles')
        .upsert({
          'id': user.id,
          'name': metadata['name']?.toString() ?? fallbackName,
          'email': user.email ?? '',
          'region': metadata['region']?.toString() ?? '',
          'xp': 0,
          'level': 1,
          'rank': XpSystem.rankForLevel(1),
          'streak': 0,
        })
        .select()
        .single();

    return UserProfile.fromJson(Map<String, dynamic>.from(row));
  }

  Future<UserProfile> requireProfile(String userId) async {
    final profile = await fetchProfile(userId);
    if (profile == null) {
      throw StateError('Profile not found for current user.');
    }
    return profile;
  }

  Future<void> addXp(String userId, int amount) async {
    if (amount <= 0) {
      return;
    }
    final profile = await requireProfile(userId);
    final nextXp = profile.xp + amount;
    final nextLevel = XpSystem.levelForXp(nextXp);

    await _client
        .from('profiles')
        .update({
          'xp': nextXp,
          'level': nextLevel,
          'rank': XpSystem.rankForLevel(nextLevel),
        })
        .eq('id', userId);
  }

  Future<void> recordLogin(String userId) async {
    final profile = await requireProfile(userId);
    final updates = <String, dynamic>{'last_login_date': AppDates.todayKey()};

    if (AppDates.isBeforeYesterday(profile.lastStreakDate)) {
      updates['streak'] = 0;
      updates['last_streak_date'] = null;
    }

    await _client.from('profiles').update(updates).eq('id', userId);
  }

  Future<void> evaluateStreakAfterActivity(String userId) async {
    final profile = await requireProfile(userId);
    if (!AppDates.isToday(profile.lastLoginDate) ||
        AppDates.isToday(profile.lastStreakDate)) {
      return;
    }

    final nextStreak = AppDates.isYesterday(profile.lastStreakDate)
        ? profile.streak + 1
        : 1;
    var nextXp = profile.xp;
    final badges = [...profile.badges];

    if (nextStreak == 3) {
      nextXp += 50;
    } else if (nextStreak == 7) {
      nextXp += 100;
    } else if (nextStreak == 30 && !badges.contains('30 Hari Konsisten')) {
      badges.add('30 Hari Konsisten');
    }

    final nextLevel = XpSystem.levelForXp(nextXp);
    await _client
        .from('profiles')
        .update({
          'streak': nextStreak,
          'last_activity_date': AppDates.todayKey(),
          'last_streak_date': AppDates.todayKey(),
          'xp': nextXp,
          'level': nextLevel,
          'rank': XpSystem.rankForLevel(nextLevel),
          'badges': badges,
        })
        .eq('id', userId);
  }
}
