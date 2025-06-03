import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/category_service.dart';

/// Barre de recherche avancée avec autocomplétion pour Gearted
class AdvancedSearchBar extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmitted;
  final Function(String)? onSuggestionSelected;
  final String? initialValue;
  final String hintText;
  final bool showSuggestions;
  final bool autofocus;
  final int maxSuggestions;

  const AdvancedSearchBar({
    Key? key,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSuggestionSelected,
    this.initialValue,
    this.hintText = 'Rechercher des équipements airsoft...',
    this.showSuggestions = true,
    this.autofocus = false,
    this.maxSuggestions = 8,
  }) : super(key: key);

  @override
  State<AdvancedSearchBar> createState() => _AdvancedSearchBarState();
}

class _AdvancedSearchBarState extends State<AdvancedSearchBar>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _pulseController;
  late AnimationController _suggestionController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _suggestionAnimation;

  List<String> _suggestions = [];
  bool _showSuggestions = false;
  String _currentQuery = '';

  // Suggestions tactiques prédéfinies
  final List<String> _tacticalSuggestions = [
    'AEG M4',
    'Masque protection',
    'Red dot',
    'Chargeur midcap',
    'Gilet tactique',
    'Billes 0.25g',
    'Batterie LiPo',
    'Sniper bolt',
  ];

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();

    // Animation du pulse pour le focus
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animation des suggestions
    _suggestionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _suggestionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _suggestionController,
      curve: Curves.easeOut,
    ));

    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _pulseController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _pulseController.repeat();
      if (widget.showSuggestions) {
        _updateSuggestions(_currentQuery);
      }
    } else {
      _pulseController.stop();
      _hideSuggestions();
    }
  }

  void _onTextChange() {
    final query = _controller.text;
    _currentQuery = query;

    if (widget.onSearchChanged != null) {
      widget.onSearchChanged!(query);
    }

    if (widget.showSuggestions && _focusNode.hasFocus) {
      _updateSuggestions(query);
    }
  }

  void _updateSuggestions(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _suggestions =
            _tacticalSuggestions.take(widget.maxSuggestions).toList();
      } else {
        _suggestions = CategoryService.getCategorySuggestions(query)
            .take(widget.maxSuggestions)
            .toList();

        // Ajoute les suggestions tactiques si pas assez de résultats
        if (_suggestions.length < widget.maxSuggestions) {
          final remainingSlots = widget.maxSuggestions - _suggestions.length;
          final tacticalMatches = _tacticalSuggestions
              .where((suggestion) =>
                  suggestion.toLowerCase().contains(query.toLowerCase()) &&
                  !_suggestions.contains(suggestion))
              .take(remainingSlots);
          _suggestions.addAll(tacticalMatches);
        }
      }

      _showSuggestions = _suggestions.isNotEmpty;
    });

    if (_showSuggestions) {
      _suggestionController.forward();
    } else {
      _suggestionController.reverse();
    }
  }

  void _hideSuggestions() {
    _suggestionController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }

  void _onSuggestionTap(String suggestion) {
    _controller.text = suggestion;
    _focusNode.unfocus();

    if (widget.onSuggestionSelected != null) {
      widget.onSuggestionSelected!(suggestion);
    }

    if (widget.onSearchSubmitted != null) {
      widget.onSearchSubmitted!(suggestion);
    }
  }

  void _onSubmitted(String query) {
    _focusNode.unfocus();

    if (widget.onSearchSubmitted != null) {
      widget.onSearchSubmitted!(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchField(),
        if (_showSuggestions) _buildSuggestionsList(),
      ],
    );
  }

  Widget _buildSearchField() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                GeartedColors.militaryBlack,
                GeartedColors.tacticalGray,
              ],
            ),
            border: Border.all(
              color: _focusNode.hasFocus
                  ? GeartedColors.battleRed
                      .withOpacity(0.5 + 0.5 * _pulseAnimation.value)
                  : GeartedColors.smokeGray,
              width: 2,
            ),
            boxShadow: [
              if (_focusNode.hasFocus)
                BoxShadow(
                  color: GeartedColors.battleRed
                      .withOpacity(0.3 * _pulseAnimation.value),
                  blurRadius: 8 + 4 * _pulseAnimation.value,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              // Icône de recherche
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.search,
                  color: _focusNode.hasFocus
                      ? GeartedColors.victoryGold
                      : GeartedColors.bulletSilver,
                  size: 24,
                ),
              ),

              // Champ de texte
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: GeartedColors.bulletSilver.withOpacity(0.7),
                      letterSpacing: 0.5,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  onSubmitted: _onSubmitted,
                  textInputAction: TextInputAction.search,
                ),
              ),

              // Bouton clear
              if (_controller.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      _controller.clear();
                      _focusNode.requestFocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: GeartedColors.smokeGray.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.clear,
                        color: GeartedColors.bulletSilver,
                        size: 18,
                      ),
                    ),
                  ),
                ),

              // Bouton microphone (placeholder pour recherche vocale future)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implémenter la recherche vocale
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Recherche vocale bientôt disponible',
                          style: TextStyle(fontFamily: 'Oswald'),
                        ),
                        backgroundColor: GeartedColors.battleRed,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: GeartedColors.battleRed.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: GeartedColors.battleRed.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.mic,
                      color: GeartedColors.battleRed,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestionsList() {
    return AnimatedBuilder(
      animation: _suggestionAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (1 - _suggestionAnimation.value)),
          child: Opacity(
            opacity: _suggestionAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: GeartedColors.tacticalGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: GeartedColors.battleRed.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header des suggestions
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GeartedColors.battleRed.withOpacity(0.1),
                          GeartedColors.battleRed.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: GeartedColors.victoryGold,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SUGGESTIONS TACTIQUES',
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: GeartedColors.victoryGold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Liste des suggestions
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) => Divider(
                      color: GeartedColors.smokeGray.withOpacity(0.3),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return _buildSuggestionItem(suggestion, index);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestionItem(String suggestion, int index) {
    final isHighlighted =
        suggestion.toLowerCase().contains(_currentQuery.toLowerCase());

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onSuggestionTap(suggestion),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              // Icône de suggestion
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? GeartedColors.victoryGold.withOpacity(0.2)
                      : GeartedColors.smokeGray.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isHighlighted ? Icons.search : Icons.history,
                  color: isHighlighted
                      ? GeartedColors.victoryGold
                      : GeartedColors.bulletSilver,
                  size: 16,
                ),
              ),

              const SizedBox(width: 12),

              // Texte de suggestion
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    children: _buildHighlightedText(suggestion, _currentQuery),
                  ),
                ),
              ),

              // Flèche
              Icon(
                Icons.north_west,
                color: GeartedColors.bulletSilver.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightedText(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      // Texte avant la correspondance
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
        ));
      }

      // Texte en surbrillance
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: GeartedColors.victoryGold,
          backgroundColor: GeartedColors.victoryGold.withOpacity(0.2),
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    // Texte restant
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
      ));
    }

    return spans;
  }
}
