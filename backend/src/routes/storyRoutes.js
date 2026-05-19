import express from 'express';
import multer from 'multer';
import path from 'path';
import { listStories, createStory } from '../controllers/storyController.js';
import { getUploadsDir } from '../services/storageService.js';

const router = express.Router();

const storage = multer.diskStorage({
  destination: (_, __, cb) => cb(null, getUploadsDir()),
  filename: (_, file, cb) => {
    const ext = path.extname(file.originalname);
    const safeName = `${Date.now()}-${Math.random().toString(16).slice(2)}${ext}`;
    cb(null, safeName);
  },
});

const upload = multer({ storage });

router.get('/', listStories);
router.post('/', upload.single('media'), createStory);

export default router;
