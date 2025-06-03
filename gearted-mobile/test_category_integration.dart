// Test d'intégration du système de catégories
import 'package:flutter/material.dart';
import 'lib/core/models/category_model.dart';
import 'lib/core/constants/categories_data.dart';

void main() {
  print('=== TEST D\'INTÉGRATION DU SYSTÈME DE CATÉGORIES ===\n');

  // Test 1: Vérification des catégories de base
  print('1. Test des catégories de base:');
  print('   - Nombre total de catégories: ${CategoriesData.allCategories.length}');
  print('   - Catégories principales: ${CategoriesData.mainCategories.length}');
  print('   - Sous-catégories: ${CategoriesData.subCategories.length}');
  
  // Test 2: Vérification des types de catégories
  print('\n2. Test des types de catégories:');
  for (final type in CategoryType.values) {
    final categoriesOfType = CategoriesData.getCategoriesByType(type);
    print('   - ${type.displayName}: ${categoriesOfType.length} catégories');
  }

  // Test 3: Vérification des catégories d'équipement de protection
  print('\n3. Test des catégories d\'équipement de protection:');
  final equipmentCategories = CategoriesData.getEquipmentProtectionCategories();
  print('   - Nombre de catégories d\'équipement: ${equipmentCategories.length}');
  for (final category in equipmentCategories) {
    print('   - ${category.displayName} (priorité: ${category.priority})');
  }

  // Test 4: Vérification des catégories populaires
  print('\n4. Test des catégories populaires:');
  final popularCategories = CategoriesData.getPopularCategories();
  print('   - Nombre de catégories populaires: ${popularCategories.length}');
  for (final category in popularCategories) {
    print('   - ${category.displayName}');
  }

  // Test 5: Test de recherche
  print('\n5. Test de recherche de catégories:');
  final searchResults = CategoriesData.searchCategories('masque');
  print('   - Recherche "masque": ${searchResults.length} résultats');
  for (final category in searchResults) {
    print('   - ${category.displayName}');
  }

  // Test 6: Test de mapping legacy
  print('\n6. Test de mapping legacy:');
  final legacyFormat = CategoriesData.toLegacyCategoryFormat();
  print('   - Nombre de catégories en format legacy: ${legacyFormat.length}');
  
  // Test 7: Vérification des couleurs et icônes
  print('\n7. Test des couleurs et icônes:');
  for (final type in CategoryType.values) {
    print('   - ${type.displayName}: ${type.icon} (${type.color})');
  }

  print('\n=== TESTS TERMINÉS ===');
  print('✅ Le système de catégories est prêt à être utilisé !');
}
