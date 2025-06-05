import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import User from '../../models/user.model';
import { logger } from '../../utils/logger';

export const authMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  try {
    // Récupérer le token du header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Accès non autorisé. Token manquant',
      });
    }

    const token = authHeader.split(' ')[1];

    // Vérifier le token
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'default_secret');
    
    // Récupérer l'utilisateur complet
    const user = await User.findById((decoded as any).id).select('-password');
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Utilisateur non trouvé',
      });
    }
    
    // Ajouter l'utilisateur à la requête
    (req as any).userId = user._id.toString();
    (req as any).user = user;
    
    next();
  } catch (error) {
    logger.error(`Erreur d'authentification: ${error instanceof Error ? error.message : String(error)}`);
    return res.status(401).json({
      success: false,
      message: 'Accès non autorisé. Token invalide',
    });
  }
};
