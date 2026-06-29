import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_provider.dart';
import '../../../core/utils/app_dates.dart';
import '../../auth/data/auth_repository.dart';
import '../../encyclopedia/data/batik_repository.dart';
import '../../profile/data/profile_repository.dart';
import '../../profile/domain/user_profile.dart';
import '../domain/daily_task.dart';
import '../domain/user_daily_task.dart';

final dailyTaskRepositoryProvider = Provider<DailyTaskRepository>((ref) {
  return DailyTaskRepository(
    client: ref.watch(supabaseClientProvider),
    batikRepository: ref.watch(batikRepositoryProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
  );
});

final todayTasksProvider = FutureProvider<List<UserDailyTask>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const [];
  }
  final repository = ref.watch(dailyTaskRepositoryProvider);
  await repository.ensureTodayTasks(user.id);
  return repository.fetchTodayTasks(user.id);
});

class DailyTaskKeys {
  const DailyTaskKeys._();

  static const uploadPhoto = 'upload_photo';
  static const readCategory = 'read_category';
  static const openEncyclopedia = 'open_encyclopedia';
  static const loginToday = 'login_today';
  static const learnOrigin = 'learn_origin';
  static const completeTwoActivities = 'complete_2_activities';
  static const uploadFavorite = 'upload_favorite';
}

class DailyTaskRepository {
  DailyTaskRepository({
    required SupabaseClient client,
    required BatikRepository batikRepository,
    required ProfileRepository profileRepository,
  }) : _client = client,
       _batikRepository = batikRepository,
       _profileRepository = profileRepository;

  final SupabaseClient _client;
  final BatikRepository _batikRepository;
  final ProfileRepository _profileRepository;

  Future<List<DailyTask>> fetchTaskPool() async {
    final rows = await _client
        .from('daily_tasks')
        .select()
        .order('title', ascending: true);

    return rows
        .map((row) => DailyTask.fromJson(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<List<UserDailyTask>> fetchTodayTasks(String userId) async {
    final rows = await _client
        .from('user_daily_tasks')
        .select(
          'id,user_id,task_id,completed,assigned_date,completed_at,'
          'daily_tasks(id,task_key,title,description,xp_reward,category_name)',
        )
        .eq('user_id', userId)
        .eq('assigned_date', AppDates.todayKey())
        .order('completed', ascending: true);

    return rows
        .map((row) => UserDailyTask.fromJson(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<void> ensureTodayTasks(String userId) async {
    final existing = await fetchTodayTasks(userId);
    if (existing.length >= 3) {
      return;
    }

    final profile = await _profileRepository.requireProfile(userId);
    final pool = await fetchTaskPool();
    if (pool.isEmpty) {
      return;
    }

    final progress = await _batikRepository.fetchProgress(userId);
    final categories = await _batikRepository.fetchCategories();
    final viewedCategoryIds = progress.map((item) => item.categoryId).toSet();
    final viewedNames = categories
        .where((category) => viewedCategoryIds.contains(category.id))
        .map((category) => category.name)
        .toSet();
    final hasUpload = await _hasUpload(userId);
    final alreadyAssigned = existing.map((item) => item.taskId).toSet();

    final scored =
        pool
            .where((task) => !alreadyAssigned.contains(task.id))
            .map(
              (task) => MapEntry(
                task,
                _scoreTask(
                  task: task,
                  profile: profile,
                  viewedCategoryNames: viewedNames,
                  hasUpload: hasUpload,
                ),
              ),
            )
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final selected = scored
        .take(3 - existing.length)
        .map((entry) => entry.key)
        .toList(growable: false);

    if (selected.isEmpty) {
      return;
    }

    await _client
        .from('user_daily_tasks')
        .insert(
          selected
              .map(
                (task) => {
                  'user_id': userId,
                  'task_id': task.id,
                  'assigned_date': AppDates.todayKey(),
                },
              )
              .toList(growable: false),
        );
  }

  Future<int> completeForActivity({
    required String userId,
    required Set<String> taskKeys,
    String? categoryName,
  }) async {
    final profile = await _profileRepository.requireProfile(userId);
    final tasks = await fetchTodayTasks(userId);
    var xpEarned = 0;

    for (final item in tasks.where((task) => !task.completed)) {
      final task = item.task;
      if (task == null) {
        continue;
      }
      final shouldComplete = _matchesActivity(
        task: task,
        taskKeys: taskKeys,
        categoryName: categoryName,
        profile: profile,
      );

      if (!shouldComplete) {
        continue;
      }

      await _completeTask(item.id);
      await _profileRepository.addXp(userId, task.xpReward);
      xpEarned += task.xpReward;
    }

    xpEarned += await _completeTwoActivityTaskIfReady(userId);
    return xpEarned;
  }

  Future<int> _completeTwoActivityTaskIfReady(String userId) async {
    final tasks = await fetchTodayTasks(userId);
    final completedCount = tasks.where((task) {
      final key = task.task?.taskKey;
      return task.completed &&
          key != DailyTaskKeys.loginToday &&
          key != DailyTaskKeys.completeTwoActivities;
    }).length;
    if (completedCount < 2) {
      return 0;
    }

    final target = tasks.where((item) {
      return !item.completed &&
          item.task?.taskKey == DailyTaskKeys.completeTwoActivities;
    }).firstOrNull;

    if (target == null || target.task == null) {
      return 0;
    }

    await _completeTask(target.id);
    await _profileRepository.addXp(userId, target.task!.xpReward);
    return target.task!.xpReward;
  }

  Future<void> _completeTask(String id) async {
    await _client
        .from('user_daily_tasks')
        .update({
          'completed': true,
          'completed_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }

  bool _matchesActivity({
    required DailyTask task,
    required Set<String> taskKeys,
    required UserProfile profile,
    String? categoryName,
  }) {
    if (task.taskKey == DailyTaskKeys.learnOrigin && categoryName != null) {
      return _preferredCategories(profile.region).contains(categoryName);
    }

    if (!taskKeys.contains(task.taskKey)) {
      return false;
    }

    if (task.taskKey == DailyTaskKeys.readCategory) {
      return task.categoryName == null || task.categoryName == categoryName;
    }

    return true;
  }

  int _scoreTask({
    required DailyTask task,
    required UserProfile profile,
    required Set<String> viewedCategoryNames,
    required bool hasUpload,
  }) {
    final preferred = _preferredCategories(profile.region);
    final categoryName = task.categoryName;

    var score = 10;
    if (task.taskKey == DailyTaskKeys.readCategory && categoryName != null) {
      score += 35;
      if (preferred.contains(categoryName)) {
        score += 35;
      }
      if (!viewedCategoryNames.contains(categoryName)) {
        score += 25;
      }
    }

    if (task.taskKey == DailyTaskKeys.learnOrigin) {
      score += preferred.isEmpty ? 5 : 45;
    }

    if (task.taskKey == DailyTaskKeys.uploadPhoto ||
        task.taskKey == DailyTaskKeys.uploadFavorite) {
      score += hasUpload ? 5 : 25;
    }

    if (task.taskKey == DailyTaskKeys.openEncyclopedia) {
      score += 12;
    }

    if (task.taskKey == DailyTaskKeys.completeTwoActivities) {
      score += 8;
    }

    if (task.taskKey == DailyTaskKeys.loginToday) {
      score += 6;
    }

    return score;
  }

  Future<bool> _hasUpload(String userId) async {
    final rows = await _client
        .from('user_batik_uploads')
        .select('id')
        .eq('user_id', userId)
        .limit(1);
    return rows.isNotEmpty;
  }

  List<String> _preferredCategories(String region) {
    final normalized = region.toLowerCase();
    if (normalized.contains('jawa tengah') ||
        normalized.contains('yogyakarta') ||
        normalized.contains('jogja') ||
        normalized.contains('solo')) {
      return const ['Parang', 'Kawung'];
    }
    if (normalized.contains('bali')) {
      return const ['Bali'];
    }
    if (normalized.contains('jawa barat') ||
        normalized.contains('cirebon') ||
        normalized.contains('bandung')) {
      return const ['Megamendung'];
    }
    return const ['Parang', 'Bali', 'Kawung', 'Megamendung'];
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
