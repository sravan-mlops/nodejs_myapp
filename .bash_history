cat > ~/myapp-db-init.sql <<'SQL'
-- create schema and tables for the sample ecommerce app
USE ecommerce;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  stock INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- seed products
INSERT INTO products (name, description, price, stock) VALUES
('Test T-shirt', 'Comfortable cotton T-shirt', 9.99, 100),
('Sample Mug', 'Ceramic mug 300ml', 6.50, 50),
('Wireless Earbuds (demo)', 'Pair of earbuds for demos', 29.99, 20);
SQL

sudo mysql -u ecomuser -p ecommerce < ~/myapp-db-init.sql
sudo mysql
mysql -u ecomuser -p -D ecommerce
cd ~
mkdir -p myapp
cd myapp
npm init -y
ls
npm install express mysql2 dotenv bcrypt jsonwebtoken cors
ls
sudo npm install -g pm2
cat > .env.example <<'ENV'
PORT=3000
DB_HOST=localhost
DB_USER=ecomuser
DB_PASSWORD=ecomuser@123 
DB_NAME=ecommerce
JWT_SECRET=ChangeThisToAStrongSecret
ENV

cat > config/db.js <<'JS'
/*
 * config/db.js
 * Database connection pool using mysql2/promise
 */
const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'ecomuser',
  password: process.env.DB_PASSWORD || 'StrongPasswordHere',
  database: process.env.DB_NAME || 'ecommerce',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool;
JS

ls
cd myapp
ls
cd .env
touch .env
ls
ls -a
nano .env
cd .
ls -a
ls
mkdir config
cd config
touch db.js
cat > config/db.js <<'JS'
/*
 * config/db.js
 * Database connection pool using mysql2/promise
 */
const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'ecomuser',
  password: process.env.DB_PASSWORD || 'StrongPasswordHere',
  database: process.env.DB_NAME || 'ecommerce',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool;
JS

cd ..
ls
cat > config/db.js <<'JS'
/*
 * config/db.js
 * Database connection pool using mysql2/promise
 */
const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'ecomuser',
  password: process.env.DB_PASSWORD || 'StrongPasswordHere',
  database: process.env.DB_NAME || 'ecommerce',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool;
JS

ls
touch server.js
cat > server.js <<'JS'
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
JS

ls
cd routes
whoami
curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || true
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl unzip build-essential git
sudo fallocate -l 1G /swapfile
ls
sudo chmod 600 /swapfile
ls
ls -a
ls -l
sudo mkswap /swapfile
sudo swapon /swapfile
ls
ls-a
ls -a
echo ' /swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
git --version
sudo apt install -y mysql-server
ls
ls -a
sudo mysql_secure_installation
sudo systemctl status mysql --no-pager
sudo mysql
mysql -u ecomuser -p -D ecommerce
cd myapp
ls
cat server.js
cd myapp
ls
sudo apt install -y nginx
# create nginx site config
sudo tee /etc/nginx/sites-available/myapp > /dev/null <<'NGINX'
server {
    listen 80;
    server_name _; # you can put your domain or leave as _ to match any

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_cache_bypass $http_upgrade;
    }
}
NGINX

# enable the site
sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/myapp
# test config and restart nginx
sudo nginx -t
sudo systemctl restart nginx
# open firewall (ufw) for HTTP/HTTPS and allow SSH from your IP only:
sudo apt install -y ufw
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
# allow SSH only from your IP (replace a.b.c.d with your IP)
# sudo ufw allow from a.b.c.d to any port 22 proto tcp
# If you want to allow SSH from anywhere (not recommended), run:
# sudo ufw allow 22/tcp
sudo ufw enable
sudo ufw status
curl http://127.0.0.1/
curl http://172.31.1.204/api/products
curl http://65.0.73.162/api/products
sudo ufw allow 22/tcp
curl http://65.0.73.162/api/products
ls
curl http://127.0.0.1/
curl http://65.0.73.162/api/products
pm2 list
cd ~/myapp
pm2 start server.js
pm2 save
curl http://localhost:3000/api/products
sudo nano /etc/nginx/sites-available/myapp
