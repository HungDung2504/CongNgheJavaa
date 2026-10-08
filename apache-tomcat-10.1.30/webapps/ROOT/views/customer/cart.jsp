<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN" scope="session"/>
<%@ include file="/includes/header.jsp" %>
<%
    java.util.Map<String, com.nexora.model.CartItem> cartMap =
        (java.util.Map<String, com.nexora.model.CartItem>) session.getAttribute("cart");
    long totalBill = 0;
    if (cartMap != null) {
        for (com.nexora.model.CartItem ci : cartMap.values()) totalBill += ci.getSubtotal();
    }
    request.setAttribute("cartMap", cartMap);
    request.setAttribute("totalBill", totalBill);
%>

<style>
    .cart-container-box {
        max-width: 1000px;
        margin: 0 auto;
    }
    .cart-card-header {
        text-align: center;
        margin-bottom: 35px;
    }
    .cart-title {
        color: var(--secondary);
        font-family: 'Playfair Display', serif;
        font-size: 1.55rem;
        letter-spacing: 2.5px;
        text-transform: uppercase;
        font-weight: 700;
        display: inline-flex;
        align-items: center;
        gap: 12px;
    }
    .cart-qty-box {
        display: inline-flex;
        align-items: center;
        border: 1px solid var(--border-color);
        border-radius: 6px;
        background: rgba(255,255,255,0.03);
        overflow: hidden;
    }
    .cart-qty-btn {
        background: transparent;
        border: none;
        color: #aaa;
        padding: 6px 12px;
        cursor: pointer;
        font-size: 0.95rem;
        transition: all 0.2s;
    }
    .cart-qty-btn:hover {
        background: rgba(255,255,255,0.08);
        color: #fff;
    }
    .cart-qty-input {
        width: 48px;
        padding: 6px 0;
        text-align: center;
        background: transparent;
        border: none;
        color: var(--text-white);
        outline: none;
        font-weight: 600;
        font-size: 0.95rem;
        -moz-appearance: textfield;
    }
    .cart-qty-input::-webkit-inner-spin-button,
    .cart-qty-input::-webkit-outer-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }
    .btn-gold-glowing {
        background: #e5b324;
        color: #0c0c0c !important;
        font-weight: 700;
        border-radius: 8px;
        box-shadow: 0 0 25px rgba(229, 179, 36, 0.4);
        text-transform: uppercase;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 13px 32px;
        letter-spacing: 1px;
        font-size: 0.92rem;
        transition: all 0.3s ease;
        border: none;
        text-decoration: none;
    }
    .btn-gold-glowing:hover {
        transform: translateY(-2px);
        box-shadow: 0 0 35px rgba(229, 179, 36, 0.6);
        background: #f0be30;
    }
</style>

<div class="page-wrapper">
    <div class="container cart-container-box">
        <div class="nexora-card" style="padding: 40px 35px; border-radius: 12px; background: #161616; border: 1px solid rgba(255,255,255,0.07);">
            
            <!-- TIÊU ĐỀ GIỎ HÀNG -->
            <div class="cart-card-header">
                <h2 class="cart-title">
                    <i class="fas fa-shopping-bag" style="color: var(--secondary); font-size: 1.35rem;"></i>
                    GIỎ HÀNG CỦA BẠN
                </h2>
            </div>

            <c:choose>
                <c:when test="${not empty cartMap}">
                    <form action="${pageContext.request.contextPath}/cart" method="POST" id="cartForm">
                        <div class="cart-table-wrapper">
                            <table class="nexora-table">
                                <thead>
                                    <tr>
                                        <th style="padding: 14px 16px;">Sản phẩm</th>
                                        <th style="padding: 14px 16px;">Đơn giá</th>
                                        <th style="padding: 14px 16px; text-align: center;">Số lượng</th>
                                        <th style="padding: 14px 16px;">Thành tiền</th>
                                        <th style="text-align: center; padding: 14px 16px;">Xóa</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="entry" items="${cartMap}">
                                    <c:set var="item" value="${entry.value}"/>
                                    <tr>
                                        <td data-label="Sản phẩm" style="padding: 16px;">
                                            <div style="display: flex; align-items: center; gap: 15px;">
                                                <img src="${fn:startsWith(item.image, 'http') ? item.image : pageContext.request.contextPath.concat('/assets/images/').concat(item.image)}"
                                                     style="width: 68px; height: 68px; object-fit: contain; border: 1px solid var(--border-color); padding: 4px; border-radius: 8px; background: #222; flex-shrink: 0;"
                                                     alt="${item.name}">
                                                <div>
                                                    <span style="font-weight: 600; color: var(--text-white); font-size: 0.95rem; display: block; line-height: 1.4;">
                                                        <c:out value="${item.name}"/>
                                                    </span>
                                                    <c:if test="${not empty item.size or not empty item.color}">
                                                        <div style="font-size: 0.8rem; color: #888; margin-top: 4px;">
                                                            <c:if test="${not empty item.size}">Size: <strong style="color: var(--secondary);">${item.size}</strong></c:if>
                                                            <c:if test="${not empty item.color}"> | Màu: <strong style="color: var(--secondary);">${item.color}</strong></c:if>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <input type="hidden" name="cart_key" value="${entry.key}">
                                        </td>
                                        <td data-label="Đơn giá" style="color: var(--text-gray); font-size: 0.95rem; padding: 16px;">
                                            <fmt:formatNumber value="${item.price}" pattern="#,###"/> &#8363;
                                        </td>
                                        <td data-label="Số lượng" style="text-align: center; padding: 16px;">
                                            <div class="cart-qty-box">
                                                <button type="button" class="cart-qty-btn" onclick="updateQty(this, -1)">-</button>
                                                <input type="number" name="qty" value="${item.qty}" min="1" max="99" class="cart-qty-input">
                                                <button type="button" class="cart-qty-btn" onclick="updateQty(this, 1)">+</button>
                                            </div>
                                        </td>
                                        <td data-label="Thành tiền" style="color: var(--secondary); font-weight: bold; font-family: 'Playfair Display', serif; font-size: 1.05rem; padding: 16px;">
                                            <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/> &#8363;
                                        </td>
                                        <td data-label="Xóa" style="text-align: center; padding: 16px;">
                                            <a href="${pageContext.request.contextPath}/cart?action=delete&id=${entry.key}"
                                               style="color: #666; font-size: 1.15rem; padding: 8px; display: inline-block; transition: all 0.25s;"
                                               onmouseover="this.style.color='#e03131'" onmouseout="this.style.color='#666'"
                                               onclick="return confirm('Bạn muốn xóa sản phẩm này khỏi giỏ hàng?')"
                                               title="Xóa sản phẩm">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- THANH ĐIỀU HƯỚNG MUA SẮM & CẬP NHẬT -->
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 25px; padding-top: 20px; border-top: 1px solid var(--border-color); flex-wrap: wrap; gap: 15px;">
                            <a href="${pageContext.request.contextPath}/" style="color: var(--text-gray); font-size: 0.9rem; display: flex; align-items: center; gap: 8px; transition: color 0.2s;" onmouseover="this.style.color='var(--secondary)'" onmouseout="this.style.color='var(--text-gray)'">
                                <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                            </a>
                            <button type="submit" class="btn-nexora btn-nexora-outline" style="padding: 10px 24px; font-size: 0.85rem;">
                                <i class="fas fa-sync-alt" style="margin-right: 6px;"></i> Cập nhật giỏ hàng
                            </button>
                        </div>
                    </form>

                    <!-- TỔNG CỘNG & TIẾN HÀNH ĐẶT HÀNG -->
                    <div style="margin-top: 35px; border-top: 1px solid var(--border-gold); padding-top: 25px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
                            <div>
                                <p style="font-size: 0.85rem; color: var(--text-gray); margin-bottom: 5px; text-transform: uppercase; letter-spacing: 1px;">Tổng cộng:</p>
                                <div style="font-size: clamp(1.5rem, 4vw, 2rem); color: var(--secondary); font-weight: bold; font-family: 'Playfair Display', serif; line-height: 1.2;">
                                    <fmt:formatNumber value="${totalBill}" pattern="#,###"/> &#8363;
                                </div>
                                <p style="font-size: 0.75rem; color: var(--text-muted); margin-top: 5px;">(Đã bao gồm VAT nếu có)</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/checkout" class="btn-nexora btn-nexora-gold" style="padding: 15px 36px; font-size: 0.95rem; font-weight: 700; letter-spacing: 1px;">
                                TIẾN HÀNH ĐẶT HÀNG <i class="fas fa-arrow-right" style="margin-left: 8px;"></i>
                            </a>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- TRẠNG THÁI GIỎ HÀNG TRỐNG (GIỐNG HÌNH CHỤP 100%) -->
                    <div style="text-align: center; padding: 70px 20px;">
                        <i class="fas fa-shopping-bag" style="font-size: 4.5rem; color: rgba(255, 255, 255, 0.12); margin-bottom: 22px; display: block;"></i>
                        <h3 style="font-size: 1.05rem; font-weight: 400; color: #888; margin-bottom: 28px; letter-spacing: 0.5px;">
                            Giỏ hàng của bạn đang trống
                        </h3>
                        <a href="${pageContext.request.contextPath}/" class="btn-gold-glowing">
                            <i class="fas fa-shopping-basket"></i> TIẾP TỤC MUA SẮM
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    function updateQty(btn, delta) {
        const box = btn.closest('.cart-qty-box');
        const input = box.querySelector('.cart-qty-input');
        let val = parseInt(input.value) || 1;
        let max = parseInt(input.max) || 99;
        let newVal = val + delta;
        if (newVal >= 1 && newVal <= max) {
            input.value = newVal;
        }
    }
</script>

<%@ include file="/includes/footer.jsp" %>
