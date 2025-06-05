"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const morgan_1 = __importDefault(require("morgan"));
const dotenv_1 = require("dotenv");
const error_middleware_1 = require("./api/middlewares/error.middleware");
// Routes
const auth_routes_1 = __importDefault(require("./api/routes/auth.routes"));
const user_routes_1 = __importDefault(require("./api/routes/user.routes"));
const listing_routes_1 = __importDefault(require("./api/routes/listing.routes"));
const health_routes_1 = __importDefault(require("./api/routes/health.routes"));
// Configuration
(0, dotenv_1.config)();
// App
const app = (0, express_1.default)();
// Middlewares
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
app.use((0, morgan_1.default)('dev'));
// Routes
app.use('/api/auth', auth_routes_1.default);
app.use('/api/users', user_routes_1.default);
app.use('/api/listings', listing_routes_1.default);
app.use('/api/health', health_routes_1.default);
// Gestion des erreurs
app.use(error_middleware_1.errorMiddleware);
exports.default = app;
