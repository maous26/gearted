import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Enum pour les types de catégories airsoft
enum AirsoftCategoryType {
  replicas,
  protection,
  accessories,
  parts,
  tactical,
  munition,
  misc;

  String get displayName {
    switch (this) {
      case AirsoftCategoryType.replicas:
        return 'Répliques';
      case AirsoftCategoryType.protection:
        return 'Protection';
      case AirsoftCategoryType.accessories:
        return 'Accessoires';
      case AirsoftCategoryType.parts:
        return 'Pièces détachées';
      case AirsoftCategoryType.tactical:
        return 'Tactique & Gear';
      case AirsoftCategoryType.munition:
        return 'Munition & Grenades';
      case AirsoftCategoryType.misc:
        return 'Divers';
    }
  }

  static AirsoftCategoryType fromId(String id) {
    switch (id) {
      case 'replicas':
        return AirsoftCategoryType.replicas;
      case 'protection':
        return AirsoftCategoryType.protection;
      case 'accessories':
        return AirsoftCategoryType.accessories;
      case 'parts':
        return AirsoftCategoryType.parts;
      case 'tactical':
        return AirsoftCategoryType.tactical;
      case 'munition':
        return AirsoftCategoryType.munition;
      case 'misc':
        return AirsoftCategoryType.misc;
      default:
        return AirsoftCategoryType.misc;
    }
  }
}

/// Modèle de catégorie airsoft avec système hiérarchique
class AirsoftCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Color accentColor;
  final Color backgroundColor;
  final AirsoftCategoryType type;
  final int priority;
  final bool isPopular;
  final List<String> keywords;
  final List<AirsoftSubCategory> subCategories;
  final String? parentId;

  const AirsoftCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.accentColor,
    required this.backgroundColor,
    required this.type,
    required this.priority,
    required this.isPopular,
    required this.keywords,
    this.subCategories = const [],
    this.parentId,
  });

  /// Récupère le gradient de la catégorie
  LinearGradient get gradient => LinearGradient(
        colors: [color, accentColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Convertit en Map pour l'API
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'priority': priority,
        'isPopular': isPopular,
        'keywords': keywords,
        'parentId': parentId,
      };

  /// Créé depuis Map de l'API
  factory AirsoftCategory.fromJson(Map<String, dynamic> json) {
    // Récupère les couleurs depuis le système de thème
    final categoryColor = GeartedColors.getCategoryColor(json['id'] ?? 'misc');
    final categoryAccent =
        GeartedColors.getCategoryAccent(json['id'] ?? 'misc');
    final categoryBackground =
        GeartedColors.getCategoryBackground(json['id'] ?? 'misc');
    final categoryId = json['id'] ?? 'misc';

    return AirsoftCategory(
      id: categoryId,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: _getIconForCategory(categoryId),
      color: categoryColor,
      accentColor: categoryAccent,
      backgroundColor: categoryBackground,
      type: AirsoftCategoryType.fromId(categoryId),
      priority: json['priority'] ?? 0,
      isPopular: json['isPopular'] ?? false,
      keywords: List<String>.from(json['keywords'] ?? []),
      parentId: json['parentId'],
    );
  }

  /// Détermine l'icône appropriée pour une catégorie
  static IconData _getIconForCategory(String categoryId) {
    switch (categoryId) {
      case 'replicas':
        return Icons.military_tech;
      case 'protection':
        return Icons.shield;
      case 'accessories':
        return Icons.center_focus_strong;
      case 'parts':
        return Icons.settings;
      case 'tactical':
        return Icons.backpack;
      case 'munition':
        return Icons.scatter_plot;
      case 'misc':
      default:
        return Icons.category;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirsoftCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Sous-catégorie pour organisation hiérarchique
class AirsoftSubCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final List<String> keywords;
  final String parentId;

  const AirsoftSubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.keywords,
    required this.parentId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'keywords': keywords,
        'parentId': parentId,
      };

  factory AirsoftSubCategory.fromJson(Map<String, dynamic> json) {
    return AirsoftSubCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: _getIconForSubCategory(json['id'] ?? ''),
      keywords: List<String>.from(json['keywords'] ?? []),
      parentId: json['parentId'] ?? '',
    );
  }

  static IconData _getIconForSubCategory(String subCategoryId) {
    switch (subCategoryId) {
      // Répliques
      case 'aeg':
        return Icons.electrical_services;
      case 'gbb':
        return Icons.local_gas_station;
      case 'sniper':
        return Icons.my_location;
      case 'shotgun':
        return Icons.scatter_plot;
      case 'pistol':
        return Icons.radio_button_unchecked;

      // Protection
      case 'masks':
        return Icons.face;
      case 'helmets':
        return Icons.sports_kabaddi;
      case 'vests':
        return Icons.shield;
      case 'gloves':
        return Icons.back_hand;

      // Accessoires
      case 'optics':
        return Icons.center_focus_strong;
      case 'magazines':
        return Icons.battery_charging_full;
      case 'suppressors':
        return Icons.volume_off;
      case 'grips':
        return Icons.pan_tool;

      // Pièces détachées
      case 'gearbox':
        return Icons.settings;
      case 'motors':
        return Icons.electrical_services;
      case 'barrels':
        return Icons.straighten;
      case 'hopup':
        return Icons.tune;

      // Tactique & Gear
      case 'bags':
        return Icons.backpack;
      case 'holsters':
        return Icons.file_present;
      case 'belts':
        return Icons.horizontal_rule;
      case 'pouches':
        return Icons.inventory;

      // Munition & Grenades
      case 'bbs':
        return Icons.scatter_plot;
      case 'grenades':
        return Icons.circle;
      case 'gas':
        return Icons.local_gas_station;
      case 'batteries':
        return Icons.battery_full;

      default:
        return Icons.category;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirsoftSubCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
