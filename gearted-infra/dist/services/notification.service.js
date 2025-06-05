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
exports.sendPushNotification = exports.NotificationType = void 0;
const admin = __importStar(require("firebase-admin"));
const logger_1 = require("../utils/logger");
// Initialiser Firebase Admin si pas déjà fait
if (!admin.apps.length) {
    admin.initializeApp({
        credential: admin.credential.cert({
            projectId: process.env.FIREBASE_PROJECT_ID,
            clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
            privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\n/g, '\n')
        }),
    });
}
var NotificationType;
(function (NotificationType) {
    NotificationType["NEW_MESSAGE"] = "new_message";
    NotificationType["NEW_OFFER"] = "new_offer";
    NotificationType["LISTING_SOLD"] = "listing_sold";
    NotificationType["NEW_REVIEW"] = "new_review";
})(NotificationType = exports.NotificationType || (exports.NotificationType = {}));
const sendPushNotification = async (userId, title, body, type, data = {}) => {
    try {
        // Dans un cas réel, vous récupéreriez le token FCM de l'utilisateur depuis la base de données
        // const user = await User.findById(userId);
        // if (!user || !user.fcmToken) return;
        // Pour la démo, on suppose qu'on a un token
        const fcmToken = 'user_fcm_token_here';
        const message = {
            notification: {
                title,
                body
            },
            data: {
                ...data,
                type
            },
            token: fcmToken
        };
        await admin.messaging().send(message);
        logger_1.logger.info(`Notification envoyée à l'utilisateur ${userId}`);
    }
    catch (error) {
        logger_1.logger.error(`Erreur lors de l'envoi de la notification: ${error instanceof Error ? error.message : String(error)}`);
    }
};
exports.sendPushNotification = sendPushNotification;
