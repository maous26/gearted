import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/category_model.dart';
import '../../core/constants/categories_data.dart';

class QuickCategoryGrid extends StatelessWidget {
  const QuickCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Équipement en priorité
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.1),
                  Colors.red.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield, color: Colors.red, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Équipement de Protection',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.priority_high,
                      size: 18,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => context.push('/search?type=equipment'),
                      child: const Text('Tout voir'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio:
                        1.2, // Increased aspect ratio for better fit
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: CategoriesData.equipmentCategories.take(6).length,
                  itemBuilder: (context, index) {
                    final category = CategoriesData.equipmentCategories[index];
                    return _buildQuickCategoryCard(context, category, true);
                  },
                ),
              ],
            ),
          ),

          // Autres catégories principales
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Toutes les catégories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 5.0, // Increased to fix overflow
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: CategoriesData.mainCategories.length,
            itemBuilder: (context, index) {
              final category = CategoriesData.mainCategories[index];
              return _buildMainCategoryCard(context, category);
            },
          ),

          const SizedBox(height: 16),

          // Section des catégories populaires
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Catégories populaires',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 100, // Reduced height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: CategoriesData.popularCategories.length,
              itemBuilder: (context, index) {
                final category = CategoriesData.popularCategories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildPopularCategoryCard(context, category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCategoryCard(
      BuildContext context, CategoryModel category, bool isEquipment) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/search?category=${category.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Icon(
                    category.icon,
                    color: category.color,
                    size: 24, // Reduced icon size
                  ),
                  if (category.isPopular)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 10, // Reduced star size
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2), // Reduced spacing
              Flexible(
                child: Text(
                  category.displayName,
                  style: const TextStyle(
                    fontSize: 10, // Reduced font size
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCategoryCard(BuildContext context, CategoryModel category) {
    final subCount = CategoriesData.getSubCategories(category.id).length;
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: category.color.withOpacity(0.1),
      child: InkWell(
        onTap: () => context.push('/search?category={category.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: category.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (subCount > 0) ...[
                      const SizedBox(width: 4),
                      Text(
                        '($subCount)',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    if (category.isPopular) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 10,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: category.color,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularCategoryCard(
      BuildContext context, CategoryModel category) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/search?category=${category.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: category.color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Icon(
                    category.icon,
                    color: category.color,
                    size: 32,
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                category.displayName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: category.color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
