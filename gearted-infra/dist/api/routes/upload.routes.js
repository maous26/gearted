"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const storage_service_1 = require("../../services/storage.service");
const upload_controller_1 = require("../../controllers/upload.controller");
const auth_middleware_1 = require("../middlewares/auth.middleware");
const router = (0, express_1.Router)();
// Route pour uploader une ou plusieurs images
router.post('/', auth_middleware_1.authMiddleware, storage_service_1.upload.array('images', 8), // Max 8 images
upload_controller_1.uploadImages);
// Route pour supprimer une image
router.delete('/', auth_middleware_1.authMiddleware, upload_controller_1.deleteImage);
exports.default = router;
