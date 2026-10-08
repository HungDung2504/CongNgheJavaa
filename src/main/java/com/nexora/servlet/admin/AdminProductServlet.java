package com.nexora.servlet.admin;

import com.nexora.dao.CategoryDAO;
import com.nexora.dao.ProductDAO;
import com.nexora.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.List;

@WebServlet("/admin/products")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class AdminProductServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private com.nexora.dao.VariantDAO variantDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        variantDAO = new com.nexora.dao.VariantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            req.setAttribute("categories", categoryDAO.getAll());
            req.getRequestDispatcher("/views/admin/productAdd.jsp").forward(req, resp);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("product", productDAO.getById(id));
            req.setAttribute("categories", categoryDAO.getAll());
            req.setAttribute("variants", variantDAO.getByProductId(id));
            req.getRequestDispatcher("/views/admin/productEdit.jsp").forward(req, resp);
            return;
        }

        if ("delete_variant".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            variantDAO.delete(id);
            setToast(req.getSession(), "success", "Đã xóa", "Biến thể đã được xóa.");
            String referer = req.getHeader("Referer");
            resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/admin/products");
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            productDAO.delete(id);
            setToast(req.getSession(), "success", "Đã xóa", "Sản phẩm đã được xóa.");
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }

        String keyword = req.getParameter("search");
        int page = 1;
        int limit = 10; // Giới hạn 10 sản phẩm mỗi trang cho Admin
        try {
            if (req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page"));
        } catch (NumberFormatException ignored) {}
        
        List<Product> products = productDAO.getAllAdminPaged(keyword, page, limit);
        int totalProducts = productDAO.countAllAdmin(keyword);
        int totalPages = (int) Math.ceil((double) totalProducts / limit);
        
        req.setAttribute("products", products);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("searchKeyword", keyword != null ? keyword : "");
        req.getRequestDispatcher("/views/admin/products.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("insert".equals(action)) {
            Product p = buildProduct(req);
            String imageName = handleFileUpload(req);
            if (imageName != null) p.setImage(imageName);
            productDAO.insert(p);
            setToast(req.getSession(), "success", "Thêm Thành công!", "Sản phẩm mới đã được thêm.");
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(req.getParameter("product_id"));
            Product p = buildProduct(req);
            p.setProductId(id);
            String imageName = handleFileUpload(req);
            if (imageName != null) {
                p.setImage(imageName);
            } else {
                Product existing = productDAO.getById(id);
                if (existing != null) p.setImage(existing.getImage());
            }
            productDAO.update(p);
            setToast(req.getSession(), "success", "Cập nhật Thành công!", "Sản phẩm đã được cập nhật.");
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        } else if ("add_variant".equals(action)) {
            try {
                int pid = Integer.parseInt(req.getParameter("product_id"));
                com.nexora.model.ProductVariant v = new com.nexora.model.ProductVariant();
                v.setProductId(pid);
                v.setSize(req.getParameter("size"));
                v.setColor(req.getParameter("color"));
                v.setPrice(Long.parseLong(req.getParameter("price")));
                v.setStock(Integer.parseInt(req.getParameter("stock")));
                variantDAO.insert(v);
                setToast(req.getSession(), "success", "Thành công!", "Đã thêm biến thể mới.");
                resp.sendRedirect(req.getContextPath() + "/admin/products?action=edit&id=" + pid);
            } catch (Exception e) {
                e.printStackTrace();
                setToast(req.getSession(), "error", "Lỗi!", "Không thể thêm biến thể: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/admin/products");
            }
        }
    }

    private Product buildProduct(HttpServletRequest req) {
        Product p = new Product();
        p.setCatId(Integer.parseInt(req.getParameter("cat_id")));
        p.setProductName(req.getParameter("product_name"));
        p.setPrice(Long.parseLong(req.getParameter("price")));
        p.setStock(Integer.parseInt(req.getParameter("stock")));
        p.setProductDesc(req.getParameter("product_desc"));
        // Cấu trúc 12 bảng không có isHot, material, style, origin. Gán mặc định để tránh lỗi logic nếu có
        p.setHot(false); 
        p.setSize(req.getParameter("size"));
        p.setColor(req.getParameter("color"));
        return p;
    }

    private String handleFileUpload(HttpServletRequest req) {
        try {
            Part filePart = req.getPart("image");
            if (filePart == null || filePart.getSize() == 0) return null;
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (fileName.isEmpty()) return null;
            String uploadDir = getServletContext().getRealPath("/assets/images/");
            new File(uploadDir).mkdirs();
            filePart.write(uploadDir + File.separator + fileName);
            return fileName;
        } catch (Exception e) { e.printStackTrace(); return null; }
    }

    private void setToast(HttpSession s, String type, String title, String msg) {
        s.setAttribute("toast_type", type);
        s.setAttribute("toast_title", title);
        s.setAttribute("toast_msg", msg);
    }
}