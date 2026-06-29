import 'package:freezed_annotation/freezed_annotation.dart';

import 'daily_task.dart';

part 'user_daily_task.freezed.dart';
part 'user_daily_task.g.dart';

@freezed
abstract class UserDailyTask with _$UserDailyTask {
  const factory UserDailyTask({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'task_id') required String taskId,
    @Default(false) bool completed,
    @JsonKey(name: 'assigned_date') required String assignedDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'daily_tasks') DailyTask? task,
  }) = _UserDailyTask;

  factory UserDailyTask.fromJson(Map<String, dynamic> json) =>
      _$UserDailyTaskFromJson(json);
}
