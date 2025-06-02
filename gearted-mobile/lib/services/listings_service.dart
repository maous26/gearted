import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_service.dart';

/// Service to manage listings locally until backend integration
class ListingsService {
  static const String _listingsKey = 'saved_listings';
  static const String _favoriteListingsKey = 'favorite_listings';

  /// Get all listings
  static Future<List<Map<String, dynamic>>> getAllListings() async {
    final prefs = await SharedPreferences.getInstance();
    final listingsString = prefs.getString(_listingsKey);

    if (listingsString != null) {
      final List<dynamic> listingsJson = json.decode(listingsString);
      return listingsJson.cast<Map<String, dynamic>>();
    }

    return _getDefaultListings();
  }

  /// Get recently added listings (last 10)
  static Future<List<Map<String, dynamic>>> getRecentListings() async {
    final allListings = await getAllListings();
    // Sort by createdAt descending and take first 10
    allListings.sort((a, b) => DateTime.parse(b['createdAt'])
        .compareTo(DateTime.parse(a['createdAt'])));
    return allListings.take(10).toList();
  }

  /// Get hot deals (listings with originalPrice > price)
  static Future<List<Map<String, dynamic>>> getHotDeals() async {
    final allListings = await getAllListings();
    return allListings
        .where((listing) =>
            listing['originalPrice'] != null &&
            listing['originalPrice'] > listing['price'])
        .toList();
  }

  /// Add a new listing
  static Future<void> addListing(Map<String, dynamic> listing) async {
    final prefs = await SharedPreferences.getInstance();
    final allListings = await getAllListings();
    final userService = UserService();

    // Add ID and timestamp
    listing['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    listing['createdAt'] = DateTime.now().toIso8601String();

    // Get current user ID from auth service
    final userId = await userService.getCurrentUserId();
    listing['userId'] = userId ?? 'user_anonymous';

    // Ensure all required fields have proper defaults for UI compatibility
    listing['rating'] = listing['rating'] ?? 0.0;
    listing['originalPrice'] = listing['originalPrice']; // Can be null
    listing['isExchangeable'] = listing['isExchangeable'] ?? false;

    allListings.insert(0, listing); // Add to beginning

    await prefs.setString(_listingsKey, json.encode(allListings));
  }

  /// Update a listing
  static Future<void> updateListing(
      String id, Map<String, dynamic> updates) async {
    final prefs = await SharedPreferences.getInstance();
    final allListings = await getAllListings();

    final index = allListings.indexWhere((listing) => listing['id'] == id);
    if (index != -1) {
      allListings[index] = {...allListings[index], ...updates};
      await prefs.setString(_listingsKey, json.encode(allListings));
    }
  }

  /// Delete a listing
  static Future<void> deleteListing(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final allListings = await getAllListings();

    allListings.removeWhere((listing) => listing['id'] == id);
    await prefs.setString(_listingsKey, json.encode(allListings));
  }

  /// Get favorite listings
  static Future<Set<String>> getFavoriteListings() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteListingsKey) ?? [];
    return favorites.toSet();
  }

  /// Toggle favorite status
  static Future<void> toggleFavorite(String listingId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteListings();

    if (favorites.contains(listingId)) {
      favorites.remove(listingId);
    } else {
      favorites.add(listingId);
    }

    await prefs.setStringList(_favoriteListingsKey, favorites.toList());
  }

  /// Check if listing is favorite
  static Future<bool> isFavorite(String listingId) async {
    final favorites = await getFavoriteListings();
    return favorites.contains(listingId);
  }

  /// Get a specific listing by ID
  static Future<Map<String, dynamic>?> getListingById(String id) async {
    final allListings = await getAllListings();
    try {
      return allListings.firstWhere((listing) => listing['id'] == id);
    } catch (e) {
      return null; // Listing not found
    }
  }

  /// Get listings by user ID
  static Future<List<Map<String, dynamic>>> getListingsByUserId(
      String userId) async {
    final allListings = await getAllListings();
    return allListings.where((listing) => listing['userId'] == userId).toList();
  }

  /// Clear all listings (for testing)
  static Future<void> clearAllListings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_listingsKey);
    await prefs.remove(_favoriteListingsKey);
  }

  /// Get default listings for initial state
  static List<Map<String, dynamic>> _getDefaultListings() {
    return [
      {
        'id': 'default_1',
        'title': 'M4A1 Daniel Defense',
        'description': 'Réplique électrique M4A1 en excellent état',
        'price': 250.0,
        'originalPrice': 350.0,
        'condition': 'Comme neuf',
        'category': 'Répliques',
        'tags': ['M4', 'Électrique', 'Daniel Defense'],
        'imageUrls': [],
        'rating': 4.8,
        'isExchangeable': false,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_2',
        'title': 'Gearbox V2 complète',
        'description': 'Gearbox V2 révisée avec nouveaux joints',
        'price': 80.0,
        'originalPrice': 120.0,
        'condition': 'Bon état',
        'category': 'Gearbox',
        'tags': ['V2', 'Gearbox', 'Révisée'],
        'imageUrls': [],
        'rating': 4.5,
        'isExchangeable': true,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_3',
        'title': 'Red dot Aimpoint',
        'description': 'Red dot Aimpoint T1 replica de qualité',
        'price': 45.0,
        'condition': 'Très bon état',
        'category': 'Optiques',
        'tags': ['Red dot', 'Aimpoint', 'T1'],
        'imageUrls': [],
        'rating': 4.7,
        'isExchangeable': false,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_4',
        'title': 'AK-74 Cyma',
        'description': 'AK-74 Cyma CM040 full métal',
        'price': 180.0,
        'condition': 'Neuf',
        'category': 'Répliques',
        'tags': ['AK-74', 'Cyma', 'Full métal'],
        'imageUrls': [],
        'rating': 4.6,
        'isExchangeable': false,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_5',
        'title': 'Pistolet GBB',
        'description': 'Pistolet GBB Glock 17 Tokyo Marui',
        'price': 95.0,
        'condition': 'Comme neuf',
        'category': 'Répliques',
        'tags': ['Glock', 'GBB', 'Tokyo Marui'],
        'imageUrls': [],
        'rating': 4.4,
        'isExchangeable': true,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'userId': 'system',
      },
    ];
  }
}
