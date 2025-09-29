const db = require('../config/db');

// GET /api/products
exports.getAllProducts = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT id, name, description, price, stock FROM products ORDER BY id DESC');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
};

// GET /api/products/:id
exports.getProductById = async (req, res) => {
  const id = req.params.id;
  try {
    const [rows] = await db.query('SELECT id, name, description, price, stock FROM products WHERE id = ?', [id]);
    if (!rows.length) return res.status(404).json({ error: 'Product not found' });
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
};
