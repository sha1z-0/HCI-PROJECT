import express from 'express';
import mongoose from 'mongoose';

const router = express.Router();

router.get('/', (req, res) => {
  const dbState = mongoose.connection.readyState; // 0 = disconnected, 1 = connected
  res.json({ status: 'ok', dbState });
});

export default router;
