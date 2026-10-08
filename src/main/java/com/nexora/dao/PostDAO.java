package com.nexora.dao;
import com.nexora.db.DBUtil;
import com.nexora.model.Post;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {
    public List<Post> getAll() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM BaiViet ORDER BY maBaiViet DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Post p = new Post();
                p.setPostId(rs.getInt("maBaiViet"));
                p.setTitle(rs.getString("tieuDe"));
                p.setContent(rs.getString("noiDung"));
                p.setImage(rs.getString("hinhAnh"));
                p.setCreatedAt(rs.getTimestamp("ngayTao"));
                p.setStatus(rs.getString("trangThai"));
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    
    public Post getById(int id) {
        String sql = "SELECT * FROM BaiViet WHERE maBaiViet=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Post p = new Post();
                    p.setPostId(rs.getInt("maBaiViet"));
                    p.setTitle(rs.getString("tieuDe"));
                    p.setContent(rs.getString("noiDung"));
                    p.setImage(rs.getString("hinhAnh"));
                    p.setCreatedAt(rs.getTimestamp("ngayTao"));
                    p.setStatus(rs.getString("trangThai"));
                    return p;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
    
    public boolean insert(Post p) {
        String sql = "INSERT INTO BaiViet (tieuDe, noiDung, hinhAnh, trangThai) VALUES (?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getTitle());
            ps.setString(2, p.getContent());
            ps.setString(3, p.getImage());
            ps.setString(4, p.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
    
    public boolean update(Post p) {
        String sql = "UPDATE BaiViet SET tieuDe=?, noiDung=?, hinhAnh=?, trangThai=? WHERE maBaiViet=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getTitle());
            ps.setString(2, p.getContent());
            ps.setString(3, p.getImage());
            ps.setString(4, p.getStatus());
            ps.setInt(5, p.getPostId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
    
    public boolean delete(int id) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM BaiViet WHERE maBaiViet=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
