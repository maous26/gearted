import { Router } from 'express';

const router = Router();

router.get('/', (req, res) => {
  res.json({ message: 'Compatibility routes - Coming soon!' });
});

export default router;