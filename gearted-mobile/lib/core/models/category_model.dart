import 'package:flutter/material.dart';

/// Modèle de catégorie unifié pour une meilleure cohérence
class CategoryModel {
  final String id;
  final String name;
  final String displayName;
  final IconData icon;
  final Color color;
  final CategoryType type;
  final List<String> keywords;
  final String? parentId;
  final int priority;
  final bool isPopular;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
    required this.type,
    required this.keywords,
    this.parentId,
    this.priority = 0,
    this.isPopular = false,
  });

  bool get isMainCategory => parentId == null;
  bool get isSubCategory => parentId != null;
  bool get isEquipment => type == CategoryType.equipment;

  // Méthodes utilitaires
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'type': type.name,
      'keywords': keywords,
      'parentId': parentId,
      'priority': priority,
      'isPopular': isPopular,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
      icon:
          Icons.category, // Default icon, will be overridden by CategoriesData
      color: Colors.blue, // Default color, will be overridden by CategoriesData
      type: CategoryType.values.firstWhere((e) => e.name == json['type']),
      keywords: List<String>.from(json['keywords']),
      parentId: json['parentId'],
      priority: json['priority'] ?? 0,
      isPopular: json['isPopular'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CategoryModel(id: $id, displayName: $displayName, type: $type)';
  }
}

enum CategoryType {
  weapon, // Répliques
  equipment, // Équipement de protection
  accessory, // Accessoires
  internal, // Pièces internes
  gear, // Tenues
  tool, // Outils
  electronic, // Électronique
}

extension CategoryTypeExtension on CategoryType {
  String get displayName {
    switch (this) {
      case CategoryType.weapon:
        return 'Répliques';
      case CategoryType.equipment:
        return 'Équipement de Protection';
      case CategoryType.accessory:
        return 'Accessoires';
      case CategoryType.internal:
        return 'Pièces Internes';
      case CategoryType.gear:
        return 'Tenues';
      case CategoryType.tool:
        return 'Outils';
      case CategoryType.electronic:
        return 'Électronique';
    }
  }

  IconData get icon {
    switch (this) {
      case CategoryType.weapon:
        return Icons.emergency; // More aggressive warning icon for weapons
      case CategoryType.equipment:
        return Icons.security; // Security shield for protection
      case CategoryType.accessory:
        return Icons.military_tech; // Military tech for accessories
      case CategoryType.internal:
        return Icons.settings; // Gear settings for internal parts
      case CategoryType.gear:
        return Icons.person_4; // Military person for gear
      case CategoryType.tool:
        return Icons.build; // Tools for construction
      case CategoryType.electronic:
        return Icons.radar; // Radar for electronics
    }
  }

  Color get color {
    switch (this) {
      case CategoryType.weapon:
        return const Color(0xFF8B0000); // Dark red for weapons
      case CategoryType.equipment:
        return const Color(0xFF1C1C1C); // Military black for equipment
      case CategoryType.accessory:
        return const Color(0xFF4F5D2F); // Camo green for accessories
      case CategoryType.internal:
        return const Color(0xFF2F2F2F); // Dark gray for internals
      case CategoryType.gear:
        return const Color(0xFFDAA520); // Victory gold for gear
      case CategoryType.tool:
        return const Color(0xFF4682B4); // Steel blue for tools
      case CategoryType.electronic:
        return const Color(0xFF556B2F); // Dark olive green for electronics
    }
  }
}
