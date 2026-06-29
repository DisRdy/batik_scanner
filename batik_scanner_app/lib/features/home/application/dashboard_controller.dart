import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/gamification/gamification_service.dart';
import '../../auth/data/auth_repository.dart';
import '../../daily_task/data/daily_task_repository.dart';
import '../../profile/data/profile_repository.dart';

final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, void>(DashboardController.new);

class DashboardController extends AsyncNotifier<void> {
  bool _bootstrapped = false;

  @override
  FutureOr<void> build() {}

  Future<void> bootstrap() async {
    if (_bootstrapped) {
      return;
    }
    _bootstrapped = true;
    final user = ref.read(currentUserProvider);
    if (user == null) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(currentProfileProvider.future);
      await ref.read(gamificationServiceProvider).recordLogin(user.id);
      ref.invalidate(currentProfileProvider);
      ref.invalidate(todayTasksProvider);
    });
  }
}
