import 'package:flutter/material.dart';
import '../../core/constants/airsoft_categories.dart';
import '../../config/theme.dart';

class CategorySelector extends StatefulWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final bool showSubCategories;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
    this.showSubCategories = true,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? _selectedMainCategory;
  bool _showingSubCategories = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedCategory != null) {
      // Determine if selected category is main or sub category
      if (AirsoftCategories.isMainCategory(widget.selectedCategory!)) {
        _selectedMainCategory = widget.selectedCategory;
      } else {
        _selectedMainCategory =
            AirsoftCategories.getMainCategory(widget.selectedCategory!);
        if (_selectedMainCategory != null) {
          _showingSubCategories = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _showingSubCategories
                    ? 'Sous-catégories'
                    : 'Sélectionner une catégorie',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_showingSubCategories)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showingSubCategories = false;
                      _selectedMainCategory = null;
                    });
                  },
                  child: const Text('Retour'),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Categories List
          Flexible(
            child: SingleChildScrollView(
              child: _showingSubCategories && _selectedMainCategory != null
                  ? _buildSubCategoriesList()
                  : _buildMainCategoriesList(),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMainCategoriesList() {
    return Column(
      children: AirsoftCategories.mainCategories.map((category) {
        final isSelected = widget.selectedCategory == category;
        final iconCode = AirsoftCategories.categoryIcons[category] ?? 0xe5f1;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              IconData(iconCode, fontFamily: 'MaterialIcons'),
              color:
                  isSelected ? GeartedTheme.primaryBlue : Colors.grey.shade600,
            ),
            title: Text(
              category,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? GeartedTheme.primaryBlue : Colors.black87,
              ),
            ),
            trailing: widget.showSubCategories
                ? Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  )
                : null,
            selected: isSelected,
            selectedTileColor: GeartedTheme.primaryBlue.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () {
              if (widget.showSubCategories) {
                // Show subcategories
                setState(() {
                  _selectedMainCategory = category;
                  _showingSubCategories = true;
                });
              } else {
                // Select main category directly
                widget.onCategorySelected(category);
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubCategoriesList() {
    final subCategories =
        AirsoftCategories.getSubCategories(_selectedMainCategory!);

    return Column(
      children: [
        // Option to select main category
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              Icons.folder,
              color: widget.selectedCategory == _selectedMainCategory
                  ? GeartedTheme.primaryBlue
                  : Colors.grey.shade600,
            ),
            title: Text(
              _selectedMainCategory!,
              style: TextStyle(
                fontWeight: widget.selectedCategory == _selectedMainCategory
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: widget.selectedCategory == _selectedMainCategory
                    ? GeartedTheme.primaryBlue
                    : Colors.black87,
              ),
            ),
            subtitle: const Text('Toutes les sous-catégories'),
            selected: widget.selectedCategory == _selectedMainCategory,
            selectedTileColor: GeartedTheme.primaryBlue.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onTap: () {
              widget.onCategorySelected(_selectedMainCategory!);
            },
          ),
        ),

        const Divider(),

        // Subcategories
        ...subCategories.map((subCategory) {
          final isSelected = widget.selectedCategory == subCategory;

          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: ListTile(
              leading: Icon(
                Icons.subdirectory_arrow_right,
                color: isSelected
                    ? GeartedTheme.primaryBlue
                    : Colors.grey.shade400,
              ),
              title: Text(
                subCategory,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? GeartedTheme.primaryBlue : Colors.black87,
                ),
              ),
              selected: isSelected,
              selectedTileColor: GeartedTheme.primaryBlue.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () {
                widget.onCategorySelected(subCategory);
              },
            ),
          );
        }).toList(),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? GeartedTheme.primaryBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? GeartedTheme.primaryBlue : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// Helper function to show category selector as bottom sheet
void showCategorySelector(
  BuildContext context, {
  String? selectedCategory,
  required Function(String) onCategorySelected,
  bool showSubCategories = true,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) => CategorySelector(
        selectedCategory: selectedCategory,
        onCategorySelected: (category) {
          onCategorySelected(category);
          Navigator.of(context).pop();
        },
        showSubCategories: showSubCategories,
      ),
    ),
  );
}
