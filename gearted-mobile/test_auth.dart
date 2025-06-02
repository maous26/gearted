import 'lib/services/auth_service.dart';

void main() async {
  final authService = AuthService();

  print('Testing authentication check...');

  try {
    final isLoggedIn = await authService.isLoggedIn();
    print('Is logged in: $isLoggedIn');
  } catch (e) {
    print('Error checking auth: $e');
  }
}
