<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/includes/admin/adminHeader.jsp" %>

<div class="admin-topbar" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px; margin-bottom: 20px;">
    <h1><i class="fas fa-users" style="color:#D4AF37;margin-right:10px;"></i>Quản lý Khách hàng</h1>
    <form action="${pageContext.request.contextPath}/admin/users" method="GET" style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
        <input type="text" name="search" value="${param.search}" placeholder="Tên, email, SĐT..." style="padding:8px; border-radius:4px; border:1px solid #444; background:#222; color:#fff; min-width: 200px;" />
        <select name="role" style="padding:8px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
            <option value="">-- Mọi vai trò --</option>
            <option value="Admin" ${param.role == 'Admin' ? 'selected' : ''}>Admin</option>
            <option value="NhanVien" ${param.role == 'NhanVien' ? 'selected' : ''}>Nhân viên</option>
            <option value="KhachHang" ${param.role == 'KhachHang' ? 'selected' : ''}>Khách hàng</option>
        </select>
        <select name="status" style="padding:8px; border-radius:4px; border:1px solid #444; background:#222; color:#fff;">
            <option value="">-- Trạng thái --</option>
            <option value="1" ${param.status == '1' ? 'selected' : ''}>Hoạt động</option>
            <option value="0" ${param.status == '0' ? 'selected' : ''}>Bị khóa</option>
        </select>
        <button type="submit" class="btn btn-primary" style="padding:8px 15px; background:#D4AF37; color:#000; border:none; border-radius:4px; font-weight:bold; cursor:pointer;"><i class="fas fa-search"></i> Lọc</button>
    </form>
    <a href="${pageContext.request.contextPath}/admin/user-add" class="btn btn-success" style="padding:8px 15px; background:#28a745; color:#fff; text-decoration:none; border-radius:4px; font-weight:bold; display:flex; align-items:center; gap:5px;"><i class="fas fa-plus"></i> THÊM KHÁCH HÀNG</a>
</div>

<div class="card-box">
    <div style="overflow-x:auto;">
        <table class="admin-table">
            <thead>
                <tr>
                    <th style="color:#fff;">ID</th>
                    <th style="color:#fff;">HỌ TÊN</th>
                    <th style="color:#fff;">EMAIL</th>
                    <th style="color:#fff;">SĐT</th>
                    <th style="color:#fff;">VAI TRÒ</th>
                    <th style="color:#fff;">TRẠNG THÁI</th>
                    <th style="color:#fff;">NGÀY ĐK</th>
                    <th style="color:#fff; text-align:center;">THAO TÁC</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="c" items="${customers}">
            <tr>
                <td style="color:#aaa;">#${c.userId}</td>
                <td style="font-weight:600;color:#F5F0E8;"><c:out value="${c.fullname}"/></td>
                <td style="color:#ddd;"><c:out value="${c.email}"/></td>
                <td style="color:#ddd;">${c.phone}</td>
                <td>
                    <c:choose>
                        <c:when test="${c.role == 'Admin'}"><span style="color:#ff4d4d; font-weight:bold;">Admin</span></c:when>
                        <c:when test="${c.role == 'NhanVien'}"><span style="color:#4da6ff; font-weight:bold;">Nhân viên</span></c:when>
                        <c:otherwise><span style="color:#ccc;">Khách hàng</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${c.status == 1}">
                            <span style="background:#28a745; color:#fff; padding:3px 10px; border-radius:12px; font-size:0.8rem; font-weight:bold;">Hoạt động</span>
                        </c:when>
                        <c:otherwise>
                            <span style="background:#6c757d; color:#fff; padding:3px 10px; border-radius:12px; font-size:0.8rem; font-weight:bold;">Bị khóa</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td style="color:#aaa;font-size:0.8rem;"><fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy"/></td>
                <td style="text-align:center; white-space:nowrap; font-size: 1.1rem;">
                    <a href="${pageContext.request.contextPath}/admin/user-edit?id=${c.userId}" title="Sửa thông tin" style="color:#ffc107; margin-right:12px; text-decoration:none;"><i class="fas fa-pen"></i></a>
                    <a href="${pageContext.request.contextPath}/admin/user-reset?id=${c.userId}" title="Reset mật khẩu" style="color:#17a2b8; margin-right:12px; text-decoration:none;"><i class="fas fa-key"></i></a>
                    <c:choose>
                        <c:when test="${c.status == 1}">
                            <a href="${pageContext.request.contextPath}/admin/user-lock?id=${c.userId}&action=lock" title="Khóa tài khoản" style="color:#dc3545; text-decoration:none;" onclick="return confirm('Bạn có chắc chắn muốn khóa tài khoản này?');"><i class="fas fa-lock"></i></a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin/user-lock?id=${c.userId}&action=unlock" title="Mở khóa tài khoản" style="color:#28a745; text-decoration:none;" onclick="return confirm('Bạn muốn mở khóa tài khoản này?');"><i class="fas fa-unlock"></i></a>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            </c:forEach>
            <c:if test="${empty customers}">
                <tr>
                    <td colspan="8" style="text-align:center; color:#888; padding: 20px;">Không tìm thấy kết quả nào.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- Phân trang -->
    <c:if test="${totalPages > 1}">
    <div class="pagination" style="display:flex; justify-content:center; gap:8px; margin-top:25px; margin-bottom: 10px;">
        <c:if test="${currentPage > 1}">
            <a href="?page=${currentPage - 1}&search=${param.search}&role=${param.role}&status=${param.status}" style="padding:6px 12px; background:#333; color:#D4AF37; text-decoration:none; border-radius:4px; border: 1px solid #444;">&laquo; Previous</a>
        </c:if>
        
        <c:forEach begin="1" end="${totalPages}" var="i">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span style="padding:6px 12px; background:#D4AF37; color:#000; font-weight:bold; border-radius:4px;">${i}</span>
                </c:when>
                <c:otherwise>
                    <a href="?page=${i}&search=${param.search}&role=${param.role}&status=${param.status}" style="padding:6px 12px; background:#333; color:#D4AF37; text-decoration:none; border-radius:4px; border: 1px solid #444;">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        
        <c:if test="${currentPage < totalPages}">
            <a href="?page=${currentPage + 1}&search=${param.search}&role=${param.role}&status=${param.status}" style="padding:6px 12px; background:#333; color:#D4AF37; text-decoration:none; border-radius:4px; border: 1px solid #444;">Next &raquo;</a>
        </c:if>
    </div>
    </c:if>
</div>

<%@ include file="/includes/admin/adminFooter.jsp" %>
