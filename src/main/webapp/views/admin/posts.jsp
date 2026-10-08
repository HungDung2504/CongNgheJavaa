<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bài viết - Admin Nexora</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nexora_luxury.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="admin-body">
    <%@ include file="/includes/admin/adminHeader.jsp" %>
    
    <div class="admin-topbar" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px; margin-bottom: 20px;">
        <h1><i class="fas fa-newspaper" style="color:#D4AF37;margin-right:10px;"></i>Quản lý Bài viết</h1>
        
        <form action="${pageContext.request.contextPath}/admin/posts" method="GET" style="display:flex; gap:10px; align-items:center;">
            <input type="text" name="search" value="${param.search}" placeholder="Tìm kiếm bài viết..." style="padding:8px; border-radius:4px; border:1px solid #444; background:#222; color:#fff; min-width: 250px;" />
            <button type="submit" class="btn btn-primary" style="padding:8px 15px; background:#D4AF37; color:#000; border:none; border-radius:4px; font-weight:bold; cursor:pointer;"><i class="fas fa-search"></i> Tìm kiếm</button>
        </form>
        
        <a href="${pageContext.request.contextPath}/admin/posts?action=edit" class="btn btn-success" style="padding:8px 15px; background:#28a745; color:#fff; text-decoration:none; border-radius:4px; font-weight:bold; display:flex; align-items:center; gap:5px;"><i class="fas fa-plus"></i> THÊM BÀI VIẾT</a>
    </div>

    <div class="card-box">
        <div style="overflow-x:auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="color:#fff;">ID</th>
                        <th style="color:#fff;">TIÊU ĐỀ</th>
                        <th style="color:#fff;">NGÀY TẠO</th>
                        <th style="color:#fff;">TRẠNG THÁI</th>
                        <th style="color:#fff; text-align:center;">THAO TÁC</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${posts}">
                        <tr>
                            <td style="color:#aaa;">#${p.postId != null ? p.postId : p.id}</td>
                            <td style="font-weight:600;color:#F5F0E8;">${p.title}</td>
                            <td style="color:#aaa;"><fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.status == 'Hiển thị' || p.status == 'published' || p.status == '1' || p.status == 1}">
                                        <span style="background:#28a745; color:#fff; padding:3px 10px; border-radius:12px; font-size:0.8rem; font-weight:bold;">Hiển thị</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="background:#6c757d; color:#fff; padding:3px 10px; border-radius:12px; font-size:0.8rem; font-weight:bold;">${not empty p.status ? p.status : 'Đã ẩn'}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:center; white-space:nowrap; font-size: 1.1rem;">
                                <a href="${pageContext.request.contextPath}/admin/posts?action=edit&id=${p.postId != null ? p.postId : p.id}" title="Sửa bài viết" style="color:#ffc107; margin-right:15px; text-decoration:none;"><i class="fas fa-pen"></i></a>
                                <a href="${pageContext.request.contextPath}/admin/posts?action=delete&id=${p.postId != null ? p.postId : p.id}" title="Xóa bài viết" style="color:#dc3545; text-decoration:none;" onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này không?');"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty posts}">
                        <tr>
                            <td colspan="5" style="text-align:center; color:#888; padding: 20px;">Không có bài viết nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

<%@ include file="/includes/admin/adminFooter.jsp" %>
