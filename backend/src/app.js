import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import path from 'path';
import { fileURLToPath } from 'url';
import storyRoutes from './routes/storyRoutes.js';
import reelRoutes from './routes/reelRoutes.js';
import healthRoutes from './routes/healthRoutes.js';
import { errorHandler } from './middleware/errorHandler.js';
import { getUploadsDir } from './services/storageService.js';

const app = express();

const limiter = rateLimit({
  windowMs: 60 * 1000,
  max: 120,
});

app.use(cors());
app.use(helmet());
app.use(limiter);
app.use(express.json({ limit: '5mb' }));
app.use(morgan('dev'));

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.use('/uploads', express.static(getUploadsDir()));

app.use('/health', healthRoutes);
app.use('/stories', storyRoutes);
app.use('/reels', reelRoutes);

app.use((req, res) => {
  res.status(404).json({ message: 'Not found' });
});

app.use(errorHandler);

export default app;
