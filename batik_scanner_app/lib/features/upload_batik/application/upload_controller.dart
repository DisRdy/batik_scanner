import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/gamification/gamification_service.dart';
import '../../auth/data/auth_repository.dart';
import '../../daily_task/data/daily_task_repository.dart';
import '../../encyclopedia/data/batik_repository.dart';
import '../../profile/data/profile_repository.dart';
import '../data/upload_repository.dart';

final selectedUploadImageProvider =
    NotifierProvider<SelectedUploadImage, XFile?>(SelectedUploadImage.new);
final selectedUploadCategoryProvider =
    NotifierProvider<SelectedUploadCategory, String?>(
      SelectedUploadCategory.new,
    );

class SelectedUploadImage extends Notifier<XFile?> {
  @override
  XFile? build() => null;

  void setImage(XFile image) {
    state = image;
  }

  void clear() {
    state = null;
  }
}

class SelectedUploadCategory extends Notifier<String?> {
  @override
  String? build() => null;

  void setCategory(String? categoryId) {
    state = categoryId;
  }
}

final uploadControllerProvider = AsyncNotifierProvider<UploadController, void>(
  UploadController.new,
);

class UploadController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> uploadSelectedImage() async {
    final user = ref.read(currentUserProvider);
    final image = ref.read(selectedUploadImageProvider);
    final categoryId = ref.read(selectedUploadCategoryProvider);

    if (user == null || image == null || categoryId == null) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final category = await ref
          .read(batikRepositoryProvider)
          .fetchCategory(categoryId);
      if (category == null) {
        throw StateError('Selected batik category was not found.');
      }

      await ref
          .read(uploadRepositoryProvider)
          .uploadBatikImage(
            userId: user.id,
            categoryId: categoryId,
            image: image,
          );
      await ref
          .read(gamificationServiceProvider)
          .recordUpload(userId: user.id, categoryName: category.name);

      ref.read(selectedUploadImageProvider.notifier).clear();
      ref.invalidate(currentProfileProvider);
      ref.invalidate(todayTasksProvider);
    });
  }
}
