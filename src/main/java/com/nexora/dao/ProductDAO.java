package com.nexora.dao;
import com.nexora.db.DBUtil;
import com.nexora.model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getHotProducts(int limit) {
        String sql = "SELECT * FROM SanPham WHERE trangThai != 0 ORDER BY ngayTao DESC LIMIT ?";
        return queryList(sql, ps -> ps.setInt(1, limit));
    }

    public List<Product> getByCategory(int catId, int limit) {
        String sql = "SELECT * FROM SanPham WHERE maDanhMuc=? AND trangThai != 0 ORDER BY maSanPham DESC LIMIT ?";
        return queryList(sql, ps -> { ps.setInt(1, catId); ps.setInt(2, limit); });
    }

    public List<Product> getByCategoryPaged(int catId, int offset, int limit) {
        String sql = "SELECT * FROM SanPham WHERE maDanhMuc=? AND trangThai != 0 ORDER BY maSanPham DESC LIMIT ? OFFSET ?";
        return queryList(sql, ps -> { ps.setInt(1, catId); ps.setInt(2, limit); ps.setInt(3, offset); });
    }

    public int countByCategory(int catId) {
        String sql = "SELECT COUNT(*) FROM SanPham WHERE maDanhMuc=? AND trangThai != 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, catId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Product> search(String keyword) {
        String sql = "SELECT * FROM SanPham WHERE tenSanPham LIKE ? AND trangThai != 0 ORDER BY maSanPham DESC LIMIT 40";
        return queryList(sql, ps -> ps.setString(1, "%" + keyword + "%"));
    }

    public Product getById(int id) {
        String sql = "SELECT * FROM SanPham WHERE maSanPham=?";
        List<Product> list = queryList(sql, ps -> ps.setInt(1, id));
        return list.isEmpty() ? null : list.get(0);
    }

    public int count() {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM SanPham");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Product> getAll() {
        String sql = "SELECT p.*, c.tenDanhMuc FROM SanPham p JOIN DanhMuc c ON p.maDanhMuc=c.maDanhMuc ORDER BY p.maSanPham DESC";
        return queryList(sql, ps -> {});
    }

    public int insert(Product p) {
        String sql = "INSERT INTO SanPham (maDanhMuc, tenSanPham, size, mauSac, hinhAnhChinh, moTaChiTiet, giaBan, tongSoLuongTon) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getCatId());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getSize());
            ps.setString(4, p.getColor());
            ps.setString(5, p.getImage());
            ps.setString(6, p.getProductDesc());
            ps.setLong(7, p.getPrice());
            ps.setInt(8, p.getStock());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean update(Product p) {
        String sql = "UPDATE SanPham SET maDanhMuc=?, tenSanPham=?, size=?, mauSac=?, hinhAnhChinh=?, moTaChiTiet=?, giaBan=?, tongSoLuongTon=? WHERE maSanPham=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCatId());
            ps.setString(2, p.getProductName());
            ps.setString(3, p.getSize());
            ps.setString(4, p.getColor());
            ps.setString(5, p.getImage());
            ps.setString(6, p.getProductDesc());
            ps.setLong(7, p.getPrice());
            ps.setInt(8, p.getStock());
            ps.setInt(9, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE SanPham SET trangThai=0 WHERE maSanPham=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @FunctionalInterface
    interface StatementSetter { void set(PreparedStatement ps) throws SQLException; }

    private List<Product> queryList(String sql, StatementSetter setter) {
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setter.set(ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("maSanPham"));
        p.setCatId(rs.getInt("maDanhMuc"));
        p.setProductName(rs.getString("tenSanPham"));
        p.setSize(rs.getString("size"));
        p.setColor(rs.getString("mauSac"));
        p.setPrice(rs.getLong("giaBan"));
        p.setStock(rs.getInt("tongSoLuongTon"));
        p.setImage(rs.getString("hinhAnhChinh"));
        p.setProductDesc(rs.getString("moTaChiTiet"));
        p.setHot(false); // Default to false
        try { p.setStatus(rs.getInt("trangThai")); } catch (SQLException ignored) {}
        try { p.setCreatedAt(rs.getTimestamp("ngayTao")); } catch (SQLException ignored) {}
        try { p.setCatName(rs.getString("tenDanhMuc")); } catch (SQLException ignored) {}
        return p;
    }

    public boolean updateStatus(int productId, int status) {
        String sql = "UPDATE SanPham SET trangThai=? WHERE maSanPham=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean addStock(int productId, int quantity) {
        String sql = "UPDATE SanPham SET tongSoLuongTon = tongSoLuongTon + ? WHERE maSanPham = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Product> getPaginated(int page, int limit) {
        int offset = (page - 1) * limit;
        String sql = "SELECT * FROM SanPham ORDER BY maSanPham DESC LIMIT ? OFFSET ?";
        return queryList(sql, ps -> {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
        });
    }

    public int countAllAdmin(String keyword) {
        String sql = "SELECT COUNT(*) FROM SanPham p JOIN DanhMuc c ON p.maDanhMuc=c.maDanhMuc";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE p.tenSanPham LIKE ?";
            try {
                int id = Integer.parseInt(keyword.trim());
                sql += " OR p.maSanPham = " + id;
            } catch (NumberFormatException ignored) {}
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Product> getAllAdminPaged(String keyword, int page, int limit) {
        int offset = (page - 1) * limit;
        String sql = "SELECT p.*, c.tenDanhMuc FROM SanPham p JOIN DanhMuc c ON p.maDanhMuc=c.maDanhMuc";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE p.tenSanPham LIKE ?";
            try {
                int id = Integer.parseInt(keyword.trim());
                sql += " OR p.maSanPham = " + id;
            } catch (NumberFormatException ignored) {}
        }
        sql += " ORDER BY p.maSanPham DESC LIMIT ? OFFSET ?";
        
        return queryList(sql, ps -> {
            int paramIdx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIdx++, "%" + keyword.trim() + "%");
            }
            ps.setInt(paramIdx++, limit);
            ps.setInt(paramIdx, offset);
        });
    }
}
