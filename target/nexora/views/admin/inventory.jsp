<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Kho - Admin Nexora</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nexora_luxury.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="admin-body">
    <%@ include file="/includes/admin/adminHeader.jsp" %>

    <div class="admin-topbar" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px; margin-bottom: 20px;">
        <div style="display:flex; align-items:center; gap:15px; flex-wrap:wrap;">
            <h1><i class="fas fa-boxes" style="color:#D4AF37;margin-right:10px;"></i>Quản lý Kho hàng</h1>
            <div style="display:inline-flex; align-items:center; gap:8px; background:rgba(212,175,55,0.08); border:1px solid rgba(212,175,55,0.25); padding:6px 14px; border-radius:30px; font-size:0.82rem; color:#D4AF37;">
                <span style="display:inline-block; width:8px; height:8px; background:#28a745; border-radius:50%; box-shadow:0 0 8px #28a745; animation: livePulse 1.5s infinite;"></span>
                <span>Tự động cập nhật: <b id="countdown-timer" style="color:#fff;">15s</b></span>
                <button type="button" onclick="window.location.reload();" style="background:transparent; border:none; color:#D4AF37; cursor:pointer; font-size:0.85rem;" title="Làm mới ngay"><i class="fas fa-sync-alt"></i></button>
            </div>
        </div>
        <form action="${pageContext.request.contextPath}/admin/inventory" method="GET" style="display:flex; gap:10px; align-items:center;">
            <input type="text" name="search" value="${param.search}" placeholder="ID hoặc Tên sản phẩm..." style="padding:8px; border-radius:4px; border:1px solid #444; background:#222; color:#fff; min-width: 250px;" />
            <button type="submit" class="btn btn-primary" style="padding:8px 15px; background:#D4AF37; color:#000; border:none; border-radius:4px; font-weight:bold; cursor:pointer;"><i class="fas fa-search"></i> Tìm kiếm</button>
        </form>
        <a href="${pageContext.request.contextPath}/admin/inventory?action=new_import" class="btn btn-success" style="padding:8px 15px; background:#28a745; color:#fff; text-decoration:none; border-radius:4px; font-weight:bold; display:flex; align-items:center; gap:5px;"><i class="fas fa-plus"></i> NHẬP KHO MỚI</a>
    </div>

    <h3 class="card-box-title" style="color: #D4AF37; margin-bottom: 10px;">Tình trạng tồn kho</h3>
    <div class="card-box" style="margin-bottom: 30px;">
        <div style="overflow-x:auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="color:#fff;">ID</th>
                        <th style="color:#fff;">SẢN PHẨM</th>
                        <th style="color:#fff;">DANH MỤC</th>
                        <th style="color:#fff; min-width:220px;">TỒN KHO & BIẾN THỂ</th>
                        <th style="color:#fff;">TRẠNG THÁI</th>
                        <th style="color:#fff; text-align:center;">THAO TÁC</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td style="color:#aaa;">#${p.productId}</td>
                            <td style="font-weight:600;color:#F5F0E8;">${p.productName}</td>
                            <td style="color:#ddd;">${p.catName}</td>
                            <td>
                                <div style="display:flex; align-items:center; gap:8px;">
                                    <span style="color:#fff; font-size:1.05rem; font-weight:bold;">${p.stock}</span>
                                    <span style="font-size:0.75rem; color:#888;">tổng SP</span>
                                </div>
                                <c:if test="${not empty p.variants}">
                                    <div style="display:flex; flex-wrap:wrap; gap:4px; margin-top:6px;">
                                        <c:forEach var="v" items="${p.variants}">
                                            <span style="font-size:0.72rem; padding:2px 6px; border-radius:4px; border:1px solid ${v.stock == 0 ? 'rgba(220,53,69,0.5)' : 'rgba(255,255,255,0.1)'}; background:${v.stock == 0 ? 'rgba(220,53,69,0.15)' : 'rgba(255,255,255,0.03)'}; color:${v.stock == 0 ? '#ff6b6b' : '#aaa'};" title="Giá: <fmt:formatNumber value='${v.price}' pattern='#,###'/>đ">
                                                ${v.size} - ${v.color}: <strong style="color:${v.stock == 0 ? '#ff4d4d' : '#D4AF37'};">${v.stock}</strong>
                                            </span>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.stock == 0}"><span style="background:#dc3545; color:#fff; padding:3px 10px; border-radius:12px; font-size:0.8rem; font-weight:bold;">Hết hàng</span></c:when>
                                    <c:when test="${p.stock < 10}"><span style="background:#ffc107; color:#000; padding:3px 10px; border-radius:12px; font-size:0.8rem; font-weight:bold;">Sắp hết</span></c:when>
                                    <c:otherwise><span style="background:#28a745; color:#fff; padding:3px 10px; border-radius:12px; font-size:0.8rem; font-weight:bold;">Còn hàng</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:center;">
                                <c:if test="${p.stock == 0}">
                                    <a href="${pageContext.request.contextPath}/admin/inventory?action=delete&id=${p.productId}" title="Xóa sản phẩm" style="color:#dc3545; text-decoration:none;" onclick="return confirm('Xóa sản phẩm này khỏi kho?');"><i class="fas fa-trash"></i></a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="5" style="text-align:center; color:#888; padding: 20px;">Không tìm thấy sản phẩm nào trong kho.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
        <div class="pagination" style="display:flex; justify-content:center; gap:8px; margin-top:25px; margin-bottom: 10px;">
            <c:if test="${currentPage > 1}">
                <a href="?page=${currentPage - 1}&search=${param.search}" style="padding:6px 12px; background:#333; color:#D4AF37; text-decoration:none; border-radius:4px; border: 1px solid #444;">&laquo; Previous</a>
            </c:if>
            
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span style="padding:6px 12px; background:#D4AF37; color:#000; font-weight:bold; border-radius:4px;">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}&search=${param.search}" style="padding:6px 12px; background:#333; color:#D4AF37; text-decoration:none; border-radius:4px; border: 1px solid #444;">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:if test="${currentPage < totalPages}">
                <a href="?page=${currentPage + 1}&search=${param.search}" style="padding:6px 12px; background:#333; color:#D4AF37; text-decoration:none; border-radius:4px; border: 1px solid #444;">Next &raquo;</a>
            </c:if>
        </div>
        </c:if>
    </div>

    <h3 class="card-box-title" style="color: #D4AF37; margin-bottom: 10px;">Lịch sử hóa đơn nhập</h3>
    <div class="card-box">
        <div style="overflow-x:auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="color:#fff;">MÃ PHIẾU</th>
                        <th style="color:#fff;">NHÀ CUNG CẤP</th>
                        <th style="color:#fff;">TỔNG TIỀN</th>
                        <th style="color:#fff;">NGƯỜI TẠO</th>
                        <th style="color:#fff;">NGÀY NHẬP</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="inv" items="${invoices}">
                        <tr>
                            <td style="color:#aaa;">#IMP-${inv.importId}</td>
                            <td style="font-weight:600;color:#F5F0E8;">${inv.supplier}</td>
                            <td style="color:#28a745; font-weight:bold;"><fmt:formatNumber value="${inv.totalCost}" pattern="#,###"/> đ</td>
                            <td style="color:#ddd;">${inv.createdBy}</td>
                            <td style="color:#aaa; font-size:0.9rem;"><fmt:formatDate value="${inv.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty invoices}">
                        <tr>
                            <td colspan="5" style="text-align:center; color:#888; padding: 20px;">Chưa có lịch sử nhập kho.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <style>
    @keyframes livePulse {
        0% { transform: scale(0.9); opacity: 0.7; }
        50% { transform: scale(1.25); opacity: 1; }
        100% { transform: scale(0.9); opacity: 0.7; }
    }
    </style>
    <script>
    (function() {
        let timeLeft = 15;
        const timerEl = document.getElementById('countdown-timer');
        if (timerEl) {
            setInterval(() => {
                timeLeft--;
                timerEl.innerText = timeLeft + 's';
                if (timeLeft <= 0) {
                    window.location.reload();
                }
            }, 1000);
        }
    })();
    </script>

<%@ include file="/includes/admin/adminFooter.jsp" %>
