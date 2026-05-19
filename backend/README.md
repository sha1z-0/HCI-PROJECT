# HCI Snap Backend

## Setup

1. Copy `.env.example` to `.env` and update values.
2. Set `MONGODB_URI` to a reachable MongoDB Atlas or hosted database. Vercel cannot use `localhost` for production.
3. Install dependencies:

```bash
npm install
```

4. Start the API server:

```bash
npm run dev
```

5. (Optional) Seed sample data:

```bash
npm run seed
```

## Endpoints

- GET /health
- GET /stories
- POST /stories (multipart field: `media`)
- GET /reels

Uploads are stored in `backend/uploads` for local development.
