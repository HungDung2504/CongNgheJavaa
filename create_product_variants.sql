-- Script to create and populate product_variants table in nexora_db

USE nexora_db;

CREATE TABLE IF NOT EXISTS product_variants (
    variant_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size VARCHAR(50) NOT NULL COMMENT 'Kích cỡ',
    color VARCHAR(50) NOT NULL COMMENT 'Màu sắc',
    price DECIMAL(15,0) NOT NULL DEFAULT 0,
    stock INT NOT NULL DEFAULT 0,
    INDEX idx_product_id (product_id),
    CONSTRAINT fk_variant_sanpham FOREIGN KEY (product_id) REFERENCES sanpham(maSanPham) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Clear any existing rows to re-seed cleanly
DELETE FROM product_variants;

-- 1. Insert variants from original Baitaplon for initial products
INSERT INTO product_variants (product_id, size, color, price, stock) VALUES
(1, 'M', 'Trắng', 150000, 20),
(1, 'L', 'Trắng', 150000, 30),
(1, 'M', 'Đen', 150000, 25),
(1, 'L', 'Đen', 150000, 25),

(2, 'L', 'Be', 250000, 15),
(2, 'XL', 'Be', 250000, 10),
(2, 'L', 'Xanh Navy', 250000, 15),
(2, 'XL', 'Xanh Navy', 250000, 10),

(3, '30', 'Xanh đen', 350000, 20),
(3, '31', 'Xanh đen', 350000, 15),
(3, '32', 'Xanh đen', 350000, 15),
(3, '30', 'Đen', 350000, 20),
(3, '31', 'Đen', 350000, 15),

(4, 'M', 'Đỏ', 180000, 25),
(4, 'L', 'Đỏ', 180000, 25),
(4, 'M', 'Đen', 180000, 20),
(4, 'L', 'Trắng', 180000, 30),

(5, 'M', 'Đen', 190000, 30),
(5, 'L', 'Đen', 190000, 30),
(5, 'XL', 'Đen', 190000, 20),
(5, 'M', 'Trắng', 190000, 25),

(6, 'L', 'Trắng', 200000, 20),
(6, 'XL', 'Trắng', 200000, 25),
(6, 'XXL', 'Trắng', 200000, 15),
(6, 'L', 'Đen', 200000, 20);

-- 2. Seed variants for all other products based on category/type
-- Shirts/Áo (IDs 7 to 13)
INSERT INTO product_variants (product_id, size, color, price, stock)
SELECT p.maSanPham, 'M', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 25 FROM sanpham p WHERE p.maSanPham BETWEEN 7 AND 13
UNION ALL
SELECT p.maSanPham, 'L', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 25 FROM sanpham p WHERE p.maSanPham BETWEEN 7 AND 13
UNION ALL
SELECT p.maSanPham, 'XL', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 7 AND 13
UNION ALL
SELECT p.maSanPham, 'M', 'Trắng', p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 7 AND 13
UNION ALL
SELECT p.maSanPham, 'L', 'Trắng', p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 7 AND 13;

-- Pants/Quần (IDs 14 to 23)
INSERT INTO product_variants (product_id, size, color, price, stock)
SELECT p.maSanPham, '29', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 14 AND 23
UNION ALL
SELECT p.maSanPham, '30', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 25 FROM sanpham p WHERE p.maSanPham BETWEEN 14 AND 23
UNION ALL
SELECT p.maSanPham, '31', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 25 FROM sanpham p WHERE p.maSanPham BETWEEN 14 AND 23
UNION ALL
SELECT p.maSanPham, '32', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 14 AND 23
UNION ALL
SELECT p.maSanPham, '30', 'Xanh Navy', p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 14 AND 23
UNION ALL
SELECT p.maSanPham, '31', 'Xanh Navy', p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 14 AND 23;

-- Shoes/Giày (IDs 24 to 33)
INSERT INTO product_variants (product_id, size, color, price, stock)
SELECT p.maSanPham, '39', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 15 FROM sanpham p WHERE p.maSanPham BETWEEN 24 AND 33
UNION ALL
SELECT p.maSanPham, '40', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 25 FROM sanpham p WHERE p.maSanPham BETWEEN 24 AND 33
UNION ALL
SELECT p.maSanPham, '41', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 25 FROM sanpham p WHERE p.maSanPham BETWEEN 24 AND 33
UNION ALL
SELECT p.maSanPham, '42', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 24 AND 33
UNION ALL
SELECT p.maSanPham, '40', 'Trắng', p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 24 AND 33
UNION ALL
SELECT p.maSanPham, '41', 'Trắng', p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 24 AND 33;

-- Hats/Mũ (IDs 34 to 43)
INSERT INTO product_variants (product_id, size, color, price, stock)
SELECT p.maSanPham, 'Free Size', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 30 FROM sanpham p WHERE p.maSanPham BETWEEN 34 AND 43
UNION ALL
SELECT p.maSanPham, 'Free Size', 'Be', p.giaBan, 25 FROM sanpham p WHERE p.maSanPham BETWEEN 34 AND 43
UNION ALL
SELECT p.maSanPham, 'Free Size', 'Đen', p.giaBan, 30 FROM sanpham p WHERE p.maSanPham BETWEEN 34 AND 43;

-- Slippers/Dép (IDs 44 to 53)
INSERT INTO product_variants (product_id, size, color, price, stock)
SELECT p.maSanPham, '39', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 30 FROM sanpham p WHERE p.maSanPham BETWEEN 44 AND 53
UNION ALL
SELECT p.maSanPham, '40', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 40 FROM sanpham p WHERE p.maSanPham BETWEEN 44 AND 53
UNION ALL
SELECT p.maSanPham, '41', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 40 FROM sanpham p WHERE p.maSanPham BETWEEN 44 AND 53
UNION ALL
SELECT p.maSanPham, '42', COALESCE(NULLIF(p.mauSac, ''), 'Đen'), p.giaBan, 30 FROM sanpham p WHERE p.maSanPham BETWEEN 44 AND 53;

-- Dresses/Váy (IDs 54 to 63)
INSERT INTO product_variants (product_id, size, color, price, stock)
SELECT p.maSanPham, 'S', COALESCE(NULLIF(p.mauSac, ''), 'Trắng'), p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 54 AND 63
UNION ALL
SELECT p.maSanPham, 'M', COALESCE(NULLIF(p.mauSac, ''), 'Trắng'), p.giaBan, 25 FROM sanpham p WHERE p.maSanPham BETWEEN 54 AND 63
UNION ALL
SELECT p.maSanPham, 'L', COALESCE(NULLIF(p.mauSac, ''), 'Trắng'), p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 54 AND 63
UNION ALL
SELECT p.maSanPham, 'S', 'Đen', p.giaBan, 15 FROM sanpham p WHERE p.maSanPham BETWEEN 54 AND 63
UNION ALL
SELECT p.maSanPham, 'M', 'Đen', p.giaBan, 20 FROM sanpham p WHERE p.maSanPham BETWEEN 54 AND 63;
