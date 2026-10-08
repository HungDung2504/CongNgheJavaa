-- ============================================================
-- NEXORA DATABASE - CHUẨN HÓA THEO THIẾT KẾ ĐỒ ÁN (12 BẢNG)
-- Đã thêm size và mauSac vào bảng SanPham
-- ============================================================

CREATE DATABASE IF NOT EXISTS nexora_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nexora_db;

SET FOREIGN_KEY_CHECKS = 0;

-- Xóa các bảng
DROP TABLE IF EXISTS HoaDon;
DROP TABLE IF EXISTS ThanhToan;
DROP TABLE IF EXISTS ChiTietDonHang;
DROP TABLE IF EXISTS DonHang;
DROP TABLE IF EXISTS ChiTietGioHang;
DROP TABLE IF EXISTS GioHang;
DROP TABLE IF EXISTS DanhGia;
DROP TABLE IF EXISTS LichSuNhapKho;
DROP TABLE IF EXISTS SanPham;
DROP TABLE IF EXISTS DanhMuc;
DROP TABLE IF EXISTS DiaChiGiaoHang;
DROP TABLE IF EXISTS NguoiDung;

-- ==========================================
-- Bảng 3.1: NguoiDung
-- ==========================================
CREATE TABLE NguoiDung (
    maNguoiDung INT AUTO_INCREMENT PRIMARY KEY,
    hoTen       VARCHAR(200) NOT NULL,
    email       VARCHAR(255) NOT NULL UNIQUE,
    matKhau     VARCHAR(512) NOT NULL,
    soDienThoai VARCHAR(30)  NULL,
    vaiTro      VARCHAR(20)  NOT NULL DEFAULT 'KhachHang',
    trangThai   TINYINT(1)   NOT NULL DEFAULT 1,
    ngayTao     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_vaiTro CHECK (vaiTro IN ('Admin', 'NhanVien', 'KhachHang'))
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.2: DiaChiGiaoHang
-- ==========================================
CREATE TABLE DiaChiGiaoHang (
    maDiaChi       INT AUTO_INCREMENT PRIMARY KEY,
    maNguoiDung    INT          NOT NULL,
    hoTenNguoiNhan VARCHAR(200) NOT NULL,
    sdtNguoiNhan   VARCHAR(30)  NOT NULL,
    diaChiChiTiet  VARCHAR(500) NOT NULL,
    isMacDinh      TINYINT(1)   NOT NULL DEFAULT 0,
    FOREIGN KEY (maNguoiDung) REFERENCES NguoiDung(maNguoiDung) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.3: DanhMuc
-- ==========================================
CREATE TABLE DanhMuc (
    maDanhMuc  INT AUTO_INCREMENT PRIMARY KEY,
    tenDanhMuc VARCHAR(200)  NOT NULL UNIQUE,
    moTa       VARCHAR(1000) NULL,
    icon       VARCHAR(100)  NULL,
    trangThai  TINYINT(1)    NOT NULL DEFAULT 1,
    ngayTao    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.4: SanPham
-- ==========================================
CREATE TABLE SanPham (
    maSanPham      INT AUTO_INCREMENT PRIMARY KEY,
    maDanhMuc      INT           NOT NULL,
    tenSanPham     VARCHAR(300)  NOT NULL,
    size           VARCHAR(20)   NULL,
    mauSac         VARCHAR(50)   NULL,
    hinhAnhChinh   VARCHAR(1000) NULL,
    moTaChiTiet    LONGTEXT      NULL,
    giaBan         DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    tongSoLuongTon INT           NOT NULL DEFAULT 0,
    trangThai      TINYINT(1)    NOT NULL DEFAULT 1,
    ngayTao        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_giaBan CHECK (giaBan >= 0),
    CONSTRAINT chk_tongSoLuongTon CHECK (tongSoLuongTon >= 0),
    FOREIGN KEY (maDanhMuc) REFERENCES DanhMuc(maDanhMuc)
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.5 (2.4): LichSuNhapKho
-- ==========================================
CREATE TABLE LichSuNhapKho (
    maLichSu    INT AUTO_INCREMENT PRIMARY KEY,
    maSanPham   INT           NOT NULL,
    ngayNhap    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    soLuongNhap INT           NOT NULL,
    giaNhap     DECIMAL(18,2) NOT NULL,
    nhaCungCap  VARCHAR(300)  NULL,
    ghiChu      VARCHAR(500)  NULL,
    CONSTRAINT chk_soLuongNhap CHECK (soLuongNhap > 0),
    CONSTRAINT chk_giaNhap CHECK (giaNhap >= 0),
    FOREIGN KEY (maSanPham) REFERENCES SanPham(maSanPham)
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.6: DanhGia
-- ==========================================
CREATE TABLE DanhGia (
    maDanhGia   INT AUTO_INCREMENT PRIMARY KEY,
    maNguoiDung INT      NOT NULL,
    maSanPham   INT      NOT NULL,
    soSao       TINYINT  NOT NULL,
    noiDung     LONGTEXT NULL,
    ngayDanhGia DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_soSao CHECK (soSao BETWEEN 1 AND 5),
    FOREIGN KEY (maNguoiDung) REFERENCES NguoiDung(maNguoiDung),
    FOREIGN KEY (maSanPham)   REFERENCES SanPham(maSanPham)
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.7: GioHang
-- ==========================================
CREATE TABLE GioHang (
    maGioHang   INT AUTO_INCREMENT PRIMARY KEY,
    maNguoiDung INT      NOT NULL UNIQUE,
    ngayCapNhat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (maNguoiDung) REFERENCES NguoiDung(maNguoiDung)
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.8: ChiTietGioHang
-- ==========================================
CREATE TABLE ChiTietGioHang (
    maChiTietGio INT AUTO_INCREMENT PRIMARY KEY,
    maGioHang    INT         NOT NULL,
    maSanPham    INT         NOT NULL,
    size         VARCHAR(20) NOT NULL,
    mauSac       VARCHAR(50) NOT NULL,
    soLuong      INT         NOT NULL DEFAULT 1,
    CONSTRAINT chk_soLuongGio CHECK (soLuong >= 1),
    FOREIGN KEY (maGioHang) REFERENCES GioHang(maGioHang) ON DELETE CASCADE,
    FOREIGN KEY (maSanPham) REFERENCES SanPham(maSanPham)
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.9: DonHang
-- ==========================================
CREATE TABLE DonHang (
    maDonHang     INT AUTO_INCREMENT PRIMARY KEY,
    maNguoiDung   INT           NULL,
    maDiaChi      INT           NULL,
    ngayDatHang   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tongTienHang  DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    phiVanChuyen  DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    tongThanhToan DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    kenhBanHang   VARCHAR(20)   NOT NULL DEFAULT 'ONLINE',
    trangThaiDon  VARCHAR(50)   NOT NULL DEFAULT 'Chờ xác nhận',
    ghiChu        VARCHAR(500)  NULL,
    CONSTRAINT chk_tongTienHang CHECK (tongTienHang >= 0),
    CONSTRAINT chk_phiVanChuyen CHECK (phiVanChuyen >= 0),
    CONSTRAINT chk_tongThanhToan CHECK (tongThanhToan >= 0),
    CONSTRAINT chk_kenhBanHang CHECK (kenhBanHang IN ('ONLINE', 'OFFLINE')),
    CONSTRAINT chk_trangThaiDon CHECK (trangThaiDon IN ('Chờ xác nhận', 'Đang giao', 'Hoàn thành', 'Đã hủy')),
    FOREIGN KEY (maNguoiDung) REFERENCES NguoiDung(maNguoiDung),
    FOREIGN KEY (maDiaChi)    REFERENCES DiaChiGiaoHang(maDiaChi)
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.10: ChiTietDonHang
-- ==========================================
CREATE TABLE ChiTietDonHang (
    maChiTietDon INT AUTO_INCREMENT PRIMARY KEY,
    maDonHang    INT           NOT NULL,
    maSanPham    INT           NOT NULL,
    size         VARCHAR(20)   NOT NULL,
    mauSac       VARCHAR(50)   NOT NULL,
    soLuong      INT           NOT NULL,
    donGia       DECIMAL(18,2) NOT NULL,
    thanhTien    DECIMAL(18,2) NOT NULL,
    CONSTRAINT chk_soLuongDon CHECK (soLuong >= 1),
    CONSTRAINT chk_donGia CHECK (donGia >= 0),
    CONSTRAINT chk_thanhTien CHECK (thanhTien >= 0),
    FOREIGN KEY (maDonHang) REFERENCES DonHang(maDonHang) ON DELETE CASCADE,
    FOREIGN KEY (maSanPham) REFERENCES SanPham(maSanPham)
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.11: ThanhToan
-- ==========================================
CREATE TABLE ThanhToan (
    maThanhToan       INT AUTO_INCREMENT PRIMARY KEY,
    maDonHang         INT           NOT NULL UNIQUE,
    phuongThuc        VARCHAR(50)   NOT NULL,
    ngayThanhToan     DATETIME      NULL,
    soTienGiaoDich    DECIMAL(18,2) NOT NULL,
    trangThaiGiaoDich VARCHAR(50)   NOT NULL DEFAULT 'Chờ xử lý',
    ghiChu            VARCHAR(500)  NULL,
    CONSTRAINT chk_soTienGiaoDich CHECK (soTienGiaoDich >= 0),
    CONSTRAINT chk_trangThaiGiaoDich CHECK (trangThaiGiaoDich IN ('Chờ xử lý', 'Thành công', 'Thất bại', 'Hoàn tiền')),
    FOREIGN KEY (maDonHang) REFERENCES DonHang(maDonHang)
) ENGINE=InnoDB;

-- ==========================================
-- Bảng 3.12: HoaDon
-- ==========================================
CREATE TABLE HoaDon (
    maHoaDon        INT AUTO_INCREMENT PRIMARY KEY,
    maDonHang       INT           NOT NULL UNIQUE,
    ngayXuat        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tenCongTy       VARCHAR(300)  NULL,
    maSoThue        VARCHAR(50)   NULL,
    diaChiCongTy    VARCHAR(500)  NULL,
    tongTien        DECIMAL(18,2) NOT NULL,
    thueSuatVAT     DECIMAL(5,2)  NOT NULL DEFAULT 0.00,
    tienVAT         DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    trangThaiHoaDon VARCHAR(50)   NOT NULL DEFAULT 'Phát hành',
    CONSTRAINT chk_tongTienHD CHECK (tongTien >= 0),
    CONSTRAINT chk_thueSuatVAT CHECK (thueSuatVAT >= 0 AND thueSuatVAT <= 100),
    CONSTRAINT chk_tienVAT CHECK (tienVAT >= 0),
    CONSTRAINT chk_trangThaiHoaDon CHECK (trangThaiHoaDon IN ('Phát hành', 'Đã hủy')),
    FOREIGN KEY (maDonHang) REFERENCES DonHang(maDonHang)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- DỮ LIỆU MẪU ĐỂ TEST
-- ============================================================
INSERT INTO NguoiDung (hoTen, email, matKhau, soDienThoai, vaiTro) VALUES
('Quản Trị Viên', 'admin@nexora.com', '$2a$10$sFqgKct5vWlSiOpvAvWZEufIvWOgeVdjrmuIKeHQidcORo9mIOvyi', '0999999999', 'Admin'),
('Khách Hàng 1', 'khachhang1@gmail.com', '$2a$10$sFqgKct5vWlSiOpvAvWZEufIvWOgeVdjrmuIKeHQidcORo9mIOvyi', '0912345678', 'KhachHang');

INSERT INTO DanhMuc (maDanhMuc, tenDanhMuc, moTa) VALUES
(1, 'Áo Thun', 'Các loại áo thun thời trang'),
(2, 'Quần Jean', 'Quần jean nam nữ'),
(3, 'Giày', 'Giày nam nữ'),
(4, 'Phụ Kiện', 'Phụ kiện'),
(5, 'Mũ', 'Mũ thời trang'),
(6, 'Dép', 'Dép đi trong nhà và đi dạo'),
(7, 'Váy', 'Váy thời trang');

INSERT INTO SanPham (maDanhMuc, tenSanPham, size, mauSac, hinhAnhChinh, giaBan, tongSoLuongTon) VALUES
(1, 'Áo thun trắng cơ bản', 'M', 'Trắng', 'ao_trang.jpg', 150000, 100),
(1, 'Áo thun trắng cơ bản', 'L', 'Trắng', 'ao_trang_l.jpg', 150000, 50),
(2, 'Quần jean form rộng', '30', 'Xanh đen', 'quan_jean.jpg', 350000, 50);

INSERT INTO DiaChiGiaoHang (maNguoiDung, hoTenNguoiNhan, sdtNguoiNhan, diaChiChiTiet, isMacDinh) VALUES
(2, 'Khách Hàng 1', '0912345678', 'Số 1, Lê Duẩn, Quận 1, TP.HCM', 1);

INSERT INTO DonHang (maNguoiDung, maDiaChi, tongTienHang, phiVanChuyen, tongThanhToan, trangThaiDon) VALUES
(2, 1, 300000, 20000, 320000, 'Chờ xác nhận');

INSERT INTO ChiTietDonHang (maDonHang, maSanPham, size, mauSac, soLuong, donGia, thanhTien) VALUES
(1, 1, 'M', 'Trắng', 2, 150000, 300000);

INSERT INTO ThanhToan (maDonHang, phuongThuc, soTienGiaoDich) VALUES
(1, 'COD', 320000);

INSERT INTO HoaDon (maDonHang, tongTien, thueSuatVAT, tienVAT) VALUES
(1, 320000, 10.00, 32000);
USE nexora_db;
-- 60 SAN PHAM MAU MOI THEM vao
INSERT INTO SanPham (maDanhMuc, tenSanPham, size, mauSac, hinhAnhChinh, moTaChiTiet, giaBan, tongSoLuongTon) VALUES
(1, 'Áo Thun Trơn Basic', 'L', 'Đỏ', 'https://placehold.co/400x500/eaeaea/555?text=Ao+Thun+Tron+Basic', 'Sản phẩm áo thun basic.', 180000, 50),
(1, 'Áo Thun Cổ Tròn', 'M', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Ao+Thun+Co+Tron', 'Sản phẩm áo thun basic.', 190000, 60),
(1, 'Áo Thun Tay Lỡ', 'XL', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Ao+Thun+Tay+Lo', 'Sản phẩm áo thun tay lỡ.', 200000, 45),
(1, 'Áo Thun In Hình', 'XXL', 'Xám', 'https://placehold.co/400x500/eaeaea/555?text=Ao+Thun+In+Hinh', 'Sản phẩm áo thun in.', 220000, 80),
(1, 'Áo Thun Polo', 'M', 'Xanh Navy', 'https://placehold.co/400x500/eaeaea/555?text=Ao+Thun+Polo', 'Áo Polo thể thao.', 250000, 90),
(1, 'Áo Thun Tay Dài', 'L', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Ao+Thun+Tay+Dai', 'Áo tay dài mùa thu.', 210000, 40),
(1, 'Áo Thun Ôm Body', 'XL', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Ao+Thun+Om+Body', 'Áo ôm sát cơ thể.', 150000, 75),
(1, 'Áo Thun Dáng Rộng', 'XXL', 'Be', 'https://placehold.co/400x500/eaeaea/555?text=Ao+Thun+Dang+Rong', 'Áo form rộng thoải mái.', 180000, 65),
(1, 'Áo Tie-dye', 'M', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Ao+Tie-dye', 'Áo nhuộm tie dye nghệ thuật.', 300000, 30),
(1, 'Áo V-Neck', 'L', 'Xám', 'https://placehold.co/400x500/eaeaea/555?text=Ao+V-Neck', 'Áo cổ chữ V cổ điển.', 170000, 55),
(2, 'Quần Jean Skinny', '30', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Jean+Skinny', 'Quần ôm dáng cực chuẩn.', 350000, 85),
(2, 'Quần Jean Suông', '32', 'Xanh Navy', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Jean+Suong', 'Quần ống suông thanh lịch.', 450000, 40),
(2, 'Quần Jean Ống Rộng', '31', 'Xám', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Jean+Ong+Rong', 'Quần ống rộng phá cách.', 480000, 50),
(2, 'Quần Rách Gối', '29', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Rach+Goi', 'Quần jean rách cá tính.', 320000, 70),
(2, 'Quần Cạp Cao', '30', 'Xanh Navy', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Cap+Cao', 'Quần cạp cao hack dáng.', 420000, 60),
(2, 'Quần Đen Basic', '32', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Den+Basic', 'Quần đen cơ bản.', 290000, 90),
(2, 'Quần Xanh Xám', '31', 'Xám', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Xanh+Xam', 'Quần jean wash xanh xám.', 390000, 45),
(2, 'Quần Baggy', '30', 'Xanh Navy', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Baggy', 'Quần baggy thoải mái.', 330000, 80),
(2, 'Quần Straight', '32', 'Xanh Navy', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Straight', 'Quần dáng thẳng.', 360000, 55),
(2, 'Quần Túi Hộp', '29', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Quan+Tui+Hop', 'Quần cargo hầm hố.', 550000, 35),
(3, 'Giày Sneaker', '40', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Sneaker', 'Sneaker trắng cơ bản.', 750000, 80),
(3, 'Giày Loafer', '41', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Loafer', 'Loafer da bò cao cấp.', 850000, 40),
(3, 'Giày Oxford', '42', 'Nâu', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Oxford', 'Giày tây sang trọng.', 1200000, 30),
(3, 'Giày Boot Da', '39', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Boot+Da', 'Boot da nam cá tính.', 1500000, 20),
(3, 'Giày Chạy Bộ', '40', 'Xám', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Chay+Bo', 'Giày running siêu nhẹ.', 650000, 90),
(3, 'Giày Canvas', '41', 'Đỏ', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Canvas', 'Giày vải canvas.', 350000, 100),
(3, 'Giày Slip-on', '42', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Slip-on', 'Giày xỏ ngón tiện lợi.', 450000, 70),
(3, 'Giày Chelsea', '40', 'Nâu', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Chelsea', 'Chelsea boot cổ điển.', 1100000, 35),
(3, 'Giày Chunky', '41', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Chunky', 'Sneaker đế bự hầm hố.', 800000, 45),
(3, 'Giày Da Cao Cấp', '42', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Giay+Da+Cao+Cap', 'Giày da nguyên miếng.', 1800000, 15),
(5, 'Mũ Lưỡi Trai', 'Free Size', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Luoi+Trai', 'Mũ lưỡi trai cotton.', 150000, 100),
(5, 'Mũ Bucket', 'Free Size', 'Be', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Bucket', 'Mũ vành tròn bucket.', 180000, 80),
(5, 'Mũ Len Beanie', 'Free Size', 'Xám', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Len+Beanie', 'Mũ len mùa đông ấm áp.', 120000, 60),
(5, 'Mũ Snapback', 'Free Size', 'Đỏ', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Snapback', 'Mũ snapback thể thao.', 160000, 75),
(5, 'Mũ Fedora', 'Free Size', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Fedora', 'Mũ phớt lịch lãm.', 250000, 30),
(5, 'Mũ Cói Đi Biển', 'Free Size', 'Nâu', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Coi', 'Mũ cói rộng vành đi biển.', 220000, 40),
(5, 'Mũ Nồi Beret', 'Free Size', 'Đỏ', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Noi+Beret', 'Mũ nồi kiểu dáng châu âu.', 190000, 50),
(5, 'Mũ Boater', 'Free Size', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Boater', 'Mũ boater rơm cứng.', 210000, 35),
(5, 'Mũ Visor', 'Free Size', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Visor', 'Mũ visor hở chóp tennis.', 140000, 90),
(5, 'Mũ Da Cừu', 'Free Size', 'Nâu', 'https://placehold.co/400x500/eaeaea/555?text=Mu+Da+Cuu', 'Mũ da giữ ấm.', 350000, 20),
(6, 'Dép Quai Ngang', '40', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Dep+Quai+Ngang', 'Dép quai ngang đi dạo.', 120000, 150),
(6, 'Dép Kẹp Xỏ Ngón', '41', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Dep+Xo+Ngon', 'Dép tông đi biển.', 90000, 200),
(6, 'Dép Da Nam', '42', 'Nâu', 'https://placehold.co/400x500/eaeaea/555?text=Dep+Da+Nam', 'Dép da bò cao cấp.', 250000, 50),
(6, 'Dép Sandal', '39', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Dep+Sandal', 'Sandal nam trẻ trung.', 180000, 80),
(6, 'Dép Trong Nhà', '40', 'Xám', 'https://placehold.co/400x500/eaeaea/555?text=Dep+Trong+Nha', 'Dép bông đi trong nhà.', 110000, 120),
(6, 'Dép Nhựa Đúc', '41', 'Xanh Navy', 'https://placehold.co/400x500/eaeaea/555?text=Dep+Nhua+Duc', 'Dép đi mưa chống trơn.', 150000, 100),
(6, 'Dép Đế Xuồng', '39', 'Đỏ', 'https://placehold.co/400x500/eaeaea/555?text=Dep+De+Xuong', 'Dép đế xuồng.', 210000, 45),
(6, 'Dép Quai Chéo', '42', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Dep+Quai+Cheo', 'Dép da quai chéo.', 230000, 60),
(6, 'Dép Sục Crocs', '40', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Dep+Crocs', 'Dép sục tiện lợi.', 350000, 75),
(6, 'Dép Bánh Mì', '41', 'Vàng', 'https://placehold.co/400x500/eaeaea/555?text=Dep+Banh+Mi', 'Dép đế dày siêu nhẹ.', 160000, 90),
(7, 'Váy Chữ A', 'M', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Chu+A', 'Váy thiết kế chữ A.', 250000, 60),
(7, 'Váy Xòe Vintage', 'L', 'Đỏ', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Xoe', 'Váy xòe phong cách cổ điển.', 350000, 40),
(7, 'Váy Công Sở', 'S', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Cong+So', 'Váy liền thân công sở.', 450000, 55),
(7, 'Váy Maxi Biển', 'M', 'Xanh Navy', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Maxi', 'Váy dài dạo biển.', 380000, 30),
(7, 'Váy Body Tôn', 'S', 'Đen', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Body', 'Váy ôm body quyến rũ.', 290000, 70),
(7, 'Váy Xếp Ly', 'L', 'Xám', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Xep+Ly', 'Chân váy xếp ly.', 220000, 85),
(7, 'Váy Đuôi Cá', 'M', 'Trắng', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Duoi+Ca', 'Váy đuôi cá dự tiệc.', 550000, 25),
(7, 'Váy Chữ V', 'S', 'Đỏ', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Chu+V', 'Váy cổ chữ V cuốn hút.', 420000, 45),
(7, 'Váy Trễ Vai', 'M', 'Be', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Tre+Vai', 'Váy trễ vai nhẹ nhàng.', 310000, 65),
(7, 'Váy Jean Trẻ', 'L', 'Xanh Navy', 'https://placehold.co/400x500/eaeaea/555?text=Vay+Jean', 'Váy yếm jean trẻ trung.', 360000, 50);
