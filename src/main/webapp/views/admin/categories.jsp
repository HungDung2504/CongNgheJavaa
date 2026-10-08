<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/includes/admin/adminHeader.jsp" %>
<div class="admin-topbar">
    <h1><i class="fas fa-tags" style="color:#D4AF37;margin-right:10px;"></i>Quản lý Danh mục</h1>
</div>

<div style="margin-bottom:20px; display:flex; gap:10px;">
    <form action="${pageContext.request.contextPath}/admin/categories" method="get" style="display:flex; gap:10px; flex-wrap:wrap;">
        <input type="text" name="search" class="form-input" placeholder="Tìm kiếm tên danh mục..." value="${searchKeyword}" style="width:300px; padding:8px 12px; background:rgba(0,0,0,0.2); color:#fff; border:1px solid rgba(255,255,255,0.1); border-radius:6px;">
        <select name="status" style="padding:8px 12px; background:rgba(0,0,0,0.2); color:#fff; border:1px solid rgba(255,255,255,0.1); border-radius:6px; outline:none;">
            <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
            <option value="hienthi" ${statusFilter == 'hienthi' ? 'selected' : ''}>Đang hiển thị</option>
            <option value="daan" ${statusFilter == 'daan' ? 'selected' : ''}>Đã ẩn</option>
        </select>
        <button type="submit" class="btn-nx btn-gold" style="padding:8px 16px;"><i class="fas fa-search"></i> Lọc</button>
    </form>
</div>

<div style="display:grid;grid-template-columns:2fr 1fr;gap:20px;">
<div class="card-box">
    <div style="overflow-x:auto;">
        <table class="admin-table">
            <thead><tr><th>ID</th><th>Icon</th><th>Tên Danh mục</th><th>Trạng thái</th><th>Hành động</th></tr></thead>
            <tbody>
            <c:forEach var="cat" items="${categories}">
            <tr>
                <td>${cat.catId}</td>
                <td style="font-size:1.2rem; color:#D4AF37;"><i class="${cat.catIcon}"></i></td>
                <td style="color:#F5F0E8;font-weight:600;">${cat.catName}</td>
                <td>
                    <c:if test="${cat.status}"><span class="badge-nx badge-done" style="background:rgba(40,167,69,0.2); color:#28a745; padding:4px 8px; border-radius:4px; font-size:0.75rem;">Hiển thị</span></c:if>
                    <c:if test="${!cat.status}"><span class="badge-nx badge-done" style="background:rgba(220,53,69,0.2); color:#dc3545; padding:4px 8px; border-radius:4px; font-size:0.75rem;">Đang ẩn</span></c:if>
                </td>
                <td>
                    <div style="display:flex;gap:6px;">
                        <button onclick="editCat(${cat.catId},'<c:out value="${cat.catName}"/>','<c:out value="${cat.catIcon}"/>', '<c:out value="${cat.description}" escapeXml="true"/>', ${cat.status})" class="btn-nx btn-outline" style="padding:5px 10px;font-size:0.75rem;"><i class="fas fa-edit"></i></button>
                        <a href="${pageContext.request.contextPath}/admin/categories?action=delete&id=${cat.catId}" class="btn-nx btn-red" style="padding:5px 10px;font-size:0.75rem;" onclick="return confirm('Xóa Danh mục này?')"><i class="fas fa-trash"></i></a>
                    </div>
                </td>
            </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    
    <c:if test="${totalPages > 1}">
    <div style="display:flex; justify-content:center; gap:8px; margin-top:20px;">
        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="${pageContext.request.contextPath}/admin/categories?page=${i}${not empty searchKeyword ? '&search='.concat(searchKeyword) : ''}${not empty statusFilter ? '&status='.concat(statusFilter) : ''}"
               style="padding:8px 14px;border-radius:6px;text-decoration:none;font-size:0.85rem;
               ${i == currentPage ? 'background:#D4AF37;color:#0C0C0C;font-weight:700;' : 'background:rgba(255,255,255,0.05);color:#aaa;border:1px solid rgba(255,255,255,0.1);'}">
                ${i}
            </a>
        </c:forEach>
    </div>
    </c:if>
</div>
<div>
<div class="card-box">
    <div class="card-box-title"><i class="fas fa-plus"></i> <span id="formTitle">THÊM DANH MỤC</span></div>
    <form action="${pageContext.request.contextPath}/admin/categories" method="POST" id="catForm">
        <input type="hidden" name="action" id="catAction" value="insert">
        <input type="hidden" name="cat_id" id="catId" value="">
        <div class="admin-form-group"><label>Tên Danh mục</label><input type="text" name="cat_name" id="catName" required></div>
        <div class="admin-form-group"><label>Mô tả chi tiết</label><textarea name="moTa" id="catDesc" rows="3" style="width:100%; padding:8px 12px; background:rgba(0,0,0,0.2); color:#fff; border:1px solid rgba(255,255,255,0.1); border-radius:6px;"></textarea></div>
        <div class="admin-form-group"><label>Trạng thái</label>
            <select name="trangThai" id="catStatus" style="width:100%; padding:8px 12px; background:rgba(0,0,0,0.2); color:#fff; border:1px solid rgba(255,255,255,0.1); border-radius:6px;">
                <option value="1">Hiển thị</option>
                <option value="0">Ẩn</option>
            </select>
        </div>
        <div class="admin-form-group"><label>Font Awesome Icon class (VD: fas fa-tshirt)</label><input type="text" name="cat_icon" id="catIcon" placeholder="fas fa-tshirt"></div>
        <button type="submit" class="btn-nx btn-gold" style="width:100%;justify-content:center;"><i class="fas fa-save"></i> Lưu</button>
        <button type="button" id="btnReset" onclick="resetCatForm()" class="btn-nx btn-outline" style="width:100%;justify-content:center;margin-top:8px;">Làm mới</button>
    </form>
</div>
</div>
</div>
<script>
function editCat(id, name, icon, desc, status) {
    document.getElementById('catAction').value='update';
    document.getElementById('catId').value=id;
    document.getElementById('catName').value=name;
    document.getElementById('catIcon').value=icon;
    document.getElementById('catDesc').value=desc;
    document.getElementById('catStatus').value= status ? "1" : "0";
    document.getElementById('formTitle').textContent='CẬP NHẬT DANH MỤC';
    var btnReset = document.getElementById('btnReset');
    btnReset.textContent = 'Hủy';
    btnReset.classList.remove('btn-outline');
    btnReset.classList.add('btn-red');
    document.getElementById('catName').focus();
}
function resetCatForm() {
    document.getElementById('catAction').value='insert';
    document.getElementById('catId').value='';
    document.getElementById('catName').value='';
    document.getElementById('catIcon').value='';
    document.getElementById('catDesc').value='';
    document.getElementById('catStatus').value='1';
    document.getElementById('formTitle').textContent='THÊM DANH MỤC';
    var btnReset = document.getElementById('btnReset');
    btnReset.textContent = 'Làm mới';
    btnReset.classList.add('btn-outline');
    btnReset.classList.remove('btn-red');
}
</script>
<%@ include file="/includes/admin/adminFooter.jsp" %>
