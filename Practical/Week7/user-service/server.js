import express from 'express';
import { connectDB } from './db.js';
import routes from './routes.js';

const app = express();
const PORT = 5001;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    message: 'User Service is running'
  });
});

app.use(routes);

connectDB().then(() => {
  app.listen(PORT, () => {
    console.log(`User Service running on http://localhost:${PORT}`);
  });
});