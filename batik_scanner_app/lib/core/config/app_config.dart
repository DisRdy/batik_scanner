class AppConfig {
  const AppConfig._();

  static const appName = 'BatikQuest';
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const uploadBucket = 'batik-uploads';

  static bool get hasSupabaseConfig {
    return supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;
  }
}
