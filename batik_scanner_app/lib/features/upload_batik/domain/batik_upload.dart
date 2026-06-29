import 'package:freezed_annotation/freezed_annotation.dart';

part 'batik_upload.freezed.dart';
part 'batik_upload.g.dart';

@freezed
abstract class BatikUpload with _$BatikUpload {
  const factory BatikUpload({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _BatikUpload;

  factory BatikUpload.fromJson(Map<String, dynamic> json) =>
      _$BatikUploadFromJson(json);
}
