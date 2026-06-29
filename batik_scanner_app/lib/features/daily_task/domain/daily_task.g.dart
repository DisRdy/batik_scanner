// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyTask _$DailyTaskFromJson(Map<String, dynamic> json) => _DailyTask(
  id: json['id'] as String,
  taskKey: json['task_key'] as String? ?? '',
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  xpReward: (json['xp_reward'] as num?)?.toInt() ?? 30,
  categoryName: json['category_name'] as String?,
);

Map<String, dynamic> _$DailyTaskToJson(_DailyTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_key': instance.taskKey,
      'title': instance.title,
      'description': instance.description,
      'xp_reward': instance.xpReward,
      'category_name': instance.categoryName,
    };
