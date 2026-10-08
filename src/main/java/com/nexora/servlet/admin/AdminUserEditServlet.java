package com.nexora.servlet.admin;

import com.nexora.dao.CustomerDAO;
import com.nexora.model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/user-edit")
public class AdminUserEditServlet extends HttpServlet {
    private CustomerDAO customerDAO;
    @Override public void init() { customerDAO = new CustomerDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            Customer c = customerDAO.getUserById(Integer.parseInt(idParam));
            if (c != null) {
                req.setAttribute("customer", c);
                req.getRequestDispatcher("/views/admin/userEdit.jsp").forward(req, resp);
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        int userId = Integer.parseInt(req.getParameter("userId"));
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String role = req.getParameter("role");
        
        customerDAO.updateUser(userId, fullname, phone, role);
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
