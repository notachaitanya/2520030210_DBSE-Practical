import mongoose from 'mongoose';

const MONGO_URI = 'mongodb://127.0.0.1:27017/user_service_db';

export const connectDB = async () => {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('MongoDB connected');
  } catch (error) {
    console.error('MongoDB connection failed:', error.message);
    process.exit(1);
  }
};

const userSchema = new mongoose.Schema(
  {
    username: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, trim: true, lowercase: true },
    profile: { type: mongoose.Schema.Types.Mixed, default: {} }
  },
  { timestamps: true }
);

const activitySchema = new mongoose.Schema(
  {
    user_id: { type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User' },
    action: { type: String, required: true, trim: true },
    timestamp: { type: Date, default: Date.now }
  }
);

export const User = mongoose.model('User', userSchema);
export const Activity = mongoose.model('Activity', activitySchema);