package com.nexora.servlet.customer;

import com.nexora.dao.CustomerDAO;
import com.nexora.dao.OrderDAO;
import com.nexora.dao.ProductDAO;
import com.nexora.model.CartItem;
import com.nexora.model.Customer;
import com.nexora.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private CustomerDAO customerDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Map<String, CartItem> cart = (session != null) ? (Map<String, CartItem>) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        Customer customer = customerDAO.findById(userId);
        if (customer == null) {
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        long totalMoney = cart.values().stream().mapToLong(item -> item.getPrice() * item.getQty()).sum();
        req.setAttribute("customer", customer);
        req.setAttribute("cart", cart);
        req.setAttribute("totalMoney", totalMoney);
        req.getRequestDispatcher("/views/customer/checkout.jsp").forward(req, resp);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Map<String, CartItem> cart = (session != null) ? (Map<String, CartItem>) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        ProductDAO productDAO = new ProductDAO();
        com.nexora.dao.VariantDAO variantDAO = new com.nexora.dao.VariantDAO();
        boolean outOfStock = false;
        
        for (CartItem item : cart.values()) {
            int availableStock = 0;
            if (item.getVariantId() > 0) {
                com.nexora.model.ProductVariant v = variantDAO.getById(item.getVariantId());
                if (v != null) availableStock = v.getStock();
            } else {
                Product p = productDAO.getById(item.getProductId());
                if (p != null) availableStock = p.getStock();
            }
            if (item.getQty() > availableStock) {
                outOfStock = true;
                item.setQty(Math.max(0, availableStock));
            }
        }
        
        if (outOfStock) {
            setToast(session, "error", "Lỗi đặt hàng", "Một số sản phẩm không đủ tồn kho. Đã tự động điều chỉnh số lượng.");
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String note = req.getParameter("note");
        String paymentMethod = req.getParameter("payment_method");

        long totalMoney = cart.values().stream().mapToLong(item -> item.getPrice() * item.getQty()).sum() + 20000; // plus shipping
        int orderId = orderDAO.createOrder(userId, fullname, phone, address, note, totalMoney, paymentMethod, cart);

        if (orderId > 0) {
            session.removeAttribute("cart");
            setToast(session, "success", "Thành công!", "Đơn hàng #" + orderId + " đã được ghi nhận.");
            resp.sendRedirect(req.getContextPath() + "/history");
        } else {
            setToast(session, "error", "Lỗi đặt hàng", "Có lỗi xảy ra, vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    }

    private void setToast(HttpSession s, String type, String title, String msg) {
        s.setAttribute("toast_type", type);
        s.setAttribute("toast_title", title);
        s.setAttribute("toast_msg", msg);
    }
}
