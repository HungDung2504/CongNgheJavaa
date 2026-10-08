package com.nexora.dao;
import com.nexora.db.DBUtil;
import com.nexora.model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM DanhMuc WHERE trangThai=1 ORDER BY maDanhMuc ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Category getById(int id) {
        String sql = "SELECT * FROM DanhMuc WHERE maDanhMuc = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Category c) {
        String sql = "INSERT INTO DanhMuc (tenDanhMuc, moTa, icon, trangThai) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCatName());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getCatIcon());
            ps.setInt(4, c.isStatus() ? 1 : 0);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Category c) {
        String sql = "UPDATE DanhMuc SET tenDanhMuc=?, moTa=?, icon=?, trangThai=? WHERE maDanhMuc=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCatName());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getCatIcon());
            ps.setInt(4, c.isStatus() ? 1 : 0);
            ps.setInt(5, c.getCatId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM DanhMuc WHERE maDanhMuc = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countAllAdmin(String keyword, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM DanhMuc WHERE 1=1";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND tenDanhMuc LIKE ?";
        }
        if ("hienthi".equals(statusFilter)) sql += " AND trangThai=1";
        else if ("daan".equals(statusFilter)) sql += " AND trangThai=0";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Category> getAllAdminPaged(String keyword, String statusFilter, int page, int limit) {
        List<Category> list = new ArrayList<>();
        int offset = (page - 1) * limit;
        String sql = "SELECT * FROM DanhMuc WHERE 1=1";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND tenDanhMuc LIKE ?";
        }
        if ("hienthi".equals(statusFilter)) sql += " AND trangThai=1";
        else if ("daan".equals(statusFilter)) sql += " AND trangThai=0";
        sql += " ORDER BY maDanhMuc DESC LIMIT ? OFFSET ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIdx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIdx++, "%" + keyword + "%");
            }
            ps.setInt(paramIdx++, limit);
            ps.setInt(paramIdx, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCatId(rs.getInt("maDanhMuc"));
        c.setCatName(rs.getString("tenDanhMuc"));
        c.setDescription(rs.getString("moTa"));
        c.setCatIcon(rs.getString("icon"));
        c.setStatus(rs.getInt("trangThai") == 1);
        c.setSortOrder(0);
        return c;
    }
}