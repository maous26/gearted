import { logger } from '../utils/logger';
import AirsoftCategories from '../constants/airsoft-categories';

/**
 * Service for tracking and analyzing category usage patterns
 */
class CategoryAnalyticsService {
  private static instance: CategoryAnalyticsService;

  private constructor() {}

  public static getInstance(): CategoryAnalyticsService {
    if (!CategoryAnalyticsService.instance) {
      CategoryAnalyticsService.instance = new CategoryAnalyticsService();
    }
    return CategoryAnalyticsService.instance;
  }

  /**
   * Track category selection in search
   */
  async trackCategorySearch(category: string, userId?: string, resultCount?: number): Promise<void> {
    try {
      const isMainCategory = AirsoftCategories.isMainCategory(category);
      const mainCategory = isMainCategory ? category : AirsoftCategories.getMainCategory(category);

      // Store category search analytics
      const analyticsEvent = {
        eventType: 'category_search',
        userId,
        timestamp: new Date(),
        properties: {
          category,
          isMainCategory,
          mainCategory,
          resultCount: resultCount || 0,
          hasResults: (resultCount || 0) > 0
        }
      };

      // In a real implementation, this would be stored in analytics database
      logger.info(`Category search tracked: ${category} - Results: ${resultCount} - User: ${userId}`);
      
    } catch (error) {
      logger.error(`Failed to track category search: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  /**
   * Track category selection in listing creation
   */
  async trackCategoryListing(category: string, userId: string, listingId: string): Promise<void> {
    try {
      const isMainCategory = AirsoftCategories.isMainCategory(category);
      const mainCategory = isMainCategory ? category : AirsoftCategories.getMainCategory(category);

      const analyticsEvent = {
        eventType: 'category_listing_created',
        userId,
        timestamp: new Date(),
        properties: {
          category,
          isMainCategory,
          mainCategory,
          listingId
        }
      };

      logger.info(`Category listing tracked: ${category} - Listing: ${listingId} - User: ${userId}`);
      
    } catch (error) {
      logger.error(`Failed to track category listing: ${error instanceof Error ? error.message : String(error)}`);
    }
  }

  /**
   * Get category popularity statistics
   */
  async getCategoryPopularity(): Promise<any> {
    try {
      // In a real implementation, this would query the analytics database
      // For now, return mock data structure
      return {
        mostPopularMainCategories: [
          { category: 'Répliques Airsoft', count: 1250, percentage: 35.2 },
          { category: 'Accessoires de réplique', count: 890, percentage: 25.1 },
          { category: 'Équipement de protection', count: 634, percentage: 17.9 },
          { category: 'Tenues et camouflages', count: 445, percentage: 12.5 },
          { category: 'Pièces internes et upgrade', count: 223, percentage: 6.3 },
          { category: 'Communication & électronique', count: 67, percentage: 1.9 },
          { category: 'Outils et maintenance', count: 41, percentage: 1.1 }
        ],
        mostPopularSubCategories: [
          { category: 'Répliques longues - AEG', count: 567, mainCategory: 'Répliques Airsoft' },
          { category: 'Répliques de poing - Gaz', count: 443, mainCategory: 'Répliques Airsoft' },
          { category: 'Chargeurs', count: 332, mainCategory: 'Accessoires de réplique' },
          { category: 'Gilets tactiques / Chest Rigs', count: 234, mainCategory: 'Équipement de protection' },
          { category: 'Organes de visée (Red Dot, lunettes, etc.)', count: 198, mainCategory: 'Accessoires de réplique' }
        ],
        totalCategorizedListings: 3550,
        lastUpdated: new Date()
      };
    } catch (error) {
      logger.error(`Failed to get category popularity: ${error instanceof Error ? error.message : String(error)}`);
      throw error;
    }
  }

  /**
   * Get category conversion rates (search to listing creation)
   */
  async getCategoryConversionRates(): Promise<any> {
    try {
      // Mock data - in real implementation, calculate from analytics
      return {
        conversionByMainCategory: [
          { category: 'Répliques Airsoft', searchCount: 2450, listingCount: 1250, conversionRate: 51.0 },
          { category: 'Accessoires de réplique', searchCount: 1780, listingCount: 890, conversionRate: 50.0 },
          { category: 'Équipement de protection', searchCount: 1456, listingCount: 634, conversionRate: 43.5 },
          { category: 'Tenues et camouflages', searchCount: 1023, listingCount: 445, conversionRate: 43.5 },
          { category: 'Pièces internes et upgrade', searchCount: 667, listingCount: 223, conversionRate: 33.4 },
          { category: 'Communication & électronique', searchCount: 234, listingCount: 67, conversionRate: 28.6 },
          { category: 'Outils et maintenance', searchCount: 156, listingCount: 41, conversionRate: 26.3 }
        ],
        averageConversionRate: 42.3,
        lastCalculated: new Date()
      };
    } catch (error) {
      logger.error(`Failed to get category conversion rates: ${error instanceof Error ? error.message : String(error)}`);
      throw error;
    }
  }

  /**
   * Get trending categories (categories with increasing usage)
   */
  async getTrendingCategories(days: number = 30): Promise<any> {
    try {
      // Mock trending data
      return {
        trendingUp: [
          { 
            category: 'Caméras (GoPro, tactiques)', 
            mainCategory: 'Communication & électronique',
            growth: 156.7,
            currentCount: 45,
            previousCount: 17
          },
          { 
            category: 'Unités de traçage lumineuses (tracer units)', 
            mainCategory: 'Communication & électronique',
            growth: 89.2,
            currentCount: 34,
            previousCount: 18
          },
          { 
            category: 'Répliques longues - GBB', 
            mainCategory: 'Répliques Airsoft',
            growth: 67.3,
            currentCount: 123,
            previousCount: 73
          }
        ],
        trendingDown: [
          { 
            category: 'Répliques de poing - Spring', 
            mainCategory: 'Répliques Airsoft',
            decline: -23.4,
            currentCount: 45,
            previousCount: 59
          }
        ],
        analysisPerod: `${days} days`,
        lastAnalysis: new Date()
      };
    } catch (error) {
      logger.error(`Failed to get trending categories: ${error instanceof Error ? error.message : String(error)}`);
      throw error;
    }
  }

  /**
   * Get category usage by time period
   */
  async getCategoryUsageByTime(startDate: Date, endDate: Date): Promise<any> {
    try {
      // Mock time-based usage data
      const daysDiff = Math.ceil((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24));
      
      return {
        period: {
          start: startDate,
          end: endDate,
          days: daysDiff
        },
        dailyUsage: AirsoftCategories.MAIN_CATEGORIES.map(category => ({
          category,
          averageDaily: Math.floor(Math.random() * 50) + 10,
          totalPeriod: Math.floor(Math.random() * 500) + 100,
          peakDay: new Date(startDate.getTime() + Math.random() * (endDate.getTime() - startDate.getTime()))
        })),
        totalUsage: Math.floor(Math.random() * 5000) + 2000
      };
    } catch (error) {
      logger.error(`Failed to get category usage by time: ${error instanceof Error ? error.message : String(error)}`);
      throw error;
    }
  }

  /**
   * Suggest categories based on listing title and description
   */
  async suggestCategories(title: string, description: string): Promise<string[]> {
    try {
      const suggestions: string[] = [];
      const combinedText = `${title} ${description}`.toLowerCase();

      // Keyword-based category suggestions
      const categoryKeywords = {
        'Répliques longues - AEG': ['aeg', 'rifle', 'fusil', 'm4', 'ak', 'électrique'],
        'Répliques de poing - Gaz': ['pistolet', 'gbb', 'glock', 'beretta', 'gaz'],
        'Répliques de poing - Spring': ['spring', 'ressort', 'manuel'],
        'Gilets tactiques / Chest Rigs': ['gilet', 'tactique', 'chest rig', 'porte plaque'],
        'Masques': ['masque', 'protection visage', 'mesh'],
        'Chargeurs': ['chargeur', 'magazine', 'mag'],
        'Organes de visée (Red Dot, lunettes, etc.)': ['red dot', 'lunette', 'visée', 'scope', 'aimpoint'],
        'Gearbox (mécanique AEG)': ['gearbox', 'mécanique', 'v2', 'v3'],
        'Talkies-Walkies': ['talkie', 'radio', 'baofeng', 'communication']
      };

      for (const [category, keywords] of Object.entries(categoryKeywords)) {
        const matchCount = keywords.filter(keyword => combinedText.includes(keyword)).length;
        if (matchCount > 0) {
          suggestions.push(category);
        }
      }

      // Limit to top 3 suggestions
      return suggestions.slice(0, 3);
    } catch (error) {
      logger.error(`Failed to suggest categories: ${error instanceof Error ? error.message : String(error)}`);
      return [];
    }
  }
}

// Export singleton instance
export const categoryAnalyticsService = CategoryAnalyticsService.getInstance();
export default categoryAnalyticsService;
