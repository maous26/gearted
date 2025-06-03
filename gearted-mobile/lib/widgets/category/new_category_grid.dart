import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../core/constants/new_categories_data.dart';

/// Widget de grille des nouvelles catégories avec style martial moderne
class NewCategoryGrid extends StatelessWidget {
  final bool showSubCategories;
  final String? selectedCategoryId;
  final Function(String)? onCategorySelected;

  const NewCategoryGrid({
    super.key,
    this.showSubCategories = true,
    this.selectedCategoryId,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Protection (priorité absolue)
          _buildPrioritySection(context),

          const SizedBox(height: 24),

          // Grille principale des 7 catégories
          _buildMainCategoriesGrid(context),

          if (showSubCategories) ...[
            const SizedBox(height: 24),
            // Section catégories populaires
            _buildPopularSection(context),
          ],
        ],
      ),
    );
  }

  /// Section protection avec style d'alerte critique
  Widget _buildPrioritySection(BuildContext context) {
    final protectionCategory = NewCategoriesData.getMainCategories()
        .firstWhere((cat) => cat['id'] == 'protection');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GeartedColors.protection.withOpacity(0.15),
            GeartedColors.protectionAccent.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GeartedColors.protection.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: GeartedColors.protection.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec alerte
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: GeartedColors.protection,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: GeartedColors.protection.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  protectionCategory['icon'] as IconData,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.priority_high,
                          color: GeartedColors.protection,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'SÉCURITÉ PRIORITAIRE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Oswald',
                            letterSpacing: 1.5,
                            color: GeartedColors.protection,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      protectionCategory['name'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald',
                        letterSpacing: 1.2,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () =>
                    _navigateToCategory(context, protectionCategory),
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: GeartedColors.protection,
                  size: 20,
                ),
                tooltip: 'Voir tout',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Mini-grille des sous-catégories protection
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: NewCategoriesData.getSubCategories('protection').length,
            itemBuilder: (context, index) {
              final subCategory =
                  NewCategoriesData.getSubCategories('protection')[index];
              return _buildProtectionSubCard(context, subCategory);
            },
          ),
        ],
      ),
    );
  }

  /// Mini-carte de sous-catégorie protection
  Widget _buildProtectionSubCard(
      BuildContext context, Map<String, dynamic> subCategory) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToCategory(context, subCategory),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: GeartedColors.protection.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                subCategory['icon'] as IconData,
                color: GeartedColors.protection,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subCategory['name'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: GeartedColors.protection,
                    fontFamily: 'Oswald',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Grille principale des 7 catégories
  Widget _buildMainCategoriesGrid(BuildContext context) {
    final categories = NewCategoriesData.getMainCategories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.dashboard,
                color: GeartedTheme.tacticalGray,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'CATÉGORIES PRINCIPALES',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Oswald',
                  letterSpacing: 1.5,
                  color: GeartedTheme.tacticalGray,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildMainCategoryCard(context, category);
          },
        ),
      ],
    );
  }

  /// Carte de catégorie principale avec style martial
  Widget _buildMainCategoryCard(
      BuildContext context, Map<String, dynamic> category) {
    final categoryId = category['id'] as String;
    final isSelected = selectedCategoryId == categoryId;
    final categoryColor = GeartedColors.getCategoryColor(categoryId);
    final subCategoriesCount =
        NewCategoriesData.getSubCategories(categoryId).length;

    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _navigateToCategory(context, category),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                categoryColor.withOpacity(0.1),
                GeartedColors.getCategoryAccent(categoryId).withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? categoryColor : categoryColor.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: categoryColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header avec icône et badges
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: categoryColor.withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),

                    const Spacer(),

                    // Badge populaire
                    if (category['isPopular'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: GeartedTheme.warningOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Nom de la catégorie
                Text(
                  category['name'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Oswald',
                    letterSpacing: 1.1,
                    color: categoryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Description
                Text(
                  category['description'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Footer avec compteur
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: Colors.grey.shade500,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$subCategoriesCount sous-cat.',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: categoryColor,
                      size: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section catégories populaires en horizontal
  Widget _buildPopularSection(BuildContext context) {
    final popularCategories = NewCategoriesData.getPopularCategories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.trending_up,
                color: GeartedTheme.warningOrange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'POPULAIRES',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Oswald',
                  letterSpacing: 1.5,
                  color: GeartedTheme.warningOrange,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/search'),
                child: const Text(
                  'Tout voir',
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: popularCategories.length,
            itemBuilder: (context, index) {
              final category = popularCategories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildPopularCategoryChip(context, category),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Chip de catégorie populaire
  Widget _buildPopularCategoryChip(
      BuildContext context, Map<String, dynamic> category) {
    final categoryId = category['id'] as String;
    final categoryColor = GeartedColors.getCategoryColor(categoryId);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToCategory(context, category),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: categoryColor.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category['icon'] as IconData,
                color: categoryColor,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                category['name'] as String,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: categoryColor,
                  fontFamily: 'Oswald',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigation vers une catégorie
  void _navigateToCategory(
      BuildContext context, Map<String, dynamic> category) {
    final categoryId = category['id'] as String;

    if (onCategorySelected != null) {
      onCategorySelected!(categoryId);
    } else {
      context.push('/search?category=$categoryId');
    }
  }
}
