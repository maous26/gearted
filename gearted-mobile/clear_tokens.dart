import 'package:shared_preferences/shared_preferences.dart';
import 'lib/services/auth_service.dart';

void main() async {
  print('🔧 Clearing expired authentication tokens...');

  try {
    final authService = AuthService();

    // Clear local tokens
    await authService.clearLocalTokens();

    print('✅ Successfully cleared authentication tokens.');
    print('💡 Users will need to log in again to get new valid tokens.');

    // Test that no token exists now
    final isLoggedIn = await authService.isLoggedIn();
    print('🔍 Login status after clearing: $isLoggedIn');
  } catch (e) {
    print('❌ Error clearing tokens: $e');
  }
}
