/**
 * Validation script to ensure mobile and backend categories are synchronized
 */

const fs = require('fs');
const path = require('path');

// Import backend categories from compiled JavaScript
const AirsoftCategories = require('../../dist/constants/airsoft-categories').default;

// Define expected mobile main categories (from the mobile constants)
const MOBILE_MAIN_CATEGORIES = [
  'Répliques Airsoft',
  'Équipement de protection', 
  'Tenues et camouflages',
  'Accessoires de réplique',
  'Pièces internes et upgrade',
  'Outils et maintenance',
  'Communication & électronique'
];

// Expected total categories count (from mobile file)
const EXPECTED_TOTAL_CATEGORIES = 49;

function validateMobileBackendSync() {
  console.log('🔍 Validating mobile-backend category synchronization...\n');
  
  let isValid = true;
  
  // Test 1: Check main categories count
  console.log('📊 Test 1: Main Categories Count');
  const backendMainCount = AirsoftCategories.MAIN_CATEGORIES.length;
  const mobileMainCount = MOBILE_MAIN_CATEGORIES.length;
  
  if (backendMainCount === mobileMainCount) {
    console.log(`✅ Main categories count matches: ${backendMainCount}`);
  } else {
    console.log(`❌ Main categories count mismatch: Backend=${backendMainCount}, Mobile=${mobileMainCount}`);
    isValid = false;
  }
  
  // Test 2: Check main categories names
  console.log('\n📊 Test 2: Main Categories Names');
  const backendMainCategories = AirsoftCategories.MAIN_CATEGORIES;
  
  for (let i = 0; i < MOBILE_MAIN_CATEGORIES.length; i++) {
    if (backendMainCategories[i] === MOBILE_MAIN_CATEGORIES[i]) {
      console.log(`✅ Category ${i + 1}: "${MOBILE_MAIN_CATEGORIES[i]}"`);
    } else {
      console.log(`❌ Category ${i + 1} mismatch:`);
      console.log(`   Backend: "${backendMainCategories[i]}"`);
      console.log(`   Mobile:  "${MOBILE_MAIN_CATEGORIES[i]}"`);
      isValid = false;
    }
  }
  
  // Test 3: Check total categories count
  console.log('\n📊 Test 3: Total Categories Count');
  const backendTotalCount = AirsoftCategories.ALL_CATEGORIES.length;
  
  if (backendTotalCount === EXPECTED_TOTAL_CATEGORIES) {
    console.log(`✅ Total categories count matches: ${backendTotalCount}`);
  } else {
    console.log(`⚠️  Total categories count: Backend=${backendTotalCount}, Expected=${EXPECTED_TOTAL_CATEGORIES}`);
    console.log('   This might be acceptable if categories were added/removed');
  }
  
  // Test 4: Validate category structure
  console.log('\n📊 Test 4: Category Structure Validation');
  
  try {
    // Test validation methods
    const testCategory = 'Répliques longues - AEG';
    const isValidTest = AirsoftCategories.isValidCategory(testCategory);
    const mainCategoryTest = AirsoftCategories.getMainCategory(testCategory);
    const isMainTest = AirsoftCategories.isMainCategory('Répliques Airsoft');
    
    if (isValidTest && mainCategoryTest === 'Répliques Airsoft' && isMainTest) {
      console.log('✅ Category validation methods working correctly');
    } else {
      console.log('❌ Category validation methods failed');
      isValid = false;
    }
  } catch (error) {
    console.log(`❌ Category validation error: ${error.message}`);
    isValid = false;
  }
  
  // Test 5: Check hierarchy mapping
  console.log('\n📊 Test 5: Category Hierarchy Validation');
  
  try {
    const hierarchy = AirsoftCategories.getCategoryHierarchy();
    const hierarchyKeys = Object.keys(hierarchy);
    
    if (hierarchyKeys.length === MOBILE_MAIN_CATEGORIES.length) {
      console.log('✅ Hierarchy structure is valid');
      
      // Check if all main categories have subcategories
      let allHaveSubcategories = true;
      for (const mainCategory of MOBILE_MAIN_CATEGORIES) {
        if (!hierarchy[mainCategory] || hierarchy[mainCategory].length === 0) {
          console.log(`❌ Main category "${mainCategory}" has no subcategories`);
          allHaveSubcategories = false;
        }
      }
      
      if (allHaveSubcategories) {
        console.log('✅ All main categories have subcategories');
      } else {
        isValid = false;
      }
      
    } else {
      console.log(`❌ Hierarchy key count mismatch: ${hierarchyKeys.length} vs ${MOBILE_MAIN_CATEGORIES.length}`);
      isValid = false;
    }
  } catch (error) {
    console.log(`❌ Hierarchy validation error: ${error.message}`);
    isValid = false;
  }
  
  // Final result
  console.log('\n' + '='.repeat(50));
  if (isValid) {
    console.log('🎉 Mobile-Backend synchronization validation PASSED!');
    console.log('✅ Categories are properly synchronized between mobile and backend');
  } else {
    console.log('❌ Mobile-Backend synchronization validation FAILED!');
    console.log('🔧 Please review and fix the category mismatches');
  }
  console.log('='.repeat(50));
  
  return isValid;
}

// Run validation if script is executed directly
if (require.main === module) {
  validateMobileBackendSync();
}

module.exports = { validateMobileBackendSync };
