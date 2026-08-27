-- Database MANGAN O
-- Import file ini melalui phpMyAdmin atau MySQL CLI.

CREATE DATABASE IF NOT EXISTS mangan_o
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE mangan_o;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  phone VARCHAR(25) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE restaurants (
  id CHAR(2) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  rating DECIMAL(2,1) NOT NULL DEFAULT 0.0,
  address VARCHAR(255) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_restaurant_rating CHECK (rating BETWEEN 0.0 AND 5.0)
) ENGINE=InnoDB;

CREATE TABLE categories (
  id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  icon VARCHAR(10) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE menu_items (
  id CHAR(2) PRIMARY KEY,
  restaurant_id CHAR(2) NOT NULL,
  category_id SMALLINT UNSIGNED NOT NULL,
  name VARCHAR(150) NOT NULL,
  description TEXT NULL,
  price DECIMAL(12,2) UNSIGNED NOT NULL,
  emoji VARCHAR(10) NULL,
  is_available TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_menu_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
  CONSTRAINT fk_menu_category FOREIGN KEY (category_id) REFERENCES categories(id),
  INDEX idx_menu_restaurant (restaurant_id),
  INDEX idx_menu_category (category_id)
) ENGINE=InnoDB;

CREATE TABLE addresses (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  label VARCHAR(50) NOT NULL DEFAULT 'Rumah',
  recipient_name VARCHAR(100) NOT NULL,
  phone VARCHAR(25) NULL,
  address TEXT NOT NULL,
  is_default TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_address_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_address_user (user_id)
) ENGINE=InnoDB;

CREATE TABLE orders (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NULL,
  address_id INT UNSIGNED NULL,
  delivery_address TEXT NOT NULL,
  payment_method ENUM('cash', 'qris', 'e_wallet') NOT NULL,
  status ENUM('processing', 'confirmed', 'on_delivery', 'completed', 'cancelled') NOT NULL DEFAULT 'processing',
  subtotal DECIMAL(12,2) UNSIGNED NOT NULL,
  delivery_fee DECIMAL(12,2) UNSIGNED NOT NULL DEFAULT 0,
  total DECIMAL(12,2) UNSIGNED NOT NULL,
  ordered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_order_address FOREIGN KEY (address_id) REFERENCES addresses(id) ON DELETE SET NULL,
  INDEX idx_order_user (user_id),
  INDEX idx_order_status (status),
  INDEX idx_ordered_at (ordered_at)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,
  menu_item_id CHAR(2) NULL,
  menu_name VARCHAR(150) NOT NULL,
  unit_price DECIMAL(12,2) UNSIGNED NOT NULL,
  quantity SMALLINT UNSIGNED NOT NULL,
  line_total DECIMAL(12,2) UNSIGNED NOT NULL,
  CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_item_menu FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE SET NULL,
  CONSTRAINT chk_item_quantity CHECK (quantity > 0),
  INDEX idx_item_order (order_id)
) ENGINE=InnoDB;

INSERT INTO categories (name, icon) VALUES
  ('Ayam', '🍗'),
  ('Mie', '🍜'),
  ('Pizza', '🍕'),
  ('Minuman', '🥤'),
  ('Dessert', '🍰');

INSERT INTO restaurants (id, name, rating) VALUES
  ('r1', 'MANGAN Chicken', 4.8),
  ('r2', 'Warung Mie O', 4.7),
  ('r3', 'O Pizza', 4.8),
  ('r4', 'Kedai Segar', 4.9),
  ('r5', 'O Dessert', 4.8);

INSERT INTO menu_items (id, restaurant_id, category_id, name, description, price, emoji)
SELECT menu.id, menu.restaurant_id, categories.id, menu.name, menu.description, menu.price, menu.emoji
FROM (
  SELECT 'm1' id, 'r1' restaurant_id, 'Ayam' category, 'Ayam Geprek MANGAN' name, 'Ayam crispy dengan sambal khas MANGAN.' description, 18000 price, '🍗' emoji
  UNION ALL SELECT 'm2', 'r2', 'Mie', 'Mie Ayam Spesial', 'Mie ayam gurih dengan topping melimpah.', 15000, '🍜'
  UNION ALL SELECT 'm3', 'r3', 'Pizza', 'Pizza Beef Cheese', 'Pizza dengan beef dan keju.', 35000, '🍕'
  UNION ALL SELECT 'm4', 'r4', 'Minuman', 'Es Teh Manis', 'Es teh manis segar.', 7000, '🥤'
  UNION ALL SELECT 'm5', 'r5', 'Dessert', 'Chocolate Cake', 'Kue cokelat lembut dan manis.', 22000, '🍰'
  UNION ALL SELECT 'm6', 'r1', 'Ayam', 'Nasi Ayam Crispy', 'Nasi hangat dan ayam crispy.', 20000, '🍱'
) AS menu
JOIN categories ON categories.name = menu.category;

-- Contoh query katalog yang dipakai halaman restoran:
-- SELECT m.id, m.name, r.name AS restaurant, c.name AS category,
--        m.price, m.emoji, m.description, r.rating
-- FROM menu_items m
-- JOIN restaurants r ON r.id = m.restaurant_id
-- JOIN categories c ON c.id = m.category_id
-- WHERE m.is_available = 1 AND r.is_active = 1;
