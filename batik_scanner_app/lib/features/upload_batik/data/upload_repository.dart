import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';
import '../../../core/supabase/supabase_provider.dart';
import '../domain/batik_upload.dart';

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  return UploadRepository(ref.watch(supabaseClientProvider));
});

class UploadRepository {
  UploadRepository(this._client);

  final SupabaseClient _client;

  Future<BatikUpload> uploadBatikImage({
    required String userId,
    required String categoryId,
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();
    final mimeType =
        lookupMimeType(image.name, headerBytes: bytes) ?? 'image/jpeg';
    final extension = _extensionFromMime(mimeType);
    final objectPath =
        '$userId/${DateTime.now().millisecondsSinceEpoch}.$extension';

    await _client.storage
        .from(AppConfig.uploadBucket)
        .uploadBinary(
          objectPath,
          bytes,
          fileOptions: FileOptions(contentType: mimeType),
        );

    final imageUrl = _client.storage
        .from(AppConfig.uploadBucket)
        .getPublicUrl(objectPath);

    final row = await _client
        .from('user_batik_uploads')
        .insert({
          'user_id': userId,
          'category_id': categoryId,
          'image_url': imageUrl,
        })
        .select()
        .single();

    return BatikUpload.fromJson(Map<String, dynamic>.from(row));
  }

  String _extensionFromMime(String mimeType) {
    if (mimeType.contains('png')) {
      return 'png';
    }
    if (mimeType.contains('webp')) {
      return 'webp';
    }
    return 'jpg';
  }
}
