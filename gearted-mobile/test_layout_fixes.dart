import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gearted/widgets/category/quick_category_grid.dart';
import 'package:gearted/core/models/category_model.dart';
import 'package:gearted/core/constants/categories_data.dart';

void main() {
  testWidgets('QuickCategoryGrid layout overflow test',
      (WidgetTester tester) async {
    // Create a test router
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const QuickCategoryGrid(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const Scaffold(body: Text('Search')),
        ),
      ],
    );

    // Test different screen sizes
    final screenSizes = [
      const Size(320, 640), // Small phone
      const Size(375, 667), // iPhone SE
      const Size(414, 896), // iPhone 11 Pro Max
    ];

    for (final size in screenSizes) {
      print('Testing layout on screen size: ${size.width}x${size.height}');

      await tester.binding.setSurfaceSize(size);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // Wait for any animations to complete
      await tester.pumpAndSettle();

      // Check that the widget is rendered without overflow
      expect(find.byType(QuickCategoryGrid), findsOneWidget);

      // Verify equipment protection section is visible
      expect(find.text('Équipement de Protection'), findsOneWidget);

      // Verify main categories are visible
      expect(find.text('Toutes les catégories'), findsOneWidget);

      // Verify popular categories are visible
      expect(find.text('Catégories populaires'), findsOneWidget);

      // Check for any render overflow errors
      final List<FlutterError> errors = [];
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.toString().contains('RenderFlex overflowed')) {
          errors.add(details.exception as FlutterError);
        }
      };

      // Trigger a rebuild to catch any overflow errors
      await tester.pump();

      // Verify no overflow errors
      expect(errors, isEmpty,
          reason:
              'Found overflow errors on ${size.width}x${size.height} screen: ${errors.map((e) => e.toString()).join(', ')}');
    }
  });

  testWidgets('Category data integrity test', (WidgetTester tester) async {
    // Test that all categories have required data
    for (final category in CategoriesData.allCategories) {
      expect(category.id, isNotEmpty,
          reason:
              'Category ID should not be empty for ${category.displayName}');
      expect(category.displayName, isNotEmpty,
          reason: 'Display name should not be empty for ${category.id}');
      expect(category.keywords, isNotEmpty,
          reason: 'Keywords should not be empty for ${category.displayName}');
      expect(category.priority, greaterThanOrEqualTo(0),
          reason:
              'Priority should be non-negative for ${category.displayName}');
    }

    // Test equipment categories have high priority
    for (final category in CategoriesData.equipmentCategories) {
      expect(category.priority, greaterThanOrEqualTo(80),
          reason:
              'Equipment category ${category.displayName} should have high priority (>=80), got ${category.priority}');
    }

    // Test category hierarchy
    final mainCategories = CategoriesData.mainCategories;
    expect(mainCategories.length, greaterThan(0),
        reason: 'Should have main categories');

    for (final mainCategory in mainCategories) {
      expect(mainCategory.isMainCategory, isTrue,
          reason:
              'Main category ${mainCategory.displayName} should have parentId = null');
    }

    // Test popular categories
    final popularCategories = CategoriesData.popularCategories;
    expect(popularCategories.length, greaterThan(0),
        reason: 'Should have popular categories');

    for (final category in popularCategories) {
      expect(category.isPopular, isTrue,
          reason:
              'Popular category ${category.displayName} should have isPopular = true');
    }
  });

  testWidgets('Category type extensions test', (WidgetTester tester) async {
    // Test all category types have proper extensions
    for (final type in CategoryType.values) {
      expect(type.displayName, isNotEmpty,
          reason: 'Type $type should have display name');
      expect(type.icon, isNotNull, reason: 'Type $type should have icon');
      expect(type.color, isNotNull, reason: 'Type $type should have color');
    }

    // Test equipment type has proper styling
    expect(
        CategoryType.equipment.displayName, equals('Équipement de Protection'));
    expect(CategoryType.equipment.icon, equals(Icons.shield));
    expect(CategoryType.equipment.color, equals(Colors.red));
  });

  testWidgets('Category search and filtering test',
      (WidgetTester tester) async {
    // Test search functionality
    final searchResults = CategoriesData.searchCategories('protection');
    expect(searchResults, isNotEmpty,
        reason: 'Should find categories matching "protection"');

    final equipmentResults =
        searchResults.where((c) => c.type == CategoryType.equipment).toList();
    expect(equipmentResults, isNotEmpty,
        reason: 'Should find equipment categories matching "protection"');

    // Test filtering by type
    final weaponCategories =
        CategoriesData.getCategoriesByType(CategoryType.weapon);
    expect(weaponCategories, isNotEmpty,
        reason: 'Should have weapon categories');

    for (final category in weaponCategories) {
      expect(category.type, equals(CategoryType.weapon),
          reason:
              'Filtered category ${category.displayName} should be weapon type');
    }

    // Test subcategories
    for (final mainCategory in CategoriesData.mainCategories) {
      final subCategories = CategoriesData.getSubCategories(mainCategory.id);
      // Some main categories might not have subcategories, which is okay
      for (final subCategory in subCategories) {
        expect(subCategory.parentId, equals(mainCategory.id),
            reason:
                'Subcategory ${subCategory.displayName} should have correct parent ID');
      }
    }
  });

  test('Category model serialization test', () {
    final testCategory = CategoryModel(
      id: 'test-id',
      name: 'test-name',
      displayName: 'Test Category',
      icon: Icons.science,
      color: Colors.blue,
      type: CategoryType.equipment,
      keywords: ['test', 'category'],
      parentId: 'parent-id',
      priority: 100,
      isPopular: true,
    );

    // Test toJson
    final json = testCategory.toJson();
    expect(json['id'], equals('test-id'));
    expect(json['name'], equals('test-name'));
    expect(json['displayName'], equals('Test Category'));
    expect(json['type'], equals('equipment'));
    expect(json['keywords'], equals(['test', 'category']));
    expect(json['parentId'], equals('parent-id'));
    expect(json['priority'], equals(100));
    expect(json['isPopular'], equals(true));

    // Test fromJson
    final recreated = CategoryModel.fromJson(json);
    expect(recreated.id, equals(testCategory.id));
    expect(recreated.name, equals(testCategory.name));
    expect(recreated.displayName, equals(testCategory.displayName));
    expect(recreated.type, equals(testCategory.type));
    expect(recreated.keywords, equals(testCategory.keywords));
    expect(recreated.parentId, equals(testCategory.parentId));
    expect(recreated.priority, equals(testCategory.priority));
    expect(recreated.isPopular, equals(testCategory.isPopular));

    // Test equality
    expect(recreated, equals(testCategory));
    expect(recreated.hashCode, equals(testCategory.hashCode));
  });
}
