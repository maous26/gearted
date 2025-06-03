import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/category_model.dart';
import '../../../core/constants/categories_data.dart';
import '../../../widgets/search/smart_search_widget.dart';

class SearchScreenRefactored extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialQuery;
  final CategoryType? initialType;
  
  const SearchScreenRefactored({
    super.key,
    this.initialCategoryId,
    this.initialQuery,
    this.initialType,
  });
  
  @override
  State<SearchScreenRefactored> createState() => _SearchScreenRefactoredState();
}

class _SearchScreenRefactoredState extends State<SearchScreenRefactored> {
  // État de recherche
  String _searchQuery = '';
  List<CategoryModel> _selectedCategories = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  
  // Options de tri et filtre
  String _sortBy = 'relevance';
  double? _minPrice;
  double? _maxPrice;
  String? _condition;
  bool _showOnlyExchangeable = false;
  
  // État UI
  bool _showAdvancedFilters = false;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    // Initialiser avec les paramètres
    if (widget.initialCategoryId != null) {
      final category = CategoriesData.getCategoryById(widget.initialCategoryId!);
      if (category != null) {
        _selectedCategories = [category];
      }
    }
    
    if (widget.initialQuery != null) {
      _searchQuery = widget.initialQuery!;
    }
    
    if (widget.initialType != null) {
      _selectedCategories = CategoriesData.allCategories
          .where((cat) => cat.type == widget.initialType)
          .toList();
    }
    
    // Lancer la recherche initiale
    _performSearch();
  }
  
  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Construire les paramètres de recherche (implémentation future)
      // final categoryIds = _selectedCategories.map((c) => c.id).toList();
      
      // Simuler un appel au service de recherche
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Résultats simulés pour la démonstration
      final results = _generateMockResults();
      
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la recherche: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _generateMockResults() {
    // Générer des résultats de test basés sur les filtres
    List<Map<String, dynamic>> mockResults = [];
    
    if (_selectedCategories.any((c) => c.type == CategoryType.equipment)) {
      mockResults.addAll([
        {
          'id': '1',
          'title': 'Masque de protection Dye i5',
          'price': 180,
          'originalPrice': 220,
          'condition': 'Très bon état',
          'categoryId': 'face_protection',
          'isExchangeable': true,
          'description': 'Masque haut de gamme pour airsoft',
        },
        {
          'id': '2',
          'title': 'Gilet tactique Viper',
          'price': 120,
          'condition': 'Bon état',
          'categoryId': 'body_protection',
          'isExchangeable': false,
          'description': 'Gilet modulaire avec porte-plaques',
        },
      ]);
    }
    
    if (_selectedCategories.any((c) => c.type == CategoryType.weapon)) {
      mockResults.addAll([
        {
          'id': '3',
          'title': 'M4A1 AEG G&G CM16',
          'price': 280,
          'condition': 'Neuf',
          'categoryId': 'aeg_rifles',
          'isExchangeable': true,
          'description': 'Réplique électrique performante',
        },
        {
          'id': '4',
          'title': 'Glock 17 GBB WE',
          'price': 95,
          'condition': 'Bon état',
          'categoryId': 'gas_pistols',
          'isExchangeable': false,
          'description': 'Pistolet à gaz réaliste',
        },
      ]);
    }
    
    // Filtrer par prix si spécifié
    if (_minPrice != null) {
      mockResults = mockResults.where((item) => item['price'] >= _minPrice!).toList();
    }
    if (_maxPrice != null) {
      mockResults = mockResults.where((item) => item['price'] <= _maxPrice!).toList();
    }
    
    // Filtrer par condition si spécifiée
    if (_condition != null) {
      mockResults = mockResults.where((item) => item['condition']?.toLowerCase().contains(_condition!.toLowerCase()) ?? false).toList();
    }
    
    // Filtrer par échange si activé
    if (_showOnlyExchangeable) {
      mockResults = mockResults.where((item) => item['isExchangeable'] == true).toList();
    }
    
    // Trier selon le critère choisi
    switch (_sortBy) {
      case 'price_asc':
        mockResults.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'price_desc':
        mockResults.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'equipment_first':
        mockResults.sort((a, b) {
          final catA = CategoriesData.getCategoryById(a['categoryId']);
          final catB = CategoriesData.getCategoryById(b['categoryId']);
          if (catA?.type == CategoryType.equipment && catB?.type != CategoryType.equipment) return -1;
          if (catB?.type == CategoryType.equipment && catA?.type != CategoryType.equipment) return 1;
          return 0;
        });
        break;
    }
    
    return mockResults;
  }
  
  void _onCategoriesSelected(List<CategoryModel> categories) {
    setState(() {
      _selectedCategories = categories;
    });
    _performSearch();
  }
  
  void _onQueryChanged(String query) {
    _searchQuery = query;
    // Debounce la recherche
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchQuery == query) {
        _performSearch();
      }
    });
  }
  
  void _clearAllFilters() {
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec recherche intelligente
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Titre et actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Text(
                          'Recherche',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (_hasActiveFilters())
                          TextButton(
                            onPressed: _clearAllFilters,
                            child: const Text('Effacer tout'),
                          ),
                      ],
                    ),
                  ),
                  
                  // Barre de recherche intelligente
                  SmartSearchWidget(
                    initialQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
                    initialCategories: _selectedCategories.isNotEmpty ? _selectedCategories : null,
                    onCategoriesSelected: _onCategoriesSelected,
                    onQueryChanged: _onQueryChanged,
                  ),
                ],
              ),
            ),
            
            // Filtres avancés (collapsible)
            if (_showAdvancedFilters)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: _buildAdvancedFilters(),
              ),
            
            // Barre d'info et tri
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Nombre de résultats
                  Text(
                    _isLoading 
                        ? 'Recherche...' 
                        : '${_searchResults.length} résultats',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Bouton filtres avancés
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAdvancedFilters = !_showAdvancedFilters;
                      });
                    },
                    icon: Icon(
                      _showAdvancedFilters ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                    ),
                    label: Text('Filtres${_getActiveFilterCount()}'),
                  ),
                  
                  // Tri
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
                    child: Row(
                      children: [
                        const Icon(Icons.sort, size: 18),
                        const SizedBox(width: 4),
                        Text(_getSortLabel()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Résultats
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? _buildEmptyState()
                      : _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAdvancedFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prix
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Prix min',
                  suffixText: '€',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _minPrice = double.tryParse(value);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Prix max',
                  suffixText: '€',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _maxPrice = double.tryParse(value);
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // État
        DropdownButtonFormField<String>(
          value: _condition,
          decoration: const InputDecoration(
            labelText: 'État',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: null, child: Text('Tous')),
            DropdownMenuItem(value: 'new', child: Text('Neuf')),
            DropdownMenuItem(value: 'very_good', child: Text('Très bon état')),
            DropdownMenuItem(value: 'good', child: Text('Bon état')),
            DropdownMenuItem(value: 'acceptable', child: Text('État correct')),
          ],
          onChanged: (value) {
            setState(() {
              _condition = value;
            });
          },
        ),
        
        const SizedBox(height: 16),
        
        // Options
        SwitchListTile(
          title: const Text('Échange possible uniquement'),
          value: _showOnlyExchangeable,
          onChanged: (value) {
            setState(() {
              _showOnlyExchangeable = value;
            });
          },
        ),
        
        const SizedBox(height: 16),
        
        // Bouton appliquer
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _performSearch();
              setState(() {
                _showAdvancedFilters = false;
              });
            },
            child: const Text('Appliquer les filtres'),
          ),
        ),
      ],
    );
  }
  
  Widget _buildResultsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        final categoryId = item['categoryId'] as String?;
        final category = categoryId != null 
            ? CategoriesData.getCategoryById(categoryId) 
            : null;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => context.push('/listing/${item['id']}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Infos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre
                        Text(
                          item['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Catégorie
                        if (category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: category.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  category.icon,
                                  size: 12,
                                  color: category.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  category.displayName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: category.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 8),
                        
                        // Prix et état
                        Row(
                          children: [
                            Text(
                              '${item['price']}€',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            if (item['originalPrice'] != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '${item['originalPrice']}€',
                                style: const TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                            const Spacer(),
                            Text(
                              item['condition'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        
                        // Tags
                        if (item['isExchangeable'] == true)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Échange possible',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
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
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun résultat trouvé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez d\'ajuster vos filtres ou votre recherche',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: _clearAllFilters,
            child: const Text('Réinitialiser la recherche'),
          ),
        ],
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
