import 'package:flutter/material.dart';
import '../../../core/constants/airsoft_categories.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  String? _selectedLocation;
  String _sortBy = 'recent';
  bool _priceNegotiable = false;
  bool _equipmentOnly = false;
  Set<String> _selectedEquipmentTypes = {};

  final List<String> _categories = AirsoftCategories.allCategories;

  final List<String> _conditions = [
    'Neuf',
    'Comme neuf',
    'Très bon état',
    'Bon état',
    'État correct',
  ];

  final List<String> _locations = [
    'Paris (75)',
    'Lyon (69)',
    'Marseille (13)',
    'Toulouse (31)',
    'Bordeaux (33)',
    'Lille (59)',
    'Nantes (44)',
    'Strasbourg (67)',
  ];

  final List<String> _sortOptions = [
    'recent',
    'price_asc',
    'price_desc',
    'distance',
    'popularity',
    'equipment_priority', // New sort option for equipment
  ];

  final Map<String, String> _sortLabels = {
    'recent': 'Plus récent',
    'price_asc': 'Prix croissant',
    'price_desc': 'Prix décroissant',
    'distance': 'Distance',
    'popularity': 'Popularité',
    'equipment_priority': 'Équipement en priorité',
  };

  // Equipment-specific filter options
  final List<Map<String, dynamic>> _equipmentTypes = [
    {
      'label': 'Protection corporelle',
      'key': 'body_protection',
      'categories': [
        AirsoftCategories.giletsTactiques,
        AirsoftCategories.portePlaques,
      ],
      'icon': Icons.security,
    },
    {
      'label': 'Protection visage',
      'key': 'face_protection',
      'categories': [
        AirsoftCategories.masques,
        AirsoftCategories.lunettesProtection,
      ],
      'icon': Icons.face,
    },
    {
      'label': 'Protection tête',
      'key': 'head_protection',
      'categories': [
        AirsoftCategories.casques,
      ],
      'icon': Icons.sports_kabaddi,
    },
    {
      'label': 'Protection mains',
      'key': 'hand_protection',
      'categories': [
        AirsoftCategories.gants,
      ],
      'icon': Icons.back_hand,
    },
    {
      'label': 'Protection articulations',
      'key': 'joint_protection',
      'categories': [
        AirsoftCategories.genouilleres,
      ],
      'icon': Icons.accessibility,
    },
  ];

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _selectedCategory = null;
      _selectedCondition = null;
      _selectedLocation = null;
      _sortBy = 'recent';
      _priceNegotiable = false;
      _equipmentOnly = false;
      _selectedEquipmentTypes.clear();
    });
  }

  void _applyFilters() {
    // TODO: Implement search with filters
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_buildFilterSummary()),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _buildFilterSummary() {
    List<String> activeFilters = [];
    
    if (_searchController.text.isNotEmpty) {
      activeFilters.add('Recherche: "${_searchController.text}"');
    }
    if (_selectedCategory != null) {
      activeFilters.add('Catégorie: ${AirsoftCategories.getCleanCategoryName(_selectedCategory!)}');
    }
    if (_equipmentOnly) {
      activeFilters.add('Équipement uniquement');
    }
    if (_selectedEquipmentTypes.isNotEmpty) {
      activeFilters.add('Types: ${_selectedEquipmentTypes.length} sélectionnés');
    }
    
    return activeFilters.isEmpty 
        ? 'Recherche avec filtres appliquée'
        : 'Filtres actifs: ${activeFilters.join(', ')}';
  }

  Widget _buildFilterSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T)? itemBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hint),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemBuilder?.call(item) ?? item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildEquipmentFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Equipment only toggle
        Container(
          decoration: BoxDecoration(
            color: _equipmentOnly ? Colors.red.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _equipmentOnly ? Colors.red.shade300 : Colors.grey.shade300,
            ),
          ),
          child: SwitchListTile(
            title: const Text(
              'Équipement de protection uniquement',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('Filtrer uniquement les articles d\'équipement'),
            value: _equipmentOnly,
            activeColor: Colors.red.shade600,
            onChanged: (value) {
              setState(() {
                _equipmentOnly = value;
                if (!value) {
                  _selectedEquipmentTypes.clear();
                }
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
        ),
        
        if (_equipmentOnly) ...[
          const SizedBox(height: 16),
          const Text(
            'Types d\'équipement',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _equipmentTypes.map((type) {
              final isSelected = _selectedEquipmentTypes.contains(type['key']);
              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type['icon'],
                      size: 16,
                      color: isSelected ? Colors.white : Colors.red.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(type['label']),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedEquipmentTypes.add(type['key']);
                    } else {
                      _selectedEquipmentTypes.remove(type['key']);
                    }
                  });
                },
                selectedColor: Colors.red.shade600,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.red.shade300),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche avancée'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search query
            _buildFilterSection(
              'Recherche',
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Que recherchez-vous ?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // Equipment-specific filters
            _buildFilterSection(
              'Filtres équipement',
              _buildEquipmentFilters(),
            ),

            // Category
            _buildFilterSection(
              'Catégorie',
              _buildDropdown<String>(
                hint: 'Sélectionner une catégorie',
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) => setState(() => _selectedCategory = value),
                itemBuilder: (category) => AirsoftCategories.getCleanCategoryName(category),
              ),
            ),

            // Price range
            _buildFilterSection(
              'Prix',
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minPriceController,
                          decoration: const InputDecoration(
                            hintText: 'Prix min.',
                            border: OutlineInputBorder(),
                            suffixText: '€',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _maxPriceController,
                          decoration: const InputDecoration(
                            hintText: 'Prix max.',
                            border: OutlineInputBorder(),
                            suffixText: '€',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('Prix négociable'),
                    value: _priceNegotiable,
                    onChanged: (value) =>
                        setState(() => _priceNegotiable = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            // Condition
            _buildFilterSection(
              'État',
              _buildDropdown<String>(
                hint: 'Sélectionner l\'état',
                value: _selectedCondition,
                items: _conditions,
                onChanged: (value) =>
                    setState(() => _selectedCondition = value),
              ),
            ),

            // Location
            _buildFilterSection(
              'Localisation',
              _buildDropdown<String>(
                hint: 'Sélectionner une ville',
                value: _selectedLocation,
                items: _locations,
                onChanged: (value) => setState(() => _selectedLocation = value),
              ),
            ),

            // Sort by
            _buildFilterSection(
              'Trier par',
              _buildDropdown<String>(
                hint: 'Choisir le tri',
                value: _sortBy,
                items: _sortOptions,
                onChanged: (value) =>
                    setState(() => _sortBy = value ?? 'recent'),
                itemBuilder: (item) => _sortLabels[item] ?? item,
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Appliquer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
