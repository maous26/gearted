/**
 * Migration script to update existing listings with new comprehensive airsoft categories
 * This script maps old category values to new standardized categories
 */

const { MongoClient } = require('mongodb');
require('dotenv').config();

// Mapping from old categories to new airsoft categories
const CATEGORY_MIGRATION_MAP = {
  // Old simple categories to new comprehensive ones
  'rifles': 'Répliques longues - AEG',
  'pistolets': 'Répliques de poing - Gaz',
  'accessoires': 'Accessoires de réplique',
  'équipement': 'Équipement de protection',
  'protection': 'Équipement de protection',
  'tenues': 'Tenues et camouflages',
  'pièces': 'Pièces internes et upgrade',
  'outils': 'Outils et maintenance',
  'communication': 'Communication & électronique',
  
  // English to French mapping
  'weapons': 'Répliques Airsoft',
  'gear': 'Équipement de protection',
  'clothing': 'Tenues et camouflages',
  'parts': 'Pièces internes et upgrade',
  'tools': 'Outils et maintenance',
  'electronics': 'Communication & électronique',
  
  // Generic fallbacks
  'autre': 'Accessoires de réplique',
  'divers': 'Accessoires de réplique',
  'other': 'Accessoires de réplique',
};

// Default category for unmapped items
const DEFAULT_CATEGORY = 'Accessoires de réplique';

async function migrateCategories() {
  const client = new MongoClient(process.env.DB_URI);
  
  try {
    await client.connect();
    console.log('✅ Connected to MongoDB');
    
    const db = client.db();
    const collection = db.collection('listings');
    
    // Get all listings
    const listings = await collection.find({}).toArray();
    console.log(`📊 Found ${listings.length} listings to potentially migrate`);
    
    let migratedCount = 0;
    let skippedCount = 0;
    const migrationLog = [];
    
    for (const listing of listings) {
      const oldCategory = listing.category;
      
      // Skip if already using new category system
      if (isNewCategory(oldCategory)) {
        skippedCount++;
        continue;
      }
      
      // Find new category mapping
      const newCategory = findNewCategory(oldCategory);
      
      // Update the listing
      await collection.updateOne(
        { _id: listing._id },
        { 
          $set: { 
            category: newCategory,
            // Add migration metadata
            migrationInfo: {
              oldCategory: oldCategory,
              newCategory: newCategory,
              migratedAt: new Date(),
              migrationVersion: '1.0'
            }
          }
        }
      );
      
      migratedCount++;
      migrationLog.push({
        id: listing._id,
        title: listing.title,
        oldCategory,
        newCategory
      });
      
      console.log(`🔄 Migrated: "${listing.title}" | ${oldCategory} → ${newCategory}`);
    }
    
    console.log('\n📈 Migration Summary:');
    console.log(`✅ Migrated: ${migratedCount} listings`);
    console.log(`⏭️  Skipped: ${skippedCount} listings (already using new categories)`);
    
    // Create index on new category field for better performance
    await collection.createIndex({ 'category': 1 }, { name: 'category_index' });
    console.log('📊 Created category index for improved performance');
    
    // Save migration log
    await db.collection('migration_logs').insertOne({
      migration: 'airsoft_categories_v1',
      executedAt: new Date(),
      migratedCount,
      skippedCount,
      migrationLog
    });
    
    console.log('\n🎉 Category migration completed successfully!');
    
  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    await client.close();
  }
}

function isNewCategory(category) {
  // Check if category contains French airsoft terminology
  const newCategoryIndicators = [
    'Répliques',
    'Équipement de protection',
    'Tenues et camouflages',
    'Accessoires de réplique',
    'Pièces internes',
    'Outils et maintenance',
    'Communication & électronique',
    'AEG',
    'GBB',
    'Spring'
  ];
  
  return newCategoryIndicators.some(indicator => 
    category.includes(indicator)
  );
}

function findNewCategory(oldCategory) {
  if (!oldCategory) return DEFAULT_CATEGORY;
  
  const categoryLower = oldCategory.toLowerCase();
  
  // Direct mapping
  if (CATEGORY_MIGRATION_MAP[categoryLower]) {
    return CATEGORY_MIGRATION_MAP[categoryLower];
  }
  
  // Keyword-based mapping
  if (categoryLower.includes('rifle') || categoryLower.includes('fusil') || categoryLower.includes('aeg')) {
    return 'Répliques longues - AEG';
  }
  
  if (categoryLower.includes('pistol') || categoryLower.includes('pistolet') || categoryLower.includes('gbb')) {
    return 'Répliques de poing - Gaz';
  }
  
  if (categoryLower.includes('masque') || categoryLower.includes('protection') || categoryLower.includes('gilet')) {
    return 'Équipement de protection';
  }
  
  if (categoryLower.includes('uniforme') || categoryLower.includes('tenue') || categoryLower.includes('camouflage')) {
    return 'Tenues et camouflages';
  }
  
  if (categoryLower.includes('chargeur') || categoryLower.includes('silencieux') || categoryLower.includes('red dot')) {
    return 'Accessoires de réplique';
  }
  
  if (categoryLower.includes('gearbox') || categoryLower.includes('moteur') || categoryLower.includes('piston')) {
    return 'Pièces internes et upgrade';
  }
  
  if (categoryLower.includes('outil') || categoryLower.includes('nettoyage') || categoryLower.includes('maintenance')) {
    return 'Outils et maintenance';
  }
  
  if (categoryLower.includes('radio') || categoryLower.includes('talkie') || categoryLower.includes('camera')) {
    return 'Communication & électronique';
  }
  
  // Default fallback
  return DEFAULT_CATEGORY;
}

// Execute migration
if (require.main === module) {
  migrateCategories()
    .then(() => {
      console.log('Migration script completed');
      process.exit(0);
    })
    .catch((error) => {
      console.error('Migration script failed:', error);
      process.exit(1);
    });
}

module.exports = { migrateCategories, CATEGORY_MIGRATION_MAP };
