import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/airsoft_categories.dart';

class EquipmentCategoryWidget extends StatelessWidget {
  const EquipmentCategoryWidget({super.key});

  static final List<Map<String, dynamic>> _equipmentCategories = [
    {
      'title': 'Protection Corporelle',
      'subtitle': 'Gilets tactiques, porte-plaques',
      'icon': Icons.security,
      'color': Colors.red,
      'categories': [
        AirsoftCategories.giletsTactiques,
        AirsoftCategories.portePlaques,
      ],
      'searchQuery': 'gilet tactique protection corporelle',
    },
    {
      'title': 'Protection Visage',
      'subtitle': 'Masques, lunettes protection',
      'icon': Icons.face,
      'color': Colors.orange,
      'categories': [
        AirsoftCategories.masques,
        AirsoftCategories.lunettesProtection,
        AirsoftCategories.protegeVisage,
      ],
      'searchQuery': 'masque lunettes protection visage',
    },
    {
      'title': 'Casques & Couvre-chefs',
      'subtitle': 'Casques tactiques, protection tête',
      'icon': Icons.sports_kabaddi,
      'color': Colors.blue,
      'categories': [
        AirsoftCategories.casques,
      ],
      'searchQuery': 'casque protection tête',
    },
    {
      'title': 'Gants & Articulations',
      'subtitle': 'Gants, genouillères, coudières',
      'icon': Icons.back_hand,
      'color': Colors.green,
      'categories': [
        AirsoftCategories.gants,
        AirsoftCategories.genouilleres,
      ],
      'searchQuery': 'gants genouilleres protection',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.security,
                color: Colors.red.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Équipement de Protection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/search?equipment=true'),
              child: const Text('Tout voir'),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Equipment categories grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _equipmentCategories.length,
          itemBuilder: (context, index) {
            final category = _equipmentCategories[index];
            return _buildEquipmentCard(context, category);
          },
        ),
        
        const SizedBox(height: 16),
        
        // Quick action buttons
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                context,
                'Recherche Rapide',
                Icons.search,
                Colors.blue,
                () => context.push('/search'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                context,
                'Filtres Avancés',
                Icons.tune,
                Colors.purple,
                () => context.push('/advanced-search'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEquipmentCard(BuildContext context, Map<String, dynamic> category) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: category['color'].withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to search with equipment filter
          context.push('/search?category=${Uri.encodeComponent(category['searchQuery'])}');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: category['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      category['icon'],
                      color: category['color'],
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: category['color'],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${category['categories'].length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                category['title'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: category['color'],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Subtitle
              Text(
                category['subtitle'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: color.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Equipment category helper functions
class EquipmentCategoryHelper {
  
  /// Get equipment categories for quick filtering
  static List<String> getEquipmentCategories() {
    return [
      AirsoftCategories.masques,
      AirsoftCategories.giletsTactiques,
      AirsoftCategories.casques,
      AirsoftCategories.lunettesProtection,
      AirsoftCategories.gants,
      AirsoftCategories.portePlaques,
      AirsoftCategories.genouilleres,
      AirsoftCategories.protegeVisage,
    ];
  }
  
  /// Check if a category is equipment-related
  static bool isEquipmentCategory(String category) {
    return getEquipmentCategories().contains(category);
  }
  
  /// Get equipment search keywords for better matching
  static List<String> getEquipmentKeywords() {
    return [
      'gilet', 'tactique', 'masque', 'protection', 'casque',
      'lunettes', 'gants', 'genouillères', 'coudières',
      'vest', 'helmet', 'goggle', 'gloves', 'knee', 'elbow',
      'balistique', 'sécurité', 'chest', 'rig', 'plate'
    ];
  }
  
  /// Get equipment priority categories for sorting
  static List<String> getEquipmentPriorityOrder() {
    return [
      AirsoftCategories.masques,
      AirsoftCategories.giletsTactiques,
      AirsoftCategories.casques,
      AirsoftCategories.lunettesProtection,
      AirsoftCategories.portePlaques,
      AirsoftCategories.gants,
      AirsoftCategories.genouilleres,
      AirsoftCategories.protegeVisage,
    ];
  }
}
