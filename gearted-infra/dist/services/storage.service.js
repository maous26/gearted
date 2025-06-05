"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getSignedUrlForDownload = exports.deleteFromS3 = exports.uploadToS3 = exports.upload = void 0;
const client_s3_1 = require("@aws-sdk/client-s3");
const s3_request_presigner_1 = require("@aws-sdk/s3-request-presigner");
const multer_1 = __importDefault(require("multer"));
const path_1 = __importDefault(require("path"));
const uuid_1 = require("uuid");
const sharp_1 = __importDefault(require("sharp"));
const logger_1 = require("../utils/logger");
// Configuration S3 Client v3
const s3Client = new client_s3_1.S3Client({
    region: process.env.AWS_REGION || 'eu-north-1',
    credentials: {
        accessKeyId: process.env.AWS_ACCESS_KEY,
        secretAccessKey: process.env.AWS_SECRET_KEY
    }
});
// Configuration pour le stockage local (temporaire avant upload S3)
const storage = multer_1.default.memoryStorage();
// Filtre pour accepter uniquement les images
const fileFilter = (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
    if (allowedTypes.includes(file.mimetype)) {
        cb(null, true);
    }
    else {
        cb(new Error('Type de fichier non supporté. Utilisez JPG, PNG ou WEBP.'), false);
    }
};
// Configuration de multer
exports.upload = (0, multer_1.default)({
    storage,
    limits: { fileSize: 10 * 1024 * 1024 },
    fileFilter
});
// Compression et redimensionnement d'image
const optimizeImage = async (file, options = { quality: 80, maxWidth: 1200 }) => {
    try {
        const transformer = (0, sharp_1.default)(file.buffer)
            .resize({
            width: options.maxWidth,
            height: undefined,
            fit: 'inside',
            withoutEnlargement: true
        });
        // Appliquer le format et la qualité selon le type MIME
        switch (file.mimetype) {
            case 'image/jpeg':
            case 'image/jpg':
                return await transformer.jpeg({ quality: options.quality }).toBuffer();
            case 'image/png':
                return await transformer.png({ compressionLevel: 9 }).toBuffer();
            case 'image/webp':
                return await transformer.webp({ quality: options.quality }).toBuffer();
            default:
                return await transformer.jpeg({ quality: options.quality }).toBuffer();
        }
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de l'optimisation de l'image: ${error instanceof Error ? error.message : String(error)}`);
        return file.buffer; // Fallback au buffer original en cas d'erreur
    }
};
// Upload vers S3 avec compression (sans ACL)
const uploadToS3 = async (file, userId) => {
    try {
        // Comprimer l'image
        const optimizedBuffer = await optimizeImage(file);
        // Générer un nom de fichier unique
        const extension = path_1.default.extname(file.originalname).toLowerCase();
        const fileName = `${(0, uuid_1.v4)()}${extension}`;
        // Déterminer le type MIME correct
        let contentType = file.mimetype;
        if (extension === '.jpg' || extension === '.jpeg')
            contentType = 'image/jpeg';
        else if (extension === '.png')
            contentType = 'image/png';
        else if (extension === '.webp')
            contentType = 'image/webp';
        // Upload vers S3 (sans ACL)
        const uploadParams = {
            Bucket: process.env.AWS_S3_BUCKET || 'gearted-images',
            Key: fileName,
            Body: optimizedBuffer,
            ContentType: contentType
        };
        await s3Client.send(new client_s3_1.PutObjectCommand(uploadParams));
        // Construire l'URL publique
        const publicUrl = `https://${uploadParams.Bucket}.s3.${process.env.AWS_REGION || 'eu-north-1'}.amazonaws.com/${fileName}`;
        // Enregistrer la référence dans la base de données (à implémenter)
        if (userId) {
            await trackImageUpload(publicUrl, userId);
        }
        return publicUrl;
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de l'upload vers S3: ${error instanceof Error ? error.message : String(error)}`);
        throw error;
    }
};
exports.uploadToS3 = uploadToS3;
// Supprimer de S3
const deleteFromS3 = async (imageUrl) => {
    try {
        // Extraire le nom du fichier de l'URL
        const key = imageUrl.split('/').pop();
        if (!key) {
            throw new Error('Impossible d\'extraire la clé de l\'URL');
        }
        const deleteParams = {
            Bucket: process.env.AWS_S3_BUCKET || 'gearted-images',
            Key: key
        };
        await s3Client.send(new client_s3_1.DeleteObjectCommand(deleteParams));
        // Supprimer la référence dans la base de données (à implémenter)
        await removeImageReference(imageUrl);
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la suppression de S3: ${error instanceof Error ? error.message : String(error)}`);
        throw error;
    }
};
exports.deleteFromS3 = deleteFromS3;
// Générer une URL signée avec expiration
const getSignedUrlForDownload = async (imageUrl, expiresInSeconds = 3600) => {
    try {
        // Extraire le nom du fichier de l'URL
        const key = imageUrl.split('/').pop();
        if (!key) {
            throw new Error('Impossible d\'extraire la clé de l\'URL');
        }
        const command = new client_s3_1.GetObjectCommand({
            Bucket: process.env.AWS_S3_BUCKET || 'gearted-images',
            Key: key
        });
        return await (0, s3_request_presigner_1.getSignedUrl)(s3Client, command, { expiresIn: expiresInSeconds });
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de la génération de l'URL signée: ${error instanceof Error ? error.message : String(error)}`);
        throw error;
    }
};
exports.getSignedUrlForDownload = getSignedUrlForDownload;
// Fonctions de suivi des images (à implémenter avec un modèle)
const trackImageUpload = async (imageUrl, userId) => {
    // TODO: Implémenter avec le modèle ImageReference
    logger_1.logger.info(`Image uploaded: ${imageUrl} by user ${userId}`);
};
const removeImageReference = async (imageUrl) => {
    // TODO: Implémenter avec le modèle ImageReference
    logger_1.logger.info(`Image reference removed: ${imageUrl}`);
};
