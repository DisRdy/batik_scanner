// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_daily_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDailyTask {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'task_id') String get taskId; bool get completed;@JsonKey(name: 'assigned_date') String get assignedDate;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'daily_tasks') DailyTask? get task;
/// Create a copy of UserDailyTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDailyTaskCopyWith<UserDailyTask> get copyWith => _$UserDailyTaskCopyWithImpl<UserDailyTask>(this as UserDailyTask, _$identity);

  /// Serializes this UserDailyTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDailyTask&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.assignedDate, assignedDate) || other.assignedDate == assignedDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,taskId,completed,assignedDate,completedAt,task);

@override
String toString() {
  return 'UserDailyTask(id: $id, userId: $userId, taskId: $taskId, completed: $completed, assignedDate: $assignedDate, completedAt: $completedAt, task: $task)';
}


}

/// @nodoc
abstract mixin class $UserDailyTaskCopyWith<$Res>  {
  factory $UserDailyTaskCopyWith(UserDailyTask value, $Res Function(UserDailyTask) _then) = _$UserDailyTaskCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'task_id') String taskId, bool completed,@JsonKey(name: 'assigned_date') String assignedDate,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'daily_tasks') DailyTask? task
});


$DailyTaskCopyWith<$Res>? get task;

}
/// @nodoc
class _$UserDailyTaskCopyWithImpl<$Res>
    implements $UserDailyTaskCopyWith<$Res> {
  _$UserDailyTaskCopyWithImpl(this._self, this._then);

  final UserDailyTask _self;
  final $Res Function(UserDailyTask) _then;

/// Create a copy of UserDailyTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? taskId = null,Object? completed = null,Object? assignedDate = null,Object? completedAt = freezed,Object? task = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,assignedDate: null == assignedDate ? _self.assignedDate : assignedDate // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as DailyTask?,
  ));
}
/// Create a copy of UserDailyTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyTaskCopyWith<$Res>? get task {
    if (_self.task == null) {
    return null;
  }

  return $DailyTaskCopyWith<$Res>(_self.task!, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserDailyTask].
extension UserDailyTaskPatterns on UserDailyTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDailyTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDailyTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDailyTask value)  $default,){
final _that = this;
switch (_that) {
case _UserDailyTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDailyTask value)?  $default,){
final _that = this;
switch (_that) {
case _UserDailyTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'task_id')  String taskId,  bool completed, @JsonKey(name: 'assigned_date')  String assignedDate, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'daily_tasks')  DailyTask? task)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDailyTask() when $default != null:
return $default(_that.id,_that.userId,_that.taskId,_that.completed,_that.assignedDate,_that.completedAt,_that.task);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'task_id')  String taskId,  bool completed, @JsonKey(name: 'assigned_date')  String assignedDate, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'daily_tasks')  DailyTask? task)  $default,) {final _that = this;
switch (_that) {
case _UserDailyTask():
return $default(_that.id,_that.userId,_that.taskId,_that.completed,_that.assignedDate,_that.completedAt,_that.task);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'task_id')  String taskId,  bool completed, @JsonKey(name: 'assigned_date')  String assignedDate, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'daily_tasks')  DailyTask? task)?  $default,) {final _that = this;
switch (_that) {
case _UserDailyTask() when $default != null:
return $default(_that.id,_that.userId,_that.taskId,_that.completed,_that.assignedDate,_that.completedAt,_that.task);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDailyTask implements UserDailyTask {
  const _UserDailyTask({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'task_id') required this.taskId, this.completed = false, @JsonKey(name: 'assigned_date') required this.assignedDate, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'daily_tasks') this.task});
  factory _UserDailyTask.fromJson(Map<String, dynamic> json) => _$UserDailyTaskFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'task_id') final  String taskId;
@override@JsonKey() final  bool completed;
@override@JsonKey(name: 'assigned_date') final  String assignedDate;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'daily_tasks') final  DailyTask? task;

/// Create a copy of UserDailyTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDailyTaskCopyWith<_UserDailyTask> get copyWith => __$UserDailyTaskCopyWithImpl<_UserDailyTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDailyTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDailyTask&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.assignedDate, assignedDate) || other.assignedDate == assignedDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.task, task) || other.task == task));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,taskId,completed,assignedDate,completedAt,task);

@override
String toString() {
  return 'UserDailyTask(id: $id, userId: $userId, taskId: $taskId, completed: $completed, assignedDate: $assignedDate, completedAt: $completedAt, task: $task)';
}


}

/// @nodoc
abstract mixin class _$UserDailyTaskCopyWith<$Res> implements $UserDailyTaskCopyWith<$Res> {
  factory _$UserDailyTaskCopyWith(_UserDailyTask value, $Res Function(_UserDailyTask) _then) = __$UserDailyTaskCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'task_id') String taskId, bool completed,@JsonKey(name: 'assigned_date') String assignedDate,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'daily_tasks') DailyTask? task
});


@override $DailyTaskCopyWith<$Res>? get task;

}
/// @nodoc
class __$UserDailyTaskCopyWithImpl<$Res>
    implements _$UserDailyTaskCopyWith<$Res> {
  __$UserDailyTaskCopyWithImpl(this._self, this._then);

  final _UserDailyTask _self;
  final $Res Function(_UserDailyTask) _then;

/// Create a copy of UserDailyTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? taskId = null,Object? completed = null,Object? assignedDate = null,Object? completedAt = freezed,Object? task = freezed,}) {
  return _then(_UserDailyTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,assignedDate: null == assignedDate ? _self.assignedDate : assignedDate // ignore: cast_nullable_to_non_nullable
as String,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as DailyTask?,
  ));
}

/// Create a copy of UserDailyTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyTaskCopyWith<$Res>? get task {
    if (_self.task == null) {
    return null;
  }

  return $DailyTaskCopyWith<$Res>(_self.task!, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
