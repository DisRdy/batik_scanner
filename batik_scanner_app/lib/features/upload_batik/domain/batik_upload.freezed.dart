// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batik_upload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatikUpload {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'image_url') String get imageUrl;@JsonKey(name: 'category_id') String get categoryId;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of BatikUpload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatikUploadCopyWith<BatikUpload> get copyWith => _$BatikUploadCopyWithImpl<BatikUpload>(this as BatikUpload, _$identity);

  /// Serializes this BatikUpload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatikUpload&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,imageUrl,categoryId,createdAt);

@override
String toString() {
  return 'BatikUpload(id: $id, userId: $userId, imageUrl: $imageUrl, categoryId: $categoryId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BatikUploadCopyWith<$Res>  {
  factory $BatikUploadCopyWith(BatikUpload value, $Res Function(BatikUpload) _then) = _$BatikUploadCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$BatikUploadCopyWithImpl<$Res>
    implements $BatikUploadCopyWith<$Res> {
  _$BatikUploadCopyWithImpl(this._self, this._then);

  final BatikUpload _self;
  final $Res Function(BatikUpload) _then;

/// Create a copy of BatikUpload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? imageUrl = null,Object? categoryId = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BatikUpload].
extension BatikUploadPatterns on BatikUpload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatikUpload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatikUpload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatikUpload value)  $default,){
final _that = this;
switch (_that) {
case _BatikUpload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatikUpload value)?  $default,){
final _that = this;
switch (_that) {
case _BatikUpload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatikUpload() when $default != null:
return $default(_that.id,_that.userId,_that.imageUrl,_that.categoryId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BatikUpload():
return $default(_that.id,_that.userId,_that.imageUrl,_that.categoryId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BatikUpload() when $default != null:
return $default(_that.id,_that.userId,_that.imageUrl,_that.categoryId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatikUpload implements BatikUpload {
  const _BatikUpload({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'image_url') required this.imageUrl, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'created_at') this.createdAt});
  factory _BatikUpload.fromJson(Map<String, dynamic> json) => _$BatikUploadFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey(name: 'category_id') final  String categoryId;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of BatikUpload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatikUploadCopyWith<_BatikUpload> get copyWith => __$BatikUploadCopyWithImpl<_BatikUpload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatikUploadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatikUpload&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,imageUrl,categoryId,createdAt);

@override
String toString() {
  return 'BatikUpload(id: $id, userId: $userId, imageUrl: $imageUrl, categoryId: $categoryId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BatikUploadCopyWith<$Res> implements $BatikUploadCopyWith<$Res> {
  factory _$BatikUploadCopyWith(_BatikUpload value, $Res Function(_BatikUpload) _then) = __$BatikUploadCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$BatikUploadCopyWithImpl<$Res>
    implements _$BatikUploadCopyWith<$Res> {
  __$BatikUploadCopyWithImpl(this._self, this._then);

  final _BatikUpload _self;
  final $Res Function(_BatikUpload) _then;

/// Create a copy of BatikUpload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? imageUrl = null,Object? categoryId = null,Object? createdAt = freezed,}) {
  return _then(_BatikUpload(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
