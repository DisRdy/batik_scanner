import 'package:freezed_annotation/freezed_annotation.dart';

part 'batik_category.freezed.dart';
part 'batik_category.g.dart';

@freezed
abstract class BatikCategory with _$BatikCategory {
  const factory BatikCategory({
    required String id,
    @Default('') String name,
    @Default('') String history,
    @Default('') String philosophy,
    @JsonKey(name: 'origin_region') @Default('') String originRegion,
    @JsonKey(name: 'image_url') @Default('') String imageUrl,
    @Default('') String facts,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _BatikCategory;

  factory BatikCategory.fromJson(Map<String, dynamic> json) =>
      _$BatikCategoryFromJson(json);
}
