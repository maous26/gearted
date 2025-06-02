import '../core/models/user.dart';
import 'auth_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  late final AuthService _authService;

  // Cache for current user data
  User? _currentUser;

  factory UserService() {
    return _instance;
  }

  UserService._internal() {
    _authService = AuthService();
  }

  /// Get the current authenticated user
  Future<User?> getCurrentUser() async {
    try {
      // Return cached user if available
      if (_currentUser != null) {
        return _currentUser;
      }

      // Get user data from auth service
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _currentUser = User.fromJson(userData);
        return _currentUser;
      }

      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  /// Get current user ID
  Future<String?> getCurrentUserId() async {
    final user = await getCurrentUser();
    return user?.id;
  }

  /// Get current user name for display
  Future<String?> getCurrentUserName() async {
    final user = await getCurrentUser();
    return user?.username;
  }

  /// Get current user profile image URL
  Future<String?> getCurrentUserProfileImage() async {
    final user = await getCurrentUser();
    return user?.photoUrl;
  }

  /// Get current user rating
  Future<double> getCurrentUserRating() async {
    final user = await getCurrentUser();
    return user?.rating ?? 0.0;
  }

  /// Get current user sales count
  Future<int> getCurrentUserSalesCount() async {
    final user = await getCurrentUser();
    return user?.salesCount ?? 0;
  }

  /// Refresh user data from server
  Future<User?> refreshCurrentUser() async {
    try {
      _currentUser = null; // Clear cache
      return await getCurrentUser();
    } catch (e) {
      print('Error refreshing user data: $e');
      return null;
    }
  }

  /// Clear cached user data (e.g., on logout)
  void clearUserCache() {
    _currentUser = null;
  }

  /// Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  /// Get user display name with fallback
  Future<String> getUserDisplayName() async {
    final user = await getCurrentUser();
    if (user != null) {
      return user.username;
    }

    // Fallback to email prefix if username not available
    final userData = await _authService.getCurrentUser();
    if (userData != null && userData['email'] != null) {
      final email = userData['email'] as String;
      return email.split('@')[0];
    }

    return 'Utilisateur';
  }

  /// Get seller information for listings
  Future<Map<String, dynamic>> getSellerInfo() async {
    final user = await getCurrentUser();
    if (user == null) {
      return {
        'name': 'Utilisateur',
        'avatar': 'U',
        'rating': 0.0,
        'reviews': 0,
        'memberSince': '2024',
        'isOnline': true,
      };
    }

    return {
      'name': user.username,
      'avatar': user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
      'rating': user.rating,
      'reviews': user.salesCount,
      'memberSince': user.createdAt.year.toString(),
      'isOnline': true,
      'profileImage': user.photoUrl,
    };
  }
}
