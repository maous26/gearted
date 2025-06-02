import 'package:flutter/material.dart';
import '../../../services/user_service.dart';
import '../../../services/listings_service.dart';

class ListingDetailScreen extends StatefulWidget {
  final String listingId;

  const ListingDetailScreen({
    super.key,
    required this.listingId,
  });

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _sellerInfo;
  Map<String, dynamic>? _listingData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadListingData();
  }

  Future<void> _loadListingData() async {
    try {
      // Load listing data from service
      final listingData =
          await ListingsService.getListingById(widget.listingId);

      // Load seller info
      final sellerInfo = await _userService.getSellerInfo();

      if (mounted) {
        setState(() {
          _listingData = listingData;
          _sellerInfo = sellerInfo;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Error loading listing data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du chargement de l\'annonce'),
          ),
        );
      }
    }
  }

  Map<String, dynamic> _getDefaultSellerInfo() {
    return _sellerInfo ??
        {
          'name': 'Vendeur inconnu',
          'avatar': 'V',
          'rating': 0.0,
          'reviews': 0,
          'memberSince': '2024',
          'isOnline': false,
        };
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state while data is being fetched
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détail de l\'annonce'),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Handle case when listing is not found
    if (_listingData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détail de l\'annonce'),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        ),
        body: const Center(
          child: Text(
            'Annonce non trouvée',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    // Use real listing data
    final listingData = _listingData!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail de l\'annonce'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ajouté aux favoris')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Partage de l\'annonce')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image gallery
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 64,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and condition
                  Text(
                    listingData['title'] ?? 'Titre non disponible',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      listingData['condition'] ?? 'Condition non spécifiée',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    children: [
                      Text(
                        '${listingData['price'] ?? 0} €',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (listingData['isNegotiable'] == true)
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Négociable',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Item details
                  _buildDetailSection('Détails', [
                    {
                      'label': 'Catégorie',
                      'value': listingData['category'] ?? 'Non spécifiée'
                    },
                    {
                      'label': 'Marque',
                      'value': listingData['brand'] ?? 'Non spécifiée'
                    },
                    {
                      'label': 'Publié le',
                      'value': listingData['publishedDate'] ?? 'Date inconnue'
                    },
                    {
                      'label': 'Localisation',
                      'value': listingData['location'] ?? 'Non spécifiée'
                    },
                  ]),
                  const SizedBox(height: 24),

                  // Description
                  _buildDetailSection('Description', null),
                  const SizedBox(height: 8),
                  Text(
                    listingData['description'] ??
                        'Aucune description disponible',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Seller info
                  _buildSellerSection(
                      listingData['seller'] ?? _getDefaultSellerInfo()),
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ouverture de la conversation')),
                  );
                },
                icon: const Icon(Icons.message),
                label: const Text('Contacter'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showOfferDialog(context);
                },
                icon: const Icon(Icons.local_offer),
                label: const Text('Faire une offre'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Map<String, String>>? details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (details != null) ...[
          const SizedBox(height: 12),
          ...details.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        '${detail['label']}:',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        detail['value']!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildSellerSection(Map<String, dynamic> seller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              seller['avatar'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${seller['rating']}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      ' (${seller['reviews']} avis)',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Membre depuis ${seller['memberSince']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (seller['isOnline'])
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
        ],
      ),
    );
  }

  void _showOfferDialog(BuildContext context) {
    final TextEditingController offerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Faire une offre'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Proposez votre prix pour cet article:'),
            const SizedBox(height: 16),
            TextField(
              controller: offerController,
              decoration: const InputDecoration(
                hintText: 'Votre offre en €',
                border: OutlineInputBorder(),
                suffixText: '€',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Offre envoyée au vendeur!')),
              );
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }
}
