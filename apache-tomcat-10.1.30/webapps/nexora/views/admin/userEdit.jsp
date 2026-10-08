<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/includes/admin/adminHeader.jsp" %>

<div class="admin-topbar">
    <h1><i class="fas fa-user-edit" style="color:#D4AF37;margin-right:10px;"></i>Sửa thông tin Người dùng</h1>
</div>

<div class="card-box" style="max-width: 800px; margin: 0 auto; padding: 30px;">
    <form action="${pageContext.request.contextPath}/admin/user-edit" method="POST">
        <input type="hidden" name="userId" value="${customer.userId}">
        
        <div style="margin-bottom: 20px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">ID Tài khoản</label>
            <input type="text" value="#${customer.userId}" disabled style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#333; color:#aaa; cursor:not-allowed;">
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Email (Không thể sửa)</label>
            <input type="email" value="${customer.email}" disabled style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#333; color:#aaa; cursor:not-allowed;">
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Họ và Tên</label>
            <input type="text" name="fullname" value="${customer.fullname}" required style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
        </div>

        <div style="margin-bottom: 20px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Số điện thoại</label>
            <input type="text" name="phone" value="${customer.phone}" required style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
        </div>

        <div style="margin-bottom: 30px;">
            <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Vai trò</label>
            <select name="role" required style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
                <option value="Admin" ${customer.role == 'Admin' ? 'selected' : ''}>Admin</option>
                <option value="NhanVien" ${customer.role == 'NhanVien' ? 'selected' : ''}>Nhân viên</option>
                <option value="KhachHang" ${customer.role == 'KhachHang' ? 'selected' : ''}>Khách hàng</option>
            </select>
        </div>

        <div style="display:flex; gap:15px; justify-content:flex-end;">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary" style="padding:10px 20px; background:#444; color:#fff; text-decoration:none; border-radius:4px;">Hủy bỏ</a>
            <button type="submit" class="btn btn-primary" style="padding:10px 20px; background:#D4AF37; color:#000; border:none; border-radius:4px; font-weight:bold; cursor:pointer;">Lưu Thay Đổi</button>
        </div>
    </form>
</div>

<%@ include file="/includes/admin/adminFooter.jsp" %>
