/// Classification complète des catégories et sous-catégories de matériel Airsoft
/// Structure numérotée avec bullet points pour une navigation claire
/// Synchronisée avec la version backend

class AirsoftCategories {
  // 🪖 1. Répliques Airsoft
  static const String repliquesAirsoft = '🪖 1. Répliques Airsoft';
  static const String repliquePoingGaz = '• Répliques de poing - Gaz';
  static const String repliquePoingAEP = '• Répliques de poing - AEP';
  static const String repliquePoingCO2 = '• Répliques de poing - CO2';
  static const String repliquePoingSpring = '• Répliques de poing - Spring';
  static const String repliqueLongueAEG = '• Répliques longues - AEG';
  static const String repliqueLongueAEGBlowback = '• Répliques longues - AEG Blowback';
  static const String repliqueLongueGBB = '• Répliques longues - GBB';
  static const String repliqueLongueSpring = '• Répliques longues - Spring';

  // 🧤 2. Équipement de protection
  static const String equipementProtection = '🧤 2. Équipement de protection';
  static const String masques = '• Masques';
  static const String lunettesProtection = '• Lunettes de protection balistique';
  static const String casques = '• Casques';
  static const String gants = '• Gants';
  static const String protegeVisage = '• Protège-dents / Protège-visage';
  static const String genouilleres = '• Genouillères / Coudières';
  static const String portePlaques = '• Porte-plaques / Porte-chargeurs';
  static const String giletsTactiques = '• Gilets tactiques / Chest Rigs';

  // 🎽 3. Tenues et camouflages
  static const String tenuesCamouflages = '🎽 3. Tenues et camouflages';
  static const String uniformes = '• Uniformes (militaire, police, civil tactique)';
  static const String ceinturesCombat = '• Ceintures de combat';
  static const String casquettesChapeaux = '• Casquettes / Chapeaux / Shemaghs';
  static const String chaussuresRangers = '• Chaussures / Rangers';

  // 📦 4. Accessoires de réplique
  static const String accessoiresReplique = '📦 4. Accessoires de réplique';
  static const String chargeurs = '• Chargeurs';
  static const String silencieuxTracers = '• Silencieux / Tracers';
  static const String organesVisee = '• Organes de visée (Red Dot, lunettes, etc.)';
  static const String railsGrips = '• Rails & grips / poignées';
  static const String lampesTactiques = '• Lampes tactiques / Lasers';
  static const String grenadesAirsoft = '• Grenades airsoft (gaz ou ressort)';

  // ⚙️ 5. Pièces internes et upgrade
  static const String piecesInternesUpgrade = '⚙️ 5. Pièces internes et upgrade';
  static const String gearbox = '• Gearbox (mécanique AEG)';
  static const String moteurs = '• Moteurs';
  static const String pistonsRessorts = '• Pistons, ressorts, engrenages';
  static const String canonPrecision = '• Canon de précision';
  static const String hopUpJoints = '• Hop-up et joints';
  static const String blocDetente = '• Bloc détente';

  // 🛠 6. Outils et maintenance
  static const String outilsMaintenance = '🛠 6. Outils et maintenance';
  static const String kitsNettoyage = '• Kits de nettoyage';
  static const String tournevisClefs = '• Tournevis / Clés Allen';
  static const String chargeursUniversels = '• Chargeurs universels';
  static const String sacTransport = '• Sac de transport / mallette de réplique';

  // 📻 7. Communication & électronique
  static const String communicationElectronique = '📻 7. Communication & électronique';
  static const String talkiesWalkies = '• Talkies-Walkies';
  static const String packsPTT = '• Packs PTT + casques';
  static const String cameras = '• Caméras (GoPro, tactiques)';
  static const String unitesTracage = '• Unités de traçage lumineuses (tracer units)';

  /// Liste complète des catégories principales avec numérotation et emojis
  static const List<String> mainCategories = [
    repliquesAirsoft,
    equipementProtection,
    tenuesCamouflages,
    accessoiresReplique,
    piecesInternesUpgrade,
    outilsMaintenance,
    communicationElectronique,
  ];

  /// Liste complète de toutes les catégories et sous-catégories
  static const List<String> allCategories = [
    // 🪖 1. Répliques Airsoft
    repliquesAirsoft,
    repliquePoingGaz,
    repliquePoingAEP,
    repliquePoingCO2,
    repliquePoingSpring,
    repliqueLongueAEG,
    repliqueLongueAEGBlowback,
    repliqueLongueGBB,
    repliqueLongueSpring,

    // 🧤 2. Équipement de protection
    equipementProtection,
    masques,
    lunettesProtection,
    casques,
    gants,
    protegeVisage,
    genouilleres,
    portePlaques,
    giletsTactiques,

    // 🎽 3. Tenues et camouflages
    tenuesCamouflages,
    uniformes,
    ceinturesCombat,
    casquettesChapeaux,
    chaussuresRangers,

    // 📦 4. Accessoires de réplique
    accessoiresReplique,
    chargeurs,
    silencieuxTracers,
    organesVisee,
    railsGrips,
    lampesTactiques,
    grenadesAirsoft,

    // ⚙️ 5. Pièces internes et upgrade
    piecesInternesUpgrade,
    gearbox,
    moteurs,
    pistonsRessorts,
    canonPrecision,
    hopUpJoints,
    blocDetente,

    // 🛠 6. Outils et maintenance
    outilsMaintenance,
    kitsNettoyage,
    tournevisClefs,
    chargeursUniversels,
    sacTransport,

    // 📻 7. Communication & électronique
    communicationElectronique,
    talkiesWalkies,
    packsPTT,
    cameras,
    unitesTracage,
  ];

  /// Mapping des catégories principales vers leurs sous-catégories
  static const Map<String, List<String>> categoryMapping = {
    repliquesAirsoft: [
      repliquePoingGaz,
      repliquePoingAEP,
      repliquePoingCO2,
      repliquePoingSpring,
      repliqueLongueAEG,
      repliqueLongueAEGBlowback,
      repliqueLongueGBB,
      repliqueLongueSpring,
    ],
    equipementProtection: [
      masques,
      lunettesProtection,
      casques,
      gants,
      protegeVisage,
      genouilleres,
      portePlaques,
      giletsTactiques,
    ],
    tenuesCamouflages: [
      uniformes,
      ceinturesCombat,
      casquettesChapeaux,
      chaussuresRangers,
    ],
    accessoiresReplique: [
      chargeurs,
      silencieuxTracers,
      organesVisee,
      railsGrips,
      lampesTactiques,
      grenadesAirsoft,
    ],
    piecesInternesUpgrade: [
      gearbox,
      moteurs,
      pistonsRessorts,
      canonPrecision,
      hopUpJoints,
      blocDetente,
    ],
    outilsMaintenance: [
      kitsNettoyage,
      tournevisClefs,
      chargeursUniversels,
      sacTransport,
    ],
    communicationElectronique: [
      talkiesWalkies,
      packsPTT,
      cameras,
      unitesTracage,
    ],
  };

  /// Obtenir les icônes correspondantes aux catégories principales
  static const Map<String, int> categoryIcons = {
    repliquesAirsoft: 0xe52f, // Icons.sports_motorsports
    equipementProtection: 0xe3bb, // Icons.security
    tenuesCamouflages: 0xe3c6, // Icons.checkroom
    accessoiresReplique: 0xe5f1, // Icons.build
    piecesInternesUpgrade: 0xe5ca, // Icons.precision_manufacturing
    outilsMaintenance: 0xe5f5, // Icons.build_circle
    communicationElectronique: 0xe324, // Icons.radio
  };

  /// Obtenir les sous-catégories d'une catégorie principale
  static List<String> getSubCategories(String mainCategory) {
    return categoryMapping[mainCategory] ?? [];
  }

  /// Vérifier si une catégorie est une catégorie principale
  static bool isMainCategory(String category) {
    return mainCategories.contains(category);
  }

  /// Obtenir la catégorie principale d'une sous-catégorie
  static String? getMainCategory(String subCategory) {
    for (final entry in categoryMapping.entries) {
      if (entry.value.contains(subCategory)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Helper functions to clean category names for display
  
  /// Remove emoji and number from category name for clean display
  static String getCleanCategoryName(String category) {
    // Remove emoji and number pattern like "🪖 1. " or "• "
    return category.replaceAll(RegExp(r'^[🪖🧤🎽📦⚙️🛠📻]\s*\d+\.\s*'), '')
                  .replaceAll(RegExp(r'^•\s*'), '');
  }
  
  /// Get clean main category names without emojis and numbers
  static List<String> get cleanMainCategories {
    return mainCategories.map((category) => getCleanCategoryName(category)).toList();
  }
  
  /// Get clean subcategories for a main category
  static List<String> getCleanSubCategories(String mainCategory) {
    final subCategories = getSubCategories(mainCategory);
    return subCategories.map((subCategory) => getCleanCategoryName(subCategory)).toList();
  }
  
  /// Get all clean subcategories (without main categories)
  static List<String> get allCleanSubCategories {
    List<String> allSubs = [];
    for (String mainCategory in mainCategories) {
      allSubs.addAll(getCleanSubCategories(mainCategory));
    }
    return allSubs;
  }
}
