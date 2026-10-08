package com.nexora.servlet.admin;

import com.nexora.dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** AdminCategoryServlet - Quan ly Danh mục (thay admin/categories.php) */
@WebServlet("/admin/categories")
public class AdminCategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override public void init() { categoryDAO = new CategoryDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            categoryDAO.delete(Integer.parseInt(req.getParameter("id")));
            setToast(req.getSession(), "success", "Da xoa", "Danh mục da duoc xoa.");
            resp.sendRedirect(req.getContextPath() + "/admin/categories"); return;
        }

        String keyword = req.getParameter("search");
        String statusFilter = req.getParameter("status");
        int page = 1;
        int limit = 20; // Kết quả hiển thị tối đa 20 bản ghi/trang
        try {
            if (req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page"));
        } catch (NumberFormatException ignored) {}

        int totalRecords = categoryDAO.countAllAdmin(keyword, statusFilter);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        req.setAttribute("categories", categoryDAO.getAllAdminPaged(keyword, statusFilter, page, limit));
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("searchKeyword", keyword != null ? keyword : "");
        req.setAttribute("statusFilter", statusFilter != null ? statusFilter : "all");

        req.getRequestDispatcher("/views/admin/categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        
        com.nexora.model.Category c = new com.nexora.model.Category();
        c.setCatName(req.getParameter("cat_name"));
        c.setCatIcon(req.getParameter("cat_icon"));
        c.setDescription(req.getParameter("moTa"));
        c.setStatus("1".equals(req.getParameter("trangThai")));

        if ("insert".equals(action)) {
            categoryDAO.insert(c);
            setToast(req.getSession(), "success", "Them Thành công!", "Danh mục moi da duoc them.");
        } else if ("update".equals(action)) {
            c.setCatId(Integer.parseInt(req.getParameter("cat_id")));
            categoryDAO.update(c);
            setToast(req.getSession(), "success", "Cap nhat Thành công!", "Danh mục da duoc cap nhat.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void setToast(HttpSession s, String type, String title, String msg) {
        s.setAttribute("toast_type", type); s.setAttribute("toast_title", title); s.setAttribute("toast_msg", msg);
    }
}