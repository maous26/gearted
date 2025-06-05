"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_middleware_1 = require("../middlewares/auth.middleware");
const router = (0, express_1.Router)();
// Route de test
router.get('/test', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'User routes working',
    });
});
// Route protégée
router.get('/profile', auth_middleware_1.authMiddleware, (req, res) => {
    res.status(200).json({
        success: true,
        message: 'Profile route protected',
        userId: req.userId,
    });
});
exports.default = router;
