package com.nexora.servlet.customer;

import com.nexora.dao.ContactDAO;
import com.nexora.model.Contact;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private ContactDAO contactDAO;

    @Override
    public void init() {
        contactDAO = new ContactDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer userId = (session != null && session.getAttribute("user_id") != null)
                ? (Integer) session.getAttribute("user_id")
                : null;
        String userEmail = (session != null && session.getAttribute("email") != null)
                ? (String) session.getAttribute("email")
                : null;

        // Cho phép người dùng chưa đăng nhập tra cứu bằng email nếu nhập form tra cứu
        String searchEmail = req.getParameter("searchEmail");
        if (searchEmail != null && !searchEmail.trim().isEmpty()) {
            userEmail = searchEmail.trim();
            req.setAttribute("searchEmail", userEmail);
        }

        List<Contact> history = null;
        if (userId != null || (userEmail != null && !userEmail.trim().isEmpty())) {
            history = contactDAO.getByUser(userId, userEmail);
        }
        req.setAttribute("contactHistory", history);

        String tab = req.getParameter("tab");
        if (tab == null && history != null && !history.isEmpty() && "1".equals(req.getParameter("submitted"))) {
            tab = "history";
        }
        req.setAttribute("activeTab", tab != null ? tab : "form");

        req.getRequestDispatcher("/views/customer/contact.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            name = req.getParameter("fullname");
        }
        String email = req.getParameter("email");
        String message = req.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            message = req.getParameter("content");
        }

        HttpSession session = req.getSession();
        if (name != null && !name.trim().isEmpty() && email != null && !email.trim().isEmpty() && message != null && !message.trim().isEmpty()) {
            Contact c = new Contact();
            if (session.getAttribute("user_id") != null) {
                try {
                    c.setUserId((Integer) session.getAttribute("user_id"));
                } catch (Exception ignored) {}
            }
            c.setFullname(name.trim());
            c.setEmail(email.trim());
            c.setMessage(message.trim());
            c.setStatus("pending");
            contactDAO.insert(c);

            session.setAttribute("toast_type", "success");
            session.setAttribute("toast_title", "Gửi thành công!");
            session.setAttribute("toast_msg", "Cảm ơn bạn đã liên hệ với Nexora. Lời nhắn của bạn đã được ghi nhận vào Lịch sử liên hệ!");
        } else {
            session.setAttribute("toast_type", "error");
            session.setAttribute("toast_title", "Lỗi gửi liên hệ");
            session.setAttribute("toast_msg", "Vui lòng điền đầy đủ họ tên, email và nội dung liên hệ.");
        }

        String referer = req.getHeader("Referer");
        if (referer != null && referer.contains("/contact")) {
            resp.sendRedirect(req.getContextPath() + "/contact?tab=history&submitted=1");
        } else if (referer != null && !referer.isEmpty()) {
            resp.sendRedirect(referer);
        } else {
            resp.sendRedirect(req.getContextPath() + "/contact?tab=history");
        }
    }
}
