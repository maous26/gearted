import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gearted_mobile/widgets/category/quick_category_grid.dart';
import 'package:gearted_mobile/core/models/category_model.dart';
import 'package:gearted_mobile/core/constants/categories_data.dart';

void main() {
  group('QuickCategoryGrid Visual Verification', () {
    testWidgets('Visual layout verification on different screen sizes',
        (WidgetTester tester) async {
      // Test on different screen sizes
      final screenSizes = [
        const Size(320, 640), // Small phone
        const Size(375, 667), // iPhone SE
        const Size(414, 896), // iPhone 11 Pro Max
      ];

      for (final size in screenSizes) {
        print(
            'Visual verification on screen size: ${size.width}x${size.height}');

        await tester.binding.setSurfaceSize(size);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const QuickCategoryGrid(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify main components are present
        expect(find.text('Équipement de protection'), findsOneWidget);
        expect(find.text('Toutes les catégories'), findsOneWidget);
        expect(find.text('Catégories populaires'), findsOneWidget);

        // Verify no overflow errors occur
        final errors = tester.takeException();
        expect(errors, isNull,
            reason:
                'No layout overflow should occur on ${size.width}x${size.height}');

        print('✓ Visual verification passed for ${size.width}x${size.height}');
      }
    });
  });
}
