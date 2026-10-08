package com.nexora.dao;
import com.nexora.db.DBUtil;
import com.nexora.model.Order;
import com.nexora.model.OrderDetail;
import com.nexora.model.CartItem;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class OrderDAO {

    public int createOrder(int userId, String fullname, String phone, String address,
                           String note, long totalMoney, String paymentMethod,
                           Map<String, CartItem> cart) {
        // Trong mô hình 12 bảng, ta cần làm các việc sau:
        // 1. Lưu Địa Chỉ Giao Hàng
        // 2. Lưu Đơn Hàng (DonHang)
        // 3. Lưu Chi Tiết Đơn Hàng (ChiTietDonHang) & Trừ Tồn Kho (SanPham)
        // 4. Lưu Thanh Toán (ThanhToan)
        // 5. Lưu Hóa Đơn (HoaDon) - Mặc định

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu Transaction
            
            // Bước 1: Lưu Địa Chỉ
            int addressId = -1;
            String sqlAddress = "INSERT INTO DiaChiGiaoHang (maNguoiDung, hoTenNguoiNhan, sdtNguoiNhan, diaChiChiTiet) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psAddr = conn.prepareStatement(sqlAddress, Statement.RETURN_GENERATED_KEYS)) {
                psAddr.setInt(1, userId);
                psAddr.setString(2, fullname);
                psAddr.setString(3, phone);
                psAddr.setString(4, address);
                psAddr.executeUpdate();
                try (ResultSet rsAddr = psAddr.getGeneratedKeys()) {
                    if (rsAddr.next()) addressId = rsAddr.getInt(1);
                }
            }

            if (addressId == -1) { conn.rollback(); return -1; }

            // Bước 2: Lưu Đơn Hàng
            int orderId = -1;
            long shippingFee = 20000; // Cước vận chuyển giả lập
            long totalGoods = totalMoney - shippingFee;
            if (totalGoods < 0) totalGoods = 0;

            String sqlOrder = "INSERT INTO DonHang (maNguoiDung, maDiaChi, tongTienHang, phiVanChuyen, tongThanhToan, ghiChu, trangThaiDon) VALUES (?,?,?,?,?,?,'Chờ xác nhận')";
            try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, userId);
                psOrder.setInt(2, addressId);
                psOrder.setLong(3, totalGoods);
                psOrder.setLong(4, shippingFee);
                psOrder.setLong(5, totalMoney);
                psOrder.setString(6, note);
                psOrder.executeUpdate();
                try (ResultSet rsOrder = psOrder.getGeneratedKeys()) {
                    if (rsOrder.next()) orderId = rsOrder.getInt(1);
                }
            }

            if (orderId == -1) { conn.rollback(); return -1; }

            // Bước 3: Lưu Chi Tiết Đơn Hàng & Trừ Tồn Kho
            String detailSql = "INSERT INTO ChiTietDonHang (maDonHang, maSanPham, size, mauSac, soLuong, donGia, thanhTien) VALUES (?,?,?,?,?,?,?)";
            String stockSql = "UPDATE SanPham SET tongSoLuongTon = GREATEST(0, tongSoLuongTon - ?) WHERE maSanPham = ?";
            String variantStockSql = "UPDATE product_variants SET stock = GREATEST(0, stock - ?) WHERE variant_id = ?";
            String variantFallbackSql = "UPDATE product_variants SET stock = GREATEST(0, stock - ?) WHERE product_id = ? AND size = ? AND color = ?";
            String syncStockSql = "UPDATE SanPham SET tongSoLuongTon = (SELECT COALESCE(SUM(stock), 0) FROM product_variants WHERE product_id = ?) WHERE maSanPham = ? AND (SELECT COUNT(*) FROM product_variants WHERE product_id = ?) > 0";
            String autoOutOfStockSql = "UPDATE SanPham SET trangThai = 2 WHERE maSanPham = ? AND tongSoLuongTon <= 0 AND trangThai = 1";

            try (PreparedStatement detailPs = conn.prepareStatement(detailSql);
                 PreparedStatement stockPs = conn.prepareStatement(stockSql);
                 PreparedStatement variantPs = conn.prepareStatement(variantStockSql);
                 PreparedStatement variantFallbackPs = conn.prepareStatement(variantFallbackSql);
                 PreparedStatement syncPs = conn.prepareStatement(syncStockSql);
                 PreparedStatement autoOutOfStockPs = conn.prepareStatement(autoOutOfStockSql)) {
                
                Set<Integer> distinctProductIds = new HashSet<>();

                for (CartItem item : cart.values()) {
                    long itemtotal = item.getPrice() * item.getQty();
                    detailPs.setInt(1, orderId);
                    detailPs.setInt(2, item.getProductId());
                    detailPs.setString(3, item.getSize() != null ? item.getSize() : "");
                    detailPs.setString(4, item.getColor() != null ? item.getColor() : "");
                    detailPs.setInt(5, item.getQty());
                    detailPs.setLong(6, item.getPrice());
                    detailPs.setLong(7, itemtotal);
                    detailPs.addBatch();

                    // Trừ tồn kho sản phẩm chính
                    stockPs.setInt(1, item.getQty());
                    stockPs.setInt(2, item.getProductId());
                    stockPs.addBatch();

                    // Trừ tồn kho biến thể chi tiết (Size, Màu)
                    if (item.getVariantId() > 0) {
                        variantPs.setInt(1, item.getQty());
                        variantPs.setInt(2, item.getVariantId());
                        variantPs.addBatch();
                    } else if (item.getSize() != null && !item.getSize().isEmpty() && item.getColor() != null && !item.getColor().isEmpty()) {
                        variantFallbackPs.setInt(1, item.getQty());
                        variantFallbackPs.setInt(2, item.getProductId());
                        variantFallbackPs.setString(3, item.getSize());
                        variantFallbackPs.setString(4, item.getColor());
                        variantFallbackPs.addBatch();
                    }

                    distinctProductIds.add(item.getProductId());
                }
                detailPs.executeBatch();
                stockPs.executeBatch();
                variantPs.executeBatch();
                variantFallbackPs.executeBatch();

                // Đồng bộ tổng tồn kho theo các biến thể và tự động cập nhật trạng thái nếu hết hàng
                for (int pid : distinctProductIds) {
                    syncPs.setInt(1, pid);
                    syncPs.setInt(2, pid);
                    syncPs.setInt(3, pid);
                    syncPs.executeUpdate();

                    autoOutOfStockPs.setInt(1, pid);
                    autoOutOfStockPs.executeUpdate();
                }
            }

            // Bước 4: Lưu Thanh Toán
            String paySql = "INSERT INTO ThanhToan (maDonHang, phuongThuc, soTienGiaoDich) VALUES (?,?,?)";
            try (PreparedStatement payPs = conn.prepareStatement(paySql)) {
                payPs.setInt(1, orderId);
                payPs.setString(2, paymentMethod);
                payPs.setLong(3, totalMoney);
                payPs.executeUpdate();
            }

            // Bước 5: Lưu Hóa Đơn (Invoice)
            String invoiceSql = "INSERT INTO HoaDon (maDonHang, tongTien) VALUES (?,?)";
            try (PreparedStatement invPs = conn.prepareStatement(invoiceSql)) {
                invPs.setInt(1, orderId);
                invPs.setLong(2, totalMoney);
                invPs.executeUpdate();
            }

            conn.commit();
            return orderId;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Order> getByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT d.*, a.hoTenNguoiNhan, a.sdtNguoiNhan, a.diaChiChiTiet, t.phuongThuc, t.trangThaiGiaoDich " +
                     "FROM DonHang d " +
                     "LEFT JOIN DiaChiGiaoHang a ON d.maDiaChi = a.maDiaChi " +
                     "LEFT JOIN ThanhToan t ON d.maDonHang = t.maDonHang " +
                     "WHERE d.maNguoiDung=? ORDER BY d.maDonHang DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        for (Order o : list) {
            o.setItems(getDetails(o.getOrderId()));
        }
        return list;
    }

    public Order getById(int orderId) {
        String sql = "SELECT d.*, a.hoTenNguoiNhan, a.sdtNguoiNhan, a.diaChiChiTiet, t.phuongThuc, t.trangThaiGiaoDich " +
                     "FROM DonHang d " +
                     "LEFT JOIN DiaChiGiaoHang a ON d.maDiaChi = a.maDiaChi " +
                     "LEFT JOIN ThanhToan t ON d.maDonHang = t.maDonHang " +
                     "WHERE d.maDonHang=?";
        Order o = null;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) o = mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        if (o != null) {
            o.setItems(getDetails(o.getOrderId()));
        }
        return o;
    }

    public List<OrderDetail> getDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT c.*, p.tenSanPham, p.hinhAnhChinh, p.tongSoLuongTon, p.trangThai " +
                     "FROM ChiTietDonHang c " +
                     "JOIN SanPham p ON c.maSanPham = p.maSanPham " +
                     "WHERE c.maDonHang=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail d = new OrderDetail();
                    d.setId(rs.getInt("maChiTietDon"));
                    d.setOrderId(rs.getInt("maDonHang"));
                    d.setProductId(rs.getInt("maSanPham"));
                    d.setProductName(rs.getString("tenSanPham"));
                    d.setProductImage(rs.getString("hinhAnhChinh"));
                    d.setSize(rs.getString("size"));
                    d.setColor(rs.getString("mauSac"));
                    d.setPrice(rs.getLong("donGia"));
                    d.setQuantity(rs.getInt("soLuong"));
                    d.settotal(rs.getLong("thanhTien"));
                    d.setCurrentStock(rs.getInt("tongSoLuongTon"));
                    d.setProductStatus(rs.getInt("trangThai"));
                    list.add(d);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Order> getAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT d.*, a.hoTenNguoiNhan, a.sdtNguoiNhan, a.diaChiChiTiet, t.phuongThuc, t.trangThaiGiaoDich " +
                     "FROM DonHang d LEFT JOIN DiaChiGiaoHang a ON d.maDiaChi = a.maDiaChi " +
                     "LEFT JOIN ThanhToan t ON d.maDonHang = t.maDonHang " +
                     "ORDER BY d.maDonHang DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Order> getRecent(int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT d.*, a.hoTenNguoiNhan, a.sdtNguoiNhan, a.diaChiChiTiet " +
                     "FROM DonHang d LEFT JOIN DiaChiGiaoHang a ON d.maDiaChi = a.maDiaChi " +
                     "ORDER BY d.maDonHang DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStatus(int orderId, String status) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE DonHang SET trangThaiDon=? WHERE maDonHang=?")) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean cancelOrder(int orderId, int userId) {
        String sql = "UPDATE DonHang SET trangThaiDon='Đã hủy' WHERE maDonHang=? AND maNguoiDung=? AND trangThaiDon='Chờ xác nhận'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countAllAdmin(String keyword, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM DonHang d LEFT JOIN DiaChiGiaoHang a ON d.maDiaChi = a.maDiaChi WHERE 1=1";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (CAST(d.maDonHang AS CHAR) = ? OR a.sdtNguoiNhan LIKE ?)";
        }
        if (statusFilter != null && !statusFilter.equals("all")) {
            sql += " AND d.trangThaiDon = ?";
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, keyword.trim());
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }
            if (statusFilter != null && !statusFilter.equals("all")) {
                ps.setString(idx++, statusFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Order> getAllAdminPaged(String keyword, String statusFilter, int page, int limit) {
        List<Order> list = new ArrayList<>();
        int offset = (page - 1) * limit;
        String sql = "SELECT d.*, a.hoTenNguoiNhan, a.sdtNguoiNhan, a.diaChiChiTiet, t.phuongThuc, t.trangThaiGiaoDich " +
                     "FROM DonHang d " +
                     "LEFT JOIN DiaChiGiaoHang a ON d.maDiaChi = a.maDiaChi " +
                     "LEFT JOIN ThanhToan t ON d.maDonHang = t.maDonHang " +
                     "WHERE 1=1";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (CAST(d.maDonHang AS CHAR) = ? OR a.sdtNguoiNhan LIKE ?)";
        }
        if (statusFilter != null && !statusFilter.equals("all")) {
            sql += " AND d.trangThaiDon = ?";
        }
        sql += " ORDER BY d.maDonHang DESC LIMIT ? OFFSET ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, keyword.trim());
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }
            if (statusFilter != null && !statusFilter.equals("all")) {
                ps.setString(idx++, statusFilter);
            }
            ps.setInt(idx++, limit);
            ps.setInt(idx, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        for (Order o : list) {
            o.setItems(getDetails(o.getOrderId()));
        }
        return list;
    }

    public int count() {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM DonHang");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public long gettotalRevenue() {
        String sql = "SELECT COALESCE(SUM(tongThanhToan),0) FROM DonHang WHERE trangThaiDon='Hoàn thành'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<String> getLast7DaysLabels() {
        List<String> labels = new ArrayList<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM");
        for (int i = 6; i >= 0; i--) {
            labels.add(LocalDate.now().minusDays(i).format(fmt));
        }
        return labels;
    }

    public List<Long> getLast7DaysRevenue() {
        List<Long> data = new ArrayList<>();
        String sql = "SELECT COALESCE(SUM(tongThanhToan),0) FROM DonHang WHERE trangThaiDon='Hoàn thành' AND DATE(ngayDatHang)=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 6; i >= 0; i--) {
                String day = LocalDate.now().minusDays(i).toString();
                ps.setString(1, day);
                try (ResultSet rs = ps.executeQuery()) {
                    data.add(rs.next() ? rs.getLong(1) : 0L);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return data;
    }

    public List<java.util.Map<String, Object>> getTopSellingProducts(int limit) {
        List<java.util.Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.tenSanPham, SUM(c.soLuong) as qty " +
                     "FROM ChiTietDonHang c JOIN SanPham p ON c.maSanPham = p.maSanPham " +
                     "GROUP BY p.maSanPham ORDER BY qty DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> map = new java.util.HashMap<>();
                    map.put("name", rs.getString("tenSanPham"));
                    map.put("qty", rs.getInt("qty"));
                    list.add(map);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("maDonHang"));
        o.setUserId(rs.getInt("maNguoiDung"));
        o.setAddressId(rs.getInt("maDiaChi"));
        o.settotalGoods(rs.getLong("tongTienHang"));
        o.setShippingFee(rs.getLong("phiVanChuyen"));
        o.settotalMoney(rs.getLong("tongThanhToan"));
        o.setChannel(rs.getString("kenhBanHang"));
        o.setStatus(rs.getString("trangThaiDon"));
        o.setNote(rs.getString("ghiChu"));
        try { o.setOrderDate(rs.getTimestamp("ngayDatHang")); } catch (SQLException ignored) {}
        
        // Joined info
        try { o.setCustomerName(rs.getString("hoTenNguoiNhan")); } catch (SQLException ignored) {}
        try { o.setCustomerPhone(rs.getString("sdtNguoiNhan")); } catch (SQLException ignored) {}
        try { o.setAddressDetail(rs.getString("diaChiChiTiet")); } catch (SQLException ignored) {}
        try { o.setPaymentMethod(rs.getString("phuongThuc")); } catch (SQLException ignored) {}
        try { o.setPaymentStatus(rs.getString("trangThaiGiaoDich")); } catch (SQLException ignored) {}
        return o;
    }
}
