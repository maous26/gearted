import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  final String? category;

  const SearchScreen({super.key, this.category});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _selectedSort = 'recent';

  // Filtres actifs
  final Set<String> _activeCategories = {};
  RangeValues _priceRange = const RangeValues(0, 1000);
  String? _selectedCondition;
  bool _exchangeOnly = false;

  // Résultats de recherche simulés
  List<Map<String, dynamic>> _searchResults = [];

  // Conditions disponibles
  final List<String> _conditions = [
    'NEUF',
    'COMME NEUF',
    'TRÈS BON ÉTAT',
    'BON ÉTAT',
    'ÉTAT CORRECT',
  ];

  // Options de tri
  final Map<String, String> _sortOptions = {
    'recent': 'PLUS RÉCENT',
    'price_asc': 'PRIX CROISSANT',
    'price_desc': 'PRIX DÉCROISSANT',
    'distance': 'DISTANCE',
  };

  // Catégories de filtrage rapide
  final List<Map<String, dynamic>> _quickFilters = [
    {
      'id': 'replicas',
      'name': 'RÉPLIQUES',
      'icon': Icons.gps_fixed, // Cohérent avec home screen - visée tactique
      'color': const Color(0xFF8B0000),
    },
    {
      'id': 'protection',
      'name': 'PROTECTION',
      'icon': Icons.shield, // Parfait pour protection ✅
      'color': const Color(0xFF2F4F2F),
    },
    {
      'id': 'optics',
      'name': 'OPTIQUES',
      'icon': Icons.center_focus_strong, // Plus précis que zoom_in 🎯
      'color': const Color(0xFF4A4A4A),
    },
    {
      'id': 'tactical',
      'name': 'TACTIQUE',
      'icon': Icons.backpack, // Parfait pour équipement tactique ✅
      'color': const Color(0xFF5C5C5C),
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      print('SearchScreen: Received category parameter: ${widget.category}');
      _searchController.text = widget.category!;
      _performSearch();
    }
  }

  void _performSearch() {
    setState(() {
      _isSearching = true;
    });

    // Simulation de recherche avec résultats basés sur la catégorie
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _searchResults = _generateMockResults();
        _isSearching = false;
      });
    });
  }

  List<Map<String, dynamic>> _generateMockResults() {
    String query = _searchController.text.toLowerCase();
    print('SearchScreen: Generating results for query: "$query"');

    // Résultats spécifiques pour les offres tactiques/deals
    if (query.contains('deals') || query.contains('offres')) {
      print(
          'SearchScreen: Detected deals/offres query - returning special deals results');
      return [
        {
          'id': '1',
          'title': 'M4A1 SOPMOD BLOCK II',
          'price': 280,
          'originalPrice': 380,
          'condition': 'TRÈS BON ÉTAT',
          'seller': 'TACTICOOL_FR',
          'distance': '5 km',
          'category': 'replicas',
          'exchangeable': true,
        },
        {
          'id': '2',
          'title': 'GILET JPC 2.0 TACTICAL',
          'price': 120,
          'originalPrice': 180,
          'condition': 'COMME NEUF',
          'seller': 'TACTICAL_STORE',
          'distance': '3 km',
          'category': 'tactical',
          'exchangeable': false,
        },
        {
          'id': '3',
          'title': 'EOTECH 553 REPLICA',
          'price': 65,
          'originalPrice': 95,
          'condition': 'BON ÉTAT',
          'seller': 'OPTIC_PRO',
          'distance': '8 km',
          'category': 'optics',
          'exchangeable': true,
        },
        {
          'id': '4',
          'title': 'AK-74M TACTICAL EDITION',
          'price': 250,
          'originalPrice': 320,
          'condition': 'BON ÉTAT',
          'seller': 'AIRSOFT_PRO',
          'distance': '8 km',
          'category': 'replicas',
          'exchangeable': false,
        },
        {
          'id': '5',
          'title': 'CASQUE FAST MARITIME',
          'price': 85,
          'originalPrice': 120,
          'condition': 'NEUF',
          'seller': 'GEAR_MASTER',
          'distance': '12 km',
          'category': 'protection',
          'exchangeable': false,
        },
      ];
    }

    // Résultats spécifiques par catégorie
    if (query.contains('replicas') || query.contains('répliques')) {
      return [
        {
          'id': '1',
          'title': 'M4A1 SOPMOD BLOCK II',
          'price': 380,
          'originalPrice': 450,
          'condition': 'TRÈS BON ÉTAT',
          'seller': 'TACTICOOL_FR',
          'distance': '5 km',
          'category': 'replicas',
          'exchangeable': true,
        },
        {
          'id': '2',
          'title': 'AK-74M TACTICAL EDITION',
          'price': 320,
          'originalPrice': 400,
          'condition': 'BON ÉTAT',
          'seller': 'AIRSOFT_PRO',
          'distance': '8 km',
          'category': 'replicas',
          'exchangeable': false,
        },
        {
          'id': '3',
          'title': 'GLOCK 17 GBB RÉALISTE',
          'price': 180,
          'condition': 'COMME NEUF',
          'seller': 'SIDEARM_SPECIALIST',
          'distance': '3 km',
          'category': 'replicas',
          'exchangeable': true,
        },
      ];
    }

    if (query.contains('aeg')) {
      return [
        {
          'id': '1',
          'title': 'M4A1 SOPMOD BLOCK II',
          'price': 380,
          'originalPrice': 450,
          'condition': 'TRÈS BON ÉTAT',
          'seller': 'TACTICOOL_FR',
          'distance': '5 km',
          'category': 'replicas',
          'exchangeable': true,
        },
        {
          'id': '4',
          'title': 'HK416 ELITE SERIES',
          'price': 420,
          'condition': 'NEUF',
          'seller': 'PREMIUM_GEAR',
          'distance': '12 km',
          'category': 'replicas',
          'exchangeable': false,
        },
      ];
    }

    if (query.contains('masks') || query.contains('masques')) {
      return [
        {
          'id': '5',
          'title': 'MASQUE PRO-TEC ACH',
          'price': 95,
          'condition': 'TRÈS BON ÉTAT',
          'seller': 'PROTECTION_PLUS',
          'distance': '6 km',
          'category': 'protection',
          'exchangeable': false,
        },
        {
          'id': '6',
          'title': 'CASQUE FAST MARITIME',
          'price': 120,
          'condition': 'NEUF',
          'seller': 'GEAR_MASTER',
          'distance': '12 km',
          'category': 'protection',
          'exchangeable': false,
        },
      ];
    }

    if (query.contains('scopes') || query.contains('optiques')) {
      return [
        {
          'id': '7',
          'title': 'EOTECH 553 REPLICA',
          'price': 85,
          'originalPrice': 110,
          'condition': 'BON ÉTAT',
          'seller': 'OPTIC_PRO',
          'distance': '8 km',
          'category': 'optics',
          'exchangeable': true,
        },
        {
          'id': '8',
          'title': 'RED DOT AIMPOINT T1',
          'price': 65,
          'condition': 'COMME NEUF',
          'seller': 'SIGHT_SOLUTIONS',
          'distance': '4 km',
          'category': 'optics',
          'exchangeable': false,
        },
      ];
    }

    if (query.contains('vests') || query.contains('gilets')) {
      return [
        {
          'id': '9',
          'title': 'GILET JPC 2.0',
          'price': 150,
          'condition': 'COMME NEUF',
          'seller': 'TACTICAL_STORE',
          'distance': '3 km',
          'category': 'tactical',
          'exchangeable': false,
        },
        {
          'id': '10',
          'title': 'CHEST RIG MODULAIRE',
          'price': 85,
          'condition': 'BON ÉTAT',
          'seller': 'GEAR_FACTORY',
          'distance': '7 km',
          'category': 'tactical',
          'exchangeable': true,
        },
      ];
    }

    if (query.contains('parts') || query.contains('pièces')) {
      return [
        {
          'id': '11',
          'title': 'GEARBOX V2 COMPLÈTE SHS',
          'price': 120,
          'condition': 'NEUF',
          'seller': 'MECHANIC_PRO',
          'distance': '5 km',
          'category': 'parts',
          'exchangeable': false,
        },
        {
          'id': '12',
          'title': 'MOTEUR HIGH TORQUE',
          'price': 45,
          'condition': 'TRÈS BON ÉTAT',
          'seller': 'UPGRADE_SPECIALIST',
          'distance': '10 km',
          'category': 'parts',
          'exchangeable': true,
        },
      ];
    }

    if (query.contains('gbb')) {
      return [
        {
          'id': '13',
          'title': 'GLOCK 17 GBB RÉALISTE',
          'price': 180,
          'condition': 'COMME NEUF',
          'seller': 'SIDEARM_SPECIALIST',
          'distance': '3 km',
          'category': 'replicas',
          'exchangeable': true,
        },
        {
          'id': '14',
          'title': 'P226 NAVY SEAL',
          'price': 165,
          'condition': 'BON ÉTAT',
          'seller': 'PISTOL_PRO',
          'distance': '6 km',
          'category': 'replicas',
          'exchangeable': false,
        },
      ];
    }

    // Gestion des catégories principales
    if (query.contains('protection')) {
      return [
        {
          'id': '5',
          'title': 'MASQUE PRO-TEC ACH',
          'price': 95,
          'condition': 'TRÈS BON ÉTAT',
          'seller': 'PROTECTION_PLUS',
          'distance': '6 km',
          'category': 'protection',
          'exchangeable': false,
        },
        {
          'id': '6',
          'title': 'CASQUE FAST MARITIME',
          'price': 120,
          'condition': 'NEUF',
          'seller': 'GEAR_MASTER',
          'distance': '12 km',
          'category': 'protection',
          'exchangeable': false,
        },
      ];
    }

    if (query.contains('equipment') || query.contains('équipement')) {
      return [
        {
          'id': '15',
          'title': 'SAC À DOS TACTICAL',
          'price': 75,
          'condition': 'BON ÉTAT',
          'seller': 'OUTDOOR_GEAR',
          'distance': '4 km',
          'category': 'equipment',
          'exchangeable': true,
        },
        {
          'id': '16',
          'title': 'HOLSTER KYDEX',
          'price': 35,
          'condition': 'NEUF',
          'seller': 'HOLSTER_FACTORY',
          'distance': '8 km',
          'category': 'equipment',
          'exchangeable': false,
        },
      ];
    }

    if (query.contains('accessories') || query.contains('accessoires')) {
      return [
        {
          'id': '17',
          'title': 'POIGNÉE VERTICALE',
          'price': 25,
          'condition': 'COMME NEUF',
          'seller': 'ACCESSORY_SHOP',
          'distance': '2 km',
          'category': 'accessories',
          'exchangeable': false,
        },
        {
          'id': '18',
          'title': 'SILENCIEUX FOAM',
          'price': 40,
          'condition': 'BON ÉTAT',
          'seller': 'STEALTH_GEAR',
          'distance': '9 km',
          'category': 'accessories',
          'exchangeable': true,
        },
      ];
    }

    // Résultats par défaut (tous les types)
    return [
      {
        'id': '1',
        'title': 'M4A1 SOPMOD BLOCK II',
        'price': 380,
        'originalPrice': 450,
        'condition': 'TRÈS BON ÉTAT',
        'seller': 'TACTICOOL_FR',
        'distance': '5 km',
        'category': 'replicas',
        'exchangeable': true,
      },
      {
        'id': '2',
        'title': 'CASQUE FAST MARITIME',
        'price': 120,
        'condition': 'NEUF',
        'seller': 'GEAR_MASTER',
        'distance': '12 km',
        'category': 'protection',
        'exchangeable': false,
      },
      {
        'id': '3',
        'title': 'EOTECH 553 REPLICA',
        'price': 85,
        'originalPrice': 110,
        'condition': 'BON ÉTAT',
        'seller': 'OPTIC_PRO',
        'distance': '8 km',
        'category': 'optics',
        'exchangeable': true,
      },
      {
        'id': '4',
        'title': 'GILET JPC 2.0',
        'price': 150,
        'condition': 'COMME NEUF',
        'seller': 'TACTICAL_STORE',
        'distance': '3 km',
        'category': 'tactical',
        'exchangeable': false,
      },
      {
        'id': '5',
        'title': 'AK-74M TACTICAL EDITION',
        'price': 320,
        'originalPrice': 400,
        'condition': 'BON ÉTAT',
        'seller': 'AIRSOFT_PRO',
        'distance': '8 km',
        'category': 'replicas',
        'exchangeable': false,
      },
      {
        'id': '6',
        'title': 'GEARBOX V2 COMPLÈTE SHS',
        'price': 120,
        'condition': 'NEUF',
        'seller': 'MECHANIC_PRO',
        'distance': '5 km',
        'category': 'parts',
        'exchangeable': false,
      },
      {
        'id': '7',
        'title': 'MASQUE PRO-TEC ACH',
        'price': 95,
        'condition': 'TRÈS BON ÉTAT',
        'seller': 'PROTECTION_PLUS',
        'distance': '6 km',
        'category': 'protection',
        'exchangeable': false,
      },
      {
        'id': '8',
        'title': 'GLOCK 17 GBB RÉALISTE',
        'price': 180,
        'condition': 'COMME NEUF',
        'seller': 'SIDEARM_SPECIALIST',
        'distance': '3 km',
        'category': 'replicas',
        'exchangeable': true,
      },
      {
        'id': '9',
        'title': 'SAC À DOS TACTICAL',
        'price': 75,
        'condition': 'BON ÉTAT',
        'seller': 'OUTDOOR_GEAR',
        'distance': '4 km',
        'category': 'equipment',
        'exchangeable': true,
      },
      {
        'id': '10',
        'title': 'RED DOT AIMPOINT T1',
        'price': 65,
        'condition': 'COMME NEUF',
        'seller': 'SIGHT_SOLUTIONS',
        'distance': '4 km',
        'category': 'optics',
        'exchangeable': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec barre de recherche
            Container(
              color: const Color(0xFF0D0D0D),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Ligne du haut
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF3A3A3A)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Oswald',
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'RECHERCHER...',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: 'Oswald',
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Colors.grey, size: 20),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchResults.clear();
                                        });
                                      },
                                    )
                                  : null,
                            ),
                            onSubmitted: (_) => _performSearch(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.search, color: Color(0xFF8B0000)),
                        onPressed: _performSearch,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Filtres rapides
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _quickFilters.length,
                      itemBuilder: (context, index) {
                        final filter = _quickFilters[index];
                        final isActive =
                            _activeCategories.contains(filter['id']);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  filter['icon'],
                                  size: 16,
                                  color:
                                      isActive ? Colors.white : filter['color'],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  filter['name'],
                                  style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? Colors.white
                                        : filter['color'],
                                  ),
                                ),
                              ],
                            ),
                            selected: isActive,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _activeCategories.add(filter['id']);
                                } else {
                                  _activeCategories.remove(filter['id']);
                                }
                              });
                              _performSearch();
                            },
                            backgroundColor: const Color(0xFF2A2A2A),
                            selectedColor: filter['color'],
                            side: BorderSide(
                              color: isActive
                                  ? filter['color']
                                  : const Color(0xFF3A3A3A),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Barre de filtres et tri
            Container(
              color: const Color(0xFF0D0D0D),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Bouton filtres avancés
                  OutlinedButton.icon(
                    onPressed: _showAdvancedFilters,
                    icon: const Icon(Icons.tune, size: 16),
                    label: Text(
                      'FILTRES',
                      style: const TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF3A3A3A)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                  ),

                  const Spacer(),

                  // Dropdown de tri
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF3A3A3A)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedSort,
                      isDense: true,
                      underline: const SizedBox(),
                      dropdownColor: const Color(0xFF2A2A2A),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Oswald',
                        fontSize: 12,
                      ),
                      icon:
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      items: _sortOptions.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSort = value!;
                        });
                        _performSearch();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Résultats
            Expanded(
              child: _isSearching
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF8B0000),
                      ),
                    )
                  : _searchResults.isEmpty
                      ? _buildEmptyState()
                      : _buildResultsList(),
            ),
          ],
        ),
      ),
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
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          Text(
            'AUCUN RÉSULTAT',
            style: TextStyle(
              color: Colors.grey[500],
              fontFamily: 'Oswald',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ESSAYEZ AVEC D\'AUTRES CRITÈRES',
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: 'Oswald',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return _buildResultItem(item);
      },
    );
  }

  Widget _buildResultItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: InkWell(
        onTap: () => context.push('/listing/${item['id']}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.image, color: Colors.grey, size: 40),
              ),

              const SizedBox(width: 12),

              // Infos produit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      item['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Oswald',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Prix
                    Row(
                      children: [
                        Text(
                          '${item['price']}€',
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Oswald',
                          ),
                        ),
                        if (item['originalPrice'] != null) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${item['originalPrice']}€',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B0000),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-${(((item['originalPrice'] - item['price']) / item['originalPrice']) * 100).round()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Infos vendeur et condition
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey[600], size: 14),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item['seller'],
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              fontFamily: 'Oswald',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.location_on,
                            color: Colors.grey[600], size: 14),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item['distance'],
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Tags
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3A3A3A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['condition'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontFamily: 'Oswald',
                            ),
                          ),
                        ),
                        if (item['exchangeable']) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2F4F2F),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.swap_horiz,
                                    color: Colors.white, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  'ÉCHANGE',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Oswald',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Bouton favori
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.grey),
                onPressed: () {
                  // Toggle favorite
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        'FILTRES AVANCÉS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Oswald',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Prix
                          Text(
                            'FOURCHETTE DE PRIX',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'Oswald',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RangeSlider(
                            values: _priceRange,
                            min: 0,
                            max: 1000,
                            divisions: 20,
                            activeColor: const Color(0xFF8B0000),
                            inactiveColor: const Color(0xFF3A3A3A),
                            labels: RangeLabels(
                              '${_priceRange.start.round()}€',
                              '${_priceRange.end.round()}€',
                            ),
                            onChanged: (values) {
                              setModalState(() {
                                _priceRange = values;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_priceRange.start.round()}€',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                                Text(
                                  '${_priceRange.end.round()}€',
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // État
                          Text(
                            'ÉTAT',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'Oswald',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _conditions.map((condition) {
                              final isSelected =
                                  _selectedCondition == condition;
                              return ChoiceChip(
                                label: Text(
                                  condition,
                                  style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[400],
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setModalState(() {
                                    _selectedCondition =
                                        selected ? condition : null;
                                  });
                                },
                                backgroundColor: const Color(0xFF2A2A2A),
                                selectedColor: const Color(0xFF2F4F2F),
                                side: BorderSide(
                                  color: isSelected
                                      ? const Color(0xFF2F4F2F)
                                      : const Color(0xFF3A3A3A),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 32),

                          // Échange possible
                          SwitchListTile(
                            title: Text(
                              'ÉCHANGE POSSIBLE UNIQUEMENT',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontFamily: 'Oswald',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            value: _exchangeOnly,
                            onChanged: (value) {
                              setModalState(() {
                                _exchangeOnly = value;
                              });
                            },
                            activeColor: const Color(0xFF8B0000),
                            inactiveTrackColor: const Color(0xFF3A3A3A),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Boutons d'action
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _priceRange = const RangeValues(0, 1000);
                              _selectedCondition = null;
                              _exchangeOnly = false;
                            });
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[400],
                            side: BorderSide(color: Colors.grey[600]!),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'RÉINITIALISER',
                            style: const TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _performSearch();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B0000),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'APPLIQUER',
                            style: const TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
