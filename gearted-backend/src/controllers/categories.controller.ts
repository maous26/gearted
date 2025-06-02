import { Request, Response, NextFunction } from 'express';
import AirsoftCategories from '../constants/airsoft-categories';
import { logger } from '../utils/logger';
import categoryAnalyticsService from '../services/category-analytics.service';

/**
 * Obtenir toutes les catégories principales
 */
export const getMainCategories = async (req: Request, res: Response, next: NextFunction) => {
  try {
    res.status(200).json({
      success: true,
      categories: AirsoftCategories.MAIN_CATEGORIES,
    });
  } catch (error) {
    logger.error(`Erreur lors de la récupération des catégories principales: ${error instanceof Error ? error.message : String(error)}`);
    next(error);
  }
};

/**
 * Obtenir toutes les catégories et sous-catégories
 */
export const getAllCategories = async (req: Request, res: Response, next: NextFunction) => {
  try {
    res.status(200).json({
      success: true,
      categories: AirsoftCategories.ALL_CATEGORIES,
    });
  } catch (error) {
    logger.error(`Erreur lors de la récupération de toutes les catégories: ${error instanceof Error ? error.message : String(error)}`);
    next(error);
  }
};

/**
 * Obtenir la hiérarchie complète des catégories
 */
export const getCategoryHierarchy = async (req: Request, res: Response, next: NextFunction) => {
  try {
    res.status(200).json({
      success: true,
      hierarchy: AirsoftCategories.getCategoryHierarchy(),
      mainCategories: AirsoftCategories.MAIN_CATEGORIES,
    });
  } catch (error) {
    logger.error(`Erreur lors de la récupération de la hiérarchie des catégories: ${error instanceof Error ? error.message : String(error)}`);
    next(error);
  }
};

/**
 * Obtenir les sous-catégories d'une catégorie principale
 */
export const getSubCategories = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { mainCategory } = req.params;
    
    if (!AirsoftCategories.isMainCategory(mainCategory)) {
      return res.status(400).json({
        success: false,
        message: 'Catégorie principale non valide',
      });
    }

    const subCategories = AirsoftCategories.getSubCategories(mainCategory);

    res.status(200).json({
      success: true,
      mainCategory,
      subCategories,
    });
  } catch (error) {
    logger.error(`Erreur lors de la récupération des sous-catégories: ${error instanceof Error ? error.message : String(error)}`);
    next(error);
  }
};

/**
 * Valider une catégorie
 */
export const validateCategory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { category } = req.params;
    
    const isValid = AirsoftCategories.isValidCategory(category);
    const isMain = AirsoftCategories.isMainCategory(category);
    const mainCategory = AirsoftCategories.getMainCategory(category);

    res.status(200).json({
      success: true,
      category,
      isValid,
      isMainCategory: isMain,
      mainCategory: mainCategory || null,
    });
  } catch (error) {
    logger.error(`Erreur lors de la validation de la catégorie: ${error instanceof Error ? error.message : String(error)}`);
    next(error);
  }
};

/**
 * Obtenir les statistiques par catégorie
 */
export const getCategoryStats = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const popularity = await categoryAnalyticsService.getCategoryPopularity();
    const conversionRates = await categoryAnalyticsService.getCategoryConversionRates();
    const trending = await categoryAnalyticsService.getTrendingCategories();

    const stats = {
      totalCategories: AirsoftCategories.ALL_CATEGORIES.length,
      mainCategories: AirsoftCategories.MAIN_CATEGORIES.length,
      popularity,
      conversionRates,
      trending,
      lastUpdated: new Date()
    };

    res.status(200).json({
      success: true,
      stats,
    });
  } catch (error) {
    logger.error(`Erreur lors de la récupération des statistiques des catégories: ${error instanceof Error ? error.message : String(error)}`);
    next(error);
  }
};

/**
 * Suggérer des catégories basées sur le titre et la description
 */
export const suggestCategories = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { title = '', description = '' } = req.body;

    if (!title && !description) {
      return res.status(400).json({
        success: false,
        message: 'Titre ou description requis pour les suggestions',
      });
    }

    const suggestions = await categoryAnalyticsService.suggestCategories(title, description);

    res.status(200).json({
      success: true,
      suggestions,
      input: { title, description },
    });
  } catch (error) {
    logger.error(`Erreur lors de la suggestion des catégories: ${error instanceof Error ? error.message : String(error)}`);
    next(error);
  }
};

/**
 * Obtenir les catégories tendances
 */
export const getTrendingCategories = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { days = 30 } = req.query;
    const trending = await categoryAnalyticsService.getTrendingCategories(Number(days));

    res.status(200).json({
      success: true,
      trending,
    });
  } catch (error) {
    logger.error(`Erreur lors de la récupération des catégories tendances: ${error instanceof Error ? error.message : String(error)}`);
    next(error);
  }
};
