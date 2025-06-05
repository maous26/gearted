"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authMiddleware = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const logger_1 = require("../../utils/logger");
const authMiddleware = (req, res, next) => {
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
        const decoded = jsonwebtoken_1.default.verify(token, process.env.JWT_SECRET || 'default_secret');
        // Ajouter l'ID utilisateur à la requête
        req.userId = decoded.id;
        next();
    }
    catch (error) {
        logger_1.logger.error(`Erreur d'authentification: ${error instanceof Error ? error.message : String(error)}`);
        return res.status(401).json({
            success: false,
            message: 'Accès non autorisé. Token invalide',
        });
    }
};
exports.authMiddleware = authMiddleware;
