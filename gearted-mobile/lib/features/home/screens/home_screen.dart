import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../widgets/common/gearted_card.dart';
import '../../../widgets/common/animations.dart';
import '../../../widgets/common/category_display_widget.dart';
import '../../../widgets/equipment/equipment_category_widget.dart';
import '../../../services/listings_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _hotDeals = [];
  List<Map<String, dynamic>> _recentListings = [];
  Set<String> _favoriteListings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadListings();
  }

  Future<void> _loadListings() async {
    try {
      final hotDeals = await ListingsService.getHotDeals();
      final recentListings = await ListingsService.getRecentListings();
      final favoriteListings = await ListingsService.getFavoriteListings();

      if (mounted) {
        setState(() {
          _hotDeals = hotDeals;
          _recentListings = recentListings;
          _favoriteListings = favoriteListings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de chargement: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await _loadListings();

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contenu actualisé !'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Enhanced visible logo for app bar
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: GeartedTheme.lightBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  'assets/images/gearted_transparent.png',
                  fit: BoxFit.contain,
                  width: 28,
                  height: 28,
                ),
              ),
            ),
            const Text(
              'Gear',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'ted',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: GeartedTheme.lightBlue,
              ),
            ),
          ],
        ),
        backgroundColor: GeartedTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () => context.push('/favorites'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _isRefreshing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barre de recherche
                    Container(
                      color: GeartedTheme.primaryBlue,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: GestureDetector(
                        onTap: () => context.push('/search'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Rechercher une pièce, une marque...',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Catégories
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: const CategoryDisplayWidget(),
                    ),

                    // Equipment Category Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: const EquipmentCategoryWidget(),
                    ),

                    // Section Hot Deals
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Hot Deals',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  PulseAnimationWidget(
                                    child: Icon(
                                      Icons.local_fire_department,
                                      color: Colors.orange,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => context.push('/search'),
                                child: const Text('Voir tout'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _isLoading
                              ? const SizedBox(
                                  height: 250,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : _hotDeals.isEmpty
                                  ? const SizedBox(
                                      height: 250,
                                      child: Center(
                                        child: Text(
                                          'Aucune offre spéciale pour le moment',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 250,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _hotDeals.length,
                                        itemBuilder: (context, index) {
                                          final item = _hotDeals[index];
                                          final listingId =
                                              item['id'] as String;

                                          return AnimatedListItem(
                                            index: index,
                                            delay: const Duration(
                                                milliseconds: 100),
                                            child: Container(
                                              width: 160,
                                              margin: const EdgeInsets.only(
                                                  right: 12),
                                              child: GeartedItemCard(
                                                title: item['title'] as String,
                                                price: item['price'] as double,
                                                originalPrice:
                                                    item['originalPrice']
                                                        as double?,
                                                condition:
                                                    item['condition'] as String,
                                                rating: (item['rating']
                                                        as double?) ??
                                                    0.0,
                                                onTap: () {
                                                  context.push(
                                                      '/listing/$listingId');
                                                },
                                                onFavoriteToggle: () async {
                                                  try {
                                                    await ListingsService
                                                        .toggleFavorite(
                                                            listingId);
                                                    // Refresh favorites
                                                    final updatedFavorites =
                                                        await ListingsService
                                                            .getFavoriteListings();
                                                    setState(() {
                                                      _favoriteListings =
                                                          updatedFavorites;
                                                    });
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Erreur: ${e.toString()}'),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                },
                                                isFavorite: _favoriteListings
                                                    .contains(listingId),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                        ],
                      ),
                    ),

                    // Section Récemment ajoutés
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Récemment ajoutés',
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
                          _isLoading
                              ? const SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : _recentListings.isEmpty
                                  ? const SizedBox(
                                      height: 300,
                                      child: Center(
                                        child: Text(
                                          'Aucun article récent pour le moment',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.75,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemCount: _recentListings.length > 6
                                          ? 6
                                          : _recentListings.length,
                                      itemBuilder: (context, index) {
                                        final item = _recentListings[index];
                                        final listingId = item['id'] as String;

                                        return AnimatedListItem(
                                          index: index,
                                          delay:
                                              const Duration(milliseconds: 50),
                                          child: GeartedItemCard(
                                            title: item['title'] as String,
                                            price: item['price'] as double,
                                            originalPrice: item['originalPrice']
                                                as double?,
                                            condition:
                                                item['condition'] as String,
                                            rating:
                                                (item['rating'] as double?) ??
                                                    0.0,
                                            onTap: () {
                                              context
                                                  .push('/listing/$listingId');
                                            },
                                            onFavoriteToggle: () async {
                                              try {
                                                await ListingsService
                                                    .toggleFavorite(listingId);
                                                // Refresh favorites
                                                final updatedFavorites =
                                                    await ListingsService
                                                        .getFavoriteListings();
                                                setState(() {
                                                  _favoriteListings =
                                                      updatedFavorites;
                                                });
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Erreur: ${e.toString()}'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            isFavorite: _favoriteListings
                                                .contains(listingId),
                                          ),
                                        );
                                      },
                                    ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Espace pour la nav bar
                  ],
                ),
              ),
      ),
    );
  }
}
