import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';

/// Carte produit moderne style e-commerce pour les résultats de recherche
class EcommerceProductCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final double price;
  final double? originalPrice;
  final String condition;
  final String? categoryId;
  final bool isExchangeable;
  final bool isFavorite;
  final double rating;
  final int reviewCount;
  final String? location;
  final String? sellerName;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onQuickView;

  const EcommerceProductCard({
    super.key,
    this.imageUrl,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.condition,
    this.categoryId,
    required this.isExchangeable,
    this.isFavorite = false,
    this.rating = 0,
    this.reviewCount = 0,
    this.location,
    this.sellerName,
    required this.onTap,
    this.onFavoriteToggle,
    this.onQuickView,
  });

  @override
  Widget build(BuildContext context) {
    final discount = originalPrice != null
        ? ((originalPrice! - price) / originalPrice! * 100).round()
        : 0;

    final categoryColor = categoryId != null
        ? GeartedColors.getCategoryColor(categoryId!)
        : GeartedTheme.tacticalGray;

    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image avec overlays
              _buildImageSection(discount, categoryColor),

              // Contenu textuel
              _buildContentSection(categoryColor),
            ],
          ),
        ),
      ),
    );
  }

  /// Section image avec badges et actions
  Widget _buildImageSection(int discount, Color categoryColor) {
    return Stack(
      children: [
        // Image principale
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade100,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(categoryColor),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey.shade400,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Image indisponible',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.grey.shade400,
                          size: 32,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pas d\'image',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ), // Badge de réduction (top-left)
        if (originalPrice != null && discount > 0)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GeartedTheme.battleRed,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '-$discount%',
                style: TextStyle(
                  color: GeartedTheme.battleRed,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ),

        // Badge échangeable (top-right corner)
        if (isExchangeable)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: GeartedColors.accessories,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.swap_horiz,
                color: GeartedColors.accessories,
                size: 14,
              ),
            ),
          ),

        // Bouton favoris (bottom-right de l'image)
        if (onFavoriteToggle != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onFavoriteToggle,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? GeartedTheme.battleRed
                        : Colors.grey.shade600,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),

        // Overlay condition (bottom-left de l'image)
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getConditionColor(),
                width: 1,
              ),
            ),
            child: Text(
              condition,
              style: TextStyle(
                color: _getConditionColor(),
                fontSize: 9,
                fontWeight: FontWeight.w600,
                fontFamily: 'Oswald',
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Section contenu avec informations produit
  Widget _buildContentSection(Color categoryColor) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre du produit
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          // Prix avec remise
          Row(
            children: [
              Text(
                '${price.toStringAsFixed(0)}€',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: categoryColor,
                  fontFamily: 'Oswald',
                ),
              ),
              if (originalPrice != null) ...[
                const SizedBox(width: 6),
                Text(
                  '${originalPrice!.toStringAsFixed(0)}€',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 8),

          // Rating et avis (si disponibles)
          if (rating > 0 || reviewCount > 0)
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < rating.floor()
                        ? Icons.star
                        : index < rating
                            ? Icons.star_half
                            : Icons.star_border,
                    color: Colors.amber,
                    size: 12,
                  );
                }),
                if (reviewCount > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    '($reviewCount)',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),

          const SizedBox(height: 8),

          // Informations vendeur et localisation
          Row(
            children: [
              // Vendeur
              if (sellerName != null) ...[
                Icon(
                  Icons.person,
                  color: Colors.grey.shade500,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    sellerName!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              // Localisation
              if (location != null) ...[
                if (sellerName != null) const SizedBox(width: 8),
                Icon(
                  Icons.location_on,
                  color: Colors.grey.shade500,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  location!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 8),

          // Actions rapides
          Row(
            children: [
              // Bouton Vue rapide
              if (onQuickView != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onQuickView,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: categoryColor,
                      side: BorderSide(color: categoryColor, width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      'Aperçu',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Oswald',
                      ),
                    ),
                  ),
                ),

              if (onQuickView != null) const SizedBox(width: 8),

              // Bouton Contact/Voir
              Expanded(
                flex: onQuickView != null ? 2 : 1,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: categoryColor,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    minimumSize: Size.zero,
                    elevation: 0,
                    side: BorderSide(color: categoryColor, width: 1),
                  ),
                  child: Text(
                    isExchangeable ? 'Échanger' : 'Voir',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Oswald',
                      color: categoryColor,
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

  /// Couleur selon l'état du produit
  Color _getConditionColor() {
    switch (condition.toLowerCase()) {
      case 'neuf':
        return GeartedColors.accessories;
      case 'très bon état':
        return GeartedColors.tactical;
      case 'bon état':
        return GeartedTheme.warningOrange;
      case 'état moyen':
        return GeartedTheme.mudBrown;
      case 'pour pièces':
        return GeartedTheme.battleRed;
      default:
        return GeartedTheme.tacticalGray;
    }
  }
}
