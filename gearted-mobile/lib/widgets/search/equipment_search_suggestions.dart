import 'package:flutter/material.dart';
import '../../core/constants/airsoft_categories.dart';
import '../equipment/equipment_category_widget.dart';

class EquipmentSearchSuggestions extends StatelessWidget {
  final String query;
  final Function(String) onSuggestionTap;
  final VoidCallback? onEquipmentFilterTap;

  const EquipmentSearchSuggestions({
    super.key,
    required this.query,
    required this.onSuggestionTap,
    this.onEquipmentFilterTap,
  });

  static final List<Map<String, dynamic>> _equipmentSuggestions = [
    {
      'title': 'Gilet tactique',
      'subtitle': 'Protection corporelle, chest rig',
      'keywords': ['gilet', 'tactique', 'chest', 'rig', 'protection', 'viper'],
      'category': AirsoftCategories.giletsTactiques,
      'icon': Icons.security,
      'color': Colors.red,
    },
    {
      'title': 'Masque de protection',
      'subtitle': 'Protection visage, mesh, intégral',
      'keywords': ['masque', 'protection', 'visage', 'mesh', 'dye', 'valken'],
      'category': AirsoftCategories.masques,
      'icon': Icons.face,
      'color': Colors.orange,
    },
    {
      'title': 'Casque tactique',
      'subtitle': 'Protection tête, FAST, MICH',
      'keywords': ['casque', 'helmet', 'fast', 'mich', 'protection', 'tête'],
      'category': AirsoftCategories.casques,
      'icon': Icons.sports_kabaddi,
      'color': Colors.blue,
    },
    {
      'title': 'Lunettes protection',
      'subtitle': 'Protection oculaire, balistique',
      'keywords': ['lunettes', 'protection', 'oculaire', 'balistique', 'ess', 'oakley'],
      'category': AirsoftCategories.lunettesProtection,
      'icon': Icons.remove_red_eye,
      'color': Colors.green,
    },
    {
      'title': 'Gants tactiques',
      'subtitle': 'Protection mains, grip, dextérité',
      'keywords': ['gants', 'mains', 'grip', 'mechanix', 'oakley', 'dextérité'],
      'category': AirsoftCategories.gants,
      'icon': Icons.back_hand,
      'color': Colors.purple,
    },
    {
      'title': 'Porte-plaques',
      'subtitle': 'Protection corporelle, plaques',
      'keywords': ['porte', 'plaques', 'protection', 'corporelle', 'carrier'],
      'category': AirsoftCategories.portePlaques,
      'icon': Icons.shield,
      'color': Colors.indigo,
    },
    {
      'title': 'Genouillères',
      'subtitle': 'Protection articulations',
      'keywords': ['genouillères', 'protection', 'genou', 'articulation', 'knee'],
      'category': AirsoftCategories.genouilleres,
      'icon': Icons.accessibility,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredSuggestions = _getFilteredSuggestions();
    
    if (filteredSuggestions.isEmpty && query.isEmpty) {
      return _buildDefaultSuggestions();
    }
    
    if (filteredSuggestions.isEmpty) {
      return _buildNoResultsWidget();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (query.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Suggestions pour "$query"',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (onEquipmentFilterTap != null)
                  TextButton.icon(
                    onPressed: onEquipmentFilterTap,
                    icon: const Icon(Icons.security, size: 16),
                    label: const Text('Équipement'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          ...filteredSuggestions.map((suggestion) => 
            _buildSuggestionItem(suggestion)).toList(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredSuggestions() {
    if (query.isEmpty) {
      return _equipmentSuggestions.take(5).toList();
    }

    final queryLower = query.toLowerCase();
    return _equipmentSuggestions.where((suggestion) {
      final title = suggestion['title'].toLowerCase();
      final subtitle = suggestion['subtitle'].toLowerCase();
      final keywords = (suggestion['keywords'] as List<String>)
          .map((k) => k.toLowerCase())
          .toList();
      
      return title.contains(queryLower) ||
             subtitle.contains(queryLower) ||
             keywords.any((keyword) => keyword.contains(queryLower));
    }).toList();
  }

  Widget _buildSuggestionItem(Map<String, dynamic> suggestion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: suggestion['color'].withOpacity(0.05),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onSuggestionTap(suggestion['title']),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: suggestion['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    suggestion['icon'],
                    color: suggestion['color'],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: suggestion['color'],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        suggestion['subtitle'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: suggestion['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ÉQUIPEMENT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: suggestion['color'],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultSuggestions() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
        Row(
          children: [
            const Text(
              'Catégories d\'équipement populaires',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (onEquipmentFilterTap != null)
              TextButton(
                onPressed: onEquipmentFilterTap,
                child: const Text('Voir tout'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _equipmentSuggestions.take(6).map((suggestion) {
            return ActionChip(
              avatar: Icon(
                suggestion['icon'],
                size: 16,
                color: suggestion['color'],
              ),
              label: Text(suggestion['title']),
              onPressed: () => onSuggestionTap(suggestion['title']),
              backgroundColor: suggestion['color'].withOpacity(0.1),
              side: BorderSide(color: suggestion['color'].withOpacity(0.3)),
              labelStyle: TextStyle(
                color: suggestion['color'],
                fontWeight: FontWeight.w500,
              ),
            );
          }).toList(),
        ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune suggestion trouvée pour "$query"',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Essayez "gilet", "masque", "casque" ou "lunettes"',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (onEquipmentFilterTap != null)
                ElevatedButton.icon(
                  onPressed: onEquipmentFilterTap,
                  icon: const Icon(Icons.security),
                  label: const Text('Parcourir l\'équipement'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Equipment search helper functions
class EquipmentSearchHelper {
  
  /// Get search suggestions based on query
  static List<String> getSearchSuggestions(String query) {
    final suggestions = <String>[];
    final queryLower = query.toLowerCase();
    
    // Equipment keywords
    final equipmentKeywords = EquipmentCategoryHelper.getEquipmentKeywords();
    
    for (final keyword in equipmentKeywords) {
      if (keyword.contains(queryLower) && !suggestions.contains(keyword)) {
        suggestions.add(keyword);
      }
    }
    
    // Category names
    final equipmentCategories = EquipmentCategoryHelper.getEquipmentCategories();
    for (final category in equipmentCategories) {
      final cleanName = AirsoftCategories.getCleanCategoryName(category);
      if (cleanName.toLowerCase().contains(queryLower) && 
          !suggestions.contains(cleanName)) {
        suggestions.add(cleanName);
      }
    }
    
    return suggestions.take(5).toList();
  }
  
  /// Check if query is equipment-related
  static bool isEquipmentQuery(String query) {
    final queryLower = query.toLowerCase();
    final equipmentKeywords = EquipmentCategoryHelper.getEquipmentKeywords();
    
    return equipmentKeywords.any((keyword) => 
        queryLower.contains(keyword) || keyword.contains(queryLower));
  }
  
  /// Get equipment categories that match query
  static List<String> getMatchingEquipmentCategories(String query) {
    final queryLower = query.toLowerCase();
    final categories = <String>[];
    
    final equipmentCategories = EquipmentCategoryHelper.getEquipmentCategories();
    
    for (final category in equipmentCategories) {
      final cleanName = AirsoftCategories.getCleanCategoryName(category);
      if (cleanName.toLowerCase().contains(queryLower)) {
        categories.add(category);
      }
    }
    
    return categories;
  }
}
