import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/airsoft_categories.dart';

class CategoryDisplayWidget extends StatefulWidget {
  const CategoryDisplayWidget({super.key});

  @override
  State<CategoryDisplayWidget> createState() => _CategoryDisplayWidgetState();
}

class _CategoryDisplayWidgetState extends State<CategoryDisplayWidget> {
  String? _selectedMainCategory;
  String? _selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Catégories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/search'),
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Main Category Dropdown
        _buildCategoryDropdown(
          label: 'Catégorie principale',
          value: _selectedMainCategory,
          items: AirsoftCategories.cleanMainCategories,
          onChanged: (value) {
            setState(() {
              _selectedMainCategory = value;
              _selectedSubCategory = null; // Reset subcategory
            });
            if (value != null) {
              // Find the original category with emoji/number to navigate
              final originalCategory = AirsoftCategories.mainCategories
                  .firstWhere((cat) => AirsoftCategories.getCleanCategoryName(cat) == value);
              context.push('/search?category=${Uri.encodeComponent(originalCategory)}');
            }
          },
        ),
        
        const SizedBox(height: 12),
        
        // Subcategory Dropdown
        _buildCategoryDropdown(
          label: 'Sous-catégorie',
          value: _selectedSubCategory,
          items: _selectedMainCategory != null 
              ? _getSubCategoriesForSelected(_selectedMainCategory!)
              : AirsoftCategories.allCleanSubCategories,
          onChanged: (value) {
            setState(() {
              _selectedSubCategory = value;
            });
            if (value != null) {
              // Find the original subcategory with bullet point to navigate
              final originalSubCategory = AirsoftCategories.allCategories
                  .firstWhere((cat) => AirsoftCategories.getCleanCategoryName(cat) == value);
              context.push('/search?category=${Uri.encodeComponent(originalSubCategory)}');
            }
          },
        ),
        
        const SizedBox(height: 16),
        
        // Reset button
        if (_selectedMainCategory != null || _selectedSubCategory != null)
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedMainCategory = null;
                  _selectedSubCategory = null;
                });
              },
              icon: const Icon(Icons.clear),
              label: const Text('Effacer la sélection'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                'Sélectionner $label',
                style: TextStyle(color: Colors.grey[600]),
              ),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  List<String> _getSubCategoriesForSelected(String cleanMainCategory) {
    // Find the original main category with emoji/number
    final originalMainCategory = AirsoftCategories.mainCategories
        .firstWhere((cat) => AirsoftCategories.getCleanCategoryName(cat) == cleanMainCategory);
    
    return AirsoftCategories.getCleanSubCategories(originalMainCategory);
  }
}
