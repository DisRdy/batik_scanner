import 'package:flutter/material.dart';

class MissingConfigScreen extends StatelessWidget {
  const MissingConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.key_outlined,
                        color: colorScheme.primary,
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'BatikQuest needs Supabase keys',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Run the app with SUPABASE_URL and SUPABASE_ANON_KEY '
                        'using --dart-define after creating the Supabase schema.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      const SelectableText(
                        'flutter run '
                        '--dart-define=SUPABASE_URL=your-url '
                        '--dart-define=SUPABASE_ANON_KEY=your-anon-key',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
