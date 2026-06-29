import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/gamification/xp_system.dart';
import '../../../../shared/widgets/async_value_view.dart';
import '../../../../shared/widgets/responsive_page.dart';
import '../../../../shared/widgets/section_card.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../daily_task/data/daily_task_repository.dart';
import '../../../daily_task/domain/user_daily_task.dart';
import '../../../encyclopedia/data/batik_repository.dart';
import '../../../encyclopedia/domain/batik_category.dart';
import '../../../profile/data/profile_repository.dart';
import '../../../profile/domain/user_profile.dart';
import '../../application/dashboard_controller.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardControllerProvider.notifier).bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileValue = ref.watch(currentProfileProvider);
    final tasksValue = ref.watch(todayTasksProvider);
    final user = ref.watch(currentUserProvider);
    final learnedValue = user == null
        ? const AsyncValue<List<BatikCategory>>.data([])
        : ref.watch(learnedCategoriesProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.go('/upload'),
            icon: const Icon(Icons.add_a_photo_outlined),
            tooltip: 'Upload Batik',
          ),
        ],
      ),
      body: AsyncValueView<UserProfile?>(
        value: profileValue,
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not available.'));
          }
          return ResponsivePage(
            children: [
              _ProfileSummary(profile: profile),
              const SizedBox(height: 16),
              _QuickActions(),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 760;
                  final children = [
                    _StreakSummary(profile: profile),
                    _TasksSummary(tasksValue: tasksValue),
                  ];
                  if (!isWide) {
                    return Column(
                      children: [
                        children[0],
                        const SizedBox(height: 16),
                        children[1],
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: children[0]),
                      const SizedBox(width: 16),
                      Expanded(child: children[1]),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              _LearnedCollection(value: learnedValue),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = XpSystem.progressToNextLevel(
      xp: profile.xp,
      level: profile.level,
    );
    final nextXp = XpSystem.nextLevelThreshold(profile.level);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  profile.name.isEmpty ? 'B' : profile.name[0].toUpperCase(),
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name.isEmpty ? 'Pembelajar Batik' : profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '${profile.region} - ${profile.rank}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Text(
                'Level ${profile.level}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text('${profile.xp} / $nextXp XP'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: () => context.go('/upload'),
          icon: const Icon(Icons.add_a_photo_outlined),
          label: const Text('Upload Batik'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go('/encyclopedia'),
          icon: const Icon(Icons.menu_book_outlined),
          label: const Text('Buka Encyclopedia'),
        ),
      ],
    );
  }
}

class _StreakSummary extends StatelessWidget {
  const _StreakSummary({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department_outlined),
              const SizedBox(width: 8),
              Text(
                'Daily Streak',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${profile.streak} hari',
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Reward tersedia di hari ke-3, ke-7, dan badge pada hari ke-30.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _TasksSummary extends StatelessWidget {
  const _TasksSummary({required this.tasksValue});

  final AsyncValue<List<UserDailyTask>> tasksValue;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Task',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          tasksValue.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return const Text('Task belum tersedia.');
              }
              return Column(
                children: tasks.map((task) => _TaskTile(task: task)).toList(),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});

  final UserDailyTask task;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dailyTask = task.task;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            task.completed
                ? Icons.check_circle
                : Icons.radio_button_unchecked_outlined,
            color: task.completed ? colorScheme.primary : colorScheme.outline,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dailyTask?.title ?? 'Task',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${dailyTask?.xpReward ?? XpSystem.defaultTaskXp} XP',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnedCollection extends StatelessWidget {
  const _LearnedCollection({required this.value});

  final AsyncValue<List<BatikCategory>> value;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Koleksi Batik Dipelajari',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          value.when(
            data: (items) {
              if (items.isEmpty) {
                return const Text('Belum ada koleksi. Baca encyclopedia dulu.');
              }
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: items
                    .map(
                      (category) => ActionChip(
                        avatar: const Icon(Icons.auto_stories_outlined),
                        label: Text(category.name),
                        onPressed: () =>
                            context.go('/encyclopedia/${category.id}'),
                      ),
                    )
                    .toList(growable: false),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
          ),
        ],
      ),
    );
  }
}
