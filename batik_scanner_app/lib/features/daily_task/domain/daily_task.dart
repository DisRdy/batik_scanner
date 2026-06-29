import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_task.freezed.dart';
part 'daily_task.g.dart';

@freezed
abstract class DailyTask with _$DailyTask {
  const factory DailyTask({
    required String id,
    @JsonKey(name: 'task_key') @Default('') String taskKey,
    @Default('') String title,
    @Default('') String description,
    @JsonKey(name: 'xp_reward') @Default(30) int xpReward,
    @JsonKey(name: 'category_name') String? categoryName,
  }) = _DailyTask;

  factory DailyTask.fromJson(Map<String, dynamic> json) =>
      _$DailyTaskFromJson(json);
}
