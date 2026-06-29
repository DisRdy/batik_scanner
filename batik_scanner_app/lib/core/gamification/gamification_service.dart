import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/daily_task/data/daily_task_repository.dart';
import '../../features/encyclopedia/data/batik_repository.dart';
import '../../features/encyclopedia/domain/batik_category.dart';
import '../../features/profile/data/profile_repository.dart';
import 'xp_system.dart';

final gamificationServiceProvider = Provider<GamificationService>((ref) {
  return GamificationService(
    profileRepository: ref.watch(profileRepositoryProvider),
    dailyTaskRepository: ref.watch(dailyTaskRepositoryProvider),
    batikRepository: ref.watch(batikRepositoryProvider),
  );
});

class GamificationService {
  GamificationService({
    required ProfileRepository profileRepository,
    required DailyTaskRepository dailyTaskRepository,
    required BatikRepository batikRepository,
  }) : _profileRepository = profileRepository,
       _dailyTaskRepository = dailyTaskRepository,
       _batikRepository = batikRepository;

  final ProfileRepository _profileRepository;
  final DailyTaskRepository _dailyTaskRepository;
  final BatikRepository _batikRepository;

  Future<void> recordLogin(String userId) async {
    await _profileRepository.recordLogin(userId);
    await _dailyTaskRepository.ensureTodayTasks(userId);
    await _dailyTaskRepository.completeForActivity(
      userId: userId,
      taskKeys: const {DailyTaskKeys.loginToday},
    );
  }

  Future<void> recordEncyclopediaOpened(String userId) async {
    await _dailyTaskRepository.ensureTodayTasks(userId);
    await _dailyTaskRepository.completeForActivity(
      userId: userId,
      taskKeys: const {DailyTaskKeys.openEncyclopedia},
    );
    await _profileRepository.evaluateStreakAfterActivity(userId);
  }

  Future<void> recordCategoryRead({
    required String userId,
    required BatikCategory category,
  }) async {
    final isNewRead = await _batikRepository.markCategoryViewed(
      userId: userId,
      categoryId: category.id,
    );

    if (isNewRead) {
      await _profileRepository.addXp(userId, XpSystem.encyclopediaReadXp);
    }

    await _dailyTaskRepository.ensureTodayTasks(userId);
    await _dailyTaskRepository.completeForActivity(
      userId: userId,
      taskKeys: const {DailyTaskKeys.readCategory, DailyTaskKeys.learnOrigin},
      categoryName: category.name,
    );
    await _profileRepository.evaluateStreakAfterActivity(userId);
  }

  Future<void> recordUpload({
    required String userId,
    required String categoryName,
  }) async {
    await _profileRepository.addXp(userId, XpSystem.uploadBatikXp);
    await _dailyTaskRepository.ensureTodayTasks(userId);
    await _dailyTaskRepository.completeForActivity(
      userId: userId,
      taskKeys: const {DailyTaskKeys.uploadPhoto, DailyTaskKeys.uploadFavorite},
      categoryName: categoryName,
    );
    await _profileRepository.evaluateStreakAfterActivity(userId);
  }
}
