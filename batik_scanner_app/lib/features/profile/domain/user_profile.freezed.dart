// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id; String get name; String get email; String get region; int get xp; int get level; String get rank; int get streak;@JsonKey(name: 'last_login_date') String? get lastLoginDate;@JsonKey(name: 'last_activity_date') String? get lastActivityDate;@JsonKey(name: 'last_streak_date') String? get lastStreakDate; List<String> get badges;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.region, region) || other.region == region)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.level, level) || other.level == level)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.lastLoginDate, lastLoginDate) || other.lastLoginDate == lastLoginDate)&&(identical(other.lastActivityDate, lastActivityDate) || other.lastActivityDate == lastActivityDate)&&(identical(other.lastStreakDate, lastStreakDate) || other.lastStreakDate == lastStreakDate)&&const DeepCollectionEquality().equals(other.badges, badges)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,region,xp,level,rank,streak,lastLoginDate,lastActivityDate,lastStreakDate,const DeepCollectionEquality().hash(badges),createdAt);

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, email: $email, region: $region, xp: $xp, level: $level, rank: $rank, streak: $streak, lastLoginDate: $lastLoginDate, lastActivityDate: $lastActivityDate, lastStreakDate: $lastStreakDate, badges: $badges, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String region, int xp, int level, String rank, int streak,@JsonKey(name: 'last_login_date') String? lastLoginDate,@JsonKey(name: 'last_activity_date') String? lastActivityDate,@JsonKey(name: 'last_streak_date') String? lastStreakDate, List<String> badges,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? region = null,Object? xp = null,Object? level = null,Object? rank = null,Object? streak = null,Object? lastLoginDate = freezed,Object? lastActivityDate = freezed,Object? lastStreakDate = freezed,Object? badges = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as String,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,lastLoginDate: freezed == lastLoginDate ? _self.lastLoginDate : lastLoginDate // ignore: cast_nullable_to_non_nullable
as String?,lastActivityDate: freezed == lastActivityDate ? _self.lastActivityDate : lastActivityDate // ignore: cast_nullable_to_non_nullable
as String?,lastStreakDate: freezed == lastStreakDate ? _self.lastStreakDate : lastStreakDate // ignore: cast_nullable_to_non_nullable
as String?,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String region,  int xp,  int level,  String rank,  int streak, @JsonKey(name: 'last_login_date')  String? lastLoginDate, @JsonKey(name: 'last_activity_date')  String? lastActivityDate, @JsonKey(name: 'last_streak_date')  String? lastStreakDate,  List<String> badges, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.region,_that.xp,_that.level,_that.rank,_that.streak,_that.lastLoginDate,_that.lastActivityDate,_that.lastStreakDate,_that.badges,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String region,  int xp,  int level,  String rank,  int streak, @JsonKey(name: 'last_login_date')  String? lastLoginDate, @JsonKey(name: 'last_activity_date')  String? lastActivityDate, @JsonKey(name: 'last_streak_date')  String? lastStreakDate,  List<String> badges, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.name,_that.email,_that.region,_that.xp,_that.level,_that.rank,_that.streak,_that.lastLoginDate,_that.lastActivityDate,_that.lastStreakDate,_that.badges,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String region,  int xp,  int level,  String rank,  int streak, @JsonKey(name: 'last_login_date')  String? lastLoginDate, @JsonKey(name: 'last_activity_date')  String? lastActivityDate, @JsonKey(name: 'last_streak_date')  String? lastStreakDate,  List<String> badges, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.region,_that.xp,_that.level,_that.rank,_that.streak,_that.lastLoginDate,_that.lastActivityDate,_that.lastStreakDate,_that.badges,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, this.name = '', this.email = '', this.region = '', this.xp = 0, this.level = 1, this.rank = 'Pemula Batik', this.streak = 0, @JsonKey(name: 'last_login_date') this.lastLoginDate, @JsonKey(name: 'last_activity_date') this.lastActivityDate, @JsonKey(name: 'last_streak_date') this.lastStreakDate, final  List<String> badges = const <String>[], @JsonKey(name: 'created_at') this.createdAt}): _badges = badges;
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String email;
@override@JsonKey() final  String region;
@override@JsonKey() final  int xp;
@override@JsonKey() final  int level;
@override@JsonKey() final  String rank;
@override@JsonKey() final  int streak;
@override@JsonKey(name: 'last_login_date') final  String? lastLoginDate;
@override@JsonKey(name: 'last_activity_date') final  String? lastActivityDate;
@override@JsonKey(name: 'last_streak_date') final  String? lastStreakDate;
 final  List<String> _badges;
@override@JsonKey() List<String> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.region, region) || other.region == region)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.level, level) || other.level == level)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.lastLoginDate, lastLoginDate) || other.lastLoginDate == lastLoginDate)&&(identical(other.lastActivityDate, lastActivityDate) || other.lastActivityDate == lastActivityDate)&&(identical(other.lastStreakDate, lastStreakDate) || other.lastStreakDate == lastStreakDate)&&const DeepCollectionEquality().equals(other._badges, _badges)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,region,xp,level,rank,streak,lastLoginDate,lastActivityDate,lastStreakDate,const DeepCollectionEquality().hash(_badges),createdAt);

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, email: $email, region: $region, xp: $xp, level: $level, rank: $rank, streak: $streak, lastLoginDate: $lastLoginDate, lastActivityDate: $lastActivityDate, lastStreakDate: $lastStreakDate, badges: $badges, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String region, int xp, int level, String rank, int streak,@JsonKey(name: 'last_login_date') String? lastLoginDate,@JsonKey(name: 'last_activity_date') String? lastActivityDate,@JsonKey(name: 'last_streak_date') String? lastStreakDate, List<String> badges,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? region = null,Object? xp = null,Object? level = null,Object? rank = null,Object? streak = null,Object? lastLoginDate = freezed,Object? lastActivityDate = freezed,Object? lastStreakDate = freezed,Object? badges = null,Object? createdAt = freezed,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as String,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,lastLoginDate: freezed == lastLoginDate ? _self.lastLoginDate : lastLoginDate // ignore: cast_nullable_to_non_nullable
as String?,lastActivityDate: freezed == lastActivityDate ? _self.lastActivityDate : lastActivityDate // ignore: cast_nullable_to_non_nullable
as String?,lastStreakDate: freezed == lastStreakDate ? _self.lastStreakDate : lastStreakDate // ignore: cast_nullable_to_non_nullable
as String?,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
