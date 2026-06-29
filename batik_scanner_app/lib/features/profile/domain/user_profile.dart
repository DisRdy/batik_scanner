import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String region,
    @Default(0) int xp,
    @Default(1) int level,
    @Default('Pemula Batik') String rank,
    @Default(0) int streak,
    @JsonKey(name: 'last_login_date') String? lastLoginDate,
    @JsonKey(name: 'last_activity_date') String? lastActivityDate,
    @JsonKey(name: 'last_streak_date') String? lastStreakDate,
    @Default(<String>[]) List<String> badges,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
