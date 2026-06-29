import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_progress.freezed.dart';
part 'user_progress.g.dart';

@freezed
abstract class UserProgress with _$UserProgress {
  const factory UserProgress({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'category_id') required String categoryId,
    @Default(false) bool viewed,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _UserProgress;

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
}
