<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/includes/admin/adminHeader.jsp" %>
<div class="admin-topbar">
    <h1><i class="fas fa-shopping-bag" style="color:#D4AF37;margin-right:10px;"></i>Quan ly Đơn hàng</h1>
</div>
<div class="card-box">
    <div style="margin-bottom:20px; display:flex; gap:10px;">
        <form action="${pageContext.request.contextPath}/admin/orders" method="get" style="display:flex; gap:10px; flex-wrap:wrap;">
            <input type="text" name="search" class="form-input" placeholder="Mã đơn hàng, Số điện thoại..." value="${searchKeyword}" style="width:300px; padding:8px 12px; background:rgba(0,0,0,0.2); color:#fff; border:1px solid rgba(255,255,255,0.1); border-radius:6px;">
            <select name="status" style="padding:8px 12px; background:rgba(0,0,0,0.2); color:#fff; border:1px solid rgba(255,255,255,0.1); border-radius:6px; outline:none;">
                <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                <option value="Chờ xác nhận" ${statusFilter == 'Chờ xác nhận' ? 'selected' : ''}>Chờ xác nhận</option>
                <option value="Đang giao" ${statusFilter == 'Đang giao' ? 'selected' : ''}>Đang giao</option>
                <option value="Hoàn thành" ${statusFilter == 'Hoàn thành' ? 'selected' : ''}>Hoàn thành</option>
                <option value="Đã hủy" ${statusFilter == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
            </select>
            <button type="submit" class="btn-nx btn-gold" style="padding:8px 16px;"><i class="fas fa-search"></i> Lọc</button>
        </form>
    </div>

    <div style="overflow-x:auto;">
        <table class="admin-table">
            <thead><tr>
                <th>Mã đơn</th><th>Sản phẩm</th><th>Khách hàng</th><th>SĐT</th><th>Tổng tiền</th><th>Thanh toán</th><th>Ngày đặt</th><th>Trạng thái</th><th>Chi tiết</th>
            </tr></thead>
            <tbody>
            <c:forEach var="order" items="${orders}">
            <tr>
                <td style="font-weight:bold;color:#D4AF37;">#${order.orderId}</td>
                <td style="min-width:200px;">
                    <c:forEach var="item" items="${order.items}">
                        <div style="display:flex; align-items:center; gap:8px; margin-bottom:4px;">
                            <c:set var="itemImg" value="${not empty item.productImage ? (fn:startsWith(item.productImage, 'http') ? item.productImage : pageContext.request.contextPath.concat('/assets/images/').concat(item.productImage)) : pageContext.request.contextPath.concat('/assets/images/no-image.png')}"/>
                            <img src="${itemImg}" alt="${item.productName}" style="width:28px; height:28px; object-fit:cover; border-radius:4px; border:1px solid rgba(212,175,55,0.3); flex-shrink:0;">
                            <div style="font-size:0.8rem; line-height:1.2;">
                                <span style="color:#F5F0E8;"><c:out value="${item.productName}"/></span>
                                <span style="color:#D4AF37; margin-left:4px;">x${item.quantity}</span>
                                <c:if test="${item.currentStock <= 0 || item.productStatus == 2}">
                                    <span style="color:#ff6b6b; font-size:0.7rem; margin-left:4px; font-weight:700;">[Hết kho]</span>
                                </c:if>
                                <c:if test="${item.productStatus == 3}">
                                    <span style="color:#ff9800; font-size:0.7rem; margin-left:4px; font-weight:700;">[Đặt trước]</span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </td>
                <td style="font-weight:600;color:#F5F0E8;"><c:out value="${order.customerName}"/></td>
                <td>${order.customerPhone}</td>
                <td style="color:#D4AF37; font-weight:700;"><fmt:formatNumber value="${order.totalMoney}" pattern="#,###"/>&#8363;</td>
                <td style="font-size:0.8rem;">${not empty order.paymentMethod ? order.paymentMethod : 'Tiền mặt'}</td>
                <td style="color:#aaa;font-size:0.8rem;"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                <td>
                    <span class="badge-nx">${order.status}</span>
                    <c:if test="${order.hasOutOfStock}">
                        <div style="margin-top:4px;"><span class="badge-nx" style="background:#dc3545; color:#fff; font-size:0.68rem; padding:2px 6px;"><i class="fas fa-exclamation-triangle"></i> Có SP hết kho</span></div>
                    </c:if>
                </td>
                <td><a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${order.orderId}" class="btn-nx btn-outline" style="padding:5px 12px;font-size:0.75rem;"><i class="fas fa-eye"></i> Xem & Xử lý</a></td>
            </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
    <div style="display:flex; justify-content:center; gap:8px; margin-top:20px;">
        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="${pageContext.request.contextPath}/admin/orders?page=${i}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}"
               style="padding:8px 14px;border-radius:6px;text-decoration:none;font-size:0.85rem;
               ${i == currentPage ? 'background:#D4AF37;color:#0C0C0C;font-weight:700;' : 'background:rgba(255,255,255,0.05);color:#aaa;border:1px solid rgba(255,255,255,0.1);'}">
                ${i}
            </a>
        </c:forEach>
    </div>
    </c:if>
<%@ include file="/includes/admin/adminFooter.jsp" %>
