// Ajouter ces lignes AU TOUT DÉBUT du fichier server.ts
import dotenv from 'dotenv';
dotenv.config();

// Le reste de vos imports
import app from './app';
import connectDB from './config/database';
import { logger } from './utils/logger';

const PORT = process.env.PORT || 3000;

// Vérifier les variables critiques
if (!process.env.DB_URI) {
  logger.error('❌ DB_URI manquant dans le fichier .env');
  process.exit(1);
}

// Démarrer le serveur
const startServer = async () => {
  try {
    await connectDB();
    
    app.listen(PORT, () => {
      logger.info(`🚀 Serveur démarré sur le port ${PORT}`);
      logger.info(`📁 Environment: ${process.env.NODE_ENV || 'development'}`);
    });
  } catch (error) {
    logger.error(`Erreur lors du démarrage du serveur: ${error instanceof Error ? error.message : String(error)}`);
    process.exit(1);
  }
};

startServer();