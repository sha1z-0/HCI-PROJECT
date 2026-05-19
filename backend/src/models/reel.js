import mongoose from 'mongoose';

const reelSchema = new mongoose.Schema(
  {
    videoUrl: { type: String, required: true },
    caption: { type: String, default: '' },
    username: { type: String, default: 'snapuser' },
  },
  { timestamps: true }
);

export const Reel = mongoose.model('Reel', reelSchema);
