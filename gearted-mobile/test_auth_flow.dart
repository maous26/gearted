// Test script for authentication flow
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'token_debug.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('==== AUTHENTICATION TEST ====');

  // First, check if we have a token and inspect it
  await debugToken();

  // Test the isLoggedIn method
  final authService = AuthService();
  print('\nTesting isLoggedIn()...');
  final isLoggedIn = await authService.isLoggedIn();
  print('isLoggedIn result: $isLoggedIn');

  if (!isLoggedIn) {
    print('\nNo valid session found. Testing login...');
    // You can uncomment and modify these lines to test login
    // try {
    //   final result = await authService.signInWithEmail('test@example.com', 'password123');
    //   print('Login result: $result');
    //   await debugToken();
    // } catch (e) {
    //   print('Login failed: $e');
    // }
  } else {
    print('\nUser is logged in. Testing getting profile...');
    // You can add code to fetch and display the user profile
  }

  print('============================');
}
