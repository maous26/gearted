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

  // Helper method for secure credential display
  static String _maskCredential(String credential) {
    if (credential.isEmpty) return 'missing';
    if (credential.length <= 8) return '****';
    return '${credential.substring(0, 4)}...${credential.substring(credential.length - 4)}';
  }

  // Debug method
  static void printConfig() {
    print('=== OAuth Configuration ===');
    print('Google configured: $isGoogleConfigured');
    print('Google client ID: ${_maskCredential(googleWebClientId)}');
    print('Facebook configured: $isFacebookConfigured');
    print('Facebook app ID: ${_maskCredential(facebookAppId)}');
    print('API URL: $apiUrl');
    print('==========================');
  }
}
