<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cài đặt - Admin Nexora</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nexora_luxury.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="admin-body">
    <%@ include file="/includes/admin/adminHeader.jsp" %>
    
    <div class="admin-topbar" style="margin-bottom: 20px;">
        <h1><i class="fas fa-cog" style="color:#D4AF37;margin-right:10px;"></i>Cài đặt Hệ thống</h1>
    </div>

    <div class="card-box" style="max-width: 800px; margin: 0 auto; padding: 30px;">
        <h3 style="color:#D4AF37; margin-bottom: 25px; border-bottom: 1px solid #444; padding-bottom: 10px;">Thông tin cửa hàng</h3>
        
        <form action="${pageContext.request.contextPath}/admin/settings" method="post">
            <div style="margin-bottom: 20px;">
                <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Tên Cửa Hàng (*)</label>
                <input type="text" name="shop_name" value="${applicationScope.app_shopName}" required style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
            </div>
            
            <div style="display:flex; gap:20px; margin-bottom: 20px;">
                <div style="flex:1;">
                    <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Số điện thoại Hotline</label>
                    <input type="text" name="shop_phone" value="${applicationScope.app_shopPhone}" style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
                </div>
                <div style="flex:1;">
                    <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Email Liên hệ</label>
                    <input type="email" name="shop_email" value="${applicationScope.app_shopEmail}" style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
                </div>
            </div>
            
            <div style="margin-bottom: 30px;">
                <label style="display:block; margin-bottom:8px; font-weight:bold; color:#D4AF37;">Địa chỉ cửa hàng</label>
                <textarea name="shop_address" rows="3" style="width:100%; padding:10px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">${applicationScope.app_shopAddress}</textarea>
            </div>
            
            <div style="display:flex; justify-content:flex-end;">
                <button type="submit" class="btn btn-primary" style="padding:10px 25px; background:#D4AF37; color:#000; border:none; border-radius:4px; font-weight:bold; cursor:pointer; font-size: 1rem;"><i class="fas fa-save"></i> LƯU THAY ĐỔI</button>
            </div>
        </form>
    </div>

<%@ include file="/includes/admin/adminFooter.jsp" %>
