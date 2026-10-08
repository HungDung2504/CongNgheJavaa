package com.nexora.servlet.customer;

import com.nexora.dao.ProductDAO;
import com.nexora.model.CartItem;
import com.nexora.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private ProductDAO productDAO;
    private com.nexora.dao.VariantDAO variantDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        variantDAO = new com.nexora.dao.VariantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        if ("add".equals(action)) {
            addToCart(req, resp, session);
            return;
        }

        if ("delete".equals(action)) {
            String key = req.getParameter("id");
            Map<String, CartItem> cart = getCart(session);
            if (cart.remove(key) != null) {
                setToast(session, "info", "Đã xóa", "Sản phẩm đã được xóa khỏi giỏ hàng.");
            }
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        if ("clear".equals(action)) {
            session.removeAttribute("cart");
            setToast(session, "warning", "Đã xóa tất cả", "Toàn bộ giỏ hàng đã được làm trống.");
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        req.getRequestDispatcher("/views/customer/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        String[] keys = req.getParameterValues("cart_key");
        String[] qtys = req.getParameterValues("qty");

        if (keys != null && qtys != null) {
            Map<String, CartItem> cart = getCart(session);
            boolean hasError = false;
            for (int i = 0; i < Math.min(keys.length, qtys.length); i++) {
                String key = keys[i];
                try {
                    int qty = Integer.parseInt(qtys[i]);
                    if (qty <= 0) {
                        cart.remove(key);
                    } else if (cart.containsKey(key)) {
                        CartItem item = cart.get(key);
                        int availableStock = 999;
                        if (item.getVariantId() > 0) {
                            com.nexora.model.ProductVariant v = variantDAO.getById(item.getVariantId());
                            if (v != null) availableStock = v.getStock();
                        } else {
                            Product p = productDAO.getById(item.getProductId());
                            if (p != null) availableStock = p.getStock();
                        }

                        if (qty > availableStock) {
                            hasError = true;
                            item.setQty(Math.max(1, availableStock));
                        } else {
                            item.setQty(qty);
                        }
                    }
                } catch (NumberFormatException ignored) {}
            }
            if (hasError) {
                setToast(session, "warning", "Cảnh báo tồn kho", "Một số sản phẩm không đủ số lượng nên đã tự động điều chỉnh theo tồn kho.");
            } else {
                setToast(session, "success", "Cập nhật thành công!", "Giỏ hàng đã được cập nhật.");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void addToCart(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws IOException {
        try {
            int productId = Integer.parseInt(req.getParameter("id"));
            String type = req.getParameter("type");
            int variantId = 0;
            try {
                if (req.getParameter("variant_id") != null && !req.getParameter("variant_id").trim().isEmpty()) {
                    variantId = Integer.parseInt(req.getParameter("variant_id").trim());
                }
            } catch (NumberFormatException ignored) {}

            int addQty = 1;
            try {
                if (req.getParameter("qty") != null && !req.getParameter("qty").trim().isEmpty()) {
                    addQty = Math.max(1, Integer.parseInt(req.getParameter("qty").trim()));
                }
            } catch (NumberFormatException ignored) {}

            Product product = productDAO.getById(productId);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }

            String key = (variantId > 0) ? (productId + "_" + variantId) : String.valueOf(productId);
            long price = product.getPrice();
            String size = product.getSize();
            String color = product.getColor();
            int availableStock = product.getStock();
            String displayName = product.getProductName();

            if (variantId > 0) {
                com.nexora.model.ProductVariant v = variantDAO.getById(variantId);
                if (v != null) {
                    price = v.getPrice();
                    size = v.getSize();
                    color = v.getColor();
                    availableStock = v.getStock();
                    displayName = product.getProductName() + " (Size " + size + " - " + color + ")";
                }
            } else {
                if (size != null && !size.isEmpty() && color != null && !color.isEmpty()) {
                    displayName = product.getProductName() + " (Size " + size + " - " + color + ")";
                }
            }

            Map<String, CartItem> cart = getCart(session);
            int currentQty = cart.containsKey(key) ? cart.get(key).getQty() : 0;
            int finalQty = currentQty + addQty;

            if (finalQty > availableStock) {
                setToast(session, "error", "Hết hàng hoặc không đủ tồn kho!", "Hiện tại chỉ còn " + availableStock + " sản phẩm sẵn có.");
                if (cart.containsKey(key) && currentQty > 0) {
                    cart.get(key).setQty(Math.min(currentQty, availableStock));
                }
            } else {
                if (cart.containsKey(key)) {
                    cart.get(key).setQty(finalQty);
                } else {
                    CartItem item = new CartItem();
                    item.setProductId(productId);
                    item.setVariantId(variantId);
                    item.setName(displayName);
                    item.setPrice(price);
                    item.setImage(product.getImage());
                    item.setQty(addQty);
                    item.setSize(size);
                    item.setColor(color);
                    cart.put(key, item);
                }
                setToast(session, "success", "Thêm thành công!", product.getProductName() + " đã được thêm vào giỏ hàng.");
            }

            if ("buy".equals(type)) {
                resp.sendRedirect(req.getContextPath() + "/checkout");
            } else {
                String referer = req.getHeader("Referer");
                resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/cart");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, CartItem> getCart(HttpSession session) {
        Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private void setToast(HttpSession s, String type, String title, String msg) {
        s.setAttribute("toast_type", type);
        s.setAttribute("toast_title", title);
        s.setAttribute("toast_msg", msg);
    }
}
