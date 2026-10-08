package com.nexora.servlet.admin;

import com.nexora.dao.OrderDAO;
import com.nexora.model.Order;
import com.nexora.model.OrderDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override public void init() { orderDAO = new OrderDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("detail".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            Order order = orderDAO.getById(orderId);
            List<OrderDetail> details = orderDAO.getDetails(orderId);
            req.setAttribute("order", order);
            req.setAttribute("details", details);
            req.getRequestDispatcher("/views/admin/orderDetail.jsp").forward(req, resp);
            return;
        }

        if ("update_status".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            String status = req.getParameter("status"); // Sửa thành String để khớp với OrderDAO
            orderDAO.updateStatus(orderId, status);
            setToast(req.getSession(), "success", "Cập nhật Thành công!", "Trạng thái Đơn hàng đã được cập nhật.");
            resp.sendRedirect(req.getContextPath() + "/admin/orders?action=detail&id=" + orderId);
            return;
        }

        if ("set_product_status".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            int status = Integer.parseInt(req.getParameter("status"));
            com.nexora.dao.ProductDAO productDAO = new com.nexora.dao.ProductDAO();
            boolean ok = productDAO.updateStatus(productId, status);
            String statusText = (status == 2) ? "HẾT HÀNG" : (status == 3 ? "TẠM HẾT, ĐẶT TRƯỚC" : "CÒN HÀNG");
            if (ok) {
                setToast(req.getSession(), "success", "Thành công!", "Sản phẩm #" + productId + " đã chuyển sang: " + statusText + " (đã cập nhật banner trên trang khách hàng).");
            } else {
                setToast(req.getSession(), "error", "Lỗi", "Không thể cập nhật trạng thái sản phẩm.");
            }
            String orderId = req.getParameter("orderId");
            if (orderId != null && !orderId.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/orders?action=detail&id=" + orderId);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
            }
            return;
        }

        String keyword = req.getParameter("search");
        String statusFilter = req.getParameter("status");
        int page = 1;
        int limit = 10;
        try {
            if (req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page"));
        } catch (NumberFormatException ignored) {}

        int totalRecords = orderDAO.countAllAdmin(keyword, statusFilter);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        List<Order> orders = orderDAO.getAllAdminPaged(keyword, statusFilter, page, limit);
        req.setAttribute("orders", orders);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("searchKeyword", keyword != null ? keyword : "");
        req.setAttribute("statusFilter", statusFilter != null ? statusFilter : "all");

        req.getRequestDispatcher("/views/admin/orders.jsp").forward(req, resp);
    }

    private void setToast(HttpSession s, String type, String title, String msg) {
        s.setAttribute("toast_type", type); s.setAttribute("toast_title", title); s.setAttribute("toast_msg", msg);
    }
}