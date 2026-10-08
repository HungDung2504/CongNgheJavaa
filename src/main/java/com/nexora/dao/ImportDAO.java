package com.nexora.dao;
import com.nexora.db.DBUtil;
import com.nexora.model.ImportDetail;
import com.nexora.model.ImportInvoice;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ImportDAO {
    public int insertInvoice(ImportInvoice inv) {
        String sql = "INSERT INTO PhieuNhapKho (nhaCungCap, tongChiPhi, nguoiTao) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, inv.getSupplier());
            ps.setDouble(2, inv.gettotalCost());
            ps.setString(3, inv.getCreatedBy());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean insertDetail(ImportDetail d) {
        String sql = "INSERT INTO ChiTietNhapKho (maPhieu, maSanPham, soLuong, donGia) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, d.getImportId());
            ps.setInt(2, d.getProductId());
            ps.setInt(3, d.getQuantity());
            ps.setDouble(4, d.getUnitPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
    
    public List<ImportInvoice> getAllInvoices() {
        List<ImportInvoice> list = new ArrayList<>();
        String sql = "SELECT * FROM PhieuNhapKho ORDER BY maPhieu DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ImportInvoice inv = new ImportInvoice();
                inv.setImportId(rs.getInt("maPhieu"));
                inv.setSupplier(rs.getString("nhaCungCap"));
                inv.settotalCost(rs.getDouble("tongChiPhi"));
                inv.setCreatedBy(rs.getString("nguoiTao"));
                inv.setCreatedAt(rs.getTimestamp("ngayTao"));
                list.add(inv);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
