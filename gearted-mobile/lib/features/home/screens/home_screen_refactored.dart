import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  // Catégories principales avec icônes cohérentes
  final List<Map<String, dynamic>> _mainCategories = [
    {
      'id': 'replicas',
      'name': 'RÉPLIQUES',
      'icon': Icons.gps_fixed, // Icône de visée/arme tactique
      'color': const Color(0xFF2E2E2E), // Noir tactique
      'gradient': [const Color(0xFF2E2E2E), const Color(0xFF1A1A1A)],
    },
    {
      'id': 'protection',
      'name': 'PROTECTION',
      'icon': Icons.shield,
      'color': const Color(0xFF3E4C3A), // Vert militaire foncé
      'gradient': [const Color(0xFF3E4C3A), const Color(0xFF2A3228)],
    },
    {
      'id': 'equipment',
      'name': 'ÉQUIPEMENT',
      'icon': Icons.backpack,
      'color': const Color(0xFF4A4A4A), // Gris tactique
      'gradient': [const Color(0xFF4A4A4A), const Color(0xFF2D2D2D)],
    },
    {
      'id': 'accessories',
      'name': 'ACCESSOIRES',
      'icon': Icons.build,
      'color': const Color(0xFF5C5C5C), // Gris métallique
      'gradient': [const Color(0xFF5C5C5C), const Color(0xFF3A3A3A)],
    },
    {
      'id': 'tools',
      'name': 'OUTILS ET MAINTENANCE',
      'icon': Icons.handyman,
      'color': const Color(0xFF6B4C57), // Brun tactique
      'gradient': [const Color(0xFF6B4C57), const Color(0xFF4A3640)],
    },
    {
      'id': 'communication',
      'name': 'COMMUNICATION & ÉLECTRONIQUE',
      'icon': Icons.radio,
      'color': const Color(0xFF4A5568), // Gris bleuté
      'gradient': [const Color(0xFF4A5568), const Color(0xFF2D3748)],
    },
  ];

  // Sous-catégories populaires
  final List<Map<String, dynamic>> _popularSubCategories = [
    {
      'id': 'aeg',
      'name': 'AEG',
      'icon': Icons.electric_bolt, // Parfait pour électrique ✅
      'count': '45',
      'color': const Color(0xFFFFB74D), // Orange plus visible
    },
    {
      'id': 'gbb',
      'name': 'GBB',
      'icon': Icons.speed, // Mieux que "air" pour GBB/gaz 🔥
      'count': '32',
      'color': const Color(0xFF81C784), // Vert plus visible
    },
    {
      'id': 'masks',
      'name': 'MASQUES',
      'icon': Icons.masks, // Icône dédiée masques protection ⭐
      'count': '28',
      'color': const Color(0xFF90CAF9), // Bleu plus visible
    },
    {
      'id': 'vests',
      'name': 'GILETS',
      'icon': Icons.security, // Parfait pour gilets tactiques ✅
      'count': '19',
      'color': const Color(0xFFFFF176), // Jaune plus visible
    },
    {
      'id': 'scopes',
      'name': 'OPTIQUES',
      'icon': Icons.center_focus_strong, // Plus précis que zoom_in 🎯
      'count': '52',
      'color': const Color(0xFFCE93D8), // Violet plus visible
    },
    {
      'id': 'parts',
      'name': 'PIÈCES',
      'icon': Icons.precision_manufacturing, // Plus spécifique que settings 🔧
      'count': '67',
      'color': const Color(0xFFFFAB91), // Orange clair plus visible
    },
  ];

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
      }
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await _loadListings();
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Fond noir profond
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: const Color(0xFF8B0000), // Rouge militaire
        child: _isRefreshing
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF8B0000),
                ),
              )
            : CustomScrollView(
                slivers: [
                  // App Bar tactique with always visible logo
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: const Color(0xFF0D0D0D),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    title: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Image.asset(
                        'assets/images/gearted_transparent.png',
                        height: 90,
                        width: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: const EdgeInsets.only(bottom: 20),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF0D0D0D),
                              const Color(0xFF0D0D0D).withValues(alpha: 0.95),
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Pattern militaire subtil
                            Positioned.fill(
                              child: CustomPaint(
                                painter: CamoPatternPainter(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () => context.push('/search'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none,
                            color: Colors.white),
                        onPressed: () => context.push('/notifications'),
                      ),
                    ],
                  ),

                  // Barre de recherche tactique
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: InkWell(
                        onTap: () => context.push('/search'),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.grey),
                              const SizedBox(width: 12),
                              Text(
                                'RECHERCHER ÉQUIPEMENT TACTIQUE...',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontFamily: 'Oswald',
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Catégories principales
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'CATÉGORIES PRINCIPALES',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontFamily: 'Oswald',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _mainCategories.length,
                            itemBuilder: (context, index) {
                              final category = _mainCategories[index];
                              return _buildMainCategoryCard(category);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Sous-catégories populaires
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RECHERCHES POPULAIRES',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontFamily: 'Oswald',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: _popularSubCategories.length,
                            itemBuilder: (context, index) {
                              final subCategory = _popularSubCategories[index];
                              return _buildSubCategoryCard(subCategory);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Section Offres Tactiques
                  if (!_isLoading && _hotDeals.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildTacticalDealsSection(),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Section Nouveautés
                  if (!_isLoading && _recentListings.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildNewArrivalsSection(),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
      ),
    );
  }

  Widget _buildMainCategoryCard(Map<String, dynamic> category) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () => context.push('/search?category=${category['id']}'),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: category['gradient'],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category['icon'],
                color: Colors.white,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                category['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Oswald',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryCard(Map<String, dynamic> subCategory) {
    return InkWell(
      onTap: () => context.push('/search?subcategory=${subCategory['id']}'),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xFF3A3A3A),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              subCategory['icon'],
              color: subCategory['color'],
              size: 32, // Augmenté de 24 à 32
            ),
            const SizedBox(height: 6), // Augmenté de 4 à 6
            Text(
              subCategory['name'],
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Oswald',
                fontSize: 13, // Augmenté de 11 à 13
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              '${subCategory['count']} articles',
              style: TextStyle(
                color: Colors.grey[400], // Plus visible que grey[500]
                fontSize: 11, // Augmenté de 9 à 11
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTacticalDealsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'OFFRES TACTIQUES',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Oswald',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/search?deals=true'),
                child: Row(
                  children: [
                    Text(
                      'VOIR TOUT',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'Oswald',
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward,
                        color: Colors.grey[400], size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _hotDeals.length,
              itemBuilder: (context, index) {
                final deal = _hotDeals[index];
                return _buildDealCard(deal);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewArrivalsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F4F2F),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.new_releases,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'NOUVEAUX ÉQUIPEMENTS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Oswald',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: _recentListings.length > 4 ? 4 : _recentListings.length,
            itemBuilder: (context, index) {
              final listing = _recentListings[index];
              return _buildListingCard(listing);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(Map<String, dynamic> deal) {
    final isFavorite = _favoriteListings.contains(deal['id']);

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: InkWell(
        onTap: () => context.push('/listing/${deal['id']}'),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec badge promo
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.image, color: Colors.grey, size: 40),
                  ),
                  if (deal['originalPrice'] != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B0000),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${(((deal['originalPrice'] - deal['price']) / deal['originalPrice']) * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color:
                            isFavorite ? const Color(0xFF8B0000) : Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {
                        await ListingsService.toggleFavorite(deal['id']);
                        _loadListings();
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Infos produit
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal['title']?.toUpperCase() ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Oswald',
                      letterSpacing: 0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${deal['price']}€',
                        style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Oswald',
                        ),
                      ),
                      if (deal['originalPrice'] != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${deal['originalPrice']}€',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal['condition'] ?? '',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    final isFavorite = _favoriteListings.contains(listing['id']);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: InkWell(
        onTap: () => context.push('/listing/${listing['id']}'),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(Icons.image, color: Colors.grey, size: 40),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? const Color(0xFF8B0000)
                              : Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {
                          await ListingsService.toggleFavorite(listing['id']);
                          _loadListings();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Infos
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing['title']?.toUpperCase() ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Oswald',
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '${listing['price']}€',
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald',
                      ),
                    ),
                    Text(
                      listing['condition'] ?? '',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
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
}

// Painter pour pattern camouflage subtil
class CamoPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..style = PaintingStyle.fill;

    // Créer un pattern subtil
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 3; j++) {
        canvas.drawCircle(
          Offset(i * size.width / 4, j * size.height / 2),
          30,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
