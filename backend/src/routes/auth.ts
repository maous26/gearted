import { Router } from 'express';
import { AuthController } from '../controllers/AuthController';
import { authenticate } from '../middleware/auth';
import { validateRequest } from '../middleware/validation';
import { authSchemas } from '../utils/validationSchemas';

const router = Router();

// Public routes
router.post('/register', validateRequest(authSchemas.register), AuthController.register);
router.post('/login', validateRequest(authSchemas.login), AuthController.login);
router.post('/refresh-token', validateRequest(authSchemas.refreshToken), AuthController.refreshToken);

// Protected routes
router.post('/logout', authenticate, AuthController.logout);
router.get('/profile', authenticate, AuthController.getProfile);

// Health check for auth service
router.get('/health', (req, res) => {
  res.json({ 
    success: true, 
    message: 'Auth service is running',
    timestamp: new Date().toISOString()
  });
});

export default router;