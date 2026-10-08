package com.nexora.dao;
import com.nexora.db.DBUtil;
import com.nexora.model.Customer;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    public Customer findByEmail(String identifier) {
        String sql = "SELECT * FROM NguoiDung WHERE (email = ? OR soDienThoai = ? OR hoTen = ?) AND vaiTro = 'KhachHang'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identifier);
            ps.setString(2, identifier);
            ps.setString(3, identifier);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Customer findById(int id) {
        String sql = "SELECT * FROM NguoiDung WHERE maNguoiDung = ? AND vaiTro = 'KhachHang'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Customer getUserById(int id) {
        String sql = "SELECT * FROM NguoiDung WHERE maNguoiDung = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean emailExists(String email) { return findByEmail(email) != null; }

    public boolean register(String fullname, String email, String password, String phone) {
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        // Bảng mới không có cột diaChi trong NguoiDung
        String sql = "INSERT INTO NguoiDung (hoTen, email, matKhau, soDienThoai, vaiTro) VALUES (?,?,?,?,'KhachHang')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, phone);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean addUser(String fullname, String email, String phone, String role, String password) {
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        String sql = "INSERT INTO NguoiDung (hoTen, email, matKhau, soDienThoai, vaiTro) VALUES (?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, phone);
            ps.setString(5, role);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
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

    public boolean changePassword(int userId, String newPassword) {
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        String sql = "UPDATE NguoiDung SET matKhau=? WHERE maNguoiDung=? AND vaiTro='KhachHang'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(int userId, int status) {
        String sql = "UPDATE NguoiDung SET trangThai=? WHERE maNguoiDung=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean resetPassword(int userId, String newPassword) {
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        String sql = "UPDATE NguoiDung SET matKhau=? WHERE maNguoiDung=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateUser(int userId, String fullname, String phone, String role) {
        String sql = "UPDATE NguoiDung SET hoTen=?, soDienThoai=?, vaiTro=? WHERE maNguoiDung=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setString(3, role);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Customer> getAll() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM NguoiDung WHERE vaiTro='KhachHang' ORDER BY maNguoiDung DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int count() {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM NguoiDung WHERE vaiTro='KhachHang'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Customer> getFilteredUsers(String search, String role, String status, int offset, int limit) {
        List<Customer> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM NguoiDung WHERE 1=1 ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (hoTen LIKE ? OR email LIKE ? OR soDienThoai LIKE ?) ");
        }
        if (role != null && !role.isEmpty()) {
            sql.append("AND vaiTro = ? ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND trangThai = ? ");
        }
        sql.append("ORDER BY maNguoiDung DESC LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
            }
            if (role != null && !role.isEmpty()) {
                ps.setString(paramIndex++, role);
            }
            if (status != null && !status.isEmpty()) {
                ps.setInt(paramIndex++, Integer.parseInt(status));
            }
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex++, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countFilteredUsers(String search, String role, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM NguoiDung WHERE 1=1 ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (hoTen LIKE ? OR email LIKE ? OR soDienThoai LIKE ?) ");
        }
        if (role != null && !role.isEmpty()) {
            sql.append("AND vaiTro = ? ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND trangThai = ? ");
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
            }
            if (role != null && !role.isEmpty()) {
                ps.setString(paramIndex++, role);
            }
            if (status != null && !status.isEmpty()) {
                ps.setInt(paramIndex++, Integer.parseInt(status));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Customer mapRow(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setUserId(rs.getInt("maNguoiDung"));
        c.setFullname(rs.getString("hoTen"));
        c.setEmail(rs.getString("email"));
        c.setPassword(rs.getString("matKhau"));
        c.setPhone(rs.getString("soDienThoai"));
        // Không có diaChi
        c.setAddress("");
        c.setRole(rs.getString("vaiTro"));
        c.setStatus(rs.getInt("trangThai"));
        try { c.setCreatedAt(rs.getTimestamp("ngayTao")); } catch (SQLException ignored) {}
        return c;
    }
}