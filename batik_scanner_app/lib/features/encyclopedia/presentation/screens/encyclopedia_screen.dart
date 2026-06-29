import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/async_value_view.dart';
import '../../../../shared/widgets/responsive_page.dart';
import '../../application/encyclopedia_controller.dart';
import '../../data/batik_repository.dart';
import '../../domain/batik_category.dart';
import '../widgets/batik_category_image.dart';

class EncyclopediaScreen extends ConsumerStatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  ConsumerState<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends ConsumerState<EncyclopediaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(encyclopediaControllerProvider.notifier).recordOpened();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredValue = ref.watch(filteredBatikCategoriesProvider);
    final categoriesValue = ref.watch(batikCategoriesProvider);
    final selectedFilter = ref.watch(encyclopediaFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Encyclopedia')),
      body: ResponsivePage(
        children: [
          SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Cari nama, daerah, sejarah, atau filosofi',
            onChanged: (value) {
              ref.read(encyclopediaSearchProvider.notifier).setQuery(value);
            },
          ),
          const SizedBox(height: 14),
          categoriesValue.when(
            data: (categories) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('Semua'),
                        selected: selectedFilter == null,
                        onSelected: (_) {
                          ref
                              .read(encyclopediaFilterProvider.notifier)
                              .setFilter(null);
                        },
                      ),
                    ),
                    for (final category in categories)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.name),
                          selected: selectedFilter == category.name,
                          onSelected: (_) {
                            ref
                                .read(encyclopediaFilterProvider.notifier)
                                .setFilter(category.name);
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
          ),
          const SizedBox(height: 18),
          AsyncValueView<List<BatikCategory>>(
            value: filteredValue,
            data: (categories) {
              if (categories.isEmpty) {
                return const Center(child: Text('Kategori tidak ditemukan.'));
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 900
                      ? 3
                      : constraints.maxWidth >= 620
                      ? 2
                      : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: columns == 1 ? 1.65 : 0.92,
                    ),
                    itemBuilder: (context, index) {
                      return _BatikCategoryCard(category: categories[index]);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BatikCategoryCard extends StatelessWidget {
  const _BatikCategoryCard({required this.category});

  final BatikCategory category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: () => context.go('/encyclopedia/${category.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: BatikCategoryImage(category: category)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.originRegion,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.history,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
