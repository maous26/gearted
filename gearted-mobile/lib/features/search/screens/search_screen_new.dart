import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/airsoft_category.dart';
import '../../../services/category_service.dart';
import '../../../widgets/search/advanced_search_bar.dart';
import '../../../widgets/category/category_grid_widget.dart';
import '../../../config/theme.dart';

class SearchScreenNew extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialQuery;
  final AirsoftCategoryType? initialType;

  const SearchScreenNew({
    super.key,
    this.initialCategoryId,
    this.initialQuery,
    this.initialType,
  });

  @override
  State<SearchScreenNew> createState() => _SearchScreenNewState();
}

class _SearchScreenNewState extends State<SearchScreenNew>
    with TickerProviderStateMixin {
  // Search state
  String _searchQuery = '';
  List<AirsoftCategory> _selectedCategories = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  // Filter options
  String _sortBy = 'relevance';
  double? _minPrice;
  double? _maxPrice;
  String? _condition;
  bool _showOnlyExchangeable = false;

  // UI state
  bool _showAdvancedFilters = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeFromParams();
    _performSearch();
  }

  void _initializeAnimations() {
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    );
  }

  void _initializeFromParams() {
    // Initialize with parameters
    if (widget.initialCategoryId != null) {
      final category =
          CategoryService.getCategoryById(widget.initialCategoryId!);
      if (category != null) {
        _selectedCategories = [category];
      }
    }

    if (widget.initialQuery != null) {
      _searchQuery = widget.initialQuery!;
    }

    if (widget.initialType != null) {
      _selectedCategories = CategoryService.getAllMainCategories()
          .where((cat) => cat.type == widget.initialType)
          .toList();
    }
  }

  @override
  void dispose() {
    _filterAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate search with filter parameters
      await Future.delayed(const Duration(milliseconds: 800));

      // Generate mock results based on search criteria
      final mockResults = _generateMockResults();

      setState(() {
        _searchResults = mockResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateMockResults() {
    List<Map<String, dynamic>> results = [];

    // Generate 12 mock results
    for (int i = 0; i < 12; i++) {
      final categories = CategoryService.getAllCategories();
      final randomCategory = categories[i % categories.length];

      results.add({
        'id': 'result_$i',
        'title': _generateMockTitle(randomCategory, i),
        'price': 50 + (i * 25),
        'originalPrice': i % 3 == 0 ? (50 + (i * 25)) + 20 : null,
        'condition': i % 2 == 0 ? 'Neuf' : 'Occasion',
        'categoryId': randomCategory.id,
        'location': _generateLocation(),
        'sellerRating': 4.0 + (i % 10) / 10,
        'distance': (i % 20) + 1,
        'isExchangeable': i % 4 == 0,
        'imageUrl': null, // No real images for mock data
        'views': (i + 1) * 15,
        'favorites': (i + 1) * 3,
      });
    }

    // Apply sorting
    _applySorting(results);

    return results;
  }

  String _generateMockTitle(AirsoftCategory category, int index) {
    final titles = {
      'repliques_aeg': ['M4A1 Électrique', 'AK-47 AEG', 'G36C Combat'],
      'repliques_gbb': ['Glock 17 GBB', 'M4 GBBR', 'AK74 Gaz'],
      'repliques_sniper': ['L96 AWS Sniper', 'M24 SWS', 'SVD Dragunov'],
      'repliques_shotgun': ['M870 Tactical', 'SPAS-12', 'M4 Breacher'],
      'repliques_pistol': ['Glock 19 GBB', 'Colt 1911', 'SIG P226'],
      'protection_masks': ['Masque Dye I5', 'Masque Valken MI-7', 'OneShot V4'],
      'protection_helmets': [
        'Casque FAST',
        'Casque MICH 2000',
        'Ops-Core FAST'
      ],
      'protection_vests': ['Gilet JPC', 'Vest 6094', 'Chest Rig Haley'],
      'protection_gloves': ['Gants Mechanix', 'Gants 5.11', 'Gants Oakley'],
    };

    final categoryTitles = titles[category.id] ?? ['Article ${category.name}'];
    return '${categoryTitles[index % categoryTitles.length]} - Article ${index + 1}';
  }

  String _generateLocation() {
    final locations = [
      'Paris',
      'Lyon',
      'Marseille',
      'Toulouse',
      'Nice',
      'Nantes'
    ];
    return locations[DateTime.now().millisecond % locations.length];
  }

  void _applySorting(List<Map<String, dynamic>> results) {
    switch (_sortBy) {
      case 'price_asc':
        results
            .sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
        break;
      case 'price_desc':
        results
            .sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
        break;
      case 'recent':
        // Already in order for mock data
        break;
      case 'equipment_first':
        results.sort((a, b) {
          final catA = CategoryService.getCategoryById(a['categoryId']);
          final catB = CategoryService.getCategoryById(b['categoryId']);
          if (catA?.type == AirsoftCategoryType.protection &&
              catB?.type != AirsoftCategoryType.protection) return -1;
          if (catB?.type == AirsoftCategoryType.protection &&
              catA?.type != AirsoftCategoryType.protection) return 1;
          return 0;
        });
        break;
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchQuery == query) {
        _performSearch();
      }
    });
  }

  void _onCategorySelected(AirsoftCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
    _performSearch();
  }

  // Utility method to clear all filters - Called from UI elements
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategories = [];
      _minPrice = null;
      _maxPrice = null;
      _condition = null;
      _showOnlyExchangeable = false;
      _sortBy = 'relevance';
    });
    _performSearch();
  }

  void _toggleAdvancedFilters() {
    setState(() {
      _showAdvancedFilters = !_showAdvancedFilters;
    });

    if (_showAdvancedFilters) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search bar
            _buildSearchHeader(),

            // Filter chips
            if (_hasActiveFilters()) _buildFilterChips(),

            // Advanced filters panel
            AnimatedBuilder(
              animation: _filterAnimation,
              builder: (context, child) {
                return SizeTransition(
                  sizeFactor: _filterAnimation,
                  child: _showAdvancedFilters
                      ? _buildAdvancedFilters()
                      : const SizedBox.shrink(),
                );
              },
            ),

            // Action bar with sort and filter buttons
            _buildActionBar(),

            // Results
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _searchResults.isEmpty
                      ? _buildEmptyState()
                      : _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Branded header
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: GeartedColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: GeartedColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'RECHERCHE TACTIQUE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Oswald',
                  letterSpacing: 1.2,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
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
                  Icons.military_tech,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Advanced search bar
          AdvancedSearchBar(
            onSearchChanged: _onSearchChanged,
            onSuggestionSelected: (suggestion) {
              _onSearchChanged(suggestion);
            },
            initialValue: _searchQuery,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // Category chips
            ..._selectedCategories.map((category) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category.name,
                      style: const TextStyle(
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    avatar: Icon(
                      Icons.category,
                      size: 16,
                      color: GeartedColors.getCategoryColor(category.id),
                    ),
                    selected: true,
                    onSelected: (_) => _onCategorySelected(category),
                    selectedColor: GeartedColors.getCategoryColor(category.id)
                        .withOpacity(0.8),
                    backgroundColor: GeartedColors.getCategoryColor(category.id)
                        .withOpacity(0.15),
                    labelStyle: TextStyle(
                        color: GeartedColors.getCategoryColor(category.id)),
                  ),
                )),

            // Price filter chip
            if (_minPrice != null || _maxPrice != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    'Prix: ${_minPrice?.toInt() ?? 0}€ - ${_maxPrice?.toInt() ?? '∞'}€',
                    style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  avatar: const Icon(Icons.euro, size: 16, color: Colors.green),
                  selected: true,
                  onSelected: (_) => setState(() {
                    _minPrice = null;
                    _maxPrice = null;
                  }),
                  selectedColor: Colors.green.withOpacity(0.8),
                  backgroundColor: Colors.green.withOpacity(0.15),
                  labelStyle: const TextStyle(color: Colors.green),
                ),
              ),

            // Condition filter chip
            if (_condition != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                    _condition!,
                    style: const TextStyle(
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  avatar:
                      const Icon(Icons.star, size: 16, color: Colors.orange),
                  selected: true,
                  onSelected: (_) => setState(() => _condition = null),
                  selectedColor: Colors.orange.withOpacity(0.8),
                  backgroundColor: Colors.orange.withOpacity(0.15),
                  labelStyle: const TextStyle(color: Colors.orange),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price range
          const Text(
            'Fourchette de prix',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Oswald',
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
                  onChanged: (value) {
                    setState(() {
                      _minPrice = double.tryParse(value);
                    });
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
                  onChanged: (value) {
                    setState(() {
                      _maxPrice = double.tryParse(value);
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Condition
          const Text(
            'État',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Oswald',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _condition,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            hint: const Text('Sélectionner un état'),
            items: [
              'Neuf',
              'Comme neuf',
              'Très bon état',
              'Bon état',
              'État correct'
            ]
                .map((condition) => DropdownMenuItem(
                      value: condition,
                      child: Text(condition),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _condition = value;
              });
            },
          ),

          const SizedBox(height: 20),

          // Exchange option
          SwitchListTile(
            title: const Text(
              'Échange possible uniquement',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            value: _showOnlyExchangeable,
            onChanged: (value) {
              setState(() {
                _showOnlyExchangeable = value;
              });
            },
            activeColor: GeartedColors.primaryBlue,
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              // Clear filters button
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    _clearFilters();
                    _toggleAdvancedFilters();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'EFFACER',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Apply filters button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    _performSearch();
                    _toggleAdvancedFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GeartedColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'APPLIQUER',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Results count
          if (_searchResults.isNotEmpty)
            Text(
              '${_searchResults.length} RÉSULTATS',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Oswald',
                letterSpacing: 0.5,
              ),
            ),

          const Spacer(),

          // Filter button
          OutlinedButton.icon(
            onPressed: _toggleAdvancedFilters,
            icon: Icon(
              _showAdvancedFilters ? Icons.expand_less : Icons.expand_more,
              size: 18,
            ),
            label: Text('Filtres${_getActiveFilterCount()}'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: GeartedColors.primaryBlue),
              foregroundColor: GeartedColors.primaryBlue,
            ),
          ),

          const SizedBox(width: 12),

          // Sort button
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
              _performSearch();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'relevance',
                child: Text('Pertinence'),
              ),
              const PopupMenuItem(
                value: 'price_asc',
                child: Text('Prix croissant'),
              ),
              const PopupMenuItem(
                value: 'price_desc',
                child: Text('Prix décroissant'),
              ),
              const PopupMenuItem(
                value: 'recent',
                child: Text('Plus récent'),
              ),
              const PopupMenuItem(
                value: 'equipment_first',
                child: Text('Équipement d\'abord'),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sort, size: 18),
                  const SizedBox(width: 4),
                  Text(_getSortLabel()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),

          // Content skeleton
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'AUCUN RÉSULTAT TROUVÉ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'Oswald',
                letterSpacing: 1.2,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Ajustez vos critères ou découvrez nos suggestions',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Category suggestions
            const Text(
              'CATÉGORIES POPULAIRES',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Oswald',
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 16),

            // Mini category grid
            SizedBox(
              height: 200,
              child: CategoryGridWidget(
                onCategorySelected: _onCategorySelected,
                selectedCategoryId: _selectedCategories.isNotEmpty
                    ? _selectedCategories.first.id
                    : null,
                showPopularOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        final category = CategoryService.getCategoryById(item['categoryId']);
        return _buildProductCard(item, category);
      },
    );
  }

  Widget _buildProductCard(
      Map<String, dynamic> item, AirsoftCategory? category) {
    final isNew = item['condition'] == 'Neuf';
    final hasDiscount = item['originalPrice'] != null;
    final isExchangeable = item['isExchangeable'] == true;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: category != null
              ? GeartedColors.getCategoryColor(category.id).withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/listing/${item['id']}'),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badges
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                  ),

                  // Condition badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isNew ? Colors.green : Colors.orange,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        isNew ? 'NEUF' : 'OCCASION',
                        style: TextStyle(
                          color: isNew ? Colors.green : Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Oswald',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  // Discount badge
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.red,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          '-${(((item['originalPrice'] - item['price']) / item['originalPrice']) * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),
                    ),

                  // Exchange badge
                  if (isExchangeable)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: GeartedColors.primaryBlue,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          'ÉCHANGE',
                          style: TextStyle(
                            color: GeartedColors.primaryBlue,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Oswald',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Category
                    if (category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: GeartedColors.getCategoryColor(category.id)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: GeartedColors.getCategoryColor(category.id),
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),

                    const Spacer(),

                    // Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${item['price']}€',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Oswald',
                            color: Colors.green,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${item['originalPrice']}€',
                            style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontFamily: 'Oswald',
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Seller info and distance
                    Row(
                      children: [
                        const Icon(Icons.verified_user,
                            size: 12, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          '${item['sellerRating']}★',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.location_on,
                            size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        Text(
                          '${item['distance']}km',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedCategories.isNotEmpty ||
        _minPrice != null ||
        _maxPrice != null ||
        _condition != null ||
        _showOnlyExchangeable ||
        _searchQuery.isNotEmpty;
  }

  String _getActiveFilterCount() {
    int count = 0;
    if (_selectedCategories.isNotEmpty) count += _selectedCategories.length;
    if (_minPrice != null || _maxPrice != null) count++;
    if (_condition != null) count++;
    if (_showOnlyExchangeable) count++;

    return count > 0 ? ' ($count)' : '';
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'price_asc':
        return 'Prix ↑';
      case 'price_desc':
        return 'Prix ↓';
      case 'recent':
        return 'Récent';
      case 'equipment_first':
        return 'Équipement';
      default:
        return 'Pertinence';
    }
  }
}
