<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/includes/admin/adminHeader.jsp" %>

<div class="admin-topbar">
    <h1><i class="fas fa-tshirt" style="color:#D4AF37;margin-right:10px;"></i>Quan ly Sản phẩm</h1>
    <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn-nx btn-gold">
        <i class="fas fa-plus"></i> Them Sản phẩm
    </a>
</div>

<div class="card-box">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
        <form action="${pageContext.request.contextPath}/admin/products" method="get" style="display:flex; gap:10px;">
            <input type="text" name="search" class="form-input" placeholder="Tìm kiếm tên sản phẩm..." value="${searchKeyword}" style="width:300px; padding:8px 12px; background:rgba(0,0,0,0.2); color:#fff; border:1px solid rgba(255,255,255,0.1); border-radius:6px;">
            <button type="submit" class="btn-nx btn-gold" style="padding:8px 16px;"><i class="fas fa-search"></i></button>
        </form>
    </div>

    <div style="overflow-x:auto;">
        <table class="admin-table">
            <thead><tr>
                <th>ID</th><th>Hinh</th><th>Ten Sản phẩm</th><th>Gia</th><th>Ton kho</th><th>Hot</th><th>Hanh dong</th>
            </tr></thead>
            <tbody>
            <c:forEach var="p" items="${products}">
            <tr>
                <td style="color:#555;">#${p.productId}</td>
                <td><img src="${fn:startsWith(p.image, 'http') ? p.image : pageContext.request.contextPath.concat('/assets/images/').concat(p.image)}" style="width:48px;height:48px;object-fit:contain;background:#1a1a1a;border-radius:6px;padding:4px;border:1px solid rgba(255,255,255,0.08);"></td>
                <td style="color:#F5F0E8;font-weight:600;"><c:out value="${p.productName}"/></td>
                <td style="color:#D4AF37;"><fmt:formatNumber value="${p.price}" pattern="#,###"/>&#8363;</td>
                <td>${p.stock}</td>
                <td><c:if test="${p.hot}"><span class="badge-nx badge-done">Hot</span></c:if><c:if test="${!p.hot}"><span style="color:#333;">-</span></c:if></td>
                <td>
                    <div style="display:flex;gap:6px;">
                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}" class="btn-nx btn-outline" style="padding:6px 12px;font-size:0.75rem;"><i class="fas fa-edit"></i></a>
                        <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.productId}" class="btn-nx btn-red" style="padding:6px 12px;font-size:0.75rem;"
                           onclick="return confirm('Xoa Sản phẩm nay?')"><i class="fas fa-trash"></i></a>
                    </div>
                </td>
            </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
    <div style="display:flex; justify-content:center; gap:8px; margin-top:30px;">
        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="${pageContext.request.contextPath}/admin/products?page=${i}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}"
               style="padding:8px 14px;border-radius:6px;text-decoration:none;font-size:0.85rem;
               ${i == currentPage ? 'background:#D4AF37;color:#0C0C0C;font-weight:700;' : 'background:rgba(255,255,255,0.05);color:#aaa;border:1px solid rgba(255,255,255,0.1);'}">
                ${i}
            </a>
        </c:forEach>
    </div>
    </c:if>
</div>
<%@ include file="/includes/admin/adminFooter.jsp" %>


