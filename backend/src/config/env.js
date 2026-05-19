import dotenv from 'dotenv';

dotenv.config();

export const env = {
  port: process.env.PORT || 4000,
  mongodbUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/hciiii',
  mediaBaseUrl: process.env.MEDIA_BASE_URL || 'http://localhost:4000',
};
