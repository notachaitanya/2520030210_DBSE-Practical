import express from 'express';
import mongoose from 'mongoose';
import { User, Activity } from './db.js';

const router = express.Router();

// POST /users
router.post('/users', async (req, res) => {
  try {
    const user = await User.create(req.body);
    res.status(201).json(user);
  } catch (error) {
    res.status(400).json({
      message: 'Failed to create user',
      error: error.message
    });
  }
});

// GET /users/:id
router.get('/users/:id', async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({ message: 'Invalid user ID' });
    }

    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({
      message: 'Failed to retrieve user',
      error: error.message
    });
  }
});

// POST /activities
router.post('/activities', async (req, res) => {
  try {
    const activity = await Activity.create(req.body);
    res.status(201).json(activity);
  } catch (error) {
    res.status(400).json({
      message: 'Failed to create activity',
      error: error.message
    });
  }
});

// GET /activities/:user_id
router.get('/activities/:user_id', async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.user_id)) {
      return res.status(400).json({ message: 'Invalid user ID' });
    }

    const activities = await Activity.find({
      user_id: req.params.user_id
    }).sort({ timestamp: -1 });

    res.status(200).json(activities);
  } catch (error) {
    res.status(500).json({
      message: 'Failed to retrieve activities',
      error: error.message
    });
  }
});

export default router;