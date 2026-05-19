# HCI Snap (Accessibility-First Snapchat Clone)

Production-grade Flutter app with a Node/Express + MongoDB backend. Built for an HCI accessibility project with Snapchat-like UX and accessibility-first improvements.

## Tech Stack

- Flutter (Material 3)
- Riverpod + GoRouter
- Node.js + Express
- MongoDB + Mongoose

## Key Accessibility Features

- Clear audience labels on stories
- Caption overlays on reels
- High contrast mode
- Large text mode
- Larger touch targets
- Reduced motion toggle
- Semantic labels on key controls

## Project Structure

```
lib/
  app/
  core/
  features/
backend/
```

## Flutter Setup

1. Install Flutter SDK.
2. Install dependencies:

```bash
flutter pub get
```

3. Configure environment values (already includes placeholders):

- `.env`
- `.env.example`

4. Run the app:

```bash
flutter run
```

## Backend Setup

1. Open `backend/.env.example` and create `backend/.env`.
2. Install dependencies:

```bash
cd backend
npm install
```

3. Run the API:

```bash
npm run dev
```

4. (Optional) Seed sample data:

```bash
npm run seed
```

## API Endpoints

- GET `/health`
- GET `/stories`
- POST `/stories` (multipart `media` + `audience`)
- GET `/reels`

## Notes

- Replace placeholder assets with your own media when ready.
- Update `.env` to point to your API base URL.
- The app defaults to direct entry (no auth screen).
