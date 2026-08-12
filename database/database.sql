CREATE DATABASE IF NOT EXISTS hesabyar
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE hesabyar;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    username VARCHAR(80) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin','staff') NOT NULL DEFAULT 'staff',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(50),
    address VARCHAR(255),
    opening_balance DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_customer_name(name)
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    unit VARCHAR(50) NOT NULL DEFAULT 'عدد',
    price DECIMAL(15,2) NOT NULL DEFAULT 0,
    price_locked BOOLEAN NOT NULL DEFAULT FALSE,
    stock DECIMAL(15,3) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_product_name(name)
);

CREATE TABLE invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_no INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    invoice_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(15,2) NOT NULL DEFAULT 0,
    paid DECIMAL(15,2) NOT NULL DEFAULT 0,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_invoice_date(invoice_date),
    INDEX idx_invoice_customer(customer_id),

    CONSTRAINT fk_invoice_customer
        FOREIGN KEY(customer_id)
        REFERENCES customers(id),

    CONSTRAINT fk_invoice_user
        FOREIGN KEY(created_by)
        REFERENCES users(id)
);

CREATE TABLE invoice_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    quantity DECIMAL(15,3) NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    line_total DECIMAL(15,2) NOT NULL,

    INDEX idx_invoice_items(invoice_id),

    CONSTRAINT fk_item_invoice
        FOREIGN KEY(invoice_id)
        REFERENCES invoices(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_product
        FOREIGN KEY(product_id)
        REFERENCES products(id)
);

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    note VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_payment_date(payment_date),

    CONSTRAINT fk_payment_customer
        FOREIGN KEY(customer_id)
        REFERENCES customers(id)
);

CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL DEFAULT 'سایر',
    amount DECIMAL(15,2) NOT NULL,
    expense_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    note VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_expense_date(expense_date)
);

CREATE TABLE price_locks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    locked_price DECIMAL(15,2) NOT NULL,
    locked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_price_lock_product
        FOREIGN KEY(product_id)
        REFERENCES products(id)
        ON DELETE CASCADE
);

INSERT INTO products
(name, unit, price, price_locked, stock)
VALUES
('رنگ','عدد',500,TRUE,100),
('قلم','عدد',100,TRUE,200),
('مواد اولیه','عدد',750,TRUE,50);
