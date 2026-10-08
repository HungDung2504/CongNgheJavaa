package com.nexora.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/settings")
public class AdminSettingsServlet extends HttpServlet {
    
    @Override
    public void init() throws ServletException {
        // Initialize default settings if empty
        if (getServletContext().getAttribute("app_shopName") == null) {
            getServletContext().setAttribute("app_shopName", "Nexora Men Boutique");
            getServletContext().setAttribute("app_shopPhone", "0123.456.789");
            getServletContext().setAttribute("app_shopEmail", "contact@nexora.com");
            getServletContext().setAttribute("app_shopAddress", "123 Đường Fashion, Quận 1, TP. HCM");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/admin/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String shopName = req.getParameter("shop_name");
        String shopPhone = req.getParameter("shop_phone");
        String shopEmail = req.getParameter("shop_email");
        String shopAddress = req.getParameter("shop_address");
        
        // Save to application context (in memory)
        req.getServletContext().setAttribute("app_shopName", shopName);
        req.getServletContext().setAttribute("app_shopPhone", shopPhone);
        req.getServletContext().setAttribute("app_shopEmail", shopEmail);
        req.getServletContext().setAttribute("app_shopAddress", shopAddress);
        
        req.getSession().setAttribute("toastMsg", "Đã lưu cài đặt hệ thống thành công!");
        req.getSession().setAttribute("toastType", "success");
        
        resp.sendRedirect(req.getContextPath() + "/admin/settings");
    }
}
