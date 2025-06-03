import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../core/constants/new_categories_data.dart';

/// Tiroir de filtres facetés avec style martial moderne
class FilterDrawer extends StatefulWidget {
  final List<String> selectedCategories;
  final double? minPrice;
  final double? maxPrice;
  final String? condition;
  final bool showOnlyExchangeable;
  final String sortBy;
  final Function(List<String>) onCategoriesChanged;
  final Function(double?, double?) onPriceRangeChanged;
  final Function(String?) onConditionChanged;
  final Function(bool) onExchangeableChanged;
  final Function(String) onSortChanged;
  final VoidCallback onClearAll;

  const FilterDrawer({
    super.key,
    required this.selectedCategories,
    this.minPrice,
    this.maxPrice,
    this.condition,
    required this.showOnlyExchangeable,
    required this.sortBy,
    required this.onCategoriesChanged,
    required this.onPriceRangeChanged,
    required this.onConditionChanged,
    required this.onExchangeableChanged,
    required this.onSortChanged,
    required this.onClearAll,
  });

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  double _currentMinPrice = 0;
  double _currentMaxPrice = 1000;

  @override
  void initState() {
    super.initState();
    _currentMinPrice = widget.minPrice ?? 0;
    _currentMaxPrice = widget.maxPrice ?? 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header martial avec poignée
          _buildHeader(),

          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Catégories
                  _buildCategoriesSection(),

                  const SizedBox(height: 24),

                  // Section Prix
                  _buildPriceSection(),

                  const SizedBox(height: 24),

                  // Section État
                  _buildConditionSection(),

                  const SizedBox(height: 24),

                  // Section Options
                  _buildOptionsSection(),

                  const SizedBox(height: 24),

                  // Section Tri
                  _buildSortSection(),
                ],
              ),
            ),
          ),

          // Footer avec actions
          _buildFooter(),
        ],
      ),
    );
  }

  /// Header martial avec style de commandement
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GeartedTheme.battleRed,
            GeartedTheme.battleRed.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Poignée de tiroir
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 16),

          // Titre et actions
          Row(
            children: [
              Icon(
                Icons.tune,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'FILTRES TACTIQUES',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Oswald',
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
                tooltip: 'Fermer',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section de sélection des catégories
  Widget _buildCategoriesSection() {
    final categories = NewCategoriesData.getMainCategories();

    return _buildSection(
      'CATÉGORIES DE COMBAT',
      Icons.category,
      GeartedColors.replicas,
      child: Column(
        children: categories.map((category) {
          final categoryId = category['id'] as String;
          final isSelected = widget.selectedCategories.contains(categoryId);
          final categoryColor = GeartedColors.getCategoryColor(categoryId);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _toggleCategory(categoryId),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? categoryColor.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? categoryColor : Colors.grey.shade600,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        color:
                            isSelected ? categoryColor : Colors.grey.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          category['name'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade300,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: categoryColor,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Section de filtrage par prix
  Widget _buildPriceSection() {
    return _buildSection(
      'BUDGET TACTIQUE',
      Icons.attach_money,
      GeartedColors.tactical,
      child: Column(
        children: [
          // Affichage de la plage actuelle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: GeartedColors.tactical.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: GeartedColors.tactical.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_currentMinPrice.toInt()}€',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GeartedColors.tactical,
                    fontFamily: 'Oswald',
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: GeartedColors.tactical,
                  size: 16,
                ),
                Text(
                  '${_currentMaxPrice.toInt()}€',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GeartedColors.tactical,
                    fontFamily: 'Oswald',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Slider de prix minimum
          _buildPriceSlider(
            'Prix minimum',
            _currentMinPrice,
            0,
            _currentMaxPrice,
            (value) {
              setState(() {
                _currentMinPrice = value;
              });
              widget.onPriceRangeChanged(_currentMinPrice, _currentMaxPrice);
            },
          ),

          const SizedBox(height: 12),

          // Slider de prix maximum
          _buildPriceSlider(
            'Prix maximum',
            _currentMaxPrice,
            _currentMinPrice,
            1000,
            (value) {
              setState(() {
                _currentMaxPrice = value;
              });
              widget.onPriceRangeChanged(_currentMinPrice, _currentMaxPrice);
            },
          ),
        ],
      ),
    );
  }

  /// Slider de prix personnalisé
  Widget _buildPriceSlider(String label, double value, double min, double max,
      Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
            fontFamily: 'Oswald',
            fontWeight: FontWeight.w500,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: GeartedColors.tactical,
            inactiveTrackColor: GeartedColors.tactical.withOpacity(0.3),
            thumbColor: GeartedColors.tactical,
            overlayColor: GeartedColors.tactical.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 20,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  /// Section état/condition
  Widget _buildConditionSection() {
    final conditions = [
      'Neuf',
      'Très bon état',
      'Bon état',
      'État moyen',
      'Pour pièces',
    ];

    return _buildSection(
      'ÉTAT DU MATÉRIEL',
      Icons.verified,
      GeartedColors.protection,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: conditions.map((condition) {
          final isSelected = widget.condition == condition;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                widget.onConditionChanged(isSelected ? null : condition);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? GeartedColors.protection
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? GeartedColors.protection
                        : Colors.grey.shade600,
                  ),
                ),
                child: Text(
                  condition,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey.shade300,
                    fontFamily: 'Oswald',
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Section options spéciales
  Widget _buildOptionsSection() {
    return _buildSection(
      'OPTIONS TACTIQUES',
      Icons.swap_horiz,
      GeartedColors.accessories,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            widget.onExchangeableChanged(!widget.showOnlyExchangeable);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: widget.showOnlyExchangeable
                  ? GeartedColors.accessories.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.showOnlyExchangeable
                    ? GeartedColors.accessories
                    : Colors.grey.shade600,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.swap_horiz,
                  color: widget.showOnlyExchangeable
                      ? GeartedColors.accessories
                      : Colors.grey.shade400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Uniquement les échanges',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: widget.showOnlyExchangeable
                          ? Colors.white
                          : Colors.grey.shade300,
                      fontFamily: 'Oswald',
                    ),
                  ),
                ),
                if (widget.showOnlyExchangeable)
                  Icon(
                    Icons.check_circle,
                    color: GeartedColors.accessories,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section tri
  Widget _buildSortSection() {
    final sortOptions = [
      {'value': 'relevance', 'label': 'Pertinence', 'icon': Icons.sort},
      {
        'value': 'price_asc',
        'label': 'Prix croissant',
        'icon': Icons.arrow_upward
      },
      {
        'value': 'price_desc',
        'label': 'Prix décroissant',
        'icon': Icons.arrow_downward
      },
      {'value': 'newest', 'label': 'Plus récent', 'icon': Icons.schedule},
      {
        'value': 'popular',
        'label': 'Plus populaire',
        'icon': Icons.trending_up
      },
    ];

    return _buildSection(
      'ORDRE DE BATAILLE',
      Icons.sort,
      GeartedColors.misc,
      child: Column(
        children: sortOptions.map((option) {
          final isSelected = widget.sortBy == option['value'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  widget.onSortChanged(option['value'] as String);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? GeartedColors.misc.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? GeartedColors.misc
                          : Colors.grey.shade600,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        option['icon'] as IconData,
                        color: isSelected
                            ? GeartedColors.misc
                            : Colors.grey.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade300,
                            fontFamily: 'Oswald',
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.radio_button_checked,
                          color: GeartedColors.misc,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Footer avec boutons d'action
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GeartedTheme.tacticalGray,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Bouton Effacer tout
          Expanded(
            child: OutlinedButton.icon(
              onPressed: widget.onClearAll,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text(
                'EFFACER TOUT',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: GeartedTheme.battleRed,
                side: BorderSide(color: GeartedTheme.battleRed),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Bouton Appliquer
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.done, size: 18),
              label: const Text(
                'APPLIQUER',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: GeartedColors.accessories,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget de section réutilisable
  Widget _buildSection(String title, IconData icon, Color color,
      {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontFamily: 'Oswald',
                letterSpacing: 1.2,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  /// Toggle d'une catégorie
  void _toggleCategory(String categoryId) {
    final List<String> newSelection = List.from(widget.selectedCategories);

    if (newSelection.contains(categoryId)) {
      newSelection.remove(categoryId);
    } else {
      newSelection.add(categoryId);
    }

    widget.onCategoriesChanged(newSelection);
  }
}
