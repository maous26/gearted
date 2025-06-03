import 'package:flutter/material.dart';
import '../../core/models/category_model.dart';
import '../../core/constants/categories_data.dart';

class SmartSearchWidget extends StatefulWidget {
  final Function(List<CategoryModel>) onCategoriesSelected;
  final Function(String) onQueryChanged;
  final String? initialQuery;
  final List<CategoryModel>? initialCategories;
  
  const SmartSearchWidget({
    super.key,
    required this.onCategoriesSelected,
    required this.onQueryChanged,
    this.initialQuery,
    this.initialCategories,
  });
  
  @override
  State<SmartSearchWidget> createState() => _SmartSearchWidgetState();
}

class _SmartSearchWidgetState extends State<SmartSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedCategoryIds = {};
  List<CategoryModel> _searchSuggestions = [];
  bool _showFilters = false;
  
  @override
  void initState() {
    super.initState();
    
    // Initialiser avec les valeurs par défaut
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }
    
    if (widget.initialCategories != null) {
      _selectedCategoryIds.addAll(widget.initialCategories!.map((c) => c.id));
    }
    
    _updateSuggestions(_searchController.text);
  }
  
  void _updateSuggestions(String query) {
    setState(() {
      _searchSuggestions = CategoriesData.getSuggestionsForQuery(query);
    });
    widget.onQueryChanged(query);
  }
  
  void _toggleCategory(CategoryModel category) {
    setState(() {
      if (_selectedCategoryIds.contains(category.id)) {
        _selectedCategoryIds.remove(category.id);
      } else {
        _selectedCategoryIds.add(category.id);
      }
    });
    
    final selectedCategories = _selectedCategoryIds
        .map((id) => CategoriesData.getCategoryById(id))
        .whereType<CategoryModel>()
        .toList();
    
    widget.onCategoriesSelected(selectedCategories);
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategoryIds.clear();
      _searchController.clear();
      _showFilters = false;
    });
    _updateSuggestions('');
    widget.onCategoriesSelected([]);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barre de recherche améliorée
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: _updateSuggestions,
                decoration: InputDecoration(
                  hintText: 'Rechercher équipement, répliques...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_selectedCategoryIds.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${_selectedCategoryIds.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      IconButton(
                        icon: Icon(
                          _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                          color: _showFilters ? Theme.of(context).primaryColor : null,
                        ),
                        onPressed: () {
                          setState(() {
                            _showFilters = !_showFilters;
                          });
                        },
                      ),
                      if (_selectedCategoryIds.isNotEmpty || _searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearAllFilters,
                        ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              
              // Suggestions rapides
              if (!_showFilters && _searchSuggestions.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _searchSuggestions.length,
                    itemBuilder: (context, index) {
                      final category = _searchSuggestions[index];
                      final isSelected = _selectedCategoryIds.contains(category.id);
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: Icon(
                            category.icon,
                            size: 16,
                            color: isSelected ? Colors.white : category.color,
                          ),
                          label: Text(
                            category.displayName,
                            style: const TextStyle(fontSize: 12),
                          ),
                          selected: isSelected,
                          onSelected: (_) => _toggleCategory(category),
                          selectedColor: category.color,
                          backgroundColor: category.color.withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : category.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Panneau de filtres avancés
        if (_showFilters)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Section équipement (prioritaire)
                _buildCategorySection(
                  'Équipement de Protection',
                  CategoriesData.equipmentCategories,
                  Colors.red,
                  isPriority: true,
                ),
                
                const SizedBox(height: 16),
                
                // Autres catégories principales
                ...CategoriesData.mainCategories
                    .where((cat) => cat.type != CategoryType.equipment)
                    .map((mainCat) {
                  final subCats = CategoriesData.getSubCategories(mainCat.id);
                  if (subCats.isEmpty) return const SizedBox.shrink();
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCategorySection(
                      mainCat.displayName,
                      subCats,
                      mainCat.color,
                    ),
                  );
                }),
                
                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clearAllFilters,
                        child: const Text('Effacer'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showFilters = false;
                          });
                        },
                        child: Text('Voir ${_selectedCategoryIds.length} filtres'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildCategorySection(
    String title, 
    List<CategoryModel> categories, 
    Color color, {
    bool isPriority = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isPriority ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (isPriority) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.priority_high,
                size: 16,
                color: color,
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = _selectedCategoryIds.contains(category.id);
            
            return InkWell(
              onTap: () => _toggleCategory(category),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? category.color : category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: category.color.withOpacity(isSelected ? 1.0 : 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: category.color.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      size: 16,
                      color: isSelected ? Colors.white : category.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.displayName,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected ? Colors.white : category.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (category.isPopular) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.star,
                        size: 12,
                        color: isSelected ? Colors.white : Colors.orange,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
