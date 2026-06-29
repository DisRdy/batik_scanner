# BatikQuest

BatikQuest is a Flutter 3 Material 3 app for batik learning gamification with
Riverpod, GoRouter, Supabase Auth, Supabase PostgreSQL, Supabase Storage,
Freezed, and Json Serializable.

## Setup

1. Create a Supabase project.
2. Run `supabase/migrations/202606120001_create_batikquest_schema.sql` in the
   Supabase SQL editor or with the Supabase CLI.
3. Run the app with your project keys:

```bash
flutter run \
  --dart-define=SUPABASE_URL=your-supabase-url \
  --dart-define=SUPABASE_ANON_KEY=your-supabase-anon-key
```

## Development

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart analyze
flutter test
```

The migration includes seed data for Parang, Bali, Kawung, and Megamendung plus
the daily task pool.
