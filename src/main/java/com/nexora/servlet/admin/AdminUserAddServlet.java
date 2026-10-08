package com.nexora.servlet.admin;

import com.nexora.dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/user-add")
public class AdminUserAddServlet extends HttpServlet {
    private CustomerDAO customerDAO;
    @Override public void init() { customerDAO = new CustomerDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/admin/userAdd.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String role = req.getParameter("role");
        String password = req.getParameter("password");
        
        if (customerDAO.emailExists(email)) {
            req.setAttribute("error", "Email đã tồn tại trong hệ thống.");
            req.getRequestDispatcher("/views/admin/userAdd.jsp").forward(req, resp);
            return;
        }
        
        customerDAO.addUser(fullname, email, phone, role, password);
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
