import mongoose from 'mongoose';

const storySchema = new mongoose.Schema(
  {
    mediaUrl: { type: String, required: true },
    mediaType: { type: String, default: 'image' },
    audience: {
      type: String,
      enum: ['public', 'friends', 'closeFriends', 'private'],
      default: 'friends',
    },
    username: { type: String, default: 'snapuser' },
    avatarUrl: { type: String, default: '' },
  },
  { timestamps: true }
);

export const Story = mongoose.model('Story', storySchema);
