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
  List<String> _recentSearches = [
    'M4A1',
    'Gearbox V2',
    'Red dot',
    'Tactical vest'
  ];
  List<String> _searchResults = [];

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

    // Simulate search with mock data
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isSearching = false;
        _searchResults = [
          'M4A1 Daniel Defense MK18',
          'Gearbox V2 complète SHS',
          'Red dot Aimpoint T1 replica',
          'M4 SOPMOD Block II',
          'Gearbox V3 upgrade',
        ]
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

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
                hintText: 'Rechercher du matériel Airsoft...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults.clear();
                          });
                        },
                      )
                    : null,
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
            const SizedBox(height: 20),

            // Content based on search state
            Expanded(
              child: _isSearching
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _searchResults.isNotEmpty
                      ? _buildSearchResults()
                      : _buildRecentSearches(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recherches récentes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_recentSearches.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune recherche récente',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                final search = _recentSearches[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(search),
                  trailing: IconButton(
                    icon: const Icon(Icons.clear),
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
        Text(
          '${_searchResults.length} résultats trouvés',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];
              return Card(
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image),
                  ),
                  title: Text(result),
                  subtitle: Text('À partir de ${(50 + index * 25)}€'),
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
}
