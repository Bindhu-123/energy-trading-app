-- Create database
CREATE DATABASE IF NOT EXISTS energy_trading;
USE energy_trading;

-- Users table (for login/signup, common for buyer & seller)
CREATE TABLE IF NOT EXISTS users (
    name VARCHAR(100) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    role ENUM('buyer', 'seller', 'admin') DEFAULT 'buyer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Buyers table
CREATE TABLE IF NOT EXISTS buyers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    balance DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Sellers table
CREATE TABLE IF NOT EXISTS sellers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    company_name VARCHAR(150),
    energy_capacity DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Trades / Orders table
CREATE TABLE IF NOT EXISTS trades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    buyer_id INT NOT NULL,
    seller_id INT NOT NULL,
    energy_amount DECIMAL(10,2) NOT NULL,
    price_per_unit DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    status ENUM('pending','completed','cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES buyers(id) ON DELETE CASCADE,
    FOREIGN KEY (seller_id) REFERENCES sellers(id) ON DELETE CASCADE
);
-- Insert demo users
INSERT INTO users (name, email, password, role) VALUES
('Alice Buyer', 'alice@example.com', 'password123', 'buyer'),
('Bob Seller', 'bob@example.com', 'password123', 'seller');

-- Link users to buyers and sellers
INSERT INTO buyers (user_id, balance) VALUES
(1, 1000.00);

INSERT INTO sellers (user_id, company_name, energy_capacity) VALUES
(2, 'Bob Energy Ltd', 5000.00);

-- Insert a sample trade
INSERT INTO trades (buyer_id, seller_id, energy_amount, price_per_unit, total_price, status) VALUES
(1, 1, 100.00, 5.00, 500.00, 'completed');

