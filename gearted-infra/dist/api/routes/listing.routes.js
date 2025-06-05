"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const listing_controller_1 = require("../../controllers/listing.controller");
const auth_middleware_1 = require("../middlewares/auth.middleware");
const router = (0, express_1.Router)();
// Routes publiques
router.get('/', listing_controller_1.getListings);
router.get('/:id', listing_controller_1.getListingById);
// Routes protégées
router.post('/', auth_middleware_1.authMiddleware, listing_controller_1.createListing);
router.put('/:id', auth_middleware_1.authMiddleware, listing_controller_1.updateListing);
router.delete('/:id', auth_middleware_1.authMiddleware, listing_controller_1.deleteListing);
router.patch('/:id/sold', auth_middleware_1.authMiddleware, listing_controller_1.markAsSold);
exports.default = router;
