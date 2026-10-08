package com.nexora.dao;
import com.nexora.db.DBUtil;
import com.nexora.model.Review;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {
    public List<Review> getByProduct(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT d.*, n.hoTen FROM DanhGia d JOIN NguoiDung n ON d.maNguoiDung=n.maNguoiDung WHERE d.maSanPham=? ORDER BY d.maDanhGia DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean addReview(int productId, int userId, int star, String content) {
        String sql = "INSERT INTO DanhGia (maSanPham, maNguoiDung, soSao, noiDung) VALUES (?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ps.setInt(3, star);
            ps.setString(4, content);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int count() {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM DanhGia");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Review mapRow(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setId(rs.getInt("maDanhGia"));
        r.setProductId(rs.getInt("maSanPham"));
        r.setUserId(rs.getInt("maNguoiDung"));
        r.setStar(rs.getInt("soSao"));
        r.setContent(rs.getString("noiDung"));
        try {
            r.setCreatedAt(rs.getTimestamp("ngayDanhGia"));
        } catch (SQLException e) {
            try { r.setCreatedAt(rs.getTimestamp("ngayTao")); } catch (SQLException ignored) {}
        }
        try { r.setFullname(rs.getString("hoTen")); } catch (SQLException ignored) {}
        return r;
    }
}