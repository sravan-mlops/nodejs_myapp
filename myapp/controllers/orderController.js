const db = require('../config/db');

// POST /api/orders
// body: { items: [{product_id, quantity}], shipping: {...} }
exports.createOrder = async (req, res) => {
  const userId = req.user && req.user.id;
  const { items } = req.body;
  if (!userId) return res.status(401).json({ error: 'Unauthorized' });
  if (!Array.isArray(items) || !items.length) return res.status(400).json({ error: 'No items' });

  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();

    // calculate total and decrease stock
    let total = 0.0;
    for (const it of items) {
      const [rows] = await conn.query('SELECT price, stock FROM products WHERE id = ? FOR UPDATE', [it.product_id]);
      if (!rows.length) throw new Error('Product not found: ' + it.product_id);
      const product = rows[0];
      if (product.stock < it.quantity) throw new Error('Insufficient stock for product ' + it.product_id);
      total += parseFloat(product.price) * parseInt(it.quantity, 10);
      await conn.query('UPDATE products SET stock = stock - ? WHERE id = ?', [it.quantity, it.product_id]);
    }

    const [orderResult] = await conn.query('INSERT INTO orders (user_id, total, status) VALUES (?, ?, ?)', [userId, total, 'pending']);
    const orderId = orderResult.insertId;

    for (const it of items) {
      // fetch price again (or pass in price)
      const [rows] = await conn.query('SELECT price FROM products WHERE id = ?', [it.product_id]);
      const price = rows[0].price;
      await conn.query('INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)', [orderId, it.product_id, it.quantity, price]);
    }

    await conn.commit();
    res.json({ orderId, total });
  } catch (err) {
    await conn.rollback();
    console.error(err);
    res.status(400).json({ error: err.message || 'Order failed' });
  } finally {
    conn.release();
  }
};

// GET /api/orders/:id
exports.getOrder = async (req, res) => {
  const userId = req.user.id;
  const orderId = req.params.id;
  try {
    const [orders] = await db.query('SELECT id, user_id, total, status, created_at FROM orders WHERE id = ?', [orderId]);
    if (!orders.length) return res.status(404).json({ error: 'Order not found' });
    const order = orders[0];
    if (order.user_id !== userId) return res.status(403).json({ error: 'Forbidden' });

    const [items] = await db.query('SELECT oi.id, oi.product_id, oi.quantity, oi.price, p.name FROM order_items oi JOIN products p ON p.id = oi.product_id WHERE oi.order_id = ?', [orderId]);
    order.items = items;
    res.json(order);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'DB error' });
  }
};
