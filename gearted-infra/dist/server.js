"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const app_1 = __importDefault(require("./app"));
const database_1 = __importDefault(require("./config/database"));
const logger_1 = require("./utils/logger");
const PORT = process.env.PORT || 3000;
// Connexion à la base de données
(0, database_1.default)();
// Démarrage du serveur
const server = app_1.default.listen(PORT, () => {
    logger_1.logger.info(`Serveur démarré sur le port ${PORT}`);
});
// Gestion des erreurs non capturées
process.on('unhandledRejection', (err) => {
    logger_1.logger.error(`Erreur non capturée: ${err.message}`);
    server.close(() => process.exit(1));
});
