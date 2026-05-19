import { Story } from '../models/story.js';
import { buildMediaUrl } from '../services/storageService.js';

export const listStories = async (req, res, next) => {
  try {
    const stories = await Story.find().sort({ createdAt: -1 }).lean();
    res.json(stories);
  } catch (error) {
    next(error);
  }
};

export const createStory = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'Media file is required.' });
    }
    const mediaUrl = buildMediaUrl(req.file.filename);
    const story = await Story.create({
      mediaUrl,
      mediaType: 'image',
      audience: req.body.audience || 'friends',
    });
    res.status(201).json(story);
  } catch (error) {
    next(error);
  }
};
