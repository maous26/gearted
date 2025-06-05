"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const logger_1 = require("../utils/logger");
const connectDB = async () => {
    try {
        const uri = process.env.DB_URI || 'mongodb://localhost:27017/gearted';
        await mongoose_1.default.connect(uri);
        logger_1.logger.info('Connexion à MongoDB établie');
    }
    catch (error) {
        logger_1.logger.error(`Erreur de connexion à MongoDB: ${error instanceof Error ? error.message : String(error)}`);
        process.exit(1);
    }
};
exports.default = connectDB;
