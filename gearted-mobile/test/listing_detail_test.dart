import 'package:flutter_test/flutter_test.dart';
import 'package:gearted/services/listings_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('ListingsService', () {
    test('should return listing by ID', () async {
      // Get all listings first
      final allListings = await ListingsService.getAllListings();
      expect(allListings.isNotEmpty, true);

      // Get first listing
      final firstListing = allListings.first;
      final listingId = firstListing['id'];

      // Test getListingById
      final listing = await ListingsService.getListingById(listingId);
      expect(listing, isNotNull);
      expect(listing!['id'], equals(listingId));
      expect(listing['description'], isNotNull);
      expect(listing['description'], isNotEmpty);
    });

    test('should return null for non-existent listing ID', () async {
      final listing = await ListingsService.getListingById('non_existent_id');
      expect(listing, isNull);
    });

    test('default listings should have descriptions', () async {
      final allListings = await ListingsService.getAllListings();

      for (final listing in allListings) {
        expect(listing['description'], isNotNull);
        expect(listing['description'], isNotEmpty);
        print(
            'Listing "${listing['title']}" has description: "${listing['description']}"');
      }
    });
  });
}
