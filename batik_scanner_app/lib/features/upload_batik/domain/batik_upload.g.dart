// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batik_upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatikUpload _$BatikUploadFromJson(Map<String, dynamic> json) => _BatikUpload(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  imageUrl: json['image_url'] as String,
  categoryId: json['category_id'] as String,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$BatikUploadToJson(_BatikUpload instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'image_url': instance.imageUrl,
      'category_id': instance.categoryId,
      'created_at': instance.createdAt?.toIso8601String(),
    };
