import path from 'path';
import { env } from '../config/env.js';

export const buildMediaUrl = (filename) => {
  return `${env.mediaBaseUrl}/uploads/${filename}`;
};

export const getUploadsDir = () => {
  return path.resolve('uploads');
};
