import express from 'express';
import { listReels } from '../controllers/reelController.js';

const router = express.Router();

router.get('/', listReels);

export default router;
