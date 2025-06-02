import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/airsoft_categories.dart';
import '../../../widgets/search/equipment_search_suggestions.dart';

class SearchScreen extends StatefulWidget {
  final String? category;

  const SearchScreen({super.key, this.category});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> _recentSearches = [
    'M4A1',
    'Gearbox V2',
    'Red dot',
    'Tactical vest'
  ];
  List<String> _searchResults = [];
  String? _selectedQuickFilter;

  // Equipment-focused quick filters
  final List<Map<String, dynamic>> _equipmentQuickFilters = [
    {
      'label': 'Équipement protection',
      'icon': Icons.security,
      'categories': [
        AirsoftCategories.masques,
        AirsoftCategories.giletsTactiques,
        AirsoftCategories.casques,
        AirsoftCategories.lunettesProtection,
      ],
      'color': Colors.red,
    },
    {
      'label': 'Répliques',
      'icon': Icons.sports_motorsports,
      'categories': [
        AirsoftCategories.repliqueLongueAEG,
        AirsoftCategories.repliquePoingGaz,
        AirsoftCategories.repliqueLongueGBB,
      ],
      'color': Colors.blue,
    },
    {
      'label': 'Accessoires',
      'icon': Icons.build,
      'categories': [
        AirsoftCategories.organesVisee,
        AirsoftCategories.chargeurs,
        AirsoftCategories.lampesTactiques,
      ],
      'color': Colors.green,
    },
    {
      'label': 'Upgrades',
      'icon': Icons.precision_manufacturing,
      'categories': [
        AirsoftCategories.gearbox,
        AirsoftCategories.canonPrecision,
        AirsoftCategories.hopUpJoints,
      ],
      'color': Colors.orange,
    },
  ];

  @override
  void initState() {
    super.initState();

    // If a category is provided, set it as the search query
    if (widget.category != null && widget.category!.isNotEmpty) {
      _searchController.text = widget.category!;
      _performSearch(widget.category!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    // Enhanced search with equipment focus
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isSearching = false;
        _searchResults = _getEnhancedSearchResults(query);

        // Add to recent searches if not already there
        if (!_recentSearches.contains(query)) {
          _recentSearches.insert(0, query);
          if (_recentSearches.length > 5) {
            _recentSearches.removeLast();
          }
        }
      });
    });
  }

  List<String> _getEnhancedSearchResults(String query) {
    final baseResults = [
      'M4A1 Daniel Defense MK18',
      'Gearbox V2 complète SHS',
      'Red dot Aimpoint T1 replica',
      'M4 SOPMOD Block II',
      'Gearbox V3 upgrade',
      'Gilet tactique Viper',
      'Masque Dye I5',
      'Casque FAST maritime',
      'Lunettes ESS Crossbow',
      'Glock 17 GBB',
      'Chargeur PMAG 120 billes',
      'Silencieux M4 14mm',
      'Canon précision 6.03mm',
      'Hop-up Maple Leaf',
    ];

    return baseResults
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _applyQuickFilter(Map<String, dynamic> filter) {
    setState(() {
      _selectedQuickFilter = filter['label'];
      _searchController.text = filter['label'];
      _performSearch(filter['label']);
    });
  }

  void _clearQuickFilter() {
    setState(() {
      _selectedQuickFilter = null;
      _searchController.clear();
      _searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Branded logo for search
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  'assets/images/gearted_transparent.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Text('Recherche'),
          ],
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          IconButton(
            onPressed: () => context.push('/advanced-search'),
            icon: const Icon(Icons.tune),
            tooltip: 'Filtres avancés',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher équipement Airsoft...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedQuickFilter != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: _clearQuickFilter,
                        tooltip: 'Effacer le filtre',
                      ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults.clear();
                          });
                        },
                      ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: _performSearch,
            ),
            
            const SizedBox(height: 16),

            // Equipment Quick Filters
            if (_selectedQuickFilter == null) ...[
              const Text(
                'Recherche rapide par catégorie',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _equipmentQuickFilters.length,
                  itemBuilder: (context, index) {
                    final filter = _equipmentQuickFilters[index];
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      child: Material(
                        borderRadius: BorderRadius.circular(12),
                        color: filter['color'].withOpacity(0.1),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _applyQuickFilter(filter),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  filter['icon'],
                                  color: filter['color'],
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  filter['label'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: filter['color'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              // Active filter indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.filter_alt,
                      color: Colors.blue.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Filtre: $_selectedQuickFilter',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _clearQuickFilter,
                      child: Icon(
                        Icons.close,
                        color: Colors.blue.shade700,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Content based on search state
            Expanded(
              child: _isSearching
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _searchResults.isNotEmpty
                      ? _buildSearchResults()
                      : _buildSearchSuggestions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_recentSearches.isNotEmpty) ...[
          const Text(
            'Recherches récentes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_recentSearches.length, (index) {
            final search = _recentSearches[index];
            return ListTile(
              leading: const Icon(Icons.history, color: Colors.grey),
              title: Text(search),
              trailing: IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  setState(() {
                    _recentSearches.removeAt(index);
                  });
                },
              ),
              onTap: () {
                _searchController.text = search;
                _performSearch(search);
              },
            );
          }),
          const SizedBox(height: 24),
        ],
        
        // Equipment search suggestions
        Expanded(
          child: EquipmentSearchSuggestions(
            query: _searchController.text,
            onSuggestionTap: (suggestion) {
              _searchController.text = suggestion;
              _performSearch(suggestion);
            },
            onEquipmentFilterTap: () {
              context.push('/advanced-search');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_searchResults.length} résultats trouvés',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            TextButton.icon(
              onPressed: () => context.push('/advanced-search'),
              icon: const Icon(Icons.tune, size: 16),
              label: const Text('Affiner'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              final isEquipment = _isEquipmentItem(result);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isEquipment 
                          ? Colors.red.shade100 
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isEquipment ? Icons.security : Icons.image,
                      color: isEquipment 
                          ? Colors.red.shade600 
                          : Colors.grey,
                    ),
                  ),
                  title: Text(result),
                  subtitle: Row(
                    children: [
                      Text('À partir de ${(50 + index * 25)}€'),
                      if (isEquipment) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6, 
                            vertical: 2
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'ÉQUIPEMENT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: const Icon(Icons.favorite_border),
                  onTap: () {
                    // TODO: Navigate to item details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isEquipmentItem(String itemName) {
    final equipmentKeywords = [
      'gilet', 'masque', 'casque', 'lunettes', 'protection',
      'tactique', 'vest', 'helmet', 'goggle', 'chest'
    ];
    
    return equipmentKeywords.any(
      (keyword) => itemName.toLowerCase().contains(keyword)
    );
  }
}
