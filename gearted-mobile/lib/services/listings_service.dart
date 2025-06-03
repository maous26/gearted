import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/airsoft_categories.dart';
import '../core/constants/categories_data.dart';
import '../core/models/category_model.dart';
import 'user_service.dart';

/// Service to manage listings locally until backend integration
class ListingsService {
  static const String _listingsKey = 'saved_listings';
  static const String _favoriteListingsKey = 'favorite_listings';

  /// Helper method to check if a category is equipment/protection related
  static bool _isEquipmentCategory(String categoryName) {
    try {
      // Check if the category is in equipment protection or high-priority categories
      final category = CategoriesData.allCategories.firstWhere(
        (cat) => cat.name == categoryName,
      );
      
      // Consider equipment categories as those with high priority (protection-focused)
      // or equipment/accessory types
      return category.type == CategoryType.equipment || 
             category.type == CategoryType.accessory ||
             category.priority >= 80; // High priority = protection equipment
    } catch (e) {
      // If category not found in new system, fallback to checking old category constants
      return _isLegacyEquipmentCategory(categoryName);
    }
  }

  /// Fallback helper for legacy categories not yet migrated
  static bool _isLegacyEquipmentCategory(String categoryName) {
    // Legacy equipment categories from old system
    const equipmentCategories = [
      'gilets-tactiques',
      'masques',
      'lunettes-protections',
      'casques',
      'genouilleres-coudieres',
      'gants',
      'chaussures-tactiques',
    ];
    return equipmentCategories.contains(categoryName);
  }

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

  /// Get equipment listings only
  static Future<List<Map<String, dynamic>>> getEquipmentListings() async {
    final allListings = await getAllListings();
    return allListings.where((listing) {
      final category = listing['category'] as String?;
      return category != null && _isEquipmentCategory(category);
    }).toList();
  }

  /// Search listings with equipment prioritization
  static Future<List<Map<String, dynamic>>> searchListings({
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? condition,
    bool equipmentOnly = false,
    bool prioritizeEquipment = false,
  }) async {
    final allListings = await getAllListings();
    List<Map<String, dynamic>> results = List.from(allListings);

    // Filter by equipment only
    if (equipmentOnly) {
      results = results.where((listing) {
        final listingCategory = listing['category'] as String?;
        return listingCategory != null && 
               _isEquipmentCategory(listingCategory);
      }).toList();
    }

    // Filter by query
    if (query != null && query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      results = results.where((listing) {
        final title = (listing['title'] as String? ?? '').toLowerCase();
        final description = (listing['description'] as String? ?? '').toLowerCase();
        final tags = (listing['tags'] as List<dynamic>? ?? [])
            .map((tag) => tag.toString().toLowerCase())
            .join(' ');
        
        return title.contains(queryLower) || 
               description.contains(queryLower) || 
               tags.contains(queryLower);
      }).toList();
    }

    // Filter by category
    if (category != null && category.isNotEmpty) {
      results = results.where((listing) {
        final listingCategory = listing['category'] as String?;
        return listingCategory == category;
      }).toList();
    }

    // Filter by price range
    if (minPrice != null || maxPrice != null) {
      results = results.where((listing) {
        final price = listing['price'] as double?;
        if (price == null) return false;
        
        if (minPrice != null && price < minPrice) return false;
        if (maxPrice != null && price > maxPrice) return false;
        
        return true;
      }).toList();
    }

    // Filter by condition
    if (condition != null && condition.isNotEmpty) {
      results = results.where((listing) {
        return listing['condition'] == condition;
      }).toList();
    }

    // Sort with equipment prioritization
    if (prioritizeEquipment) {
      results.sort((a, b) {
        final aIsEquipment = _isEquipmentCategory(
            a['category'] as String? ?? '');
        final bIsEquipment = _isEquipmentCategory(
            b['category'] as String? ?? '');
        
        if (aIsEquipment && !bIsEquipment) return -1;
        if (!aIsEquipment && bIsEquipment) return 1;
        
        // If both are equipment or both are not, sort by creation date
        final aDate = DateTime.parse(a['createdAt'] as String);
        final bDate = DateTime.parse(b['createdAt'] as String);
        return bDate.compareTo(aDate);
      });
    } else {
      // Default sort by creation date
      results.sort((a, b) {
        final aDate = DateTime.parse(a['createdAt'] as String);
        final bDate = DateTime.parse(b['createdAt'] as String);
        return bDate.compareTo(aDate);
      });
    }

    return results;
  }

  /// Get listings by equipment type
  static Future<List<Map<String, dynamic>>> getListingsByEquipmentType(
      List<String> equipmentCategories) async {
    final allListings = await getAllListings();
    return allListings.where((listing) {
      final category = listing['category'] as String?;
      return category != null && equipmentCategories.contains(category);
    }).toList();
  }

  /// Get recently added listings with equipment priority
  static Future<List<Map<String, dynamic>>> getRecentListings({
    bool prioritizeEquipment = true
  }) async {
    final allListings = await getAllListings();
    
    if (prioritizeEquipment) {
      // Sort equipment items first, then by date
      allListings.sort((a, b) {
        final aIsEquipment = _isEquipmentCategory(
            a['category'] as String? ?? '');
        final bIsEquipment = _isEquipmentCategory(
            b['category'] as String? ?? '');
        
        if (aIsEquipment && !bIsEquipment) return -1;
        if (!aIsEquipment && bIsEquipment) return 1;
        
        // If both are equipment or both are not, sort by creation date
        final aDate = DateTime.parse(a['createdAt'] as String);
        final bDate = DateTime.parse(b['createdAt'] as String);
        return bDate.compareTo(aDate);
      });
    } else {
      // Sort by createdAt descending only
      allListings.sort((a, b) => DateTime.parse(b['createdAt'])
          .compareTo(DateTime.parse(a['createdAt'])));
    }
    
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
      // Equipment listings prioritized at the top for better UX
      {
        'id': 'default_6',
        'title': 'Gilet tactique Viper VX Buckle Up',
        'description': 'Gilet tactique modulaire avec système MOLLE complet',
        'price': 85.0,
        'condition': 'Très bon état',
        'category': AirsoftCategories.giletsTactiques,
        'tags': ['Viper', 'Tactique', 'MOLLE', 'Modulaire'],
        'imageUrls': [],
        'rating': 4.3,
        'isExchangeable': false,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_7',
        'title': 'Masque Dye i4 Pro',
        'description': 'Masque de protection intégral avec écran thermique anti-buée',
        'price': 120.0,
        'originalPrice': 180.0,
        'condition': 'Comme neuf',
        'category': AirsoftCategories.masques,
        'tags': ['Dye', 'i4', 'Protection', 'Anti-buée'],
        'imageUrls': [],
        'rating': 4.9,
        'isExchangeable': false,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_1',
        'title': 'M4A1 Daniel Defense MK18',
        'description': 'Réplique électrique AEG M4A1 en excellent état avec rail RIS et crosse rétractable',
        'price': 250.0,
        'originalPrice': 350.0,
        'condition': 'Comme neuf',
        'category': AirsoftCategories.repliqueLongueAEG,
        'tags': ['M4', 'AEG', 'Daniel Defense', 'Rail RIS'],
        'imageUrls': [],
        'rating': 4.8,
        'isExchangeable': false,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_2',
        'title': 'Gearbox V2 complète upgrade',
        'description': 'Gearbox V2 révisée avec nouveaux joints et piston renforcé',
        'price': 80.0,
        'originalPrice': 120.0,
        'condition': 'Bon état',
        'category': AirsoftCategories.gearbox,
        'tags': ['V2', 'Gearbox', 'Révisée', 'Upgrade'],
        'imageUrls': [],
        'rating': 4.5,
        'isExchangeable': true,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_3',
        'title': 'Red dot Aimpoint T1 replica',
        'description': 'Red dot Aimpoint T1 replica de qualité avec montage picatinny',
        'price': 45.0,
        'condition': 'Très bon état',
        'category': AirsoftCategories.organesVisee,
        'tags': ['Red dot', 'Aimpoint', 'T1', 'Picatinny'],
        'imageUrls': [],
        'rating': 4.7,
        'isExchangeable': false,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_4',
        'title': 'AK-74 Cyma CM040',
        'description': 'AK-74 Cyma CM040 full métal avec crosse pliante',
        'price': 180.0,
        'condition': 'Neuf',
        'category': AirsoftCategories.repliqueLongueAEG,
        'tags': ['AK-74', 'Cyma', 'Full métal', 'Crosse pliante'],
        'imageUrls': [],
        'rating': 4.6,
        'isExchangeable': false,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_5',
        'title': 'Pistolet GBB Glock 17 Gen4',
        'description': 'Pistolet GBB Glock 17 Tokyo Marui avec blowback réaliste',
        'price': 95.0,
        'condition': 'Comme neuf',
        'category': AirsoftCategories.repliquePoingGaz,
        'tags': ['Glock', 'GBB', 'Tokyo Marui', 'Blowback'],
        'imageUrls': [],
        'rating': 4.4,
        'isExchangeable': true,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_8',
        'title': 'Silencieux tracer Acetech Lighter BT',
        'description': 'Silencieux avec unité tracer intégrée et contrôle Bluetooth',
        'price': 75.0,
        'condition': 'Neuf',
        'category': AirsoftCategories.silencieuxTracers,
        'tags': ['Acetech', 'Tracer', 'Bluetooth', 'Silencieux'],
        'imageUrls': [],
        'rating': 4.6,
        'isExchangeable': true,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 8)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_9',
        'title': 'Uniforme multicam complet',
        'description': 'Uniforme militaire multicam avec veste et pantalon taille L',
        'price': 65.0,
        'condition': 'Bon état',
        'category': AirsoftCategories.uniformes,
        'tags': ['Multicam', 'Militaire', 'Taille L', 'Complet'],
        'imageUrls': [],
        'rating': 4.2,
        'isExchangeable': false,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 9)).toIso8601String(),
        'userId': 'system',
      },
      {
        'id': 'default_10',
        'title': 'Radio Baofeng UV-5R + PTT',
        'description': 'Radio Baofeng UV-5R avec kit PTT et oreillette tactique',
        'price': 35.0,
        'condition': 'Très bon état',
        'category': AirsoftCategories.talkiesWalkies,
        'tags': ['Baofeng', 'UV-5R', 'PTT', 'Radio'],
        'imageUrls': [],
        'rating': 4.1,
        'isExchangeable': true,
        'createdAt':
            DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'userId': 'system',
      },
    ];
  }
}
