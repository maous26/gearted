import 'lib/services/auth_service.dart';
import 'dart:developer' as developer;

void main() async {
  developer.log('🔧 Clearing expired authentication tokens...');

  try {
    final authService = AuthService();

    // Clear local tokens using the signOut method
    await authService.signOut();

    developer.log('✅ Successfully cleared authentication tokens.');
    developer
        .log('💡 Users will need to log in again to get new valid tokens.');

    // Test that no token exists now
    final isLoggedIn = await authService.isLoggedIn();
    developer.log('🔍 Login status after clearing: $isLoggedIn');
  } catch (e) {
    developer.log('❌ Error clearing tokens: $e');
  }
}
