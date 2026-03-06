// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Environment Constants

class Env {
  Env._();

  /// Supabase project URL - replace with your own
  static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';

  /// Supabase anonymous key - replace with your own
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';

  /// Google Maps API key
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_KEY';

  /// Mapbox access token (for offline tiles)
  static const String mapboxAccessToken = 'YOUR_MAPBOX_TOKEN';

  /// Hugging Face API token (for cloud AI inference)
  static const String huggingFaceToken = 'YOUR_HF_TOKEN';

  /// Weather API key (for predictions)
  static const String weatherApiKey = 'YOUR_WEATHER_API_KEY';

  /// App version
  static const String appVersion = '1.0.0';

  /// App name
  static const String appName = 'InfraGuard AI';
}
