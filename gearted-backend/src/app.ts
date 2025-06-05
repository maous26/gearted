import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import session from 'express-session';
import { config } from 'dotenv';
import { errorMiddleware } from './api/middlewares/error.middleware';
import passport from './config/passport';

// Routes
import authRoutes from './api/routes/auth.routes';
import userRoutes from './api/routes/user.routes';
import listingRoutes from './api/routes/listing.routes';
import uploadRoutes from './api/routes/upload.routes';
import healthRoutes from './api/routes/health.routes';
import adminRoutes from './api/routes/admin.routes';

// Configuration
config();

// App
const app: Application = express();

// Middlewares
app.use(helmet());
app.use(cors({
  origin: [
    process.env.CLIENT_URL || 'http://localhost:3000',
    'http://localhost:3001', // Admin console (port 3001)
    'http://localhost:3002', // Admin console (port 3002)
    'http://localhost:3003', // Admin console (port 3003)
    'http://localhost:3005'  // Admin console (port 3005)
  ],
  credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// Session middleware pour OAuth
app.use(session({
  secret: process.env.JWT_SECRET || 'default_secret',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    maxAge: 24 * 60 * 60 * 1000, // 24 heures
  }
}));

// Initialiser Passport
app.use(passport.initialize());
app.use(passport.session());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/listings', listingRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/health', healthRoutes);
app.use('/api/admin', adminRoutes);

// Gestion des erreurs
app.use(errorMiddleware);

export default app;
