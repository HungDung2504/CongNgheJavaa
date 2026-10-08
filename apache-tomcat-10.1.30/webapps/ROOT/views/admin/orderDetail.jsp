<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/includes/admin/adminHeader.jsp" %>
<div class="admin-topbar">
    <h1><i class="fas fa-file-invoice" style="color:#D4AF37;margin-right:10px;"></i>Đơn hàng #${order.orderId}</h1>
    <a href="${pageContext.request.contextPath}/admin/orders" class="btn-nx btn-outline"><i class="fas fa-arrow-left"></i> Quay lại</a>
</div>
<div style="display:grid;grid-template-columns:2fr 1fr;gap:20px;">
<div>
    <div class="card-box">
        <div class="card-box-title"><i class="fas fa-list"></i> Chi tiết Sản phẩm</div>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Tồn kho</th>
                    <th>Đơn giá</th>
                    <th>SL</th>
                    <th>Thành tiền</th>
                    <th style="text-align:center;">Thao tác SP</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="d" items="${details}">
            <tr>
                <td>
                    <div style="display:flex; align-items:center; gap:10px;">
                        <c:set var="dImg" value="${not empty d.productImage ? (fn:startsWith(d.productImage, 'http') ? d.productImage : pageContext.request.contextPath.concat('/assets/images/').concat(d.productImage)) : pageContext.request.contextPath.concat('/assets/images/no-image.png')}"/>
                        <img src="${dImg}" alt="${d.productName}" style="width:38px; height:38px; object-fit:cover; border-radius:6px; border:1px solid rgba(212,175,55,0.3); flex-shrink:0;">
                        <div>
                            <div style="font-weight:600; color:#F5F0E8;"><c:out value="${d.productName}"/></div>
                            <small style="color:#aaa;"><c:if test="${not empty d.size}">Size: ${d.size} </c:if><c:if test="${not empty d.color}">&middot; Màu: ${d.color}</c:if></small>
                        </div>
                    </div>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${d.productStatus == 2}">
                            <span class="badge-nx" style="background:#dc3545; color:#fff; font-weight:700;"><i class="fas fa-ban"></i> HẾT HÀNG</span>
                        </c:when>
                        <c:when test="${d.productStatus == 3}">
                            <span class="badge-nx" style="background:#ff9800; color:#fff; font-weight:700;"><i class="fas fa-clock"></i> ĐẶT TRƯỚC</span>
                        </c:when>
                        <c:when test="${d.currentStock <= 0}">
                            <span class="badge-nx" style="background:rgba(220,53,69,0.2); color:#ff6b6b; font-weight:700;"><i class="fas fa-exclamation-triangle"></i> HẾT KHO (0)</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-nx" style="background:rgba(40,167,69,0.2); color:#51cf66;">Còn ${d.currentStock}</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td style="color:#D4AF37;"><fmt:formatNumber value="${d.price}" pattern="#,###"/>&#8363;</td>
                <td style="font-weight:600;">${d.quantity}</td>
                <td style="font-weight:bold; color:#D4AF37;"><fmt:formatNumber value="${d.total}" pattern="#,###"/>&#8363;</td>
                <td style="text-align:center;">
                    <div style="display:flex; justify-content:center; gap:6px; flex-wrap:wrap;">
                        <a href="${pageContext.request.contextPath}/admin/orders?action=set_product_status&productId=${d.productId}&status=2&orderId=${order.orderId}" 
                           class="btn-nx" style="padding:4px 8px; font-size:0.72rem; background:#dc3545; color:#fff; text-decoration:none; ${d.productStatus == 2 ? 'opacity:0.4; pointer-events:none;' : ''}"
                           title="Bật banner HẾT HÀNG trên trang chủ">
                            <i class="fas fa-ban"></i> Hết hàng
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/orders?action=set_product_status&productId=${d.productId}&status=3&orderId=${order.orderId}" 
                           class="btn-nx" style="padding:4px 8px; font-size:0.72rem; background:#ff9800; color:#fff; text-decoration:none; ${d.productStatus == 3 ? 'opacity:0.4; pointer-events:none;' : ''}"
                           title="Bật banner TẠM HẾT, ĐẶT TRƯỚC trên trang chủ">
                            <i class="fas fa-clock"></i> Đặt trước
                        </a>
                        <c:if test="${d.productStatus == 2 || d.productStatus == 3}">
                            <a href="${pageContext.request.contextPath}/admin/orders?action=set_product_status&productId=${d.productId}&status=1&orderId=${order.orderId}" 
                               class="btn-nx btn-outline" style="padding:4px 8px; font-size:0.72rem; text-decoration:none;"
                               title="Khôi phục trạng thái bán">
                                <i class="fas fa-undo"></i> Còn hàng
                            </a>
                        </c:if>
                    </div>
                </td>
            </tr>
            </c:forEach>
            </tbody>
        </table>
        
        <div style="text-align:right;font-size:1rem;color:#aaa;padding-top:15px;border-top:1px solid rgba(255,255,255,0.07);margin-top:10px;">
            Phí vận chuyển: <span style="color:#D4AF37;"><fmt:formatNumber value="${order.shippingFee}" pattern="#,###"/>&#8363;</span>
        </div>
        <div style="text-align:right;font-size:1.1rem;font-weight:bold;padding-top:5px;">
            Tổng cộng: <span style="color:#D4AF37;"><fmt:formatNumber value="${order.totalMoney}" pattern="#,###"/>&#8363;</span>
        </div>
    </div>
</div>
<div>
    <div class="card-box">
        <div class="card-box-title"><i class="fas fa-user"></i> Thông tin Khách hàng</div>
        <div style="font-size:0.88rem;line-height:2.2;color:#aaa;">
            <div><strong style="color:#D4AF37;">Họ tên:</strong> <c:out value="${order.customerName}"/></div>
            <div><strong style="color:#D4AF37;">Điện thoại:</strong> ${order.customerPhone}</div>
            <div><strong style="color:#D4AF37;">Địa chỉ:</strong> <c:out value="${order.addressDetail}"/></div>
            <div><strong style="color:#D4AF37;">Kênh bán:</strong> ${order.channel}</div>
            <div><strong style="color:#D4AF37;">Phương thức thanh toán:</strong> ${not empty order.paymentMethod ? order.paymentMethod : 'Tiền mặt (COD)'}</div>
            <div><strong style="color:#D4AF37;">Trạng thái thanh toán:</strong> 
                <c:if test="${order.paymentStatus == 'Thành công'}"><span style="color:#28a745;">Đã thanh toán</span></c:if>
                <c:if test="${order.paymentStatus != 'Thành công'}"><span style="color:#dc3545;">Chưa thanh toán (Thu COD)</span></c:if>
            </div>
            <c:if test="${not empty order.note}">
            <div><strong style="color:#D4AF37;">Ghi chú:</strong> <c:out value="${order.note}"/></div>
            </c:if>
        </div>
        <div style="margin-top:20px;padding-top:16px;border-top:1px solid rgba(255,255,255,0.07);">
            <div class="card-box-title"><i class="fas fa-clipboard-list"></i> CẬP NHẬT TRẠNG THÁI</div>
            <form action="${pageContext.request.contextPath}/admin/orders" method="GET">
                <input type="hidden" name="action" value="update_status">
                <input type="hidden" name="id" value="${order.orderId}">
                <div class="admin-form-group">
                    <select name="status">
                        <option value="Chờ xác nhận" ${order.status == 'Chờ xác nhận' ? 'selected' : ''}>Chờ xác nhận</option>
                        <option value="Đang xử lý" ${order.status == 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                        <option value="Đang giao" ${order.status == 'Đang giao' ? 'selected' : ''}>Đang giao</option>
                        <option value="Hoàn thành" ${order.status == 'Hoàn thành' ? 'selected' : ''}>Hoàn thành</option>
                        <option value="Đã hủy" ${order.status == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                </div>
                <button type="submit" class="btn-nx btn-gold" style="width:100%;justify-content:center;"><i class="fas fa-save"></i> Cập nhật</button>
            </form>
        </div>
    </div>
</div>
<%@ include file="/includes/admin/adminFooter.jsp" %>
