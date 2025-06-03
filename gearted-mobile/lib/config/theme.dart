import 'package:flutter/material.dart';

class GeartedTheme {
  // Couleurs primaires de guerre
  static const Color militaryBlack = Color(0xFF0A0A0A); // Noir profond
  static const Color battleRed = Color(0xFF8B0000); // Rouge sang foncé
  static const Color tacticalGray = Color(0xFF1C1C1C); // Gris acier
  static const Color combatGreen = Color(0xFF2F4F2F); // Vert militaire sombre
  static const Color warningOrange =
      Color(0xFFD2691E); // Orange brûlé (alertes)
  static const Color steelBlue = Color(0xFF4682B4); // Bleu acier
  static const Color mudBrown = Color(0xFF3E2723); // Marron boue
  static const Color smokeGray = Color(0xFF424242); // Gris fumée

  // Couleurs d'accent
  static const Color victoryGold =
      Color(0xFFB8860B); // Or foncé (succès/premium)
  static const Color bulletSilver = Color(0xFF708090); // Argent métallique
  static const Color bloodOrange = Color(0xFFCC5500); // Orange sang
  static const Color nightVision = Color(0xFF00FF00); // Vert vision nocturne

  // Compatibilité rétroactive pour l'ancien code
  static const Color primaryBlue = steelBlue; // Ancien 'primaryBlue' = steelBlue martial
  static const Color accentOrange = warningOrange; // Ancien 'accentOrange' = warningOrange martial
  static const Color lightBlue = steelBlue; // Compatibilité legacy

  // Thème clair (mode jour tactique)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false, // Plus angulaire, moins arrondi
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
    fontFamily: 'Oswald', // Police militaire
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
        borderRadius: BorderRadius.circular(4), // Angles durs
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
        borderRadius: BorderRadius.circular(0), // Pas d'arrondi
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
