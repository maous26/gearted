import 'package:flutter/material.dart';
import '../../models/airsoft_category.dart';
import '../../services/category_service.dart';
import '../../config/theme.dart';

/// Widget de grille de catégories avec design martial et navigation hiérarchique
class CategoryGridWidget extends StatefulWidget {
  final Function(AirsoftCategory)? onCategorySelected;
  final String? selectedCategoryId;
  final bool showPopularOnly;
  final bool showSubCategories;
  final String? parentCategoryId;
  final CrossAxisAlignment alignment;
  final int crossAxisCount;
  final double childAspectRatio;

  const CategoryGridWidget({
    Key? key,
    this.onCategorySelected,
    this.selectedCategoryId,
    this.showPopularOnly = false,
    this.showSubCategories = false,
    this.parentCategoryId,
    this.alignment = CrossAxisAlignment.center,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
  }) : super(key: key);

  @override
  State<CategoryGridWidget> createState() => _CategoryGridWidgetState();
}

class _CategoryGridWidgetState extends State<CategoryGridWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<AirsoftCategory> _categories = [];
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.selectedCategoryId;
    _loadCategories();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadCategories() {
    if (widget.showPopularOnly) {
      _categories = CategoryService.getPopularCategories();
    } else {
      _categories = CategoryService.getAllMainCategories();
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: widget.alignment,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildCategoryGrid(),
            if (widget.showSubCategories && _selectedCategoryId != null)
              _buildSubCategoriesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GeartedColors.primaryBlue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.category,
            color: GeartedColors.primaryBlue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.showPopularOnly
                  ? 'CATÉGORIES POPULAIRES'
                  : 'TOUTES LES CATÉGORIES',
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: GeartedColors.primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_categories.length}',
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final isSelected = _selectedCategoryId == category.id;

        return _buildCategoryCard(category, isSelected, index);
      },
    );
  }

  Widget _buildCategoryCard(
      AirsoftCategory category, bool isSelected, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.1 * index,
            0.1 * index + 0.6,
            curve: Curves.easeOut,
          ),
        ));

        return SlideTransition(
          position: slideAnimation,
          child: GestureDetector(
            onTap: () => _selectCategory(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? category.color
                      : category.color.withOpacity(0.3),
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: category.color.withOpacity(isSelected ? 0.3 : 0.1),
                    blurRadius: isSelected ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Badge priorité pour catégories populaires
                  if (category.isPopular)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: GeartedColors.victoryGold,
                            width: 1.5,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.star,
                          color: GeartedColors.victoryGold,
                          size: 12,
                        ),
                      ),
                    ),

                  // Contenu principal
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icône de catégorie
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: category.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: category.color.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            category.icon,
                            color: category.color,
                            size: 28,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Nom de la catégorie
                        Text(
                          category.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: category.color,
                            letterSpacing: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Description courte
                        Text(
                          category.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Nombre de sous-catégories
                        if (category.subCategories.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${category.subCategories.length} sous-cat.',
                              style: TextStyle(
                                fontFamily: 'Oswald',
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Indicateur de sélection
                  if (isSelected)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: category.color,
                            width: 1.5,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check,
                          color: category.color,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubCategoriesSection() {
    final selectedCategory =
        CategoryService.getCategoryById(_selectedCategoryId!);
    if (selectedCategory == null || selectedCategory.subCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selectedCategory.color,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'SOUS-CATÉGORIES: ${selectedCategory.name.toUpperCase()}',
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: selectedCategory.color,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedCategory.subCategories.map((subCat) {
            return _buildSubCategoryChip(subCat, selectedCategory);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubCategoryChip(
      AirsoftSubCategory subCategory, AirsoftCategory parentCategory) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: parentCategory.color,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            subCategory.icon,
            color: parentCategory.color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            subCategory.name,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: parentCategory.color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  void _selectCategory(AirsoftCategory category) {
    setState(() {
      _selectedCategoryId =
          _selectedCategoryId == category.id ? null : category.id;
    });

    if (widget.onCategorySelected != null) {
      widget.onCategorySelected!(category);
    }
  }
}
