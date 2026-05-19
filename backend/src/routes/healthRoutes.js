import express from 'express';
import mongoose from 'mongoose';
import { ensureDbConnected } from '../config/db.js';

const router = express.Router();

router.get('/', async (req, res, next) => {
  try {
    await ensureDbConnected();

    res.json({
      status: 'connected',
      dbState: mongoose.connection.readyState,
    });
  } catch (error) {
    next(error);
  }
});

export default router;
