// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  name: json['name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  region: json['region'] as String? ?? '',
  xp: (json['xp'] as num?)?.toInt() ?? 0,
  level: (json['level'] as num?)?.toInt() ?? 1,
  rank: json['rank'] as String? ?? 'Pemula Batik',
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  lastLoginDate: json['last_login_date'] as String?,
  lastActivityDate: json['last_activity_date'] as String?,
  lastStreakDate: json['last_streak_date'] as String?,
  badges:
      (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'region': instance.region,
      'xp': instance.xp,
      'level': instance.level,
      'rank': instance.rank,
      'streak': instance.streak,
      'last_login_date': instance.lastLoginDate,
      'last_activity_date': instance.lastActivityDate,
      'last_streak_date': instance.lastStreakDate,
      'badges': instance.badges,
      'created_at': instance.createdAt?.toIso8601String(),
    };
