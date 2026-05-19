import app from './app.js';
import { env } from './config/env.js';
import { connectDb } from './config/db.js';

const start = async () => {
  await connectDb();
  app.listen(env.port, () => {
    console.log(`API running on port ${env.port}`);
  });
};

start();
