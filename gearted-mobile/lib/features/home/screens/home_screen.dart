import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue.shade600, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                  'assets/images/gearted_transparent.png',
                  fit: BoxFit.contain,
                  width: 32,
                  height: 32,
                ),
              ),
            ),
            Text(
              'GEAR',
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: 2,
                color: Colors.grey.shade800,
              ),
            ),
            Text(
              'TED',
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.w900,
                color: Colors.blue.shade600,
                fontSize: 22,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.military_tech,
                color: Colors.blue.shade600, size: 28),
            onPressed: () => context.push('/notifications'),
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: Icon(Icons.shield, color: Colors.red.shade600, size: 28),
            onPressed: () => context.push('/favorites'),
            tooltip: 'Favoris',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade50, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: _isRefreshing
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SEARCH BAR
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: GestureDetector(
                          onTap: () => context.push('/search'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search,
                                    color: Colors.grey.shade600, size: 22),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'RECHERCHER UNE PIÈCE, UNE MARQUE...',
                                    style: GoogleFonts.oswald(
                                      color: Colors.grey.shade600,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // CATEGORIES
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: const CategoryDisplayWidget(),
                      ),
                      // EQUIPMENT CATEGORIES
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: const EquipmentCategoryWidget(),
                      ),
                      // HOT DEALS SECTION
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.local_fire_department,
                                    color: GeartedTheme.battleRed, size: 36),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: GeartedTheme.battleRed,
                                        width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: GeartedTheme.battleRed
                                            .withOpacity(0.18),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.chevron_right,
                                          color: GeartedTheme.victoryGold,
                                          size: 22),
                                      Text(
                                        'HOT DEALS',
                                        style: GoogleFonts.oswald(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          letterSpacing: 2.5,
                                          color: GeartedTheme.battleRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'OFFRES DE COMBAT LIMITÉES',
                              style: GoogleFonts.oswald(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: GeartedTheme.tacticalGray,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _isLoading
                                      ? const SizedBox(
                                          height: 250,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : _hotDeals.isEmpty
                                          ? Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: GeartedTheme.tacticalGray
                                                    .withOpacity(0.12),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: GeartedTheme
                                                      .tacticalGray
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.military_tech,
                                                        size: 48,
                                                        color: GeartedTheme
                                                            .tacticalGray),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      'AUCUNE OFFRE DE COMBAT\nPOUR LE MOMENT',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.oswald(
                                                        color: GeartedTheme
                                                            .tacticalGray,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 1.2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 250,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 12),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius: 4,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: GeartedItemCard(
                                                        title: (item['title']
                                                                as String)
                                                            .toUpperCase(),
                                                        price: item['price']
                                                            as double,
                                                        originalPrice: item[
                                                                'originalPrice']
                                                            as double?,
                                                        condition:
                                                            (item['condition']
                                                                    as String)
                                                                .toUpperCase(),
                                                        rating: (item['rating']
                                                                as double?) ??
                                                            0.0,
                                                        onTap: () {
                                                          context.push(
                                                              '/listing/$listingId');
                                                        },
                                                        onFavoriteToggle:
                                                            () async {
                                                          try {
                                                            await ListingsService
                                                                .toggleFavorite(
                                                                    listingId);
                                                            final updatedFavorites =
                                                                await ListingsService
                                                                    .getFavoriteListings();
                                                            setState(() {
                                                              _favoriteListings =
                                                                  updatedFavorites;
                                                            });
                                                          } catch (e) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    'Erreur: \\${e.toString()}'),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        isFavorite:
                                                            _favoriteListings
                                                                .contains(
                                                                    listingId),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // AJOUTS RECENTS SECTION
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.new_releases,
                                    color: GeartedTheme.combatGreen, size: 36),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: GeartedTheme.combatGreen,
                                        width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: GeartedTheme.combatGreen
                                            .withOpacity(0.18),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.chevron_right,
                                          color: GeartedTheme.steelBlue,
                                          size: 22),
                                      Text(
                                        'AJOUTS RÉCENTS',
                                        style: GoogleFonts.oswald(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          letterSpacing: 2.5,
                                          color: GeartedTheme.combatGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'NOUVEAU MATÉRIEL DE TERRAIN',
                              style: GoogleFonts.oswald(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: GeartedTheme.tacticalGray,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _isLoading
                                      ? const SizedBox(
                                          height: 300,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : _recentListings.isEmpty
                                          ? Container(
                                              height: 250,
                                              decoration: BoxDecoration(
                                                color: GeartedTheme.tacticalGray
                                                    .withOpacity(0.12),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: GeartedTheme
                                                      .tacticalGray
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.inventory_2,
                                                        size: 48,
                                                        color: GeartedTheme
                                                            .tacticalGray),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      'AUCUN NOUVEL ÉQUIPEMENT\nPOUR LE MOMENT',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.oswald(
                                                        color: GeartedTheme
                                                            .tacticalGray,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 1.2,
                                                      ),
                                                    ),
                                                  ],
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
                                              itemCount:
                                                  _recentListings.length > 6
                                                      ? 6
                                                      : _recentListings.length,
                                              itemBuilder: (context, index) {
                                                final item =
                                                    _recentListings[index];
                                                final listingId =
                                                    item['id'] as String;
                                                return AnimatedListItem(
                                                  index: index,
                                                  delay: const Duration(
                                                      milliseconds: 50),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.1),
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: GeartedItemCard(
                                                      title: (item['title']
                                                              as String)
                                                          .toUpperCase(),
                                                      price: item['price']
                                                          as double,
                                                      originalPrice:
                                                          item['originalPrice']
                                                              as double?,
                                                      condition:
                                                          (item['condition']
                                                                  as String)
                                                              .toUpperCase(),
                                                      rating: (item['rating']
                                                              as double?) ??
                                                          0.0,
                                                      onTap: () {
                                                        context.push(
                                                            '/listing/$listingId');
                                                      },
                                                      onFavoriteToggle:
                                                          () async {
                                                        try {
                                                          await ListingsService
                                                              .toggleFavorite(
                                                                  listingId);
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
                                                                  'Erreur: \\${e.toString()}'),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      isFavorite:
                                                          _favoriteListings
                                                              .contains(
                                                                  listingId),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
