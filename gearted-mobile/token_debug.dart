// Token debugging utility for Gearted app
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Simple JWT decoder - does not validate signature
Map<String, dynamic> decodeJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid JWT token format');
  }

  // Decode the payload (middle part)
  String normalizedPayload = base64.normalize(parts[1]);
  final payloadJson = utf8.decode(base64.decode(normalizedPayload));
  return json.decode(payloadJson);
}

// Format date from timestamp
String formatExpiry(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return date.toString();
}

// Main debug function
Future<void> debugToken() async {
  print('===== TOKEN DEBUG UTILITY =====');

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print('No token found in SharedPreferences');
      return;
    }

    print('Token found: ${token.substring(0, 20)}...');

    // Decode token without validation
    final decodedToken = decodeJwt(token);
    print('Decoded payload: $decodedToken');

    // Check expiration
    if (decodedToken.containsKey('exp')) {
      final expiry = decodedToken['exp'] as int;
      final expiryDate = formatExpiry(expiry);
      final now = DateTime.now();
      final expiresIn =
          DateTime.fromMillisecondsSinceEpoch(expiry * 1000).difference(now);

      print('Token expires at: $expiryDate');
      print('Current time is: $now');

      if (expiry * 1000 < DateTime.now().millisecondsSinceEpoch) {
        print('⚠️ TOKEN IS EXPIRED!');
      } else {
        print(
            '✅ Token is valid for another ${expiresIn.inHours} hours and ${expiresIn.inMinutes % 60} minutes');
      }
    }

    // Check token format
    if (token.startsWith('Bearer ')) {
      print(
          '⚠️ WARNING: Token has "Bearer " prefix which should not be stored!');
    }
  } catch (e) {
    print('Error analyzing token: $e');
  }

  print('============================');
}

// Simple clear token utility
Future<void> clearToken() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    print('✅ Token cleared successfully');
  } catch (e) {
    print('Error clearing token: $e');
  }
}
