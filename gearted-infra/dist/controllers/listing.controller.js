"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.markAsSold = exports.deleteListing = exports.updateListing = exports.createListing = exports.getListingById = exports.getListings = void 0;
const listing_model_1 = __importStar(require("../models/listing.model"));
const logger_1 = require("../utils/logger");
// Obtenir toutes les annonces avec pagination et filtrage
const getListings = async (req, res, next) => {
    try {
        const { page = 1, limit = 10, search = '', category = '', subcategory = '', condition = '', minPrice, maxPrice, isExchangeable, sortBy = 'createdAt', sortOrder = 'desc' } = req.query;
        // Construire le filtre
        const filter = {};
        // Recherche textuelle
        if (search) {
            filter.$text = { $search: search.toString() };
        }
        // Filtre par catégorie
        if (category) {
            filter.category = category;
        }
        // Filtre par sous-catégorie
        if (subcategory) {
            filter.subcategory = subcategory;
        }
        // Filtre par condition
        if (condition && Object.values(listing_model_1.ListingCondition).includes(condition)) {
            filter.condition = condition;
        }
        // Filtre par prix
        if (minPrice || maxPrice) {
            filter.price = {};
            if (minPrice)
                filter.price.$gte = Number(minPrice);
            if (maxPrice)
                filter.price.$lte = Number(maxPrice);
        }
        // Filtre par échange possible
        if (isExchangeable !== undefined) {
            filter.isExchangeable = isExchangeable === 'true';
        }
        // Ne pas inclure les annonces déjà vendues
        filter.isSold = false;
        // Pagination
        const pageNum = Number(page);
        const limitNum = Number(limit);
        const skip = (pageNum - 1) * limitNum;
        // Tri
        const sort = {};
        sort[sortBy] = sortOrder === 'desc' ? -1 : 1;
        // Exécuter la requête
        const listings = await listing_model_1.default.find(filter)
            .sort(sort)
            .skip(skip)
            .limit(limitNum)
            .populate('sellerId', 'username profileImage rating salesCount');
        // Compter le nombre total d'annonces
        const total = await listing_model_1.default.countDocuments(filter);
        res.status(200).json({
            success: true,
            count: listings.length,
            total,
            totalPages: Math.ceil(total / limitNum),
            currentPage: pageNum,
            listings,
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la récupération des annonces: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.getListings = getListings;
// Obtenir une annonce par son ID
const getListingById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const listing = await listing_model_1.default.findById(id)
            .populate('sellerId', 'username profileImage rating salesCount');
        if (!listing) {
            return res.status(404).json({
                success: false,
                message: 'Annonce non trouvée',
            });
        }
        res.status(200).json({
            success: true,
            listing,
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la récupération de l'annonce: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.getListingById = getListingById;
// Créer une nouvelle annonce
const createListing = async (req, res, next) => {
    try {
        const { title, description, price, imageUrls, condition, category, subcategory, tags, isExchangeable } = req.body;
        // L'ID du vendeur est extrait du middleware d'authentification
        const sellerId = req.userId;
        const listing = new listing_model_1.default({
            title,
            description,
            price,
            sellerId,
            imageUrls,
            condition,
            category,
            subcategory,
            tags,
            isExchangeable,
        });
        await listing.save();
        res.status(201).json({
            success: true,
            listing,
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la création de l'annonce: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.createListing = createListing;
// Mettre à jour une annonce
const updateListing = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { title, description, price, imageUrls, condition, category, tags, isExchangeable } = req.body;
        // Vérifier que l'annonce existe et appartient à l'utilisateur
        const listing = await listing_model_1.default.findById(id);
        if (!listing) {
            return res.status(404).json({
                success: false,
                message: 'Annonce non trouvée',
            });
        }
        // Vérifier que l'utilisateur est le propriétaire de l'annonce
        if (listing.sellerId.toString() !== req.userId) {
            return res.status(403).json({
                success: false,
                message: 'Vous n\'êtes pas autorisé à modifier cette annonce',
            });
        }
        // Mettre à jour l'annonce
        Object.assign(listing, {
            title,
            description,
            price,
            imageUrls,
            condition,
            category,
            tags,
            isExchangeable,
        });
        await listing.save();
        res.status(200).json({
            success: true,
            listing,
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la mise à jour de l'annonce: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.updateListing = updateListing;
// Supprimer une annonce
const deleteListing = async (req, res, next) => {
    try {
        const { id } = req.params;
        // Vérifier que l'annonce existe et appartient à l'utilisateur
        const listing = await listing_model_1.default.findById(id);
        if (!listing) {
            return res.status(404).json({
                success: false,
                message: 'Annonce non trouvée',
            });
        }
        // Vérifier que l'utilisateur est le propriétaire de l'annonce
        if (listing.sellerId.toString() !== req.userId) {
            return res.status(403).json({
                success: false,
                message: 'Vous n\'êtes pas autorisé à supprimer cette annonce',
            });
        }
        await listing_model_1.default.findByIdAndDelete(id);
        res.status(200).json({
            success: true,
            message: 'Annonce supprimée avec succès',
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la suppression de l'annonce: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.deleteListing = deleteListing;
// Marquer une annonce comme vendue
const markAsSold = async (req, res, next) => {
    try {
        const { id } = req.params;
        // Vérifier que l'annonce existe et appartient à l'utilisateur
        const listing = await listing_model_1.default.findById(id);
        if (!listing) {
            return res.status(404).json({
                success: false,
                message: 'Annonce non trouvée',
            });
        }
        // Vérifier que l'utilisateur est le propriétaire de l'annonce
        if (listing.sellerId.toString() !== req.userId) {
            return res.status(403).json({
                success: false,
                message: 'Vous n\'êtes pas autorisé à modifier cette annonce',
            });
        }
        // Marquer comme vendue
        listing.isSold = true;
        await listing.save();
        res.status(200).json({
            success: true,
            listing,
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors du marquage de l'annonce comme vendue: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.markAsSold = markAsSold;
