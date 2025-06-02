/**
 * Test suite for the comprehensive airsoft categories system
 */

const request = require('supertest');
const app = require('../src/app').default;
const AirsoftCategories = require('../src/constants/airsoft-categories').default;

describe('Airsoft Categories API', () => {
  
  describe('GET /api/categories', () => {
    it('should return all categories', async () => {
      const response = await request(app)
        .get('/api/categories')
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.categories).toBeInstanceOf(Array);
      expect(response.body.categories.length).toBeGreaterThan(40); // We have 40+ categories
    });
  });

  describe('GET /api/categories/main', () => {
    it('should return main categories only', async () => {
      const response = await request(app)
        .get('/api/categories/main')
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.categories).toHaveLength(7); // 7 main categories
      expect(response.body.categories).toContain('Répliques Airsoft');
      expect(response.body.categories).toContain('Équipement de protection');
    });
  });

  describe('GET /api/categories/hierarchy', () => {
    it('should return category hierarchy', async () => {
      const response = await request(app)
        .get('/api/categories/hierarchy')
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.hierarchy).toBeInstanceOf(Object);
      expect(response.body.mainCategories).toHaveLength(7);
      
      // Check that each main category has subcategories
      Object.keys(response.body.hierarchy).forEach(mainCategory => {
        expect(response.body.hierarchy[mainCategory]).toBeInstanceOf(Array);
        expect(response.body.hierarchy[mainCategory].length).toBeGreaterThan(0);
      });
    });
  });

  describe('GET /api/categories/main/:mainCategory/subcategories', () => {
    it('should return subcategories for valid main category', async () => {
      const response = await request(app)
        .get('/api/categories/main/Répliques Airsoft/subcategories')
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.mainCategory).toBe('Répliques Airsoft');
      expect(response.body.subCategories).toBeInstanceOf(Array);
      expect(response.body.subCategories.length).toBeGreaterThan(5);
    });

    it('should return error for invalid main category', async () => {
      const response = await request(app)
        .get('/api/categories/main/Invalid Category/subcategories')
        .expect(400);
      
      expect(response.body.success).toBe(false);
      expect(response.body.message).toContain('non valide');
    });
  });

  describe('GET /api/categories/validate/:category', () => {
    it('should validate correct category', async () => {
      const response = await request(app)
        .get('/api/categories/validate/Répliques longues - AEG')
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.isValid).toBe(true);
      expect(response.body.isMainCategory).toBe(false);
      expect(response.body.mainCategory).toBe('Répliques Airsoft');
    });

    it('should invalidate incorrect category', async () => {
      const response = await request(app)
        .get('/api/categories/validate/Invalid Category Name')
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.isValid).toBe(false);
      expect(response.body.mainCategory).toBe(null);
    });
  });

  describe('Category Constants Tests', () => {
    it('should have correct number of main categories', () => {
      expect(AirsoftCategories.MAIN_CATEGORIES).toHaveLength(7);
    });

    it('should have all required main categories', () => {
      const expectedMainCategories = [
        'Répliques Airsoft',
        'Équipement de protection',
        'Tenues et camouflages',
        'Accessoires de réplique',
        'Pièces internes et upgrade',
        'Outils et maintenance',
        'Communication & électronique'
      ];
      
      expectedMainCategories.forEach(category => {
        expect(AirsoftCategories.MAIN_CATEGORIES).toContain(category);
      });
    });

    it('should validate categories correctly', () => {
      // Test valid categories
      expect(AirsoftCategories.isValidCategory('Répliques longues - AEG')).toBe(true);
      expect(AirsoftCategories.isValidCategory('Gilets tactiques / Chest Rigs')).toBe(true);
      
      // Test invalid categories
      expect(AirsoftCategories.isValidCategory('Invalid Category')).toBe(false);
      expect(AirsoftCategories.isValidCategory('')).toBe(false);
    });

    it('should identify main categories correctly', () => {
      expect(AirsoftCategories.isMainCategory('Répliques Airsoft')).toBe(true);
      expect(AirsoftCategories.isMainCategory('Répliques longues - AEG')).toBe(false);
    });

    it('should get main category for subcategories', () => {
      expect(AirsoftCategories.getMainCategory('Répliques longues - AEG')).toBe('Répliques Airsoft');
      expect(AirsoftCategories.getMainCategory('Gilets tactiques / Chest Rigs')).toBe('Équipement de protection');
      expect(AirsoftCategories.getMainCategory('Invalid Category')).toBe(null);
    });

    it('should get subcategories for main categories', () => {
      const subCategories = AirsoftCategories.getSubCategories('Répliques Airsoft');
      expect(subCategories.length).toBeGreaterThan(5);
      expect(subCategories).toContain('Répliques longues - AEG');
      expect(subCategories).toContain('Répliques de poing - Gaz');
    });

    it('should have comprehensive category coverage', () => {
      // Ensure we have categories for all major airsoft equipment types
      const allCategories = AirsoftCategories.ALL_CATEGORIES;
      
      // Check for key category types
      expect(allCategories.some(cat => cat.includes('AEG'))).toBe(true);
      expect(allCategories.some(cat => cat.includes('GBB'))).toBe(true);
      expect(allCategories.some(cat => cat.includes('Spring'))).toBe(true);
      expect(allCategories.some(cat => cat.includes('Masques'))).toBe(true);
      expect(allCategories.some(cat => cat.includes('Uniformes'))).toBe(true);
      expect(allCategories.some(cat => cat.includes('Chargeurs'))).toBe(true);
      expect(allCategories.some(cat => cat.includes('Gearbox'))).toBe(true);
      expect(allCategories.some(cat => cat.includes('Talkies'))).toBe(true);
    });
  });

  describe('Category Integration with Listings', () => {
    // These tests would require actual database integration
    // For now, we test the structure and validation
    
    it('should have proper category validation structure', () => {
      // Test that categories can be used in listing validation
      const testCategories = [
        'Répliques longues - AEG',
        'Répliques de poing - Gaz',
        'Gilets tactiques / Chest Rigs',
        'Tenues et camouflages',
        'Gearbox (mécanique AEG)',
        'Talkies-Walkies'
      ];
      
      testCategories.forEach(category => {
        expect(AirsoftCategories.isValidCategory(category)).toBe(true);
      });
    });
  });
});

module.exports = {};
