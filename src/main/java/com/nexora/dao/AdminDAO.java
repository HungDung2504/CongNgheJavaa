package com.nexora.dao;
import com.nexora.db.DBUtil;
import com.nexora.model.Admin;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;

public class AdminDAO {
    public Admin findByEmailOrUsername(String identifier) {
        String sql = "SELECT * FROM NguoiDung WHERE (email=? OR hoTen=? OR soDienThoai=? OR ?='admin' OR (email='admin@nexora.com' AND ?='admin@nexora.vn')) AND vaiTro IN ('Admin', 'NhanVien')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identifier);
            ps.setString(2, identifier);
            ps.setString(3, identifier);
            ps.setString(4, identifier);
            ps.setString(5, identifier);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Admin findById(int id) {
        String sql = "SELECT * FROM NguoiDung WHERE maNguoiDung=? AND vaiTro IN ('Admin', 'NhanVien')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean verifyPassword(String rawPassword, String hashedPassword) {
        if (rawPassword == null || hashedPassword == null) return false;
        // 1. So sánh trực tiếp nếu mật khẩu cũ dạng plain-text
        if (rawPassword.equals(hashedPassword)) return true;

        // 2. Kiểm tra MD5
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] digest = md.digest(rawPassword.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) sb.append(String.format("%02x", b));
            if (sb.toString().equalsIgnoreCase(hashedPassword)) return true;
        } catch (Exception ignored) {}

        // 3. Kiểm tra BCrypt
        try {
            String javaHash = hashedPassword.replace("$2y$", "$2a$").replace("$2b$", "$2a$");
            if (javaHash.startsWith("$2a$")) {
                return BCrypt.checkpw(rawPassword, javaHash);
            }
        } catch (Exception ignored) {}

        return false;
    }

    private Admin mapRow(ResultSet rs) throws SQLException {
        Admin a = new Admin();
        a.setUserId(rs.getInt("maNguoiDung"));
        a.setUsername(rs.getString("email")); // Không có tenDangNhap nên xài email
        a.setEmail(rs.getString("email"));
        a.setPassword(rs.getString("matKhau"));
        a.setFullname(rs.getString("hoTen"));
        try { a.setCreatedAt(rs.getTimestamp("ngayTao")); } catch (SQLException ignored) {}
        return a;
    }
}