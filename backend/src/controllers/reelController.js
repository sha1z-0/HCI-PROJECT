import { Reel } from '../models/reel.js';

export const listReels = async (req, res, next) => {
  try {
    const reels = await Reel.find().sort({ createdAt: -1 }).lean();
    res.json(reels);
  } catch (error) {
    next(error);
  }
};
