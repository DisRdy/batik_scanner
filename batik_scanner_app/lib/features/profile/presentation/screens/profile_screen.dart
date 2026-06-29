import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/widgets/async_value_view.dart';
import '../../../../shared/widgets/responsive_page.dart';
import '../../../../shared/widgets/section_card.dart';
import '../../../auth/application/auth_controller.dart';
import '../../data/profile_repository.dart';
import '../../domain/user_profile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage(next.error!))));
      }
    });

    final profileValue = ref.watch(currentProfileProvider);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: AsyncValueView<UserProfile?>(
        value: profileValue,
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not available.'));
          }
          return ResponsivePage(
            maxWidth: 720,
            children: [
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          child: Text(
                            profile.name.isEmpty
                                ? 'B'
                                : profile.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              Text(profile.email),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _ProfileRow(label: 'Domisili', value: profile.region),
                    _ProfileRow(label: 'Level', value: '${profile.level}'),
                    _ProfileRow(label: 'Rank', value: profile.rank),
                    _ProfileRow(label: 'XP', value: '${profile.xp}'),
                    _ProfileRow(
                      label: 'Streak',
                      value: '${profile.streak} hari',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Badge',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (profile.badges.isEmpty)
                      const Text('Belum ada badge.')
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: profile.badges
                            .map(
                              (badge) => Chip(
                                avatar: const Icon(Icons.workspace_premium),
                                label: Text(badge),
                              ),
                            )
                            .toList(growable: false),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: authState.isLoading
                    ? null
                    : () => ref.read(authControllerProvider.notifier).logout(),
                icon: authState.isLoading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
