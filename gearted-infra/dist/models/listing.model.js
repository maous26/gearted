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
exports.ListingCondition = void 0;
const mongoose_1 = __importStar(require("mongoose"));
var ListingCondition;
(function (ListingCondition) {
    ListingCondition["NEW"] = "new";
    ListingCondition["VERY_GOOD"] = "veryGood";
    ListingCondition["GOOD"] = "good";
    ListingCondition["ACCEPTABLE"] = "acceptable";
    ListingCondition["FOR_REPAIR"] = "forRepair";
})(ListingCondition = exports.ListingCondition || (exports.ListingCondition = {}));
const listingSchema = new mongoose_1.Schema({
    title: {
        type: String,
        required: [true, 'Le titre est requis'],
        trim: true,
        maxlength: [100, 'Le titre ne peut pas dépasser 100 caractères'],
    },
    description: {
        type: String,
        required: [true, 'La description est requise'],
        trim: true,
    },
    price: {
        type: Number,
        required: [true, 'Le prix est requis'],
        min: [0, 'Le prix doit être positif'],
    },
    sellerId: {
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: [true, 'Le vendeur est requis'],
    },
    imageUrls: {
        type: [String],
        required: [true, 'Au moins une image est requise'],
    },
    condition: {
        type: String,
        enum: Object.values(ListingCondition),
        required: [true, 'L\'état est requis'],
    },
    category: {
        type: String,
        required: [true, 'La catégorie est requise'],
        trim: true,
    },
    subcategory: {
        type: String,
        required: [true, 'La sous-catégorie est requise'],
        trim: true,
    },
    tags: {
        type: [String],
        default: [],
    },
    isExchangeable: {
        type: Boolean,
        default: false,
    },
    isSold: {
        type: Boolean,
        default: false,
    },
}, {
    timestamps: true,
});
// Index pour la recherche
listingSchema.index({ title: 'text', description: 'text', tags: 'text' });
exports.default = mongoose_1.default.model('Listing', listingSchema);
