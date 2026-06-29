import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/gamification/gamification_service.dart';
import '../../auth/data/auth_repository.dart';
import '../../daily_task/data/daily_task_repository.dart';
import '../../profile/data/profile_repository.dart';
import '../data/batik_repository.dart';
import '../domain/batik_category.dart';

final encyclopediaSearchProvider = NotifierProvider<EncyclopediaSearch, String>(
  EncyclopediaSearch.new,
);
final encyclopediaFilterProvider =
    NotifierProvider<EncyclopediaFilter, String?>(EncyclopediaFilter.new);

class EncyclopediaSearch extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) {
    state = value;
  }
}

class EncyclopediaFilter extends Notifier<String?> {
  @override
  String? build() => null;

  void setFilter(String? value) {
    state = value;
  }
}

final filteredBatikCategoriesProvider =
    Provider<AsyncValue<List<BatikCategory>>>((ref) {
      final categories = ref.watch(batikCategoriesProvider);
      final query = ref.watch(encyclopediaSearchProvider).trim().toLowerCase();
      final filter = ref.watch(encyclopediaFilterProvider);

      return categories.whenData((items) {
        return items
            .where((category) {
              final matchesFilter = filter == null || category.name == filter;
              final matchesSearch =
                  query.isEmpty ||
                  category.name.toLowerCase().contains(query) ||
                  category.originRegion.toLowerCase().contains(query) ||
                  category.history.toLowerCase().contains(query) ||
                  category.philosophy.toLowerCase().contains(query);
              return matchesFilter && matchesSearch;
            })
            .toList(growable: false);
      });
    });

final encyclopediaControllerProvider =
    AsyncNotifierProvider<EncyclopediaController, void>(
      EncyclopediaController.new,
    );

class EncyclopediaController extends AsyncNotifier<void> {
  bool _openedTracked = false;

  @override
  FutureOr<void> build() {}

  Future<void> recordOpened() async {
    if (_openedTracked) {
      return;
    }
    _openedTracked = true;
    final user = ref.read(currentUserProvider);
    if (user == null) {
      return;
    }
    await ref
        .read(gamificationServiceProvider)
        .recordEncyclopediaOpened(user.id);
    ref.invalidate(currentProfileProvider);
    ref.invalidate(todayTasksProvider);
  }

  Future<void> recordRead(BatikCategory category) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(gamificationServiceProvider)
          .recordCategoryRead(userId: user.id, category: category);
      ref.invalidate(currentProfileProvider);
      ref.invalidate(todayTasksProvider);
      ref.invalidate(userProgressProvider(user.id));
      ref.invalidate(learnedCategoriesProvider(user.id));
    });
  }
}
