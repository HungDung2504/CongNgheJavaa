<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/includes/admin/adminHeader.jsp" %>

<div class="admin-topbar">
    <h1><i class="fas fa-user-plus" style="color:#D4AF37;margin-right:10px;"></i>Thêm Người dùng mới</h1>
</div>

<div class="card-box" style="max-width: 800px; margin: 0 auto; padding: 30px;">
    <c:if test="${not empty error}">
        <div style="padding: 15px; margin-bottom: 20px; border: 1px solid #dc3545; background-color: #f8d7da; color: #721c24; border-radius: 4px;">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/user-add" method="POST">
        
        <div style="margin-bottom: 20px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Họ và Tên (*)</label>
            <input type="text" name="fullname" required style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Email (*)</label>
            <input type="email" name="email" required style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Số điện thoại</label>
            <input type="text" name="phone" style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Mật khẩu (*)</label>
            <input type="password" name="password" required style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
        </div>

        <div style="margin-bottom: 30px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Vai trò</label>
            <select name="role" required style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
                <option value="KhachHang">Khách hàng</option>
                <option value="NhanVien">Nhân viên</option>
                <option value="Admin">Admin</option>
            </select>
        </div>

        <div style="display:flex; gap:15px; justify-content:flex-end;">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary" style="padding:10px 20px; background:#444; color:#fff; text-decoration:none; border-radius:4px;">Hủy bỏ</a>
            <button type="submit" class="btn btn-primary" style="padding:10px 20px; background:#28a745; color:#fff; border:none; border-radius:4px; font-weight:bold; cursor:pointer;">Lưu Người Dùng</button>
        </div>
    </form>
</div>

<%@ include file="/includes/admin/adminFooter.jsp" %>
