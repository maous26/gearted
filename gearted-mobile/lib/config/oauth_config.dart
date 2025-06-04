import 'package:flutter_dotenv/flutter_dotenv.dart';

class OAuthConfig {
  // Google OAuth Configuration
  static String get googleWebClientId =>
      dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  // Facebook OAuth Configuration
  static String get facebookAppId => dotenv.env['FACEBOOK_APP_ID'] ?? '';

  // API Configuration
  static String get apiUrl =>
      dotenv.env['API_URL'] ?? 'http://localhost:3000/api';

  // Validation methods
  static bool get isGoogleConfigured => googleWebClientId.isNotEmpty;
  static bool get isFacebookConfigured => facebookAppId.isNotEmpty;

  static bool get isOAuthConfigured =>
      isGoogleConfigured && isFacebookConfigured;

  // Debug method
  static void printConfig() {
    print('=== OAuth Configuration ===');
    print('Google configured: $isGoogleConfigured');
    print('Facebook configured: $isFacebookConfigured');
    print('API URL: $apiUrl');
    print('==========================');
  }
}
