<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title> Bài viết</title>
    <link rel="stylesheet" href="/assets/css/nexora_luxury.css">
</head>
<body class="admin-body">
    <%@ include file="/includes/admin/adminHeader.jsp" %>
    
        <div class="admin-topbar">
            <h1><i class="fas fa-newspaper" style="color:#D4AF37; margin-right:10px;"></i>${not empty post ? 'Chỉnh sửa' : 'Thêm mới'} Bài viết</h1>
        </div>
        <div class="card-box">
            <form action="${pageContext.request.contextPath}/admin/posts" method="post">
                <input type="hidden" name="id" value="${post.postId}">
                <div class="admin-form-group">
                    <label>Tiêu đề bài viết (*)</label>
                    <input type="text" name="title" value="${post.title}" required placeholder="Nhập tiêu đề bài viết...">
                </div>
                <div class="admin-form-group">
                    <label>Nội dung chi tiết (*)</label>
                    <textarea name="content" rows="8" required placeholder="Nhập nội dung bài viết...">${post.content}</textarea>
                </div>
                <div class="admin-form-group">
                    <label>Hình ảnh đại diện (URL hoặc tên file ảnh)</label>
                    <input type="text" name="image" value="${post.image}" placeholder="https://... hoặc ten_anh.jpg">
                </div>
                <div class="admin-form-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="Hiển thị" ${post.status == 'Hiển thị' || post.status == 'published' ? 'selected' : ''}>Hiển thị (Xuất bản)</option>
                        <option value="Bản nháp" ${post.status == 'Bản nháp' || post.status == 'draft' ? 'selected' : ''}>Bản nháp (Ẩn)</option>
                    </select>
                </div>
                <div style="margin-top:20px; display:flex; gap:10px;">
                    <button type="submit" class="btn-nx btn-gold"><i class="fas fa-save"></i> Lưu bài viết</button>
                    <a href="${pageContext.request.contextPath}/admin/posts" class="btn-nx btn-gold" style="background: #333;"><i class="fas fa-times"></i> Hủy</a>
                </div>
            </form>
        </div>
    </div>
<%@ include file="/includes/admin/adminFooter.jsp" %>




