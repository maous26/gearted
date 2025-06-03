import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/airsoft_category.dart';
import '../../../services/category_service.dart';

class SearchScreenRefactored extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialQuery;
  final AirsoftCategoryType? initialType;

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
  List<AirsoftCategory> _selectedCategories = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

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

    if (_selectedCategories
        .any((c) => c.type == AirsoftCategoryType.protection)) {
      mockResults.addAll([
        {
          'id': '1',
          'title': 'Masque de protection Dye i5',
          'price': 180,
          'originalPrice': 220,
          'condition': 'Très bon état',
          'categoryId': 'protection',
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

    if (_selectedCategories
        .any((c) => c.type == AirsoftCategoryType.replicas)) {
      mockResults.addAll([
        {
          'id': '3',
          'title': 'M4A1 AEG G&G CM16',
          'price': 280,
          'condition': 'Neuf',
          'categoryId': 'replicas',
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
      mockResults =
          mockResults.where((item) => item['price'] >= _minPrice!).toList();
    }
    if (_maxPrice != null) {
      mockResults =
          mockResults.where((item) => item['price'] <= _maxPrice!).toList();
    }

    // Filtrer par condition si spécifiée
    if (_condition != null) {
      mockResults = mockResults
          .where((item) =>
              item['condition']
                  ?.toLowerCase()
                  .contains(_condition!.toLowerCase()) ??
              false)
          .toList();
    }

    // Filtrer par échange si activé
    if (_showOnlyExchangeable) {
      mockResults =
          mockResults.where((item) => item['isExchangeable'] == true).toList();
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

    return mockResults;
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
            // Header modernisé
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: Colors.grey.shade700, size: 24),
                          onPressed: () => context.go('/home'),
                          tooltip: 'Retour',
                        ),
                        Text(
                          'Recherche',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Oswald',
                            letterSpacing: 1.2,
                            color: Color(0xFF424242),
                          ),
                        ),
                        const Spacer(),
                        if (_hasActiveFilters())
                          TextButton.icon(
                            onPressed: _clearAllFilters,
                            icon: const Icon(Icons.clear,
                                size: 18, color: Colors.red),
                            label: const Text('Effacer tout',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                  ),
                  // Barre de recherche intelligente
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: TextEditingController(text: _searchQuery),
                      onChanged: _onQueryChanged,
                      style: const TextStyle(
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Rechercher équipement, réplique…',
                        hintStyle: const TextStyle(
                            color: Colors.green,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w500),
                        prefixIcon:
                            Icon(Icons.search, color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    setState(() => _searchQuery = ''),
                                tooltip: 'Effacer',
                              )
                            : null,
                      ),
                    ),
                  ),
                  // Barre de filtres horizontale
                  if (_selectedCategories.isNotEmpty || _hasActiveFilters())
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          ..._selectedCategories.map((cat) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(cat.name,
                                      style: const TextStyle(
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w500)),
                                  avatar: Icon(cat.icon,
                                      size: 18, color: cat.color),
                                  selected: true,
                                  onSelected: (_) => setState(
                                      () => _selectedCategories.remove(cat)),
                                  selectedColor: cat.color.withOpacity(0.8),
                                  backgroundColor: cat.color.withOpacity(0.15),
                                  labelStyle: TextStyle(color: cat.color),
                                ),
                              )),
                          if (_minPrice != null || _maxPrice != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text('Prix',
                                    style: const TextStyle(
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w500)),
                                avatar: const Icon(Icons.euro,
                                    size: 18, color: Colors.black),
                                selected: true,
                                onSelected: (_) => setState(() {
                                  _minPrice = null;
                                  _maxPrice = null;
                                }),
                                selectedColor: Colors.black.withOpacity(0.8),
                                backgroundColor: Colors.black.withOpacity(0.15),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                              ),
                            ),
                          if (_condition != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(_condition!,
                                    style: const TextStyle(
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w500)),
                                avatar: const Icon(Icons.verified,
                                    size: 18, color: Colors.orange),
                                selected: true,
                                onSelected: (_) =>
                                    setState(() => _condition = null),
                                selectedColor: Colors.orange.withOpacity(0.8),
                                backgroundColor:
                                    Colors.orange.withOpacity(0.15),
                                labelStyle:
                                    const TextStyle(color: Colors.orange),
                              ),
                            ),
                          if (_showOnlyExchangeable)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: const Text('Échange possible',
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w500)),
                                avatar: const Icon(Icons.swap_horiz,
                                    size: 18, color: Colors.blue),
                                selected: true,
                                onSelected: (_) => setState(
                                    () => _showOnlyExchangeable = false),
                                selectedColor: Colors.blue.withOpacity(0.8),
                                backgroundColor: Colors.blue.withOpacity(0.15),
                                labelStyle: const TextStyle(color: Colors.blue),
                              ),
                            ),
                        ],
                      ),
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
                      _showAdvancedFilters
                          ? Icons.expand_less
                          : Icons.expand_more,
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
                  ? _buildSkeletonLoading()
                  : _searchResults.isEmpty
                      ? _buildEmptyState()
                      : Column(
                          children: [
                            // Section Pack Économique (apparaît seulement avec des résultats)
                            if (_searchResults.isNotEmpty &&
                                _searchResults.length > 2)
                              _buildEconomicPackBanner(),

                            // Grille des résultats
                            Expanded(child: _buildResultsList()),

                            // Section cross-selling en bas
                            if (_searchResults.isNotEmpty)
                              _buildCrossSellingSection(),
                          ],
                        ),
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
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65, // Cartes plus hautes pour plus d'infos
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        final categoryId = item['categoryId'] as String?;
        final category = categoryId != null
            ? CategoryService.getCategoryById(categoryId)
            : null;

        return _buildProductCard(item, category);
      },
    );
  }

  Widget _buildProductCard(
      Map<String, dynamic> item, AirsoftCategory? category) {
    final isNew = item['condition'] == 'Neuf';
    final isExchangeable = item['isExchangeable'] == true;
    final hasDiscount = item['originalPrice'] != null;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/listing/${item['id']}'),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec badges
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
                    child:
                        const Icon(Icons.image, size: 48, color: Colors.grey),
                  ),

                  // Badge état (Neuf/Occasion)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: isNew ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        isNew ? 'NEUF' : 'OCCASION',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Oswald',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  // Badge réduction
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          '-${(((item['originalPrice'] - item['price']) / item['originalPrice']) * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),
                    ),

                  // Badge échange
                  if (isExchangeable)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.swap_horiz,
                                size: 12, color: Colors.white),
                            SizedBox(width: 2),
                            Text(
                              'ÉCHANGE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Contenu de la carte
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      item['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Oswald',
                        letterSpacing: 0.3,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Catégorie
                    if (category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: category.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: category.color.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              category.icon,
                              size: 10,
                              color: category.color,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 9,
                                color: category.color,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ],
                        ),
                      ),

                    const Spacer(),

                    // Prix
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

                    const SizedBox(height: 8),

                    // Vendeur info et distance (simulées)
                    Row(
                      children: [
                        const Icon(Icons.verified_user,
                            size: 12, color: Colors.green),
                        const SizedBox(width: 4),
                        const Text(
                          'Vendeur vérifié',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.location_on,
                            size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        const Text(
                          '5km',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Bouton contact
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action contact vendeur
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Redirection vers le chat...'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade700,
                          elevation: 0,
                          side:
                              BorderSide(color: Colors.blue.shade700, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                        child: const Text(
                          'Contacter',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Oswald',
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // Icône principale
          Container(
            padding: const EdgeInsets.all(24),
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

          // Titre principal
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

          // Sous-titre
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

          // Suggestions rapides
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SUGGESTIONS TACTIQUES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Oswald',
                    letterSpacing: 1,
                    color: Color(0xFF424242),
                  ),
                ),
                const SizedBox(height: 16),

                // Suggestions de recherche populaires
                _buildSuggestionChip('M4A1', Icons.sports_motorsports),
                const SizedBox(height: 8),
                _buildSuggestionChip('Masque protection', Icons.security),
                const SizedBox(height: 8),
                _buildSuggestionChip('Gilet tactique', Icons.shield),
                const SizedBox(height: 8),
                _buildSuggestionChip('Pistolet GBB', Icons.sports_handball),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearAllFilters,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text(
                    'Réinitialiser',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Ouvrir les filtres avancés
                    setState(() {
                      _showAdvancedFilters = true;
                    });
                  },
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text(
                    'Filtres',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.blue.shade600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Section trending (simulée)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.shade50,
                  Colors.red.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up,
                        color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'TENDANCES DU MOMENT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Oswald',
                        letterSpacing: 0.8,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '• Nouveaux masques Dye i5 2024\n'
                  '• Répliques Tokyo Marui en promo\n'
                  '• Packs débutant complets -30%',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          _searchQuery = text;
        });
        _performSearch();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(Icons.search, size: 16, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: 6, // Afficher 6 squelettes
      itemBuilder: (context, index) {
        return _buildSkeletonCard();
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
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
              child: Stack(
                children: [
                  // Effet shimmer
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey.shade300,
                            Colors.grey.shade200,
                            Colors.grey.shade300,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // Skeleton badges
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 40,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenu skeleton
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre skeleton
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
                    width: 120,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Catégorie skeleton
                  Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),

                  const Spacer(),

                  // Prix skeleton
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Info vendeur skeleton
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 70,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 30,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Bouton skeleton
                  Container(
                    width: double.infinity,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
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

  Widget _buildEconomicPackBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade600,
            Colors.red.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PACK ÉCONOMIQUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Oswald',
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Combinez plusieurs articles et économisez jusqu\'à 25%',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'VOIR',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                fontFamily: 'Oswald',
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrossSellingSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'ARTICLES SIMILAIRES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Oswald',
                    letterSpacing: 1,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Navigation vers plus d'articles similaires
                  },
                  child: const Text(
                    'Voir tout',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Liste horizontale d'articles similaires (simulés)
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.image,
                                size: 32, color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Article ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Oswald',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Text(
                                  '${(50 + index * 20)}€',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Oswald',
                                    color: Colors.green,
                                  ),
                                ),
                              ],
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

          const SizedBox(height: 16),
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
