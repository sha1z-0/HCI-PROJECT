import dotenv from 'dotenv';

dotenv.config();

const requiredMongoUri = process.env.MONGODB_URI;

export const env = {
  port: process.env.PORT || 4000,
  mongodbUri: requiredMongoUri,
  mediaBaseUrl: process.env.MEDIA_BASE_URL || 'http://localhost:4000',
};

if (!env.mongodbUri) {
  throw new Error('MONGODB_URI is required. Set it in Vercel environment variables.');
}
