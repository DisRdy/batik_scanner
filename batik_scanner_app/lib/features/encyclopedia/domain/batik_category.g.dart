// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batik_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatikCategory _$BatikCategoryFromJson(Map<String, dynamic> json) =>
    _BatikCategory(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      history: json['history'] as String? ?? '',
      philosophy: json['philosophy'] as String? ?? '',
      originRegion: json['origin_region'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      facts: json['facts'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BatikCategoryToJson(_BatikCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'history': instance.history,
      'philosophy': instance.philosophy,
      'origin_region': instance.originRegion,
      'image_url': instance.imageUrl,
      'facts': instance.facts,
      'created_at': instance.createdAt?.toIso8601String(),
    };
