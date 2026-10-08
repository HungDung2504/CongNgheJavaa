package com.nexora.dao;

import com.nexora.db.DBUtil;
import com.nexora.model.Contact;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {

    private Contact mapRow(ResultSet rs) throws SQLException {
        Contact c = new Contact();
        c.setContactId(rs.getInt("maLienHe"));
        if (rs.getObject("maNguoiDung") != null) {
            c.setUserId(rs.getInt("maNguoiDung"));
        }
        c.setFullname(rs.getString("hoTen"));
        c.setEmail(rs.getString("email"));
        c.setMessage(rs.getString("noiDung"));
        c.setReply(rs.getString("phanHoi"));
        c.setStatus(rs.getString("trangThai"));
        c.setProcessedAt(rs.getTimestamp("ngayXuLy"));
        c.setCreatedAt(rs.getTimestamp("ngayTao"));
        return c;
    }

    public List<Contact> getAll() {
        List<Contact> list = new ArrayList<>();
        String sql = "SELECT * FROM LienHe ORDER BY maLienHe DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Contact getById(int id) {
        String sql = "SELECT * FROM LienHe WHERE maLienHe = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Contact> getByUser(Integer userId, String email) {
        List<Contact> list = new ArrayList<>();
        String sql;
        if (userId != null && email != null && !email.trim().isEmpty()) {
            sql = "SELECT * FROM LienHe WHERE maNguoiDung = ? OR email = ? ORDER BY maLienHe DESC";
        } else if (userId != null) {
            sql = "SELECT * FROM LienHe WHERE maNguoiDung = ? ORDER BY maLienHe DESC";
        } else if (email != null && !email.trim().isEmpty()) {
            sql = "SELECT * FROM LienHe WHERE email = ? ORDER BY maLienHe DESC";
        } else {
            return list;
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId != null && email != null && !email.trim().isEmpty()) {
                ps.setInt(1, userId);
                ps.setString(2, email.trim());
            } else if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setString(1, email.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insert(Contact c) {
        String sql = "INSERT INTO LienHe (maNguoiDung, hoTen, email, noiDung, trangThai, ngayTao) VALUES (?, ?, ?, ?, 'pending', NOW())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (c.getUserId() != null) {
                ps.setInt(1, c.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, c.getFullname());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE LienHe SET trangThai = ?, ngayXuLy = (CASE WHEN ? IN ('resolved', 'Đã xử lý') THEN NOW() ELSE NULL END) WHERE maLienHe = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean resolve(int id, String reply) {
        String finalReply = (reply != null && !reply.trim().isEmpty())
                ? reply.trim()
                : "Ban quản trị Nexora đã tiếp nhận và xử lý yêu cầu của quý khách.";
        String sql = "UPDATE LienHe SET trangThai = 'resolved', phanHoi = ?, ngayXuLy = NOW() WHERE maLienHe = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, finalReply);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM LienHe WHERE maLienHe = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
