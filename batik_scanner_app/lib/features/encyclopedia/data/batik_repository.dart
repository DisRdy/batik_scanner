import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_provider.dart';
import '../domain/batik_category.dart';
import '../domain/user_progress.dart';

final batikRepositoryProvider = Provider<BatikRepository>((ref) {
  return BatikRepository(ref.watch(supabaseClientProvider));
});

final batikCategoriesProvider = FutureProvider<List<BatikCategory>>((ref) {
  return ref.watch(batikRepositoryProvider).fetchCategories();
});

final batikCategoryProvider = FutureProvider.family<BatikCategory?, String>((
  ref,
  id,
) {
  return ref.watch(batikRepositoryProvider).fetchCategory(id);
});

final userProgressProvider = FutureProvider.family<List<UserProgress>, String>((
  ref,
  userId,
) {
  return ref.watch(batikRepositoryProvider).fetchProgress(userId);
});

final learnedCategoriesProvider =
    FutureProvider.family<List<BatikCategory>, String>((ref, userId) async {
      final categories = await ref.watch(batikCategoriesProvider.future);
      final progress = await ref.watch(userProgressProvider(userId).future);
      final learnedIds = progress.map((item) => item.categoryId).toSet();
      return categories
          .where((category) => learnedIds.contains(category.id))
          .toList();
    });

class BatikRepository {
  BatikRepository(this._client);

  final SupabaseClient _client;

  Future<List<BatikCategory>> fetchCategories() async {
    final rows = await _client
        .from('batik_categories')
        .select()
        .order('name', ascending: true);

    return rows
        .map((row) => BatikCategory.fromJson(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<BatikCategory?> fetchCategory(String id) async {
    final row = await _client
        .from('batik_categories')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (row == null) {
      return null;
    }
    return BatikCategory.fromJson(Map<String, dynamic>.from(row));
  }

  Future<List<UserProgress>> fetchProgress(String userId) async {
    final rows = await _client
        .from('user_progress')
        .select()
        .eq('user_id', userId)
        .eq('viewed', true)
        .order('completed_at', ascending: false);

    return rows
        .map((row) => UserProgress.fromJson(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<bool> markCategoryViewed({
    required String userId,
    required String categoryId,
  }) async {
    final existing = await _client
        .from('user_progress')
        .select('id')
        .eq('user_id', userId)
        .eq('category_id', categoryId)
        .maybeSingle();

    if (existing != null) {
      return false;
    }

    await _client.from('user_progress').insert({
      'user_id': userId,
      'category_id': categoryId,
      'viewed': true,
      'completed_at': DateTime.now().toIso8601String(),
    });

    return true;
  }
}
