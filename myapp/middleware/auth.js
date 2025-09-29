const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET || 'ChangeThisToAStrongSecret';

// simple JWT auth middleware; expects Authorization: Bearer <token>
module.exports = (req, res, next) => {
  const h = req.headers.authorization;
  if (!h) return res.status(401).json({ error: 'Missing Authorization header' });
  const [type, token] = h.split(' ');
  if (type !== 'Bearer' || !token) return res.status(401).json({ error: 'Invalid Authorization header' });
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    req.user = payload;
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid or expired token' });
  }
};
