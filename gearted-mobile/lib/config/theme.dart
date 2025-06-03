import 'package:flutter/material.dart';

/// Palette de couleurs spécialisée pour les nouvelles catégories Gearted
class GeartedColors {
  // === COULEURS PAR CATÉGORIE ===

  // 1. RÉPLIQUES (Noir militaire - Puissance)
  static const Color replicas = Color(0xFF1A1A1A);
  static const Color replicasAccent = Color(0xFF2C2C2C);
  static const Color replicasBackground = Color(0xFF0F0F0F);

  // 2. PROTECTION (Rouge bataille - Sécurité critique)
  static const Color protection = Color(0xFF8B0000);
  static const Color protectionAccent = Color(0xFFA01010);
  static const Color protectionBackground = Color(0xFF4A0000);

  // 3. ACCESSOIRES (Vert camouflage - Équipement tactique)
  static const Color accessories = Color(0xFF4F5D2F);
  static const Color accessoriesAccent = Color(0xFF6B7F3F);
  static const Color accessoriesBackground = Color(0xFF3A4522);

  // 4. PIÈCES DÉTACHÉES (Gris foncé - Technologie)
  static const Color parts = Color(0xFF2F2F2F);
  static const Color partsAccent = Color(0xFF404040);
  static const Color partsBackground = Color(0xFF1F1F1F);

  // 5. TACTIQUE & GEAR (Or victoire - Élite)
  static const Color tactical = Color(0xFFB8860B);
  static const Color tacticalAccent = Color(0xFFD4A61A);
  static const Color tacticalBackground = Color(0xFF8B6508);

  // 6. MUNITION & GRENADES (Orange avertissement - Explosifs)
  static const Color munition = Color(0xFFD2691E);
  static const Color munitionAccent = Color(0xFFE6842E);
  static const Color munitionBackground = Color(0xFFB85A15);

  // 7. DIVERS (Bleu acier - Polyvalent)
  static const Color misc = Color(0xFF4682B4);
  static const Color miscAccent = Color(0xFF5A96C4);
  static const Color miscBackground = Color(0xFF3A6B94);

  // Couleurs principales de guerre (legacy support)
  static const Color militaryBlack = Color(0xFF0A0A0A);
  static const Color battleRed = Color(0xFF8B0000);
  static const Color tacticalGray = Color(0xFF1C1C1C);
  static const Color combatGreen = Color(0xFF2F4F2F);
  static const Color warningOrange = Color(0xFFD2691E);
  static const Color steelBlue = Color(0xFF4682B4);
  static const Color mudBrown = Color(0xFF3E2723);
  static const Color smokeGray = Color(0xFF424242);

  // Couleurs d'accent
  static const Color victoryGold = Color(0xFFB8860B);
  static const Color bulletSilver = Color(0xFF708090);
  static const Color bloodOrange = Color(0xFFCC5500);
  static const Color nightVision = Color(0xFF00FF00);

  // Couleurs de catégories airsoft (legacy support)
  static const Color weaponRed = Color(0xFF8B0000);
  static const Color protectionBlue = Color(0xFF4682B4);
  static const Color tacticalGreen = Color(0xFF2F4F2F);
  static const Color ammunitionOrange = Color(0xFFD2691E);
  static const Color accessoryPurple = Color(0xFF800080);
  static const Color sparepartGray = Color(0xFF708090);
  static const Color miscellaneousOrange = Color(0xFFCC5500);

  // Couleurs d'état
  static const Color successGreen = Color(0xFF228B22);
  static const Color errorRed = Color(0xFFDC143C);
  static const Color warningYellow = Color(0xFFFF8C00);
  static const Color infoBlue = Color(0xFF4169E1);

  // Couleurs de badges
  static const Color newBadge = Color(0xFF00C851);
  static const Color usedBadge = Color(0xFFFF9800);
  static const Color discountBadge = Color(0xFFFF1744);
  static const Color exchangeBadge = Color(0xFF2196F3);
  static const Color verifiedBadge = Color(0xFF4CAF50);

  // Couleurs de l'application
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color accent = Color(0xFF03A9F4);

  // === MÉTHODES UTILITAIRES ===

  /// Récupère la couleur principale d'une catégorie
  static Color getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'replicas':
        return replicas;
      case 'protection':
        return protection;
      case 'accessories':
        return accessories;
      case 'parts':
        return parts;
      case 'tactical':
        return tactical;
      case 'munition':
        return munition;
      case 'misc':
      default:
        return misc;
    }
  }

  /// Récupère la couleur d'accent d'une catégorie
  static Color getCategoryAccent(String categoryId) {
    switch (categoryId) {
      case 'replicas':
        return replicasAccent;
      case 'protection':
        return protectionAccent;
      case 'accessories':
        return accessoriesAccent;
      case 'parts':
        return partsAccent;
      case 'tactical':
        return tacticalAccent;
      case 'munition':
        return munitionAccent;
      case 'misc':
      default:
        return miscAccent;
    }
  }

  /// Récupère la couleur de fond d'une catégorie
  static Color getCategoryBackground(String categoryId) {
    switch (categoryId) {
      case 'replicas':
        return replicasBackground;
      case 'protection':
        return protectionBackground;
      case 'accessories':
        return accessoriesBackground;
      case 'parts':
        return partsBackground;
      case 'tactical':
        return tacticalBackground;
      case 'munition':
        return munitionBackground;
      case 'misc':
      default:
        return miscBackground;
    }
  }

  /// Palette de gradient pour une catégorie
  static LinearGradient getCategoryGradient(String categoryId) {
    return LinearGradient(
      colors: [
        getCategoryColor(categoryId),
        getCategoryAccent(categoryId),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

/// Chemins des icônes SVG pour les catégories
class GeartedIcons {
  static const String basePath = 'assets/icons/categories/';

  // Icônes principales des catégories
  static const String repliques = '${basePath}repliques.svg';
  static const String protection = '${basePath}protection.svg';
  static const String accessoires = '${basePath}accessoires.svg';
  static const String pieces = '${basePath}pieces.svg';
  static const String tactique = '${basePath}tactique.svg';
  static const String munition = '${basePath}munition.svg';
  static const String divers = '${basePath}divers.svg';

  // Sous-catégories répliques
  static const String aeg = '${basePath}aeg.svg';
  static const String gbb = '${basePath}gbb.svg';
  static const String sniper = '${basePath}sniper.svg';
  static const String shotgun = '${basePath}shotgun.svg';

  // Sous-catégories protection
  static const String mask = '${basePath}mask.svg';
  static const String vest = '${basePath}vest.svg';
  static const String helmet = '${basePath}helmet.svg';
  static const String gloves = '${basePath}gloves.svg';
}

class GeartedTheme {
  // Couleurs primaires de guerre
  static const Color militaryBlack = Color(0xFF0A0A0A);
  static const Color battleRed = Color(0xFF8B0000);
  static const Color tacticalGray = Color(0xFF1C1C1C);
  static const Color combatGreen = Color(0xFF2F4F2F);
  static const Color warningOrange = Color(0xFFD2691E);
  static const Color steelBlue = Color(0xFF4682B4);
  static const Color mudBrown = Color(0xFF3E2723);
  static const Color smokeGray = Color(0xFF424242);

  // Couleurs d'accent
  static const Color victoryGold = Color(0xFFB8860B);
  static const Color bulletSilver = Color(0xFF708090);
  static const Color bloodOrange = Color(0xFFCC5500);
  static const Color nightVision = Color(0xFF00FF00);

  // Compatibilité rétroactive pour l'ancien code
  static const Color primaryBlue = steelBlue;
  static const Color accentOrange = warningOrange;
  static const Color lightBlue = steelBlue;

  // Thème clair (mode jour tactique)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    colorScheme: ColorScheme.light(
      primary: combatGreen,
      secondary: battleRed,
      tertiary: warningOrange,
      background: smokeGray,
      surface: tacticalGray,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      error: bloodOrange,
    ),
    scaffoldBackgroundColor: militaryBlack,
    fontFamily: 'Oswald',
    appBarTheme: AppBarTheme(
      backgroundColor: militaryBlack,
      foregroundColor: victoryGold,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Oswald',
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        color: Colors.white,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: battleRed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: bloodOrange, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: battleRed,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: bloodOrange, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Oswald',
          fontSize: 16,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: tacticalGray,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(color: battleRed, width: 2),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: steelBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: nightVision, width: 2),
      ),
      filled: true,
      fillColor: smokeGray,
      hintStyle: TextStyle(
        color: nightVision.withOpacity(0.5),
        fontFamily: 'Courier',
      ),
    ),
    textTheme: _createTextTheme(Colors.white),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: militaryBlack,
      selectedItemColor: battleRed,
      unselectedItemColor: smokeGray,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
      type: BottomNavigationBarType.fixed,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  // Thème sombre (identique, mais peut être ajusté si besoin)
  static final ThemeData darkTheme = lightTheme.copyWith(
    colorScheme: ColorScheme.dark(
      primary: combatGreen,
      secondary: battleRed,
      tertiary: warningOrange,
      background: militaryBlack,
      surface: tacticalGray,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      error: bloodOrange,
    ),
    scaffoldBackgroundColor: militaryBlack,
    textTheme: _createTextTheme(Colors.white),
  );

  static TextTheme _createTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: 2,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: 2,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: 2,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: 2,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: 2,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 1.5,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 1.5,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 1.2,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 1.2,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Oswald',
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
    );
  }
}
