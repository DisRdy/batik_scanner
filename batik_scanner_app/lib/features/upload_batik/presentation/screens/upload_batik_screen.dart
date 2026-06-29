import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/async_value_view.dart';
import '../../../../shared/widgets/responsive_page.dart';
import '../../../../shared/widgets/section_card.dart';
import '../../../encyclopedia/data/batik_repository.dart';
import '../../../encyclopedia/domain/batik_category.dart';
import '../../application/upload_controller.dart';

class UploadBatikScreen extends ConsumerWidget {
  const UploadBatikScreen({super.key});

  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      imageQuality: 88,
      maxWidth: 1800,
    );

    if (image != null) {
      ref.read(selectedUploadImageProvider.notifier).setImage(image);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(uploadControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage(next.error!))));
      }
    });

    final image = ref.watch(selectedUploadImageProvider);
    final selectedCategory = ref.watch(selectedUploadCategoryProvider);
    final categoriesValue = ref.watch(batikCategoriesProvider);
    final uploadState = ref.watch(uploadControllerProvider);
    final canUpload =
        image != null && selectedCategory != null && !uploadState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Batik')),
      body: ResponsivePage(
        maxWidth: 860,
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Foto Batik',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                _ImagePreview(image: image),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: uploadState.isLoading
                          ? null
                          : () => _pickImage(ref, ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Camera'),
                    ),
                    OutlinedButton.icon(
                      onPressed: uploadState.isLoading
                          ? null
                          : () => _pickImage(ref, ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Gallery'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: AsyncValueView<List<BatikCategory>>(
              value: categoriesValue,
              data: (categories) {
                return DropdownButtonFormField<String>(
                  key: ValueKey(selectedCategory),
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori batik',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: uploadState.isLoading
                      ? null
                      : (value) {
                          ref
                              .read(selectedUploadCategoryProvider.notifier)
                              .setCategory(value);
                        },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: canUpload
                ? () async {
                    await ref
                        .read(uploadControllerProvider.notifier)
                        .uploadSelectedImage();
                    final state = ref.read(uploadControllerProvider);
                    if (!state.hasError && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Upload berhasil. +50 XP'),
                        ),
                      );
                    }
                  }
                : null,
            icon: uploadState.isLoading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: const Text('Upload ke Supabase'),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.image});

  final XFile? image;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: image == null
              ? Center(
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: colorScheme.onSecondaryContainer,
                    size: 56,
                  ),
                )
              : FutureBuilder<Uint8List>(
                  future: image!.readAsBytes(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Image.memory(snapshot.data!, fit: BoxFit.cover);
                  },
                ),
        ),
      ),
    );
  }
}
