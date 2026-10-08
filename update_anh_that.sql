USE nexora_db;

UPDATE SanPham 
SET hinhAnhChinh = ELT(FLOOR(1 + (RAND() * 3)), 
    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&q=80',
    'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=400&q=80',
    'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=400&q=80'
) 
WHERE maDanhMuc = 1;

UPDATE SanPham 
SET hinhAnhChinh = ELT(FLOOR(1 + (RAND() * 3)), 
    'https://images.unsplash.com/photo-1542272604-780c8d52f63e?w=400&q=80',
    'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=400&q=80',
    'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=400&q=80'
) 
WHERE maDanhMuc = 2;

UPDATE SanPham 
SET hinhAnhChinh = ELT(FLOOR(1 + (RAND() * 3)), 
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
    'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&q=80',
    'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400&q=80'
) 
WHERE maDanhMuc = 3;

UPDATE SanPham 
SET hinhAnhChinh = ELT(FLOOR(1 + (RAND() * 3)), 
    'https://images.unsplash.com/photo-1556306535-0f09a537f0a3?w=400&q=80',
    'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=400&q=80',
    'https://images.unsplash.com/photo-1533827432537-70133748f5c8?w=400&q=80'
) 
WHERE maDanhMuc = 5;

UPDATE SanPham 
SET hinhAnhChinh = ELT(FLOOR(1 + (RAND() * 2)), 
    'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400&q=80',
    'https://images.unsplash.com/photo-1620331317312-74b88bf40907?w=400&q=80'
) 
WHERE maDanhMuc = 6;

UPDATE SanPham 
SET hinhAnhChinh = ELT(FLOOR(1 + (RAND() * 3)), 
    'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=400&q=80',
    'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&q=80',
    'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400&q=80'
) 
WHERE maDanhMuc = 7;
