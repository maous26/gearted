"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getMe = exports.login = exports.register = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const user_model_1 = __importDefault(require("../models/user.model"));
const logger_1 = require("../utils/logger");
// Enregistrement d'un nouvel utilisateur
const register = async (req, res, next) => {
    try {
        const { username, email, password } = req.body;
        // Vérifier si l'utilisateur existe déjà
        const existingUser = await user_model_1.default.findOne({
            $or: [{ email: email }, { username: username }]
        });
        if (existingUser) {
            return res.status(400).json({
                success: false,
                message: 'Cet email ou nom d\'utilisateur est déjà utilisé',
            });
        }
        // Créer un nouvel utilisateur
        const user = new user_model_1.default({
            username,
            email,
            password,
        });
        await user.save();
        // Générer un token JWT
        const token = jsonwebtoken_1.default.sign({ id: user._id }, process.env.JWT_SECRET || 'default_secret', { expiresIn: process.env.JWT_EXPIRATION || '24h' });
        // Réponse sans le mot de passe
        res.status(201).json({
            success: true,
            token,
            user: {
                id: user._id,
                username: user.username,
                email: user.email,
                profileImage: user.profileImage,
                rating: user.rating,
                salesCount: user.salesCount,
                createdAt: user.createdAt,
            },
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de l'enregistrement: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.register = register;
// Connexion d'un utilisateur
const login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        // Trouver l'utilisateur par email
        const user = await user_model_1.default.findOne({ email }).select('+password');
        if (!user) {
            return res.status(401).json({
                success: false,
                message: 'Email ou mot de passe incorrect',
            });
        }
        // Vérifier le mot de passe
        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            return res.status(401).json({
                success: false,
                message: 'Email ou mot de passe incorrect',
            });
        }
        // Générer un token JWT
        const token = jsonwebtoken_1.default.sign({ id: user._id }, process.env.JWT_SECRET || 'default_secret', { expiresIn: process.env.JWT_EXPIRATION || '24h' });
        // Réponse sans le mot de passe
        res.status(200).json({
            success: true,
            token,
            user: {
                id: user._id,
                username: user.username,
                email: user.email,
                profileImage: user.profileImage,
                rating: user.rating,
                salesCount: user.salesCount,
                createdAt: user.createdAt,
            },
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la connexion: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.login = login;
// Obtenir les informations de l'utilisateur connecté
const getMe = async (req, res, next) => {
    try {
        // L'ID de l'utilisateur est extrait du middleware d'authentification
        const userId = req.userId;
        const user = await user_model_1.default.findById(userId);
        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'Utilisateur non trouvé',
            });
        }
        res.status(200).json({
            success: true,
            user: {
                id: user._id,
                username: user.username,
                email: user.email,
                profileImage: user.profileImage,
                rating: user.rating,
                salesCount: user.salesCount,
                createdAt: user.createdAt,
            },
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la récupération du profil: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.getMe = getMe;
