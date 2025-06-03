import '../models/airsoft_category.dart';
import '../config/theme.dart';
import 'package:flutter/material.dart';

/// Service de gestion des catégories airsoft avec système à 7 catégories
class CategoryService {
  /// Les 7 catégories principales du système Gearted
  static final List<AirsoftCategory> mainCategories = [
    // 1. RÉPLIQUES - Catégorie #1 (Armes principales)
    AirsoftCategory(
      id: 'replicas',
      name: 'Répliques',
      description: 'AEG, GBB, Spring - Toutes répliques',
      icon: Icons.military_tech,
      color: GeartedColors.replicas,
      accentColor: GeartedColors.replicasAccent,
      backgroundColor: GeartedColors.replicasBackground,
      type: AirsoftCategoryType.replicas,
      priority: 100,
      isPopular: true,
      keywords: [
        'réplique',
        'aeg',
        'gbb',
        'spring',
        'fusil',
        'pistolet',
        'arme'
      ],
      subCategories: [
        AirsoftSubCategory(
          id: 'aeg',
          name: 'AEG (Électrique)',
          description: 'Répliques électriques automatiques',
          icon: Icons.electrical_services,
          keywords: ['aeg', 'électrique', 'automatic', 'batterie'],
          parentId: 'replicas',
        ),
        AirsoftSubCategory(
          id: 'gbb',
          name: 'GBB (Gaz)',
          description: 'Répliques à gaz blowback',
          icon: Icons.local_gas_station,
          keywords: ['gbb', 'gaz', 'blowback', 'green gas'],
          parentId: 'replicas',
        ),
        AirsoftSubCategory(
          id: 'sniper',
          name: 'Snipers',
          description: 'Répliques de précision',
          icon: Icons.my_location,
          keywords: ['sniper', 'bolt', 'précision', 'longue distance'],
          parentId: 'replicas',
        ),
        AirsoftSubCategory(
          id: 'shotgun',
          name: 'Shotguns',
          description: 'Répliques fusils à pompe',
          icon: Icons.scatter_plot,
          keywords: ['shotgun', 'pompe', 'spring', 'multibille'],
          parentId: 'replicas',
        ),
        AirsoftSubCategory(
          id: 'pistol',
          name: 'Pistolets',
          description: 'Armes de poing',
          icon: Icons.radio_button_unchecked,
          keywords: ['pistolet', 'handgun', 'sidearm', 'secondary'],
          parentId: 'replicas',
        ),
      ],
    ),

    // 2. PROTECTION - Catégorie #2 (Sécurité critique)
    AirsoftCategory(
      id: 'protection',
      name: 'Protection',
      description: 'Masques, casques, gilets tactiques',
      icon: Icons.shield,
      color: GeartedColors.protection,
      accentColor: GeartedColors.protectionAccent,
      backgroundColor: GeartedColors.protectionBackground,
      type: AirsoftCategoryType.protection,
      priority: 99,
      isPopular: true,
      keywords: [
        'masque',
        'casque',
        'gilet',
        'protection',
        'sécurité',
        'safety'
      ],
      subCategories: [
        AirsoftSubCategory(
          id: 'masks',
          name: 'Masques & Lunettes',
          description: 'Protection visage et yeux',
          icon: Icons.face,
          keywords: ['masque', 'lunettes', 'protection yeux', 'mesh'],
          parentId: 'protection',
        ),
        AirsoftSubCategory(
          id: 'helmets',
          name: 'Casques',
          description: 'Protection tête',
          icon: Icons.sports_kabaddi,
          keywords: ['casque', 'helmet', 'fast', 'mich'],
          parentId: 'protection',
        ),
        AirsoftSubCategory(
          id: 'vests',
          name: 'Gilets & Armures',
          description: 'Protection corps',
          icon: Icons.shield,
          keywords: ['gilet', 'vest', 'plate carrier', 'armure'],
          parentId: 'protection',
        ),
        AirsoftSubCategory(
          id: 'gloves',
          name: 'Gants',
          description: 'Protection mains',
          icon: Icons.back_hand,
          keywords: ['gants', 'gloves', 'tactique'],
          parentId: 'protection',
        ),
      ],
    ),

    // 3. ACCESSOIRES - Catégorie #3 (Équipement tactique)
    AirsoftCategory(
      id: 'accessories',
      name: 'Accessoires',
      description: 'Optiques, chargeurs, silencieux',
      icon: Icons.center_focus_strong,
      color: GeartedColors.accessories,
      accentColor: GeartedColors.accessoriesAccent,
      backgroundColor: GeartedColors.accessoriesBackground,
      type: AirsoftCategoryType.accessories,
      priority: 98,
      isPopular: true,
      keywords: [
        'optique',
        'chargeur',
        'silencieux',
        'visée',
        'scope',
        'red dot'
      ],
      subCategories: [
        AirsoftSubCategory(
          id: 'optics',
          name: 'Optiques',
          description: 'Visées et scopes',
          icon: Icons.center_focus_strong,
          keywords: ['optique', 'scope', 'red dot', 'holo', 'acog'],
          parentId: 'accessories',
        ),
        AirsoftSubCategory(
          id: 'magazines',
          name: 'Chargeurs',
          description: 'Chargeurs et speed loaders',
          icon: Icons.battery_charging_full,
          keywords: ['chargeur', 'magazine', 'midcap', 'hicap', 'speedloader'],
          parentId: 'accessories',
        ),
        AirsoftSubCategory(
          id: 'suppressors',
          name: 'Silencieux',
          description: 'Suppresseurs et flash hiders',
          icon: Icons.volume_off,
          keywords: ['silencieux', 'suppressor', 'flash hider', 'compensateur'],
          parentId: 'accessories',
        ),
        AirsoftSubCategory(
          id: 'grips',
          name: 'Poignées & Rails',
          description: 'Grips et systèmes de rails',
          icon: Icons.pan_tool,
          keywords: ['grip', 'poignée', 'rail', 'picatinny', 'mlok'],
          parentId: 'accessories',
        ),
      ],
    ),

    // 4. PIÈCES DÉTACHÉES - Catégorie #4 (Technologie interne)
    AirsoftCategory(
      id: 'parts',
      name: 'Pièces détachées',
      description: 'Gearbox, moteurs, canons, hop-up',
      icon: Icons.settings,
      color: GeartedColors.parts,
      accentColor: GeartedColors.partsAccent,
      backgroundColor: GeartedColors.partsBackground,
      type: AirsoftCategoryType.parts,
      priority: 97,
      isPopular: false,
      keywords: ['gearbox', 'moteur', 'canon', 'hop-up', 'pièce', 'upgrade'],
      subCategories: [
        AirsoftSubCategory(
          id: 'gearbox',
          name: 'Gearbox & Gears',
          description: 'Mécanismes internes',
          icon: Icons.settings,
          keywords: ['gearbox', 'gears', 'piston', 'cylinder', 'tête'],
          parentId: 'parts',
        ),
        AirsoftSubCategory(
          id: 'motors',
          name: 'Moteurs',
          description: 'Moteurs électriques',
          icon: Icons.electrical_services,
          keywords: ['moteur', 'motor', 'high torque', 'speed'],
          parentId: 'parts',
        ),
        AirsoftSubCategory(
          id: 'barrels',
          name: 'Canons',
          description: 'Canons internes et externes',
          icon: Icons.straighten,
          keywords: ['canon', 'barrel', 'inner', 'outer', 'précision'],
          parentId: 'parts',
        ),
        AirsoftSubCategory(
          id: 'hopup',
          name: 'Hop-up',
          description: 'Systèmes hop-up et joints',
          icon: Icons.tune,
          keywords: ['hop-up', 'joint', 'bucking', 'nub', 'chamber'],
          parentId: 'parts',
        ),
      ],
    ),

    // 5. TACTIQUE & GEAR - Catégorie #5 (Équipement terrain)
    AirsoftCategory(
      id: 'tactical',
      name: 'Tactique & Gear',
      description: 'Sacs, holsters, ceinturons',
      icon: Icons.backpack,
      color: GeartedColors.tactical,
      accentColor: GeartedColors.tacticalAccent,
      backgroundColor: GeartedColors.tacticalBackground,
      type: AirsoftCategoryType.tactical,
      priority: 96,
      isPopular: true,
      keywords: ['tactique', 'gear', 'sac', 'holster', 'ceinture', 'militaire'],
      subCategories: [
        AirsoftSubCategory(
          id: 'bags',
          name: 'Sacs & Bagages',
          description: 'Sacs tactiques et transport',
          icon: Icons.backpack,
          keywords: ['sac', 'bag', 'backpack', 'transport', 'tactical'],
          parentId: 'tactical',
        ),
        AirsoftSubCategory(
          id: 'holsters',
          name: 'Holsters',
          description: 'Étuis pour armes de poing',
          icon: Icons.file_present,
          keywords: ['holster', 'étui', 'pistol', 'retention'],
          parentId: 'tactical',
        ),
        AirsoftSubCategory(
          id: 'belts',
          name: 'Ceinturons',
          description: 'Ceintures tactiques',
          icon: Icons.horizontal_rule,
          keywords: ['ceinture', 'belt', 'tactical', 'molle'],
          parentId: 'tactical',
        ),
        AirsoftSubCategory(
          id: 'pouches',
          name: 'Pochettes',
          description: 'Pochettes et organisateurs',
          icon: Icons.inventory,
          keywords: ['pochette', 'pouch', 'molle', 'admin', 'dump'],
          parentId: 'tactical',
        ),
      ],
    ),

    // 6. MUNITION & GRENADES - Catégorie #6 (Consommables)
    AirsoftCategory(
      id: 'munition',
      name: 'Munition & Grenades',
      description: 'Billes, grenades, gaz, batteries',
      icon: Icons.scatter_plot,
      color: GeartedColors.munition,
      accentColor: GeartedColors.munitionAccent,
      backgroundColor: GeartedColors.munitionBackground,
      type: AirsoftCategoryType.munition,
      priority: 95,
      isPopular: true,
      keywords: ['bille', 'grenade', 'gaz', 'batterie', 'munition', 'bb'],
      subCategories: [
        AirsoftSubCategory(
          id: 'bbs',
          name: 'Billes BB',
          description: 'Billes 6mm de tous poids',
          icon: Icons.scatter_plot,
          keywords: ['bille', 'bb', '6mm', '0.20g', '0.25g', '0.28g'],
          parentId: 'munition',
        ),
        AirsoftSubCategory(
          id: 'grenades',
          name: 'Grenades',
          description: 'Grenades gaz et pyrotechniques',
          icon: Icons.circle,
          keywords: ['grenade', 'gaz', 'pyro', 'smoke', 'thunder'],
          parentId: 'munition',
        ),
        AirsoftSubCategory(
          id: 'gas',
          name: 'Gaz & Fluides',
          description: 'Green gas, CO2, lubrifiants',
          icon: Icons.local_gas_station,
          keywords: ['gaz', 'green gas', 'co2', 'lubrifiant', 'silicone'],
          parentId: 'munition',
        ),
        AirsoftSubCategory(
          id: 'batteries',
          name: 'Batteries',
          description: 'Batteries LiPo, NiMH et chargeurs',
          icon: Icons.battery_full,
          keywords: ['batterie', 'lipo', 'nimh', 'chargeur', 'balancer'],
          parentId: 'munition',
        ),
      ],
    ),

    // 7. DIVERS - Catégorie #7 (Autres articles)
    AirsoftCategory(
      id: 'misc',
      name: 'Divers',
      description: 'Vêtements, tools, autres équipements',
      icon: Icons.category,
      color: GeartedColors.misc,
      accentColor: GeartedColors.miscAccent,
      backgroundColor: GeartedColors.miscBackground,
      type: AirsoftCategoryType.misc,
      priority: 94,
      isPopular: false,
      keywords: ['divers', 'vêtement', 'tool', 'autre', 'accessoire'],
      subCategories: [
        AirsoftSubCategory(
          id: 'clothing',
          name: 'Vêtements',
          description: 'Uniformes et tenues tactiques',
          icon: Icons.checkroom,
          keywords: ['vêtement', 'uniforme', 'bdu', 'combat', 'camouflage'],
          parentId: 'misc',
        ),
        AirsoftSubCategory(
          id: 'tools',
          name: 'Outils',
          description: 'Outils de maintenance',
          icon: Icons.build,
          keywords: ['outil', 'tool', 'maintenance', 'cleaning', 'repair'],
          parentId: 'misc',
        ),
        AirsoftSubCategory(
          id: 'targets',
          name: 'Cibles',
          description: 'Cibles et chronographes',
          icon: Icons.gps_fixed,
          keywords: ['cible', 'target', 'chrono', 'chronographe'],
          parentId: 'misc',
        ),
        AirsoftSubCategory(
          id: 'other',
          name: 'Autres',
          description: 'Articles non classifiés',
          icon: Icons.more_horiz,
          keywords: ['autre', 'other', 'divers', 'non classé'],
          parentId: 'misc',
        ),
      ],
    ),
  ];

  /// Récupère toutes les catégories principales
  static List<AirsoftCategory> getAllMainCategories() {
    return List.from(mainCategories);
  }

  /// Alias pour getAllMainCategories (compatibilité)
  static List<AirsoftCategory> getAllCategories() {
    return getAllMainCategories();
  }

  /// Récupère les catégories populaires
  static List<AirsoftCategory> getPopularCategories() {
    return mainCategories.where((cat) => cat.isPopular).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// Récupère une catégorie par ID
  static AirsoftCategory? getCategoryById(String id) {
    try {
      return mainCategories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Récupère les sous-catégories d'une catégorie
  static List<AirsoftSubCategory> getSubCategories(String categoryId) {
    final category = getCategoryById(categoryId);
    return category?.subCategories ?? [];
  }

  /// Recherche de catégories par mots-clés
  static List<AirsoftCategory> searchCategories(String query) {
    if (query.trim().isEmpty) return getAllMainCategories();

    final searchQuery = query.toLowerCase().trim();

    return mainCategories.where((category) {
      // Recherche dans le nom
      if (category.name.toLowerCase().contains(searchQuery)) return true;

      // Recherche dans la description
      if (category.description.toLowerCase().contains(searchQuery)) return true;

      // Recherche dans les mots-clés
      if (category.keywords
          .any((keyword) => keyword.toLowerCase().contains(searchQuery)))
        return true;

      // Recherche dans les sous-catégories
      return category.subCategories.any((subCat) =>
          subCat.name.toLowerCase().contains(searchQuery) ||
          subCat.keywords
              .any((keyword) => keyword.toLowerCase().contains(searchQuery)));
    }).toList();
  }

  /// Convertit l'ancienne catégorie vers le nouveau système
  static String migrateLegacyCategory(String oldCategoryId) {
    switch (oldCategoryId) {
      case 'weapons':
      case 'repliques':
        return 'replicas';
      case 'protection':
      case 'safety':
        return 'protection';
      case 'accessories':
      case 'accessoires':
        return 'accessories';
      case 'parts':
      case 'pieces':
      case 'spare_parts':
        return 'parts';
      case 'tactical':
      case 'gear':
        return 'tactical';
      case 'ammunition':
      case 'munitions':
      case 'consumables':
        return 'munition';
      case 'misc':
      case 'miscellaneous':
      case 'other':
      case 'divers':
      default:
        return 'misc';
    }
  }

  /// Récupère les suggestions de catégories pour l'autocomplétion
  static List<String> getCategorySuggestions(String query) {
    if (query.trim().isEmpty) return [];

    final suggestions = <String>[];
    final searchQuery = query.toLowerCase().trim();

    for (final category in mainCategories) {
      // Ajoute le nom de la catégorie
      if (category.name.toLowerCase().contains(searchQuery)) {
        suggestions.add(category.name);
      }

      // Ajoute les mots-clés correspondants
      for (final keyword in category.keywords) {
        if (keyword.toLowerCase().contains(searchQuery) &&
            !suggestions.contains(keyword)) {
          suggestions.add(keyword);
        }
      }

      // Ajoute les sous-catégories correspondantes
      for (final subCat in category.subCategories) {
        if (subCat.name.toLowerCase().contains(searchQuery) &&
            !suggestions.contains(subCat.name)) {
          suggestions.add(subCat.name);
        }
      }
    }

    return suggestions.take(10).toList(); // Limite à 10 suggestions
  }
}
