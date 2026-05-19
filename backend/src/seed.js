import { connectDb } from './config/db.js';
import { Reel } from './models/reel.js';
import { Story } from './models/story.js';

const seed = async () => {
  await connectDb();

  await Story.deleteMany({});
  await Reel.deleteMany({});

  await Story.create([
    {
      mediaUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=800&q=80',
      audience: 'public',
      username: 'mira.flow',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
    },
    {
      mediaUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=80',
      audience: 'closeFriends',
      username: 'jaylen',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    }
  ]);

  await Reel.create([
    {
      videoUrl: 'https://res.cloudinary.com/dczgb66ca/video/upload/v1779165768/How_much_does_David_Goggins_sleeps____motivation_discipline_davidgoggins_nf1fk5.mp4',
      caption: 'Discipline spotlight: David Goggins',
      username: 'goggins.daily',
    },
    {
      videoUrl: 'https://res.cloudinary.com/dczgb66ca/video/upload/v1779165768/MrBeast_Got_Paid_250_000_To_Do_This_g3hl4g.mp4',
      caption: 'MrBeast paid challenge clip',
      username: 'mrbeast',
    },
    {
      videoUrl: 'https://res.cloudinary.com/dczgb66ca/video/upload/v1779165768/videoplayback_vt9oaj.mp4',
      caption: 'Motivation spotlight reel',
      username: 'spotlight',
    }
  ]);

  process.exit(0);
};

seed();
