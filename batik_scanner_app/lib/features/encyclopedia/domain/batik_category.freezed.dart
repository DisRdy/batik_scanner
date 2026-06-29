// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batik_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatikCategory {

 String get id; String get name; String get history; String get philosophy;@JsonKey(name: 'origin_region') String get originRegion;@JsonKey(name: 'image_url') String get imageUrl; String get facts;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of BatikCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatikCategoryCopyWith<BatikCategory> get copyWith => _$BatikCategoryCopyWithImpl<BatikCategory>(this as BatikCategory, _$identity);

  /// Serializes this BatikCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatikCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.history, history) || other.history == history)&&(identical(other.philosophy, philosophy) || other.philosophy == philosophy)&&(identical(other.originRegion, originRegion) || other.originRegion == originRegion)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.facts, facts) || other.facts == facts)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,history,philosophy,originRegion,imageUrl,facts,createdAt);

@override
String toString() {
  return 'BatikCategory(id: $id, name: $name, history: $history, philosophy: $philosophy, originRegion: $originRegion, imageUrl: $imageUrl, facts: $facts, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BatikCategoryCopyWith<$Res>  {
  factory $BatikCategoryCopyWith(BatikCategory value, $Res Function(BatikCategory) _then) = _$BatikCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String history, String philosophy,@JsonKey(name: 'origin_region') String originRegion,@JsonKey(name: 'image_url') String imageUrl, String facts,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$BatikCategoryCopyWithImpl<$Res>
    implements $BatikCategoryCopyWith<$Res> {
  _$BatikCategoryCopyWithImpl(this._self, this._then);

  final BatikCategory _self;
  final $Res Function(BatikCategory) _then;

/// Create a copy of BatikCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? history = null,Object? philosophy = null,Object? originRegion = null,Object? imageUrl = null,Object? facts = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as String,philosophy: null == philosophy ? _self.philosophy : philosophy // ignore: cast_nullable_to_non_nullable
as String,originRegion: null == originRegion ? _self.originRegion : originRegion // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,facts: null == facts ? _self.facts : facts // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BatikCategory].
extension BatikCategoryPatterns on BatikCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatikCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatikCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatikCategory value)  $default,){
final _that = this;
switch (_that) {
case _BatikCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatikCategory value)?  $default,){
final _that = this;
switch (_that) {
case _BatikCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String history,  String philosophy, @JsonKey(name: 'origin_region')  String originRegion, @JsonKey(name: 'image_url')  String imageUrl,  String facts, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatikCategory() when $default != null:
return $default(_that.id,_that.name,_that.history,_that.philosophy,_that.originRegion,_that.imageUrl,_that.facts,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String history,  String philosophy, @JsonKey(name: 'origin_region')  String originRegion, @JsonKey(name: 'image_url')  String imageUrl,  String facts, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BatikCategory():
return $default(_that.id,_that.name,_that.history,_that.philosophy,_that.originRegion,_that.imageUrl,_that.facts,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String history,  String philosophy, @JsonKey(name: 'origin_region')  String originRegion, @JsonKey(name: 'image_url')  String imageUrl,  String facts, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BatikCategory() when $default != null:
return $default(_that.id,_that.name,_that.history,_that.philosophy,_that.originRegion,_that.imageUrl,_that.facts,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatikCategory implements BatikCategory {
  const _BatikCategory({required this.id, this.name = '', this.history = '', this.philosophy = '', @JsonKey(name: 'origin_region') this.originRegion = '', @JsonKey(name: 'image_url') this.imageUrl = '', this.facts = '', @JsonKey(name: 'created_at') this.createdAt});
  factory _BatikCategory.fromJson(Map<String, dynamic> json) => _$BatikCategoryFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String history;
@override@JsonKey() final  String philosophy;
@override@JsonKey(name: 'origin_region') final  String originRegion;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey() final  String facts;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of BatikCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatikCategoryCopyWith<_BatikCategory> get copyWith => __$BatikCategoryCopyWithImpl<_BatikCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatikCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatikCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.history, history) || other.history == history)&&(identical(other.philosophy, philosophy) || other.philosophy == philosophy)&&(identical(other.originRegion, originRegion) || other.originRegion == originRegion)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.facts, facts) || other.facts == facts)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,history,philosophy,originRegion,imageUrl,facts,createdAt);

@override
String toString() {
  return 'BatikCategory(id: $id, name: $name, history: $history, philosophy: $philosophy, originRegion: $originRegion, imageUrl: $imageUrl, facts: $facts, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BatikCategoryCopyWith<$Res> implements $BatikCategoryCopyWith<$Res> {
  factory _$BatikCategoryCopyWith(_BatikCategory value, $Res Function(_BatikCategory) _then) = __$BatikCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String history, String philosophy,@JsonKey(name: 'origin_region') String originRegion,@JsonKey(name: 'image_url') String imageUrl, String facts,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$BatikCategoryCopyWithImpl<$Res>
    implements _$BatikCategoryCopyWith<$Res> {
  __$BatikCategoryCopyWithImpl(this._self, this._then);

  final _BatikCategory _self;
  final $Res Function(_BatikCategory) _then;

/// Create a copy of BatikCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? history = null,Object? philosophy = null,Object? originRegion = null,Object? imageUrl = null,Object? facts = null,Object? createdAt = freezed,}) {
  return _then(_BatikCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as String,philosophy: null == philosophy ? _self.philosophy : philosophy // ignore: cast_nullable_to_non_nullable
as String,originRegion: null == originRegion ? _self.originRegion : originRegion // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,facts: null == facts ? _self.facts : facts // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
