import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/async_value_view.dart';
import '../../../../shared/widgets/responsive_page.dart';
import '../../../../shared/widgets/section_card.dart';
import '../../application/encyclopedia_controller.dart';
import '../../data/batik_repository.dart';
import '../../domain/batik_category.dart';
import '../widgets/batik_category_image.dart';

class BatikDetailScreen extends ConsumerStatefulWidget {
  const BatikDetailScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<BatikDetailScreen> createState() => _BatikDetailScreenState();
}

class _BatikDetailScreenState extends ConsumerState<BatikDetailScreen> {
  bool _readTracked = false;

  @override
  Widget build(BuildContext context) {
    final categoryValue = ref.watch(batikCategoryProvider(widget.categoryId));

    ref.listen(batikCategoryProvider(widget.categoryId), (previous, next) {
      next.whenData((category) {
        if (category != null && !_readTracked) {
          _readTracked = true;
          ref
              .read(encyclopediaControllerProvider.notifier)
              .recordRead(category);
        }
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Batik')),
      body: AsyncValueView<BatikCategory?>(
        value: categoryValue,
        data: (category) {
          if (category == null) {
            return const Center(child: Text('Kategori tidak ditemukan.'));
          }
          return ResponsivePage(
            maxWidth: 920,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Card(child: BatikCategoryImage(category: category)),
              ),
              const SizedBox(height: 18),
              Text(
                category.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.place_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(category.originRegion)),
                ],
              ),
              const SizedBox(height: 18),
              _InfoSection(title: 'Sejarah', body: category.history),
              const SizedBox(height: 12),
              _InfoSection(title: 'Filosofi', body: category.philosophy),
              const SizedBox(height: 12),
              _InfoSection(
                title: 'Fakta Menarik',
                body: category.facts.isEmpty
                    ? 'Fakta menarik belum tersedia.'
                    : category.facts,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(body, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
