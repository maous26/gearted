"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteImage = exports.uploadImages = void 0;
const storage_service_1 = require("../services/storage.service");
const logger_1 = require("../utils/logger");
// Upload d'une ou plusieurs images
const uploadImages = async (req, res, next) => {
    try {
        if (!req.files || req.files.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'Aucun fichier n\'a été envoyé',
            });
        }
        const files = req.files;
        const userId = req.userId; // Extract userId from authenticated request
        const uploadPromises = files.map(file => (0, storage_service_1.uploadToS3)(file, userId));
        const imageUrls = await Promise.all(uploadPromises);
        res.status(200).json({
            success: true,
            imageUrls,
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de l'upload d'images: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.uploadImages = uploadImages;
// Suppression d'une image
const deleteImage = async (req, res, next) => {
    try {
        const { imageUrl } = req.body;
        if (!imageUrl) {
            return res.status(400).json({
                success: false,
                message: 'URL de l\'image requise',
            });
        }
        await (0, storage_service_1.deleteFromS3)(imageUrl);
        res.status(200).json({
            success: true,
            message: 'Image supprimée avec succès',
        });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la suppression d'image: ${error instanceof Error ? error.message : String(error)}`);
        next(error);
    }
};
exports.deleteImage = deleteImage;
