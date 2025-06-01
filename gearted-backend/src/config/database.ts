import mongoose from 'mongoose';
import { logger } from '../utils/logger';

// Configuration Mongoose
mongoose.set('strictQuery', false);

// Options de connexion recommandées
const mongooseOptions = {
  maxPoolSize: 10, // Nombre maximum de connexions dans le pool
  serverSelectionTimeoutMS: 5000, // Timeout de 5s pour la sélection du serveur
  socketTimeoutMS: 45000, // Timeout de 45s pour les sockets
};

const connectDB = async (): Promise<void> => {
  try {
    // Utiliser DB_URI (comme dans votre .env) au lieu de MONGO_URI
    const uri = process.env.DB_URI;
    
    if (!uri) {
      throw new Error('DB_URI n\'est pas défini dans les variables d\'environnement');
    }
    
    // Connexion avec options
    await mongoose.connect(uri, mongooseOptions);
    
    // Événements de connexion
    mongoose.connection.on('connected', () => {
      logger.info('✅ Connexion à MongoDB Atlas établie');
    });
    
    mongoose.connection.on('error', (err) => {
      logger.error(`❌ Erreur MongoDB: ${err}`);
    });
    
    mongoose.connection.on('disconnected', () => {
      logger.warn('⚠️ Déconnexion de MongoDB');
    });
    
    // Gestion propre de la fermeture
    process.on('SIGINT', async () => {
      await mongoose.connection.close();
      logger.info('Connexion MongoDB fermée suite à l\'arrêt de l\'application');
      process.exit(0);
    });
    
  } catch (error) {
    logger.error(`❌ Erreur de connexion à MongoDB: ${error instanceof Error ? error.message : String(error)}`);
    process.exit(1);
  }
};

// Fonction utilitaire pour vérifier l'état de la connexion
export const isConnected = (): boolean => {
  return mongoose.connection.readyState === 1;
};

// Fonction pour obtenir des statistiques de connexion
export const getConnectionStats = () => {
  const { readyState } = mongoose.connection;
  const states = {
    0: 'Déconnecté',
    1: 'Connecté',
    2: 'En cours de connexion',
    3: 'En cours de déconnexion',
  };
  
  return {
    status: states[readyState as keyof typeof states] || 'Inconnu',
    readyState,
    host: mongoose.connection.host,
    name: mongoose.connection.name,
  };
};

export default connectDB;