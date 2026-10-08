package com.nexora.servlet.admin;

import com.nexora.dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/** AdminUserServlet - Quan ly Khách hàng (thay admin/users.php) */
@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private CustomerDAO customerDAO;

    @Override public void init() { customerDAO = new CustomerDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String search = req.getParameter("search");
        String role = req.getParameter("role");
        String status = req.getParameter("status");
        
        int page = 1;
        int limit = 20;
        try {
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
        } catch (NumberFormatException ignored) {}
        
        int offset = (page - 1) * limit;
        
        req.setAttribute("customers", customerDAO.getFilteredUsers(search, role, status, offset, limit));
        
        int totalRecords = customerDAO.countFilteredUsers(search, role, status);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);
        
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("search", search);
        req.setAttribute("role", role);
        req.setAttribute("status", status);

        req.getRequestDispatcher("/views/admin/users.jsp").forward(req, resp);
    }
}