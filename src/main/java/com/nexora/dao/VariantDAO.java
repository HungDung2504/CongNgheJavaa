package com.nexora.dao;

import com.nexora.db.DBUtil;
import com.nexora.model.Product;
import com.nexora.model.ProductVariant;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VariantDAO {

    public List<ProductVariant> getByProductId(int productId) {
        List<ProductVariant> list = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ? ORDER BY size ASC, price ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Fallback: nếu sản phẩm chưa có trong product_variants thì tạo variant mặc định từ bảng SanPham
        if (list.isEmpty()) {
            ProductDAO pdao = new ProductDAO();
            Product p = pdao.getById(productId);
            if (p != null) {
                ProductVariant pv = new ProductVariant();
                pv.setVariantId(0);
                pv.setProductId(productId);
                pv.setSize(p.getSize() != null && !p.getSize().isEmpty() ? p.getSize() : "Tiêu chuẩn");
                pv.setColor(p.getColor() != null && !p.getColor().isEmpty() ? p.getColor() : "Mặc định");
                pv.setPrice(p.getPrice());
                pv.setStock(p.getStock());
                list.add(pv);
            }
        }

        return list;
    }

    public ProductVariant getById(int variantId) {
        if (variantId <= 0) return null;
        String sql = "SELECT * FROM product_variants WHERE variant_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insert(ProductVariant v) {
        String sql = "INSERT INTO product_variants (product_id, size, color, price, stock) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, v.getProductId());
            ps.setString(2, v.getSize());
            ps.setString(3, v.getColor());
            ps.setLong(4, v.getPrice());
            ps.setInt(5, v.getStock());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean update(ProductVariant v) {
        String sql = "UPDATE product_variants SET size = ?, color = ?, price = ?, stock = ? WHERE variant_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getSize());
            ps.setString(2, v.getColor());
            ps.setLong(3, v.getPrice());
            ps.setInt(4, v.getStock());
            ps.setInt(5, v.getVariantId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int variantId) {
        String sql = "DELETE FROM product_variants WHERE variant_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, variantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private ProductVariant mapRow(ResultSet rs) throws SQLException {
        ProductVariant v = new ProductVariant();
        v.setVariantId(rs.getInt("variant_id"));
        v.setProductId(rs.getInt("product_id"));
        v.setSize(rs.getString("size"));
        v.setColor(rs.getString("color"));
        v.setPrice(rs.getLong("price"));
        v.setStock(rs.getInt("stock"));
        return v;
    }
}
