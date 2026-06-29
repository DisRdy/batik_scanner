import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/screens/missing_config_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.hasSupabaseConfig) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabaseAnonKey,
    );
  }

  runApp(const ProviderScope(child: BatikQuestRoot()));
}

class BatikQuestRoot extends ConsumerWidget {
  const BatikQuestRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppConfig.hasSupabaseConfig) {
      return MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const MissingConfigScreen(),
      );
    }

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
