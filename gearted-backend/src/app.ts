import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { config } from 'dotenv';
import { errorMiddleware } from './api/middlewares/error.middleware';

// Routes
import authRoutes from './api/routes/auth.routes';
import userRoutes from './api/routes/user.routes';
import listingRoutes from './api/routes/listing.routes';

// Configuration
config();

// App
const app: Application = express();

// Middlewares
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/listings', listingRoutes);

// Gestion des erreurs
app.use(errorMiddleware);

export default app;
