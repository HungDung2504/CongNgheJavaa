package com.nexora.servlet.admin;

import com.nexora.dao.ImportDAO;
import com.nexora.dao.ProductDAO;
import com.nexora.model.ImportDetail;
import com.nexora.model.ImportInvoice;
import com.nexora.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/inventory")
public class AdminInventoryServlet extends HttpServlet {
    private ProductDAO productDAO;
    private ImportDAO importDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        importDAO = new ImportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("new_import".equals(action)) {
            req.setAttribute("products", productDAO.getAll()); // No pagination for dropdown selection
            req.getRequestDispatcher("/views/admin/importForm.jsp").forward(req, resp);
            return;
        } else if ("delete".equals(action)) {
            int pid = Integer.parseInt(req.getParameter("id"));
            productDAO.delete(pid);
            req.getSession().setAttribute("toastMsg", "Đã xóa sản phẩm khỏi kho!");
            req.getSession().setAttribute("toastType", "success");
            resp.sendRedirect(req.getContextPath() + "/admin/inventory");
            return;
        }
        
        String keyword = req.getParameter("search");
        
        int page = 1;
        int limit = 20;
        try {
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
        } catch (NumberFormatException ignored) {}
        
        List<Product> products = productDAO.getAllAdminPaged(keyword, page, limit);
        com.nexora.dao.VariantDAO variantDAO = new com.nexora.dao.VariantDAO();
        for (Product p : products) {
            p.setVariants(variantDAO.getByProductId(p.getProductId()));
        }
        int totalRecords = productDAO.countAllAdmin(keyword);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);
        
        List<ImportInvoice> invoices = importDAO.getAllInvoices();
        
        req.setAttribute("products", products);
        req.setAttribute("invoices", invoices);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("search", keyword);
        
        req.getRequestDispatcher("/views/admin/inventory.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String supplier = req.getParameter("supplier");
        String[] productIds = req.getParameterValues("product_id[]");
        String[] quantities = req.getParameterValues("quantity[]");
        String[] prices = req.getParameterValues("price[]");

        if (supplier == null || productIds == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/inventory?error=1");
            return;
        }

        double totalCost = 0;
        ImportInvoice inv = new ImportInvoice();
        inv.setSupplier(supplier);
        HttpSession session = req.getSession();
        inv.setCreatedBy((String) session.getAttribute("email"));

        // Temporary calculate total
        for (int i = 0; i < productIds.length; i++) {
            int qty = Integer.parseInt(quantities[i]);
            double price = Double.parseDouble(prices[i]);
            totalCost += (qty * price);
        }
        inv.settotalCost(totalCost);

        int importId = importDAO.insertInvoice(inv);
        if (importId > 0) {
            for (int i = 0; i < productIds.length; i++) {
                int pid = Integer.parseInt(productIds[i]);
                int qty = Integer.parseInt(quantities[i]);
                double price = Double.parseDouble(prices[i]);

                ImportDetail d = new ImportDetail();
                d.setImportId(importId);
                d.setProductId(pid);
                d.setQuantity(qty);
                d.setUnitPrice(price);
                importDAO.insertDetail(d);
                
                // Cap nhat ton kho
                productDAO.addStock(pid, qty);
            }
        }
        
        req.getSession().setAttribute("toastMsg", "Nhập kho thành công!");
        req.getSession().setAttribute("toastType", "success");
        resp.sendRedirect(req.getContextPath() + "/admin/inventory");
    }
}
