<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/includes/header.jsp" %>

<div class="page-wrapper">
    <div class="container">
        <h2 class="nexora-card-title" style="margin-bottom:20px;">
            <i class="${category.catIcon}" style="margin-right:8px;"></i>${category.catName}
            <span style="font-size:0.75rem;color:#555;font-weight:400;margin-left:10px;">${total} Sản phẩm</span>
        </h2>
        <!-- Danh mục ngang -->
        <div style="display:flex;gap:10px;flex-wrap:wrap;margin-bottom:30px;">
            <c:forEach var="cat" items="${allCategories}">
                <a href="${pageContext.request.contextPath}/category?id=${cat.catId}"
                   class="btn-nexora ${cat.catId == category.catId ? 'btn-nexora-gold' : 'btn-nexora-outline'}"
                   style="padding:7px 18px;font-size:0.78rem;">
                    <i class="${cat.catIcon}" style="margin-right:5px;"></i>${cat.catName}
                </a>
            </c:forEach>
        </div>
        <!-- Product Grid -->
        <div style="display:grid;grid-template-columns:repeat(6, 1fr);gap:20px;margin-bottom:40px;">
            <c:forEach var="p" items="${products}">
            <div class="lane-card" style="flex:unset;">
                <div class="lane-card-img-wrap">
                    <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                        <img src="${fn:startsWith(p.image, 'http') ? p.image : pageContext.request.contextPath.concat('/assets/images/').concat(p.image)}" alt="${p.productName}" loading="lazy">
                    </a>
                    <c:choose>
                        <c:when test="${p.status == 2 || (p.status != 3 && p.stock <= 0)}">
                            <div class="product-banner-tag banner-out-of-stock"><i class="fas fa-ban"></i> HẾT HÀNG</div>
                        </c:when>
                        <c:when test="${p.status == 3}">
                            <div class="product-banner-tag banner-pre-order"><i class="fas fa-clock"></i> TẠM HẾT, ĐẶT TRƯỚC</div>
                        </c:when>
                        <c:when test="${p.hot}">
                            <div class="product-badge">Hot</div>
                        </c:when>
                    </c:choose>
                </div>
                <div class="lane-card-info">
                    <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                        <p class="lane-card-name"><c:out value="${p.productName}"/></p>
                    </a>
                    <p class="lane-card-price"><fmt:formatNumber value="${p.price}" pattern="#,###"/> &#8363;</p>
                    <div class="lane-card-actions">
                        <c:choose>
                            <c:when test="${p.status == 2 || (p.status != 3 && p.stock <= 0)}">
                                <span class="btn-primary" style="background:#2a2a2a; color:#888; border:1px solid #444; cursor:not-allowed; display:block; width:100%; text-align:center; font-weight:700;">Hết hàng</span>
                            </c:when>
                            <c:when test="${p.status == 3}">
                                <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="btn-primary" style="background:linear-gradient(135deg, #f08c00, #D4AF37); color:#000; font-weight:800; display:block; width:100%; text-align:center;">Đặt trước ngay</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="btn-primary">Mua ngay</a>
                                <a href="${pageContext.request.contextPath}/cart?action=add&id=${p.productId}" class="btn-cart"><i class="fas fa-cart-plus"></i></a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            </c:forEach>
        </div>
        <!-- Phan trang -->
        <c:if test="${totalPages > 1}">
        <div style="display:flex;justify-content:center;gap:8px;margin-top:20px;">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/category?id=${category.catId}&page=${i}"
                   style="padding:8px 14px;border-radius:6px;text-decoration:none;font-size:0.85rem;
                   ${i == currentPage ? 'background:#D4AF37;color:#0C0C0C;font-weight:700;' : 'background:rgba(255,255,255,0.05);color:#aaa;border:1px solid rgba(255,255,255,0.1);'}">
                    ${i}
                </a>
            </c:forEach>
        </div>
        </c:if>
    </div>
</div>
<style>
.lane-card{flex:unset!important;}
.lane-card-img-wrap{aspect-ratio:3/4;}
.product-banner-tag {
    position: absolute;
    top: 10px;
    left: 10px;
    padding: 5px 10px;
    font-size: 0.68rem;
    font-weight: 800;
    letter-spacing: 0.6px;
    text-transform: uppercase;
    border-radius: 6px;
    z-index: 5;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.6);
    backdrop-filter: blur(8px);
}
.banner-out-of-stock {
    background: linear-gradient(135deg, #c92a2a, #800000);
    color: #fff;
    border: 1px solid rgba(255,255,255,0.25);
}
.banner-pre-order {
    background: linear-gradient(135deg, #f08c00, #d9480f);
    color: #fff;
    border: 1px solid rgba(255,255,255,0.3);
}
</style>
<%@ include file="/includes/footer.jsp" %>
