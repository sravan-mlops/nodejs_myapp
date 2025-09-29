/*
 * server.js - entry point
 * - loads routes, connects to DB via pool (lazy)
 */
require('dotenv').config();
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
const cors = require('cors');

// middleware
app.use(express.json());
app.use(cors());

// routes
app.use('/api/products', require('./routes/product'));
app.use('/api/users', require('./routes/user'));
app.use('/api/orders', require('./routes/order'));

// health check
app.get('/', (req, res) => res.send('E-commerce API (myapp) is running'));

// start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
