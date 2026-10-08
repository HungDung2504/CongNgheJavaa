<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Liên hệ - Admin Nexora</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nexora_luxury.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="admin-body">
    <%@ include file="/includes/admin/adminHeader.jsp" %>
    
    <div class="admin-topbar" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px; margin-bottom: 25px;">
        <div>
            <h1 style="font-family:'Playfair Display', serif; color:#F5F0E8; margin:0; font-size:1.8rem;">
                <i class="fas fa-envelope-open-text" style="color:#D4AF37; margin-right:12px;"></i>Quản Lý Liên Hệ &amp; Tư Vấn
            </h1>
            <p style="color:#888; font-size:0.85rem; margin-top:4px;">Khi bạn ấn &quot;Xử lý xong&quot;, trạng thái và nội dung phản hồi sẽ đồng bộ tức thì sang Lịch sử liên hệ của người dùng.</p>
        </div>

        <form action="${pageContext.request.contextPath}/admin/contacts" method="GET" style="display:flex; gap:10px; align-items:center;">
            <input type="text" name="search" value="${param.search}" placeholder="Tìm theo tên, email, nội dung..." style="padding:9px 14px; border-radius:6px; border:1px solid rgba(255,255,255,0.15); background:#1a1a1a; color:#fff; min-width: 260px; font-size:0.88rem;" />
            <button type="submit" class="btn btn-primary" style="padding:9px 18px; font-size:0.88rem; font-weight:bold; cursor:pointer;"><i class="fas fa-search"></i> Lọc</button>
        </form>
    </div>

    <div class="card-box" style="background:#111; border:1px solid rgba(212,175,55,0.2); border-radius:12px; padding:24px; box-shadow:0 10px 30px rgba(0,0,0,0.5);">
        <div style="overflow-x:auto;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="color:#D4AF37; width:65px;">MÃ</th>
                        <th style="color:#fff; min-width:160px;">KHÁCH HÀNG</th>
                        <th style="color:#fff; min-width:180px;">EMAIL</th>
                        <th style="color:#fff; min-width:280px;">NỘI DUNG YÊU CẦU</th>
                        <th style="color:#fff; min-width:130px;">NGÀY GỬI</th>
                        <th style="color:#fff; min-width:170px;">TRẠNG THÁI</th>
                        <th style="color:#D4AF37; text-align:center; min-width:180px;">THAO TÁC XỬ LÝ</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${contacts}">
                        <tr>
                            <td style="color:#aaa; font-weight:700;">#${c.id}</td>
                            <td>
                                <div style="font-weight:600; color:#F5F0E8; font-size:0.92rem;">
                                    ${c.name}
                                    <c:if test="${not empty c.userId}">
                                        <span title="Thành viên đã đăng ký" style="color:#D4AF37; font-size:0.75rem; margin-left:4px;"><i class="fas fa-check-circle"></i> Thành viên</span>
                                    </c:if>
                                </div>
                            </td>
                            <td style="color:#bbb; font-size:0.88rem;">${c.email}</td>
                            <td>
                                <div style="color:#E0E0E0; font-size:0.88rem; line-height:1.5; margin-bottom:4px;">
                                    ${c.message}
                                </div>
                                <c:if test="${not empty c.reply}">
                                    <div style="font-size:0.78rem; color:#51cf66; background:rgba(40,167,69,0.1); padding:4px 8px; border-radius:4px; border-left:2px solid #28a745; margin-top:6px;">
                                        <i class="fas fa-reply"></i> <strong>Đã phản hồi:</strong> ${c.reply}
                                    </div>
                                </c:if>
                            </td>
                            <td style="color:#888; font-size:0.82rem;">
                                <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.status == 'resolved' || c.status == 'Đã xử lý'}">
                                        <div>
                                            <span style="background:rgba(40,167,69,0.2); color:#51cf66; border:1px solid rgba(40,167,69,0.4); padding:4px 10px; border-radius:20px; font-size:0.75rem; font-weight:700; display:inline-flex; align-items:center; gap:5px;">
                                                <i class="fas fa-check-circle"></i> ĐÃ XỬ LÝ XONG
                                            </span>
                                            <c:if test="${not empty c.processedAt}">
                                                <div style="color:#666; font-size:0.72rem; margin-top:4px;">
                                                    <i class="far fa-clock"></i> <fmt:formatDate value="${c.processedAt}" pattern="dd/MM HH:mm"/>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="background:rgba(255,193,7,0.15); color:#fbc531; border:1px solid rgba(255,193,7,0.3); padding:4px 10px; border-radius:20px; font-size:0.75rem; font-weight:700; display:inline-flex; align-items:center; gap:5px;">
                                            <i class="fas fa-hourglass-half"></i> CHỜ XỬ LÝ
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:center; white-space:nowrap;">
                                <c:choose>
                                    <c:when test="${c.status == 'resolved' || c.status == 'Đã xử lý'}">
                                        <a href="?action=status&id=${c.id}&st=pending" class="btn" style="background:rgba(255,255,255,0.06); color:#aaa; border:1px solid rgba(255,255,255,0.15); padding:5px 10px; font-size:0.75rem; border-radius:5px; text-decoration:none; margin-right:8px;" title="Chuyển lại chờ xử lý">
                                            <i class="fas fa-undo"></i> Hoàn tác
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" onclick="openResolveModal('${c.id}', '${fn:escapeXml(c.name)}', '${fn:escapeXml(c.message)}')" style="background:linear-gradient(135deg, #28a745, #218838); color:#fff; border:none; padding:6px 14px; font-size:0.8rem; font-weight:700; border-radius:6px; cursor:pointer; margin-right:8px; box-shadow:0 3px 10px rgba(40,167,69,0.3);">
                                            <i class="fas fa-check-double"></i> Xử lý xong
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                                
                                <a href="?action=delete&id=${c.id}" style="color:#ff6b6b; padding:6px 9px; font-size:0.85rem; border-radius:5px; background:rgba(220,53,69,0.1); border:1px solid rgba(220,53,69,0.3); text-decoration:none;" onclick="return confirm('Bạn có chắc chắn muốn xóa liên hệ #${c.id} không?');" title="Xóa liên hệ">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty contacts}">
                        <tr>
                            <td colspan="7" style="text-align:center; color:#888; padding: 35px 20px;">
                                <i class="fas fa-inbox" style="font-size:2rem; color:#444; margin-bottom:10px; display:block;"></i>
                                Chưa có tin nhắn liên hệ nào từ khách hàng.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- MODAL XỬ LÝ XONG & PHẢN HỒI -->
    <div id="resolveModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.75); backdrop-filter:blur(6px); z-index:9999; align-items:center; justify-content:center;">
        <div style="background:#161616; border:1px solid #D4AF37; border-radius:12px; width:90%; max-width:550px; padding:28px; box-shadow:0 15px 40px rgba(0,0,0,0.8); position:relative;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px; border-bottom:1px solid rgba(255,255,255,0.1); padding-bottom:12px;">
                <h3 style="margin:0; font-family:'Playfair Display', serif; color:#D4AF37; font-size:1.3rem;">
                    <i class="fas fa-check-circle" style="color:#28a745; margin-right:8px;"></i>Xác Nhận Xử Lý Liên Hệ
                </h3>
                <button type="button" onclick="closeResolveModal()" style="background:none; border:none; color:#888; font-size:1.2rem; cursor:pointer;"><i class="fas fa-times"></i></button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/contacts" method="POST">
                <input type="hidden" name="action" value="resolve">
                <input type="hidden" name="id" id="modalContactId" value="">

                <div style="margin-bottom:14px; background:rgba(255,255,255,0.03); padding:12px 14px; border-radius:6px; border-left:3px solid #D4AF37;">
                    <div style="font-size:0.75rem; color:#aaa; text-transform:uppercase;">Khách hàng:</div>
                    <div id="modalCustomerName" style="color:#fff; font-weight:600; margin-bottom:6px;"></div>
                    <div style="font-size:0.75rem; color:#aaa; text-transform:uppercase;">Nội dung khách gửi:</div>
                    <div id="modalCustomerMsg" style="color:#ddd; font-size:0.85rem; font-style:italic;"></div>
                </div>

                <div style="margin-bottom:20px;">
                    <label style="display:block; font-size:0.8rem; color:#D4AF37; font-weight:600; margin-bottom:6px;">
                        Ghi chú / Phản hồi xử lý (Sẽ đồng bộ trực tiếp sang tài khoản người dùng):
                    </label>
                    <textarea name="reply" id="modalReplyText" rows="3" style="width:100%; padding:10px 12px; background:#0a0a0a; border:1px solid rgba(255,255,255,0.15); border-radius:6px; color:#fff; font-size:0.88rem; box-sizing:border-box;">Ban quản trị Nexora đã tiếp nhận và hoàn tất xử lý yêu cầu của quý khách.</textarea>
                </div>

                <div style="display:flex; justify-content:flex-end; gap:10px;">
                    <button type="button" onclick="closeResolveModal()" style="padding:10px 18px; background:rgba(255,255,255,0.08); color:#ccc; border:none; border-radius:6px; cursor:pointer;">Hủy</button>
                    <button type="submit" style="padding:10px 22px; background:linear-gradient(135deg, #28a745, #218838); color:#fff; border:none; border-radius:6px; font-weight:700; cursor:pointer; box-shadow:0 4px 15px rgba(40,167,69,0.3);">
                        <i class="fas fa-check-double" style="margin-right:6px;"></i> Xác nhận Xử lý xong
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
    function openResolveModal(id, name, msg) {
        document.getElementById('modalContactId').value = id;
        document.getElementById('modalCustomerName').textContent = name + ' (Liên hệ #' + id + ')';
        document.getElementById('modalCustomerMsg').textContent = msg;
        document.getElementById('resolveModal').style.display = 'flex';
    }
    function closeResolveModal() {
        document.getElementById('resolveModal').style.display = 'none';
    }
    </script>

<%@ include file="/includes/admin/adminFooter.jsp" %>
