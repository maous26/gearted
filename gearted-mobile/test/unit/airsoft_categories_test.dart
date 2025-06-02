import 'package:flutter_test/flutter_test.dart';
import 'package:gearted/core/constants/airsoft_categories.dart';

void main() {
  group('AirsoftCategories Tests', () {
    test('should have main categories defined', () {
      expect(AirsoftCategories.mainCategories, isNotEmpty);
      expect(AirsoftCategories.mainCategories.length, equals(7));
    });

    test('should have all categories defined', () {
      expect(AirsoftCategories.allCategories, isNotEmpty);
      expect(AirsoftCategories.allCategories.length, greaterThan(20));
    });

    test('should correctly identify main categories', () {
      expect(
          AirsoftCategories.isMainCategory(AirsoftCategories.repliquesAirsoft),
          isTrue);
      expect(
          AirsoftCategories.isMainCategory(
              AirsoftCategories.equipementProtection),
          isTrue);
      expect(AirsoftCategories.isMainCategory(AirsoftCategories.repliquePoing),
          isFalse);
      expect(
          AirsoftCategories.isMainCategory(AirsoftCategories.masques), isFalse);
    });

    test('should get correct subcategories', () {
      final replicaSubCategories = AirsoftCategories.getSubCategories(
          AirsoftCategories.repliquesAirsoft);
      expect(replicaSubCategories, contains(AirsoftCategories.repliquePoing));
      expect(replicaSubCategories, contains(AirsoftCategories.repliqueLongue));
      expect(
          replicaSubCategories, contains(AirsoftCategories.repliqueLongueAEG));
    });

    test('should get correct main category from subcategory', () {
      expect(AirsoftCategories.getMainCategory(AirsoftCategories.repliquePoing),
          equals(AirsoftCategories.repliquesAirsoft));
      expect(AirsoftCategories.getMainCategory(AirsoftCategories.masques),
          equals(AirsoftCategories.equipementProtection));
      expect(AirsoftCategories.getMainCategory(AirsoftCategories.gearbox),
          equals(AirsoftCategories.piecesInternesUpgrade));
    });

    test('should have category icons defined', () {
      expect(AirsoftCategories.categoryIcons, isNotEmpty);
      expect(AirsoftCategories.categoryIcons.length, equals(7));

      for (final mainCategory in AirsoftCategories.mainCategories) {
        expect(
            AirsoftCategories.categoryIcons.containsKey(mainCategory), isTrue);
      }
    });

    test('should return null for non-existent categories', () {
      expect(
          AirsoftCategories.getMainCategory('Non-existent Category'), isNull);
      expect(
          AirsoftCategories.getSubCategories('Non-existent Category'), isEmpty);
    });

    test('should contain specific airsoft categories', () {
      // Test some specific categories that are important for airsoft
      expect(AirsoftCategories.allCategories,
          contains(AirsoftCategories.repliqueLongueAEG));
      expect(AirsoftCategories.allCategories,
          contains(AirsoftCategories.repliquePoingGaz));
      expect(AirsoftCategories.allCategories,
          contains(AirsoftCategories.organesVisee));
      expect(AirsoftCategories.allCategories,
          contains(AirsoftCategories.giletsTactiques));
      expect(
          AirsoftCategories.allCategories, contains(AirsoftCategories.masques));
      expect(
          AirsoftCategories.allCategories, contains(AirsoftCategories.gearbox));
    });
  });
}
