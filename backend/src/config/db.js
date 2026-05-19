import mongoose from 'mongoose';
import { env } from './env.js';

let connectionPromise;

export const connectDb = async () => {
  if (mongoose.connection.readyState === 1) {
    return mongoose.connection;
  }

  if (connectionPromise) {
    return connectionPromise;
  }

  mongoose.set('strictQuery', true);
  connectionPromise = mongoose.connect(env.mongodbUri, {
    serverSelectionTimeoutMS: 5000,
    connectTimeoutMS: 5000,
  });

  try {
    return await connectionPromise;
  } finally {
    connectionPromise = undefined;
  }
};

export const ensureDbConnected = async () => {
  await connectDb();
};
