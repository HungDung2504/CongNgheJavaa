package com.nexora.servlet.admin;

import com.nexora.dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/user-reset")
public class AdminUserResetServlet extends HttpServlet {
    private CustomerDAO customerDAO;
    @Override public void init() { customerDAO = new CustomerDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            int userId = Integer.parseInt(idParam);
            customerDAO.resetPassword(userId, "123456");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
