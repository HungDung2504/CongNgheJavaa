package com.nexora.servlet.admin;

import com.nexora.dao.ContactDAO;
import com.nexora.model.Contact;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/contacts")
public class AdminContactServlet extends HttpServlet {
    private ContactDAO contactDAO;

    @Override
    public void init() {
        contactDAO = new ContactDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("resolve".equals(action)) {
            // Admin an Xu ly xong
            int id = Integer.parseInt(req.getParameter("id"));
            String reply = req.getParameter("reply");
            contactDAO.resolve(id, reply);
            req.getSession().setAttribute("toastMsg", "Đã đánh dấu xử lý xong liên hệ #" + id + "!");
            req.getSession().setAttribute("toastType", "success");
            resp.sendRedirect(req.getContextPath() + "/admin/contacts");
            return;
        } else if ("status".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String st = req.getParameter("st");
            contactDAO.updateStatus(id, st);
            req.getSession().setAttribute("toastMsg", "Cập nhật trạng thái thành công!");
            req.getSession().setAttribute("toastType", "success");
            resp.sendRedirect(req.getContextPath() + "/admin/contacts");
            return;
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            contactDAO.delete(id);
            req.getSession().setAttribute("toastMsg", "Đã xóa liên hệ thành công!");
            req.getSession().setAttribute("toastType", "success");
            resp.sendRedirect(req.getContextPath() + "/admin/contacts");
            return;
        }

        List<Contact> contacts = contactDAO.getAll();
        req.setAttribute("contacts", contacts);
        req.getRequestDispatcher("/views/admin/contacts.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if ("resolve".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                String reply = req.getParameter("reply");
                contactDAO.resolve(id, reply);
                req.getSession().setAttribute("toastMsg", "Đã xử lý xong và phản hồi cho liên hệ #" + id + "!");
                req.getSession().setAttribute("toastType", "success");
            } catch (Exception e) {
                req.getSession().setAttribute("toastMsg", "Lỗi xử lý: " + e.getMessage());
                req.getSession().setAttribute("toastType", "error");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/contacts");
    }
}
