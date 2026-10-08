package com.nexora.servlet.admin;

import com.nexora.dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/user-lock")
public class AdminUserLockServlet extends HttpServlet {
    private CustomerDAO customerDAO;
    @Override public void init() { customerDAO = new CustomerDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        String action = req.getParameter("action");
        if (idParam != null && action != null) {
            int userId = Integer.parseInt(idParam);
            int status = action.equals("lock") ? 0 : 1;
            customerDAO.updateStatus(userId, status);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
