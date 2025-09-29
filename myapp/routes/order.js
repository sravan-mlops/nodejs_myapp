const express = require('express');
const router = express.Router();
const controller = require('../controllers/orderController');
const auth = require('../middleware/auth');

// user must be logged in to place an order
router.post('/', auth, controller.createOrder);
router.get('/:id', auth, controller.getOrder);

module.exports = router;
