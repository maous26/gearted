/**
 * Classification complète des catégories et sous-catégories de matériel Airsoft
 * Structure numérotée avec bullet points pour une navigation claire
 * Synchronisée avec la version mobile
 */

class AirsoftCategories {
  // 🪖 1. Répliques Airsoft
  static readonly REPLIQUES_AIRSOFT = '🪖 1. Répliques Airsoft';
  static readonly REPLIQUE_POING_GAZ = '• Répliques de poing - Gaz';
  static readonly REPLIQUE_POING_AEP = '• Répliques de poing - AEP';
  static readonly REPLIQUE_POING_CO2 = '• Répliques de poing - CO2';
  static readonly REPLIQUE_POING_SPRING = '• Répliques de poing - Spring';
  static readonly REPLIQUE_LONGUE_AEG = '• Répliques longues - AEG';
  static readonly REPLIQUE_LONGUE_AEG_BLOWBACK = '• Répliques longues - AEG Blowback';
  static readonly REPLIQUE_LONGUE_GBB = '• Répliques longues - GBB';
  static readonly REPLIQUE_LONGUE_SPRING = '• Répliques longues - Spring';

  // 🧤 2. Équipement de protection
  static readonly EQUIPEMENT_PROTECTION = '🧤 2. Équipement de protection';
  static readonly MASQUES = '• Masques';
  static readonly LUNETTES_PROTECTION = '• Lunettes de protection balistique';
  static readonly CASQUES = '• Casques';
  static readonly GANTS = '• Gants';
  static readonly PROTEGE_VISAGE = '• Protège-dents / Protège-visage';
  static readonly GENOUILLERES = '• Genouillères / Coudières';
  static readonly PORTE_PLAQUES = '• Porte-plaques / Porte-chargeurs';
  static readonly GILETS_TACTIQUES = '• Gilets tactiques / Chest Rigs';

  // 🎽 3. Tenues et camouflages
  static readonly TENUES_CAMOUFLAGES = '🎽 3. Tenues et camouflages';
  static readonly UNIFORMES = '• Uniformes (militaire, police, civil tactique)';
  static readonly CEINTURES_COMBAT = '• Ceintures de combat';
  static readonly CASQUETTES_CHAPEAUX = '• Casquettes / Chapeaux / Shemaghs';
  static readonly CHAUSSURES_RANGERS = '• Chaussures / Rangers';

  // 📦 4. Accessoires de réplique
  static readonly ACCESSOIRES_REPLIQUE = '📦 4. Accessoires de réplique';
  static readonly CHARGEURS = '• Chargeurs';
  static readonly SILENCIEUX_TRACERS = '• Silencieux / Tracers';
  static readonly ORGANES_VISEE = '• Organes de visée (Red Dot, lunettes, etc.)';
  static readonly RAILS_GRIPS = '• Rails & grips / poignées';
  static readonly LAMPES_TACTIQUES = '• Lampes tactiques / Lasers';
  static readonly GRENADES_AIRSOFT = '• Grenades airsoft (gaz ou ressort)';

  // ⚙️ 5. Pièces internes et upgrade
  static readonly PIECES_INTERNES_UPGRADE = '⚙️ 5. Pièces internes et upgrade';
  static readonly GEARBOX = '• Gearbox (mécanique AEG)';
  static readonly MOTEURS = '• Moteurs';
  static readonly PISTONS_RESSORTS = '• Pistons, ressorts, engrenages';
  static readonly CANON_PRECISION = '• Canon de précision';
  static readonly HOP_UP_JOINTS = '• Hop-up et joints';
  static readonly BLOC_DETENTE = '• Bloc détente';

  // 🛠 6. Outils et maintenance
  static readonly OUTILS_MAINTENANCE = '🛠 6. Outils et maintenance';
  static readonly KITS_NETTOYAGE = '• Kits de nettoyage';
  static readonly TOURNEVIS_CLEFS = '• Tournevis / Clés Allen';
  static readonly CHARGEURS_UNIVERSELS = '• Chargeurs universels';
  static readonly SAC_TRANSPORT = '• Sac de transport / mallette de réplique';

  // 📻 7. Communication & électronique
  static readonly COMMUNICATION_ELECTRONIQUE = '📻 7. Communication & électronique';
  static readonly TALKIES_WALKIES = '• Talkies-Walkies';
  static readonly PACKS_PTT = '• Packs PTT + casques';
  static readonly CAMERAS = '• Caméras (GoPro, tactiques)';
  static readonly UNITES_TRACAGE = '• Unités de traçage lumineuses (tracer units)';

  /**
   * Liste complète des catégories principales avec numérotation et emojis
   */
  static readonly MAIN_CATEGORIES: readonly string[] = [
    AirsoftCategories.REPLIQUES_AIRSOFT,
    AirsoftCategories.EQUIPEMENT_PROTECTION,
    AirsoftCategories.TENUES_CAMOUFLAGES,
    AirsoftCategories.ACCESSOIRES_REPLIQUE,
    AirsoftCategories.PIECES_INTERNES_UPGRADE,
    AirsoftCategories.OUTILS_MAINTENANCE,
    AirsoftCategories.COMMUNICATION_ELECTRONIQUE,
  ];

  /**
   * Liste complète de toutes les catégories et sous-catégories
   */
  static readonly ALL_CATEGORIES: readonly string[] = [
    // 🪖 1. Répliques Airsoft
    AirsoftCategories.REPLIQUES_AIRSOFT,
    AirsoftCategories.REPLIQUE_POING_GAZ,
    AirsoftCategories.REPLIQUE_POING_AEP,
    AirsoftCategories.REPLIQUE_POING_CO2,
    AirsoftCategories.REPLIQUE_POING_SPRING,
    AirsoftCategories.REPLIQUE_LONGUE_AEG,
    AirsoftCategories.REPLIQUE_LONGUE_AEG_BLOWBACK,
    AirsoftCategories.REPLIQUE_LONGUE_GBB,
    AirsoftCategories.REPLIQUE_LONGUE_SPRING,

    // 🧤 2. Équipement de protection
    AirsoftCategories.EQUIPEMENT_PROTECTION,
    AirsoftCategories.MASQUES,
    AirsoftCategories.LUNETTES_PROTECTION,
    AirsoftCategories.CASQUES,
    AirsoftCategories.GANTS,
    AirsoftCategories.PROTEGE_VISAGE,
    AirsoftCategories.GENOUILLERES,
    AirsoftCategories.PORTE_PLAQUES,
    AirsoftCategories.GILETS_TACTIQUES,

    // 🎽 3. Tenues et camouflages
    AirsoftCategories.TENUES_CAMOUFLAGES,
    AirsoftCategories.UNIFORMES,
    AirsoftCategories.CEINTURES_COMBAT,
    AirsoftCategories.CASQUETTES_CHAPEAUX,
    AirsoftCategories.CHAUSSURES_RANGERS,

    // 📦 4. Accessoires de réplique
    AirsoftCategories.ACCESSOIRES_REPLIQUE,
    AirsoftCategories.CHARGEURS,
    AirsoftCategories.SILENCIEUX_TRACERS,
    AirsoftCategories.ORGANES_VISEE,
    AirsoftCategories.RAILS_GRIPS,
    AirsoftCategories.LAMPES_TACTIQUES,
    AirsoftCategories.GRENADES_AIRSOFT,

    // ⚙️ 5. Pièces internes et upgrade
    AirsoftCategories.PIECES_INTERNES_UPGRADE,
    AirsoftCategories.GEARBOX,
    AirsoftCategories.MOTEURS,
    AirsoftCategories.PISTONS_RESSORTS,
    AirsoftCategories.CANON_PRECISION,
    AirsoftCategories.HOP_UP_JOINTS,
    AirsoftCategories.BLOC_DETENTE,

    // 🛠 6. Outils et maintenance
    AirsoftCategories.OUTILS_MAINTENANCE,
    AirsoftCategories.KITS_NETTOYAGE,
    AirsoftCategories.TOURNEVIS_CLEFS,
    AirsoftCategories.CHARGEURS_UNIVERSELS,
    AirsoftCategories.SAC_TRANSPORT,

    // 📻 7. Communication & électronique
    AirsoftCategories.COMMUNICATION_ELECTRONIQUE,
    AirsoftCategories.TALKIES_WALKIES,
    AirsoftCategories.PACKS_PTT,
    AirsoftCategories.CAMERAS,
    AirsoftCategories.UNITES_TRACAGE,
  ];

  /**
   * Mapping des catégories principales vers leurs sous-catégories
   */
  static readonly CATEGORY_MAPPING: Record<string, readonly string[]> = {
    [AirsoftCategories.REPLIQUES_AIRSOFT]: [
      AirsoftCategories.REPLIQUE_POING_GAZ,
      AirsoftCategories.REPLIQUE_POING_AEP,
      AirsoftCategories.REPLIQUE_POING_CO2,
      AirsoftCategories.REPLIQUE_POING_SPRING,
      AirsoftCategories.REPLIQUE_LONGUE_AEG,
      AirsoftCategories.REPLIQUE_LONGUE_AEG_BLOWBACK,
      AirsoftCategories.REPLIQUE_LONGUE_GBB,
      AirsoftCategories.REPLIQUE_LONGUE_SPRING,
    ],
    [AirsoftCategories.EQUIPEMENT_PROTECTION]: [
      AirsoftCategories.MASQUES,
      AirsoftCategories.LUNETTES_PROTECTION,
      AirsoftCategories.CASQUES,
      AirsoftCategories.GANTS,
      AirsoftCategories.PROTEGE_VISAGE,
      AirsoftCategories.GENOUILLERES,
      AirsoftCategories.PORTE_PLAQUES,
      AirsoftCategories.GILETS_TACTIQUES,
    ],
    [AirsoftCategories.TENUES_CAMOUFLAGES]: [
      AirsoftCategories.UNIFORMES,
      AirsoftCategories.CEINTURES_COMBAT,
      AirsoftCategories.CASQUETTES_CHAPEAUX,
      AirsoftCategories.CHAUSSURES_RANGERS,
    ],
    [AirsoftCategories.ACCESSOIRES_REPLIQUE]: [
      AirsoftCategories.CHARGEURS,
      AirsoftCategories.SILENCIEUX_TRACERS,
      AirsoftCategories.ORGANES_VISEE,
      AirsoftCategories.RAILS_GRIPS,
      AirsoftCategories.LAMPES_TACTIQUES,
      AirsoftCategories.GRENADES_AIRSOFT,
    ],
    [AirsoftCategories.PIECES_INTERNES_UPGRADE]: [
      AirsoftCategories.GEARBOX,
      AirsoftCategories.MOTEURS,
      AirsoftCategories.PISTONS_RESSORTS,
      AirsoftCategories.CANON_PRECISION,
      AirsoftCategories.HOP_UP_JOINTS,
      AirsoftCategories.BLOC_DETENTE,
    ],
    [AirsoftCategories.OUTILS_MAINTENANCE]: [
      AirsoftCategories.KITS_NETTOYAGE,
      AirsoftCategories.TOURNEVIS_CLEFS,
      AirsoftCategories.CHARGEURS_UNIVERSELS,
      AirsoftCategories.SAC_TRANSPORT,
    ],
    [AirsoftCategories.COMMUNICATION_ELECTRONIQUE]: [
      AirsoftCategories.TALKIES_WALKIES,
      AirsoftCategories.PACKS_PTT,
      AirsoftCategories.CAMERAS,
      AirsoftCategories.UNITES_TRACAGE,
    ],
  };

  /**
   * Obtenir la catégorie principale d'une sous-catégorie
   */
  static getMainCategory(subCategory: string): string | null {
    for (const [mainCategory, subCategories] of Object.entries(this.CATEGORY_MAPPING)) {
      if (subCategories.includes(subCategory)) {
        return mainCategory;
      }
    }
    return null;
  }

  /**
   * Obtenir les sous-catégories d'une catégorie principale
   */
  static getSubCategories(mainCategory: string): readonly string[] {
    return this.CATEGORY_MAPPING[mainCategory] || [];
  }

  /**
   * Vérifier si une catégorie est valide
   */
  static isValidCategory(category: string): boolean {
    return this.ALL_CATEGORIES.includes(category);
  }

  /**
   * Vérifier si une catégorie est une catégorie principale
   */
  static isMainCategory(category: string): boolean {
    return this.MAIN_CATEGORIES.includes(category);
  }

  /**
   * Obtenir toutes les catégories dans une structure hiérarchique
   */
  static getCategoryHierarchy(): Record<string, readonly string[]> {
    return this.CATEGORY_MAPPING;
  }
}

export default AirsoftCategories;
