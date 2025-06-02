import { Router } from 'express';
import { 
  getMainCategories,
  getAllCategories,
  getCategoryHierarchy,
  getSubCategories,
  validateCategory,
  getCategoryStats,
  suggestCategories,
  getTrendingCategories
} from '../../controllers/categories.controller';

const router = Router();

// Routes publiques pour les catégories
router.get('/', getAllCategories);
router.get('/main', getMainCategories);
router.get('/hierarchy', getCategoryHierarchy);
router.get('/stats', getCategoryStats);
router.get('/trending', getTrendingCategories);
router.get('/main/:mainCategory/subcategories', getSubCategories);
router.get('/validate/:category', validateCategory);
router.post('/suggest', suggestCategories);

export default router;
