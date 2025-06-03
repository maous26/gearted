import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Système de catégories refactorisé avec 7 catégories principales et icônes thématiques
class NewCategoriesData {
  // === 7 CATÉGORIES PRINCIPALES ===

  static const List<Map<String, dynamic>> mainCategories = [
    {
      'id': 'replicas',
      'name': 'Répliques',
      'icon': Icons.military_tech, // Icône de fusil (militaire)
      'description': 'AEG, GBB, Spring - Toutes répliques',
      'color': GeartedColors.replicas,
      'priority': 100,
      'isPopular': true,
      'keywords': [
        'réplique',
        'aeg',
        'gbb',
        'spring',
        'fusil',
        'pistolet',
        'arme'
      ]
    },
    {
      'id': 'protection',
      'name': 'Protection',
      'icon': Icons.shield, // Bouclier + masque combo
      'description': 'Masques, casques, gilets tactiques',
      'color': GeartedColors.protection,
      'priority': 99,
      'isPopular': true,
      'keywords': [
        'masque',
        'casque',
        'gilet',
        'protection',
        'sécurité',
        'safety'
      ]
    },
    {
      'id': 'accessories',
      'name': 'Accessoires',
      'icon': Icons.center_focus_strong, // Icône optique/visée
      'description': 'Optiques, chargeurs, silencieux',
      'color': GeartedColors.accessories,
      'priority': 98,
      'isPopular': true,
      'keywords': [
        'optique',
        'chargeur',
        'silencieux',
        'visée',
        'scope',
        'red dot'
      ]
    },
    {
      'id': 'parts',
      'name': 'Pièces détachées',
      'icon': Icons.settings, // Icône engrenage/pièces
      'description': 'Gearbox, moteurs, canons, hop-up',
      'color': GeartedColors.parts,
      'priority': 97,
      'isPopular': false,
      'keywords': ['gearbox', 'moteur', 'canon', 'hop-up', 'pièce', 'upgrade']
    },
    {
      'id': 'tactical',
      'name': 'Tactique & Gear',
      'icon': Icons.backpack, // Icône sac à dos/équipement
      'description': 'Chest rigs, sacs, holsters, ceintures',
      'color': GeartedColors.tactical,
      'priority': 96,
      'isPopular': true,
      'keywords': [
        'chest rig',
        'sac',
        'holster',
        'ceinture',
        'tactical',
        'gear'
      ]
    },
    {
      'id': 'munition',
      'name': 'Munition & Grenades',
      'icon': Icons.radio_button_on, // Icône grenade/munition
      'description': 'Billes, grenades, tracers, gaz',
      'color': GeartedColors.munition,
      'priority': 95,
      'isPopular': false,
      'keywords': ['billes', 'grenade', 'tracer', 'gaz', 'munition', 'bb']
    },
    {
      'id': 'misc',
      'name': 'Divers',
      'icon': Icons.category, // Icône boîte cadeau/divers
      'description': 'Outils, entretien, communication',
      'color': GeartedColors.misc,
      'priority': 94,
      'isPopular': false,
      'keywords': ['outil', 'nettoyage', 'radio', 'batterie', 'divers', 'autre']
    },
  ];

  // === SOUS-CATÉGORIES PAR CATÉGORIE PRINCIPALE ===

  static const Map<String, List<Map<String, dynamic>>> subCategories = {
    'replicas': [
      {
        'id': 'aeg_rifles',
        'name': 'Fusils AEG',
        'icon': Icons.military_tech,
        'description': 'M4, AK, G36, SCAR...',
        'keywords': ['aeg', 'fusil', 'm4', 'ak', 'g36', 'scar', 'électrique']
      },
      {
        'id': 'gas_pistols',
        'name': 'Pistolets GBB',
        'icon': Icons.gps_fixed,
        'description': 'Glock, Beretta, CZ...',
        'keywords': ['gbb', 'pistolet', 'glock', 'beretta', 'cz', 'gaz']
      },
      {
        'id': 'sniper_rifles',
        'name': 'Snipers',
        'icon': Icons.my_location,
        'description': 'VSR, L96, M24...',
        'keywords': ['sniper', 'vsr', 'l96', 'm24', 'précision', 'spring']
      },
      {
        'id': 'shotguns',
        'name': 'Shotguns',
        'icon': Icons.dangerous,
        'description': 'M870, Benelli...',
        'keywords': ['shotgun', 'm870', 'benelli', 'pompe']
      },
    ],
    'protection': [
      {
        'id': 'face_protection',
        'name': 'Protection visage',
        'icon': Icons.face,
        'description': 'Masques intégraux, lunettes',
        'keywords': [
          'masque',
          'lunettes',
          'protection',
          'visage',
          'mesh',
          'dye'
        ]
      },
      {
        'id': 'body_armor',
        'name': 'Blindage corporel',
        'icon': Icons.security,
        'description': 'Gilets tactiques, porte-plaques',
        'keywords': ['gilet', 'tactique', 'porte', 'plaque', 'vest', 'armor']
      },
      {
        'id': 'helmets',
        'name': 'Casques',
        'icon': Icons.shield,
        'description': 'FAST, MICH, casques tactiques',
        'keywords': ['casque', 'fast', 'mich', 'helmet', 'protection']
      },
      {
        'id': 'gloves_pads',
        'name': 'Gants & Protections',
        'icon': Icons.fitness_center,
        'description': 'Gants, genouillères, coudières',
        'keywords': ['gants', 'genouillères', 'coudières', 'protection', 'pads']
      },
    ],
    'accessories': [
      {
        'id': 'optics',
        'name': 'Optiques',
        'icon': Icons.center_focus_strong,
        'description': 'Red dots, scopes, lunettes',
        'keywords': [
          'optique',
          'red dot',
          'scope',
          'lunette',
          'visée',
          'eotech'
        ]
      },
      {
        'id': 'magazines',
        'name': 'Chargeurs',
        'icon': Icons.battery_full,
        'description': 'Hi-cap, mid-cap, real-cap',
        'keywords': ['chargeur', 'magazine', 'hi-cap', 'mid-cap', 'real-cap']
      },
      {
        'id': 'silencers',
        'name': 'Silencieux',
        'icon': Icons.volume_off,
        'description': 'Silencieux, flash hiders',
        'keywords': ['silencieux', 'flash hider', 'suppressor', 'acetech']
      },
      {
        'id': 'rails_grips',
        'name': 'Rails & Grips',
        'icon': Icons.category,
        'description': 'Rails RIS, grips, bipods',
        'keywords': ['rail', 'ris', 'grip', 'bipod', 'mlok', 'keymod']
      },
    ],
    'parts': [
      {
        'id': 'gearbox_parts',
        'name': 'Gearbox',
        'icon': Icons.precision_manufacturing,
        'description': 'Gearbox, engrenages, pistons',
        'keywords': ['gearbox', 'engrenage', 'piston', 'cylinder', 'nozzle']
      },
      {
        'id': 'motors',
        'name': 'Moteurs',
        'icon': Icons.electric_bolt,
        'description': 'Moteurs high torque/speed',
        'keywords': ['moteur', 'motor', 'high torque', 'high speed', 'power']
      },
      {
        'id': 'barrels',
        'name': 'Canons',
        'icon': Icons.straighten,
        'description': 'Canons de précision, hop-up',
        'keywords': ['canon', 'barrel', 'hop-up', 'précision', 'maple leaf']
      },
      {
        'id': 'electronics',
        'name': 'Électronique',
        'icon': Icons.memory,
        'description': 'Mosfets, batteries, chargeurs',
        'keywords': ['mosfet', 'batterie', 'chargeur', 'électronique', 'lipo']
      },
    ],
    'tactical': [
      {
        'id': 'chest_rigs',
        'name': 'Chest Rigs',
        'icon': Icons.security,
        'description': 'Chest rigs, porte-chargeurs',
        'keywords': ['chest rig', 'porte chargeur', 'tactical vest']
      },
      {
        'id': 'backpacks',
        'name': 'Sacs & Bagages',
        'icon': Icons.backpack,
        'description': 'Sacs tactiques, hydratation',
        'keywords': [
          'sac',
          'backpack',
          'tactical',
          'hydratation',
          'assault pack'
        ]
      },
      {
        'id': 'holsters',
        'name': 'Holsters',
        'icon': Icons.work,
        'description': 'Holsters tactiques, leg rigs',
        'keywords': ['holster', 'leg rig', 'tactical', 'kydex', 'retention']
      },
      {
        'id': 'belts_pouches',
        'name': 'Ceintures & Pochettes',
        'icon': Icons.category,
        'description': 'Ceintures tactiques, pochettes',
        'keywords': ['ceinture', 'belt', 'pochette', 'pouch', 'molle']
      },
    ],
    'munition': [
      {
        'id': 'bbs',
        'name': 'Billes',
        'icon': Icons.circle,
        'description': 'Billes 0.20g à 0.40g+',
        'keywords': ['billes', 'bb', '0.20', '0.25', '0.28', '0.30', 'bio']
      },
      {
        'id': 'grenades',
        'name': 'Grenades',
        'icon': Icons.radio_button_on,
        'description': 'Grenades gaz, thunder B',
        'keywords': ['grenade', 'thunder b', 'gaz', 'pyrotechnie']
      },
      {
        'id': 'gas_co2',
        'name': 'Gaz & CO2',
        'icon': Icons.cloud,
        'description': 'Green gas, CO2, gaz propane',
        'keywords': ['gaz', 'co2', 'green gas', 'propane', 'cartouche']
      },
      {
        'id': 'tracers',
        'name': 'Tracers',
        'icon': Icons.flash_on,
        'description': 'Billes tracers, unités tracer',
        'keywords': ['tracer', 'acetech', 'lumineux', 'glow']
      },
    ],
    'misc': [
      {
        'id': 'maintenance',
        'name': 'Entretien',
        'icon': Icons.handyman,
        'description': 'Outils, nettoyage, lubrifiants',
        'keywords': [
          'nettoyage',
          'lubrifiant',
          'outil',
          'maintenance',
          'silicone'
        ]
      },
      {
        'id': 'communication',
        'name': 'Communication',
        'icon': Icons.settings_input_antenna,
        'description': 'Radios, PTT, casques audio',
        'keywords': ['radio', 'ptt', 'casque', 'audio', 'baofeng']
      },
      {
        'id': 'targets',
        'name': 'Cibles & Chronos',
        'icon': Icons.my_location,
        'description': 'Cibles, chronographes',
        'keywords': ['cible', 'chronographe', 'target', 'chrono', 'mesure']
      },
      {
        'id': 'clothing',
        'name': 'Vêtements',
        'icon': Icons.person_4,
        'description': 'Uniformes, BDU, t-shirts',
        'keywords': ['uniforme', 'bdu', 't-shirt', 'vêtement', 'multicam']
      },
    ],
  };

  // === MÉTHODES UTILITAIRES ===

  /// Récupère toutes les catégories principales
  static List<Map<String, dynamic>> getMainCategories() {
    return List.from(mainCategories);
  }

  /// Récupère les sous-catégories d'une catégorie principale
  static List<Map<String, dynamic>> getSubCategories(String mainCategoryId) {
    return List.from(subCategories[mainCategoryId] ?? []);
  }

  /// Récupère une catégorie par son ID
  static Map<String, dynamic>? getCategoryById(String categoryId) {
    // Recherche dans les catégories principales
    for (var category in mainCategories) {
      if (category['id'] == categoryId) {
        return category;
      }
    }

    // Recherche dans les sous-catégories
    for (var subCatList in subCategories.values) {
      for (var subCategory in subCatList) {
        if (subCategory['id'] == categoryId) {
          return subCategory;
        }
      }
    }

    return null;
  }

  /// Recherche de catégories par mots-clés
  static List<Map<String, dynamic>> searchCategories(String query) {
    final List<Map<String, dynamic>> results = [];
    final searchTerm = query.toLowerCase();

    // Recherche dans les catégories principales
    for (var category in mainCategories) {
      if (_matchesQuery(category, searchTerm)) {
        results.add(category);
      }
    }

    // Recherche dans les sous-catégories
    for (var subCatList in subCategories.values) {
      for (var subCategory in subCatList) {
        if (_matchesQuery(subCategory, searchTerm)) {
          results.add(subCategory);
        }
      }
    }

    // Tri par priorité puis par nom
    results.sort((a, b) {
      final priorityA = a['priority'] ?? 0;
      final priorityB = b['priority'] ?? 0;

      if (priorityA != priorityB) {
        return priorityB.compareTo(priorityA); // Ordre décroissant
      }

      return (a['name'] as String).compareTo(b['name'] as String);
    });

    return results;
  }

  /// Vérifie si une catégorie correspond à la requête
  static bool _matchesQuery(Map<String, dynamic> category, String query) {
    final name = (category['name'] as String).toLowerCase();
    final description = (category['description'] as String).toLowerCase();
    final keywords = (category['keywords'] as List<String>)
        .map((k) => k.toLowerCase())
        .toList();

    // Recherche dans le nom
    if (name.contains(query)) return true;

    // Recherche dans la description
    if (description.contains(query)) return true;

    // Recherche dans les mots-clés
    for (var keyword in keywords) {
      if (keyword.contains(query)) return true;
    }

    return false;
  }

  /// Récupère les catégories populaires
  static List<Map<String, dynamic>> getPopularCategories() {
    return mainCategories.where((cat) => cat['isPopular'] == true).toList();
  }

  /// Récupère les catégories par type pour l'affichage prioritaire
  static List<Map<String, dynamic>> getCategoriesByPriority() {
    final categories = List<Map<String, dynamic>>.from(mainCategories);
    categories
        .sort((a, b) => (b['priority'] as int).compareTo(a['priority'] as int));
    return categories;
  }
}
