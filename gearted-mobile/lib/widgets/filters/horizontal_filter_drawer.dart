import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/category_service.dart';

class HorizontalFilterDrawer extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> currentFilters;

  const HorizontalFilterDrawer({
    super.key,
    required this.onFiltersChanged,
    this.currentFilters = const {},
  });

  @override
  State<HorizontalFilterDrawer> createState() => _HorizontalFilterDrawerState();
}

class _HorizontalFilterDrawerState extends State<HorizontalFilterDrawer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> _filters = {};

  // Filter categories
  final List<FilterCategory> _filterCategories = [
    FilterCategory(
      id: 'categories',
      title: 'Catégories',
      icon: Icons.category,
      color: Colors.blue,
    ),
    FilterCategory(
      id: 'price',
      title: 'Prix',
      icon: Icons.euro,
      color: Colors.green,
    ),
    FilterCategory(
      id: 'condition',
      title: 'État',
      icon: Icons.star,
      color: Colors.orange,
    ),
    FilterCategory(
      id: 'location',
      title: 'Distance',
      icon: Icons.location_on,
      color: Colors.red,
    ),
    FilterCategory(
      id: 'features',
      title: 'Options',
      icon: Icons.tune,
      color: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _filterCategories.length, vsync: this);
    _filters = Map.from(widget.currentFilters);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      if (value == null || (value is List && value.isEmpty)) {
        _filters.remove(key);
      } else {
        _filters[key] = value;
      }
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    setState(() {
      _filters.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [GeartedColors.primaryBlue, GeartedColors.accent],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'FILTRES AVANCÉS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Oswald',
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Reset'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Filter tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: GeartedColors.primaryBlue,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: GeartedColors.primaryBlue,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontFamily: 'Oswald',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: _filterCategories
                  .map((category) => Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(category.icon, size: 16),
                            const SizedBox(width: 8),
                            Text(category.title),
                            if (_hasActiveFiltersInCategory(category.id)) ...[
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: category.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Filter content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoriesFilter(),
                _buildPriceFilter(),
                _buildConditionFilter(),
                _buildLocationFilter(),
                _buildFeaturesFilter(),
              ],
            ),
          ),

          // Apply button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GeartedColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'APPLIQUER${_getActiveFilterCount()}',
                        style: const TextStyle(
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesFilter() {
    final categories = CategoryService.getAllCategories();
    final selectedCategories = _filters['categories'] as List<String>? ?? [];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sélectionnez les catégories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Oswald',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategories.contains(category.id);

                return GestureDetector(
                  onTap: () {
                    final newSelection = List<String>.from(selectedCategories);
                    if (isSelected) {
                      newSelection.remove(category.id);
                    } else {
                      newSelection.add(category.id);
                    }
                    _updateFilter('categories', newSelection);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? GeartedColors.getCategoryColor(category.id)
                              .withOpacity(0.15)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? GeartedColors.getCategoryColor(category.id)
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: GeartedColors.getCategoryColor(category.id),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontFamily: 'Oswald',
                                color: isSelected
                                    ? GeartedColors.getCategoryColor(
                                        category.id)
                                    : Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceFilter() {
    final priceRange = _filters['priceRange'] as Map<String, double?>? ?? {};
    final minPrice = priceRange['min'];
    final maxPrice = priceRange['max'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fourchette de prix',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Oswald',
            ),
          ),
          const SizedBox(height: 16),

          // Quick price ranges
          const Text(
            'Sélection rapide',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPriceChip('Moins de 50€', 0, 50),
              _buildPriceChip('50€ - 100€', 50, 100),
              _buildPriceChip('100€ - 200€', 100, 200),
              _buildPriceChip('200€ - 500€', 200, 500),
              _buildPriceChip('Plus de 500€', 500, null),
            ],
          ),

          const SizedBox(height: 24),

          // Custom range
          const Text(
            'Fourchette personnalisée',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Prix min (€)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                    text: minPrice?.toInt().toString() ?? '',
                  ),
                  onChanged: (value) {
                    final price = double.tryParse(value);
                    final currentRange = Map<String, double?>.from(priceRange);
                    currentRange['min'] = price;
                    _updateFilter('priceRange', currentRange);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Prix max (€)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                    text: maxPrice?.toInt().toString() ?? '',
                  ),
                  onChanged: (value) {
                    final price = double.tryParse(value);
                    final currentRange = Map<String, double?>.from(priceRange);
                    currentRange['max'] = price;
                    _updateFilter('priceRange', currentRange);
                  },
                ),
              ),
            ],
          ),

          if (minPrice != null || maxPrice != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Filtre: ${minPrice?.toInt() ?? 0}€ - ${maxPrice?.toInt() ?? '∞'}€',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceChip(String label, double? min, double? max) {
    final currentRange = _filters['priceRange'] as Map<String, double?>? ?? {};
    final isSelected = currentRange['min'] == min && currentRange['max'] == max;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _updateFilter('priceRange', {'min': min, 'max': max});
        } else {
          _updateFilter('priceRange', null);
        }
      },
      selectedColor: Colors.green.withOpacity(0.2),
      checkmarkColor: Colors.green,
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        color: isSelected ? Colors.green : Colors.black87,
      ),
    );
  }

  Widget _buildConditionFilter() {
    final conditions = [
      'Neuf',
      'Comme neuf',
      'Très bon état',
      'Bon état',
      'État correct'
    ];
    final selectedConditions = _filters['conditions'] as List<String>? ?? [];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'État des articles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Oswald',
            ),
          ),
          const SizedBox(height: 16),
          ...conditions.map((condition) {
            final isSelected = selectedConditions.contains(condition);
            return CheckboxListTile(
              title: Text(
                condition,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: isSelected,
              onChanged: (selected) {
                final newSelection = List<String>.from(selectedConditions);
                if (selected == true) {
                  newSelection.add(condition);
                } else {
                  newSelection.remove(condition);
                }
                _updateFilter('conditions', newSelection);
              },
              activeColor: Colors.orange,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLocationFilter() {
    final maxDistance = _filters['maxDistance'] as double? ?? 50;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distance maximale',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Oswald',
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Rayon de recherche: ${maxDistance.toInt()} km',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),

          Slider(
            value: maxDistance,
            min: 5,
            max: 200,
            divisions: 39,
            label: '${maxDistance.toInt()} km',
            onChanged: (value) {
              _updateFilter('maxDistance', value);
            },
            activeColor: Colors.red,
            inactiveColor: Colors.red.withOpacity(0.3),
          ),

          const SizedBox(height: 16),

          // Quick distance options
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [5, 10, 25, 50, 100, 200].map((distance) {
              final isSelected = maxDistance == distance.toDouble();
              return FilterChip(
                label: Text('${distance}km'),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    _updateFilter('maxDistance', distance.toDouble());
                  }
                },
                selectedColor: Colors.red.withOpacity(0.2),
                checkmarkColor: Colors.red,
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.red : Colors.black87,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesFilter() {
    final features = _filters['features'] as Map<String, bool>? ?? {};

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Options spéciales',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Oswald',
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureSwitch(
            'Échange possible',
            'exchange',
            features['exchange'] ?? false,
            Icons.swap_horiz,
            Colors.blue,
          ),
          _buildFeatureSwitch(
            'Livraison disponible',
            'delivery',
            features['delivery'] ?? false,
            Icons.local_shipping,
            Colors.green,
          ),
          _buildFeatureSwitch(
            'Prix négociable',
            'negotiable',
            features['negotiable'] ?? false,
            Icons.handshake,
            Colors.orange,
          ),
          _buildFeatureSwitch(
            'Vendeur vérifié',
            'verified',
            features['verified'] ?? false,
            Icons.verified_user,
            Colors.purple,
          ),
          _buildFeatureSwitch(
            'Photos multiples',
            'multiplePhotos',
            features['multiplePhotos'] ?? false,
            Icons.photo_library,
            Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSwitch(
    String title,
    String key,
    bool value,
    IconData icon,
    Color color,
  ) {
    final features = _filters['features'] as Map<String, bool>? ?? {};
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? color.withOpacity(0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? color : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: value ? color : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: value ? color : Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              final currentFeatures = Map<String, bool>.from(features);
              currentFeatures[key] = newValue;
              _updateFilter('features', currentFeatures);
            },
            activeColor: color,
          ),
        ],
      ),
    );
  }

  bool _hasActiveFiltersInCategory(String categoryId) {
    switch (categoryId) {
      case 'categories':
        final categories = _filters['categories'] as List<String>?;
        return categories != null && categories.isNotEmpty;
      case 'price':
        final priceRange = _filters['priceRange'] as Map<String, double?>?;
        return priceRange != null &&
            (priceRange['min'] != null || priceRange['max'] != null);
      case 'condition':
        final conditions = _filters['conditions'] as List<String>?;
        return conditions != null && conditions.isNotEmpty;
      case 'location':
        return _filters['maxDistance'] != null && _filters['maxDistance'] != 50;
      case 'features':
        final features = _filters['features'] as Map<String, bool>?;
        return features != null && features.values.any((v) => v == true);
      default:
        return false;
    }
  }

  String _getActiveFilterCount() {
    int count = 0;
    if (_hasActiveFiltersInCategory('categories')) count++;
    if (_hasActiveFiltersInCategory('price')) count++;
    if (_hasActiveFiltersInCategory('condition')) count++;
    if (_hasActiveFiltersInCategory('location')) count++;
    if (_hasActiveFiltersInCategory('features')) count++;

    return count > 0 ? ' ($count)' : '';
  }
}

class FilterCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  const FilterCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}
