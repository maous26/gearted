import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoriesData {
  // War-themed categories with aggressive styling
  static const List<CategoryModel> mainCategories = [
    // 1. ÉQUIPEMENT DE PROTECTION (priorité haute pour la sécurité)
    CategoryModel(
      id: 'protection',
      name: 'protection',
      displayName: 'Combat Protection',
      icon: Icons.emergency,
      color: Color(0xFF8B0000), // Battle Red
      type: CategoryType.equipment,
      keywords: [
        'protection',
        'sécurité',
        'équipement',
        'safety',
        'combat',
        'battle'
      ],
      priority: 100,
      isPopular: true,
    ),

    // 2. RÉPLIQUES
    CategoryModel(
      id: 'replicas',
      name: 'replicas',
      displayName: 'Tactical Weapons',
      icon: Icons.military_tech,
      color: Color(0xFF1C1C1C), // Military Black
      type: CategoryType.weapon,
      keywords: [
        'réplique',
        'arme',
        'gun',
        'rifle',
        'pistol',
        'weapon',
        'tactical'
      ],
      priority: 90,
      isPopular: true,
    ),

    // 3. ACCESSOIRES
    CategoryModel(
      id: 'accessories',
      name: 'accessories',
      displayName: 'Combat Gear',
      icon: Icons.build,
      color: Color(0xFF4F5D2F), // Camouflage Green
      type: CategoryType.accessory,
      keywords: [
        'accessoire',
        'visée',
        'chargeur',
        'silencieux',
        'combat',
        'gear'
      ],
      priority: 80,
      isPopular: true,
    ),

    // 4. TENUES & CAMOUFLAGE
    CategoryModel(
      id: 'clothing',
      name: 'clothing',
      displayName: 'Military Uniforms',
      icon: Icons.person_4,
      color: Color(0xFFDAA520), // Victory Gold
      type: CategoryType.gear,
      keywords: [
        'tenue',
        'uniforme',
        'camouflage',
        'vêtement',
        'military',
        'tactical'
      ],
      priority: 70,
    ),

    // 5. PIÈCES & UPGRADES
    CategoryModel(
      id: 'parts',
      name: 'parts',
      displayName: 'Tactical Upgrades',
      icon: Icons.precision_manufacturing,
      color: Color(0xFF2F2F2F), // Dark Gray
      type: CategoryType.internal,
      keywords: [
        'pièce',
        'upgrade',
        'gearbox',
        'moteur',
        'tactical',
        'performance'
      ],
      priority: 60,
    ),

    // 6. OUTILS & MAINTENANCE
    CategoryModel(
      id: 'tools',
      name: 'tools',
      displayName: 'Field Tools',
      icon: Icons.handyman,
      color: Color(0xFF4682B4), // Steel Blue
      type: CategoryType.tool,
      keywords: [
        'outil',
        'maintenance',
        'nettoyage',
        'entretien',
        'field',
        'tools'
      ],
      priority: 50,
    ),

    // 7. COMMUNICATION
    CategoryModel(
      id: 'communication',
      name: 'communication',
      displayName: 'Command Center',
      icon: Icons.settings_input_antenna,
      color: Color(0xFF556B2F), // Combat Green
      type: CategoryType.electronic,
      keywords: [
        'radio',
        'talkie',
        'communication',
        'ptt',
        'command',
        'tactical'
      ],
      priority: 40,
    ),
  ];

  // Aggressive war-themed subcategories
  static const List<CategoryModel> subCategories = [
    // === COMBAT PROTECTION ===
    CategoryModel(
      id: 'face_protection',
      name: 'face_protection',
      displayName: 'Battle Masks',
      icon: Icons.warning,
      color: Color(0xFF8B0000), // Battle Red
      type: CategoryType.equipment,
      parentId: 'protection',
      keywords: [
        'masque',
        'lunettes',
        'protection visage',
        'mesh',
        'dye',
        'battle',
        'combat'
      ],
      priority: 100,
      isPopular: true,
    ),
    CategoryModel(
      id: 'body_protection',
      name: 'body_protection',
      displayName: 'Tactical Armor',
      icon: Icons.security,
      color: Color(0xFF8B0000), // Battle Red
      type: CategoryType.equipment,
      parentId: 'protection',
      keywords: [
        'gilet',
        'tactique',
        'chest rig',
        'porte plaque',
        'vest',
        'armor',
        'tactical'
      ],
      priority: 99,
      isPopular: true,
    ),
    CategoryModel(
      id: 'head_protection',
      name: 'head_protection',
      displayName: 'Combat Helmets',
      icon: Icons.shield,
      color: Color(0xFF8B0000), // Battle Red
      type: CategoryType.equipment,
      parentId: 'protection',
      keywords: [
        'casque',
        'helmet',
        'fast',
        'mich',
        'protection tête',
        'combat',
        'military'
      ],
      priority: 98,
      isPopular: true,
    ),
    CategoryModel(
      id: 'hands_protection',
      name: 'hands_protection',
      displayName: 'Tactical Gloves',
      icon: Icons.front_hand,
      color: Color(0xFF8B0000), // Battle Red
      type: CategoryType.equipment,
      parentId: 'protection',
      keywords: [
        'gants',
        'gloves',
        'mechanix',
        'protection mains',
        'tactical',
        'combat'
      ],
      priority: 97,
    ),
    CategoryModel(
      id: 'joints_protection',
      name: 'joints_protection',
      displayName: 'Combat Pads',
      icon: Icons.fitness_center,
      color: Color(0xFF8B0000), // Battle Red
      type: CategoryType.equipment,
      parentId: 'protection',
      keywords: [
        'genouillères',
        'coudières',
        'knee pads',
        'elbow',
        'combat',
        'protection'
      ],
      priority: 96,
    ),

    // === TACTICAL WEAPONS ===
    CategoryModel(
      id: 'aeg_rifles',
      name: 'aeg_rifles',
      displayName: 'Assault Rifles',
      icon: Icons.military_tech,
      color: Color(0xFF1C1C1C), // Military Black
      type: CategoryType.weapon,
      parentId: 'replicas',
      keywords: [
        'aeg',
        'fusil',
        'électrique',
        'm4',
        'ak',
        'rifle',
        'assault',
        'tactical'
      ],
      priority: 95,
      isPopular: true,
    ),
    CategoryModel(
      id: 'gas_pistols',
      name: 'gas_pistols',
      displayName: 'Combat Sidearms',
      icon: Icons.gps_fixed,
      color: Color(0xFF1C1C1C), // Military Black
      type: CategoryType.weapon,
      parentId: 'replicas',
      keywords: [
        'pistolet',
        'gbb',
        'gaz',
        'pistol',
        'glock',
        'beretta',
        'sidearm',
        'combat'
      ],
      priority: 94,
      isPopular: true,
    ),
    CategoryModel(
      id: 'sniper_rifles',
      name: 'sniper_rifles',
      displayName: 'Precision Weapons',
      icon: Icons.my_location,
      color: Color(0xFF1C1C1C), // Military Black
      type: CategoryType.weapon,
      parentId: 'replicas',
      keywords: [
        'sniper',
        'précision',
        'spring',
        'bolt action',
        'precision',
        'long range'
      ],
      priority: 93,
    ),
    CategoryModel(
      id: 'shotguns',
      name: 'shotguns',
      displayName: 'Breacher Weapons',
      icon: Icons.dangerous,
      color: Color(0xFF1C1C1C), // Military Black
      type: CategoryType.weapon,
      parentId: 'replicas',
      keywords: [
        'shotgun',
        'pompe',
        'fusil pompe',
        'breacher',
        'tactical',
        'close combat'
      ],
      priority: 92,
    ),

    // === COMBAT GEAR ===
    CategoryModel(
      id: 'sights',
      name: 'sights',
      displayName: 'Targeting Systems',
      icon: Icons.center_focus_strong,
      color: Color(0xFF4F5D2F), // Camouflage Green
      type: CategoryType.accessory,
      parentId: 'accessories',
      keywords: [
        'red dot',
        'lunette',
        'visée',
        'scope',
        'aimpoint',
        'eotech',
        'targeting',
        'tactical'
      ],
      priority: 91,
      isPopular: true,
    ),
    CategoryModel(
      id: 'magazines',
      name: 'magazines',
      displayName: 'Ammo Systems',
      icon: Icons.battery_full,
      color: Color(0xFF4F5D2F), // Camouflage Green
      type: CategoryType.accessory,
      parentId: 'accessories',
      keywords: [
        'chargeur',
        'magazine',
        'hi-cap',
        'mid-cap',
        'real-cap',
        'ammo',
        'tactical'
      ],
      priority: 90,
    ),
    CategoryModel(
      id: 'silencers',
      name: 'silencers',
      displayName: 'Stealth Systems',
      icon: Icons.volume_off,
      color: Color(0xFF4F5D2F), // Camouflage Green
      type: CategoryType.accessory,
      parentId: 'accessories',
      keywords: [
        'silencieux',
        'tracer',
        'suppressor',
        'acetech',
        'stealth',
        'tactical'
      ],
      priority: 89,
    ),
    CategoryModel(
      id: 'grips_rails',
      name: 'grips_rails',
      displayName: 'Weapon Systems',
      icon: Icons.category,
      color: Color(0xFF4F5D2F), // Camouflage Green
      type: CategoryType.accessory,
      parentId: 'accessories',
      keywords: [
        'grip',
        'rail',
        'poignée',
        'ris',
        'mlok',
        'keymod',
        'weapon',
        'tactical'
      ],
      priority: 88,
    ),

    // === MILITARY UNIFORMS ===
    CategoryModel(
      id: 'uniforms',
      name: 'uniforms',
      displayName: 'Field Uniforms',
      icon: Icons.person_4,
      color: Color(0xFFDAA520), // Victory Gold
      type: CategoryType.gear,
      parentId: 'clothing',
      keywords: [
        'uniforme',
        'bdu',
        'acu',
        'multicam',
        'camouflage',
        'field',
        'military'
      ],
      priority: 85,
    ),
    CategoryModel(
      id: 'boots',
      name: 'boots',
      displayName: 'Combat Boots',
      icon: Icons.hiking,
      color: Color(0xFFDAA520), // Victory Gold
      type: CategoryType.gear,
      parentId: 'clothing',
      keywords: [
        'rangers',
        'chaussures',
        'boots',
        'tactical',
        'combat',
        'military'
      ],
      priority: 84,
    ),

    // === TACTICAL UPGRADES ===
    CategoryModel(
      id: 'gearbox',
      name: 'gearbox',
      displayName: 'War Machine Parts',
      icon: Icons.precision_manufacturing,
      color: Color(0xFF2F2F2F), // Dark Gray
      type: CategoryType.internal,
      parentId: 'parts',
      keywords: [
        'gearbox',
        'v2',
        'v3',
        'engrenage',
        'piston',
        'war',
        'machine',
        'tactical'
      ],
      priority: 80,
    ),
    CategoryModel(
      id: 'barrels',
      name: 'barrels',
      displayName: 'Precision Systems',
      icon: Icons.straighten,
      color: Color(0xFF2F2F2F), // Dark Gray
      type: CategoryType.internal,
      parentId: 'parts',
      keywords: [
        'canon',
        'barrel',
        'hop-up',
        'précision',
        'maple leaf',
        'accuracy',
        'tactical'
      ],
      priority: 79,
    ),
    CategoryModel(
      id: 'motors',
      name: 'motors',
      displayName: 'Power Systems',
      icon: Icons.electric_bolt,
      color: Color(0xFF2F2F2F), // Dark Gray
      type: CategoryType.internal,
      parentId: 'parts',
      keywords: [
        'moteur',
        'motor',
        'high torque',
        'high speed',
        'power',
        'tactical'
      ],
      priority: 78,
    ),

    // === FIELD TOOLS ===
    CategoryModel(
      id: 'cleaning_tools',
      name: 'cleaning_tools',
      displayName: 'Field Maintenance',
      icon: Icons.handyman,
      color: Color(0xFF4682B4), // Steel Blue
      type: CategoryType.tool,
      parentId: 'tools',
      keywords: [
        'nettoyage',
        'cleaning',
        'rod',
        'baguette',
        'field',
        'maintenance',
        'tactical'
      ],
      priority: 75,
    ),
    CategoryModel(
      id: 'tech_tools',
      name: 'tech_tools',
      displayName: 'Tactical Tools',
      icon: Icons.construction,
      color: Color(0xFF4682B4), // Steel Blue
      type: CategoryType.tool,
      parentId: 'tools',
      keywords: [
        'tournevis',
        'clé',
        'technique',
        'réparation',
        'tactical',
        'field'
      ],
      priority: 74,
    ),

    // === COMMAND CENTER ===
    CategoryModel(
      id: 'radios',
      name: 'radios',
      displayName: 'Command Radios',
      icon: Icons.settings_input_antenna,
      color: Color(0xFF556B2F), // Combat Green
      type: CategoryType.electronic,
      parentId: 'communication',
      keywords: [
        'radio',
        'talkie',
        'baofeng',
        'motorola',
        'command',
        'tactical'
      ],
      priority: 73,
    ),
    CategoryModel(
      id: 'headsets',
      name: 'headsets',
      displayName: 'Tactical Comms',
      icon: Icons.headphones,
      color: Colors.teal,
      type: CategoryType.electronic,
      parentId: 'communication',
      keywords: ['casque', 'headset', 'comtac', 'peltor'],
      priority: 72,
    ),
  ];

  // Toutes les catégories combinées
  static List<CategoryModel> get allCategories =>
      [...mainCategories, ...subCategories];

  // Obtenir toutes les catégories d'équipement
  static List<CategoryModel> get equipmentCategories =>
      allCategories.where((cat) => cat.type == CategoryType.equipment).toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));

  // Obtenir les catégories populaires
  static List<CategoryModel> get popularCategories =>
      allCategories.where((cat) => cat.isPopular).toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));

  // Obtenir les sous-catégories d'une catégorie principale
  static List<CategoryModel> getSubCategories(String parentId) =>
      subCategories.where((cat) => cat.parentId == parentId).toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));

  // Trouver une catégorie par ID
  static CategoryModel? getCategoryById(String id) {
    try {
      return allCategories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Recherche de catégories par mots-clés
  static List<CategoryModel> searchCategories(String query) {
    final queryLower = query.toLowerCase();
    return allCategories.where((cat) {
      return cat.name.toLowerCase().contains(queryLower) ||
          cat.displayName.toLowerCase().contains(queryLower) ||
          cat.keywords.any((k) => k.toLowerCase().contains(queryLower));
    }).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }

  // Obtenir les catégories par type
  static List<CategoryModel> getCategoriesByType(CategoryType type) =>
      allCategories.where((cat) => cat.type == type).toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));

  // Obtenir les catégories principales seulement
  static List<CategoryModel> get mainCategoriesOnly => mainCategories;

  // Obtenir les sous-catégories seulement
  static List<CategoryModel> get subCategoriesOnly => subCategories;

  // Mapper vers l'ancien format pour la compatibilité
  static Map<String, List<String>> get legacyFormatMapping {
    final Map<String, List<String>> mapping = {};

    for (final mainCat in mainCategories) {
      final subCats = getSubCategories(mainCat.id);
      mapping[mainCat.displayName] =
          subCats.map((sub) => sub.displayName).toList();
    }

    return mapping;
  }

  // Trouver la catégorie principale d'une sous-catégorie
  static CategoryModel? getParentCategory(String categoryId) {
    final category = getCategoryById(categoryId);
    if (category?.parentId != null) {
      return getCategoryById(category!.parentId!);
    }
    return null;
  }

  // Vérifier si une catégorie est un équipement de protection
  static bool isProtectionEquipment(String categoryId) {
    final category = getCategoryById(categoryId);
    return category?.type == CategoryType.equipment;
  }

  // Obtenir les suggestions de catégories pour la recherche
  static List<CategoryModel> getSuggestionsForQuery(String query) {
    if (query.isEmpty) return popularCategories.take(6).toList();

    final suggestions = searchCategories(query).take(8).toList();

    // Prioriser les équipements de protection dans les suggestions
    suggestions.sort((a, b) {
      if (a.type == CategoryType.equipment && b.type != CategoryType.equipment)
        return -1;
      if (b.type == CategoryType.equipment && a.type != CategoryType.equipment)
        return 1;
      return b.priority.compareTo(a.priority);
    });

    return suggestions;
  }
}
