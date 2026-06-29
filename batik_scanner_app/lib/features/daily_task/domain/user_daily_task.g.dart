// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_daily_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDailyTask _$UserDailyTaskFromJson(Map<String, dynamic> json) =>
    _UserDailyTask(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      taskId: json['task_id'] as String,
      completed: json['completed'] as bool? ?? false,
      assignedDate: json['assigned_date'] as String,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      task: json['daily_tasks'] == null
          ? null
          : DailyTask.fromJson(json['daily_tasks'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDailyTaskToJson(_UserDailyTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'task_id': instance.taskId,
      'completed': instance.completed,
      'assigned_date': instance.assignedDate,
      'completed_at': instance.completedAt?.toIso8601String(),
      'daily_tasks': instance.task,
    };
