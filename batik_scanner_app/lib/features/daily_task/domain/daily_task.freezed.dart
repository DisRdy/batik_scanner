// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyTask {

 String get id;@JsonKey(name: 'task_key') String get taskKey; String get title; String get description;@JsonKey(name: 'xp_reward') int get xpReward;@JsonKey(name: 'category_name') String? get categoryName;
/// Create a copy of DailyTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyTaskCopyWith<DailyTask> get copyWith => _$DailyTaskCopyWithImpl<DailyTask>(this as DailyTask, _$identity);

  /// Serializes this DailyTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyTask&&(identical(other.id, id) || other.id == id)&&(identical(other.taskKey, taskKey) || other.taskKey == taskKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskKey,title,description,xpReward,categoryName);

@override
String toString() {
  return 'DailyTask(id: $id, taskKey: $taskKey, title: $title, description: $description, xpReward: $xpReward, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class $DailyTaskCopyWith<$Res>  {
  factory $DailyTaskCopyWith(DailyTask value, $Res Function(DailyTask) _then) = _$DailyTaskCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'task_key') String taskKey, String title, String description,@JsonKey(name: 'xp_reward') int xpReward,@JsonKey(name: 'category_name') String? categoryName
});




}
/// @nodoc
class _$DailyTaskCopyWithImpl<$Res>
    implements $DailyTaskCopyWith<$Res> {
  _$DailyTaskCopyWithImpl(this._self, this._then);

  final DailyTask _self;
  final $Res Function(DailyTask) _then;

/// Create a copy of DailyTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskKey = null,Object? title = null,Object? description = null,Object? xpReward = null,Object? categoryName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskKey: null == taskKey ? _self.taskKey : taskKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyTask].
extension DailyTaskPatterns on DailyTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyTask value)  $default,){
final _that = this;
switch (_that) {
case _DailyTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyTask value)?  $default,){
final _that = this;
switch (_that) {
case _DailyTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'task_key')  String taskKey,  String title,  String description, @JsonKey(name: 'xp_reward')  int xpReward, @JsonKey(name: 'category_name')  String? categoryName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyTask() when $default != null:
return $default(_that.id,_that.taskKey,_that.title,_that.description,_that.xpReward,_that.categoryName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'task_key')  String taskKey,  String title,  String description, @JsonKey(name: 'xp_reward')  int xpReward, @JsonKey(name: 'category_name')  String? categoryName)  $default,) {final _that = this;
switch (_that) {
case _DailyTask():
return $default(_that.id,_that.taskKey,_that.title,_that.description,_that.xpReward,_that.categoryName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'task_key')  String taskKey,  String title,  String description, @JsonKey(name: 'xp_reward')  int xpReward, @JsonKey(name: 'category_name')  String? categoryName)?  $default,) {final _that = this;
switch (_that) {
case _DailyTask() when $default != null:
return $default(_that.id,_that.taskKey,_that.title,_that.description,_that.xpReward,_that.categoryName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyTask implements DailyTask {
  const _DailyTask({required this.id, @JsonKey(name: 'task_key') this.taskKey = '', this.title = '', this.description = '', @JsonKey(name: 'xp_reward') this.xpReward = 30, @JsonKey(name: 'category_name') this.categoryName});
  factory _DailyTask.fromJson(Map<String, dynamic> json) => _$DailyTaskFromJson(json);

@override final  String id;
@override@JsonKey(name: 'task_key') final  String taskKey;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey(name: 'xp_reward') final  int xpReward;
@override@JsonKey(name: 'category_name') final  String? categoryName;

/// Create a copy of DailyTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyTaskCopyWith<_DailyTask> get copyWith => __$DailyTaskCopyWithImpl<_DailyTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyTask&&(identical(other.id, id) || other.id == id)&&(identical(other.taskKey, taskKey) || other.taskKey == taskKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskKey,title,description,xpReward,categoryName);

@override
String toString() {
  return 'DailyTask(id: $id, taskKey: $taskKey, title: $title, description: $description, xpReward: $xpReward, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class _$DailyTaskCopyWith<$Res> implements $DailyTaskCopyWith<$Res> {
  factory _$DailyTaskCopyWith(_DailyTask value, $Res Function(_DailyTask) _then) = __$DailyTaskCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'task_key') String taskKey, String title, String description,@JsonKey(name: 'xp_reward') int xpReward,@JsonKey(name: 'category_name') String? categoryName
});




}
/// @nodoc
class __$DailyTaskCopyWithImpl<$Res>
    implements _$DailyTaskCopyWith<$Res> {
  __$DailyTaskCopyWithImpl(this._self, this._then);

  final _DailyTask _self;
  final $Res Function(_DailyTask) _then;

/// Create a copy of DailyTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskKey = null,Object? title = null,Object? description = null,Object? xpReward = null,Object? categoryName = freezed,}) {
  return _then(_DailyTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskKey: null == taskKey ? _self.taskKey : taskKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
