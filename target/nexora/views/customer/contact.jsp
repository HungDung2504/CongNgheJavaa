<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/includes/header.jsp" %>

<div class="container" style="max-width: 1100px; margin: 40px auto; padding: 0 20px;">
    <!-- Title -->
    <div style="text-align: center; margin-bottom: 30px;">
        <span style="color: #D4AF37; font-size: 0.8rem; letter-spacing: 3px; text-transform: uppercase; font-weight: 600;">Customer Care &amp; Concierge</span>
        <h1 style="font-family: 'Playfair Display', serif; color: #F5F0E8; font-size: 2.4rem; margin-top: 10px; font-weight: 700;">Liên Hệ &amp; Tư Vấn Nexora</h1>
        <div style="width: 60px; height: 2px; background: #D4AF37; margin: 15px auto;"></div>
        <p style="color: #888; max-width: 650px; margin: 0 auto; font-size: 0.95rem;">Đội ngũ chuyên viên tư vấn phong cách Nexora luôn sẵn sàng lắng nghe và hỗ trợ bạn trong mọi yêu cầu.</p>
    </div>

    <!-- Navigation Tabs: Form vs History -->
    <div class="contact-tab-nav" style="display: flex; justify-content: center; gap: 15px; margin-bottom: 35px; border-bottom: 1px solid rgba(212,175,55,0.2); padding-bottom: 15px;">
        <button type="button" class="tab-btn ${activeTab != 'history' ? 'active' : ''}" onclick="switchTab('form')" id="btnTabForm">
            <i class="fas fa-paper-plane" style="margin-right: 8px;"></i> Gửi Lời Nhắn Mới
        </button>
        <button type="button" class="tab-btn ${activeTab == 'history' ? 'active' : ''}" onclick="switchTab('history')" id="btnTabHistory">
            <i class="fas fa-history" style="margin-right: 8px;"></i> Lịch Sử Liên Hệ Của Bạn
            <c:if test="${not empty contactHistory}">
                <span class="tab-badge">${contactHistory.size()}</span>
            </c:if>
        </button>
    </div>

    <!-- TAB 1: FORM & BOUTIQUE INFO -->
    <div id="tabContentForm" style="${activeTab == 'history' ? 'display:none;' : 'display:block;'}">
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 35px; align-items: start;">
            <!-- Left: Boutique Information -->
            <div style="background: rgba(255,255,255,0.02); border: 1px solid rgba(212,175,55,0.2); border-radius: 12px; padding: 35px 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
                <h3 style="font-family: 'Playfair Display', serif; color: #D4AF37; font-size: 1.4rem; margin-bottom: 25px;">
                    Showroom &amp; Văn Phòng
                </h3>

                <div style="display: flex; gap: 15px; margin-bottom: 22px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(212,175,55,0.1); border: 1px solid rgba(212,175,55,0.3); display: flex; align-items: center; justify-content: center; color: #D4AF37; flex-shrink: 0;">
                        <i class="fas fa-map-marker-alt"></i>
                    </div>
                    <div>
                        <h4 style="color: #F5F0E8; font-size: 0.95rem; margin-bottom: 4px;">Địa chỉ Showroom</h4>
                        <p style="color: #aaa; font-size: 0.88rem; line-height: 1.5;">124 Đồng Khởi, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh</p>
                    </div>
                </div>

                <div style="display: flex; gap: 15px; margin-bottom: 22px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(212,175,55,0.1); border: 1px solid rgba(212,175,55,0.3); display: flex; align-items: center; justify-content: center; color: #D4AF37; flex-shrink: 0;">
                        <i class="fas fa-phone-alt"></i>
                    </div>
                    <div>
                        <h4 style="color: #F5F0E8; font-size: 0.95rem; margin-bottom: 4px;">Hotline CSKH</h4>
                        <p style="color: #aaa; font-size: 0.88rem;"><a href="tel:0912345678" style="color: #D4AF37; text-decoration: none;">0912 345 678</a> (8:30 - 21:30 hàng ngày)</p>
                    </div>
                </div>

                <div style="display: flex; gap: 15px; margin-bottom: 22px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(212,175,55,0.1); border: 1px solid rgba(212,175,55,0.3); display: flex; align-items: center; justify-content: center; color: #D4AF37; flex-shrink: 0;">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div>
                        <h4 style="color: #F5F0E8; font-size: 0.95rem; margin-bottom: 4px;">Email liên hệ</h4>
                        <p style="color: #aaa; font-size: 0.88rem;"><a href="mailto:contact@nexora.com" style="color: #D4AF37; text-decoration: none;">contact@nexora.com</a></p>
                    </div>
                </div>

                <div style="display: flex; gap: 15px;">
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(212,175,55,0.1); border: 1px solid rgba(212,175,55,0.3); display: flex; align-items: center; justify-content: center; color: #D4AF37; flex-shrink: 0;">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div>
                        <h4 style="color: #F5F0E8; font-size: 0.95rem; margin-bottom: 4px;">Giờ mở cửa</h4>
                        <p style="color: #aaa; font-size: 0.88rem;">Thứ Hai - Chủ Nhật: 09:00 - 22:00</p>
                    </div>
                </div>
            </div>

            <!-- Right: Contact Form -->
            <div style="background: rgba(255,255,255,0.02); border: 1px solid rgba(212,175,55,0.2); border-radius: 12px; padding: 35px 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
                <h3 style="font-family: 'Playfair Display', serif; color: #D4AF37; font-size: 1.4rem; margin-bottom: 20px;">
                    Gửi Lời Nhắn Đến Nexora
                </h3>
                
                <form action="${pageContext.request.contextPath}/contact" method="POST" class="nexora-form">
                    <div class="form-group" style="margin-bottom: 18px;">
                        <label style="display: block; margin-bottom: 6px; font-size: 0.85rem; color: #D4AF37;">Họ và tên của bạn (*)</label>
                        <input type="text" name="name" required placeholder="Ví dụ: Nguyễn Văn A" value="${sessionScope.fullname}" style="width: 100%; padding: 10px 14px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.12); border-radius: 6px; color: #fff;">
                    </div>

                    <div class="form-group" style="margin-bottom: 18px;">
                        <label style="display: block; margin-bottom: 6px; font-size: 0.85rem; color: #D4AF37;">Địa chỉ Email (*)</label>
                        <input type="email" name="email" required placeholder="name@example.com" value="${sessionScope.email}" style="width: 100%; padding: 10px 14px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.12); border-radius: 6px; color: #fff;">
                    </div>

                    <div class="form-group" style="margin-bottom: 22px;">
                        <label style="display: block; margin-bottom: 6px; font-size: 0.85rem; color: #D4AF37;">Nội dung yêu cầu / tư vấn (*)</label>
                        <textarea name="message" rows="5" required placeholder="Bạn cần tư vấn phong cách, đặt may đo hoặc hỗ trợ đơn hàng..." style="width: 100%; padding: 10px 14px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.12); border-radius: 6px; color: #fff;"></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; font-size: 0.95rem; font-weight: 700;">
                        <i class="fas fa-paper-plane" style="margin-right: 8px;"></i> GỬI LỜI NHẮN NGAY
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- TAB 2: LỊCH SỬ LIÊN HỆ ĐỒNG BỘ VỚI ADMIN -->
    <div id="tabContentHistory" style="${activeTab == 'history' ? 'display:block;' : 'display:none;'}">
        <div style="background: rgba(255,255,255,0.02); border: 1px solid rgba(212,175,55,0.2); border-radius: 12px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; margin-bottom: 25px; border-bottom: 1px solid rgba(255,255,255,0.08); padding-bottom: 15px;">
                <div>
                    <h3 style="font-family: 'Playfair Display', serif; color: #F5F0E8; font-size: 1.4rem; margin-bottom: 4px;">
                        <i class="fas fa-headset" style="color: #D4AF37; margin-right: 8px;"></i> Tiến Độ Xử Lý Liên Hệ
                    </h3>
                    <p style="color: #888; font-size: 0.85rem;">Các yêu cầu liên hệ, tư vấn phong cách và ghi chú phản hồi trực tiếp từ Ban Quản Trị Nexora.</p>
                </div>

                <!-- Form tra cứu theo email nếu chưa đăng nhập -->
                <c:if test="${empty sessionScope.user_id}">
                    <form action="${pageContext.request.contextPath}/contact" method="GET" style="display: flex; gap: 8px;">
                        <input type="hidden" name="tab" value="history">
                        <input type="email" name="searchEmail" value="${searchEmail}" placeholder="Nhập email để tra cứu..." required style="padding: 8px 12px; background: rgba(0,0,0,0.6); border: 1px solid rgba(212,175,55,0.3); border-radius: 6px; color: #fff; font-size: 0.85rem; min-width: 220px;">
                        <button type="submit" class="btn btn-primary" style="padding: 8px 14px; font-size: 0.85rem;">Tra cứu</button>
                    </form>
                </c:if>
            </div>

            <c:choose>
                <c:when test="${not empty contactHistory}">
                    <div style="display: flex; flex-direction: column; gap: 20px;">
                        <c:forEach var="item" items="${contactHistory}">
                            <div class="contact-history-card ${item.status == 'resolved' ? 'card-resolved' : 'card-pending'}">
                                <!-- Card Header -->
                                <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 12px; margin-bottom: 14px;">
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <span style="font-weight: 700; color: #D4AF37; font-size: 0.95rem; letter-spacing: 1px;">#LH-${item.contactId}</span>
                                        <span style="color: #777; font-size: 0.8rem;"><i class="far fa-clock"></i> <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    </div>

                                    <!-- Status Badge synced with Admin -->
                                    <div>
                                        <c:choose>
                                            <c:when test="${item.status == 'resolved' || item.status == 'Đã xử lý'}">
                                                <span class="badge-status-resolved">
                                                    <i class="fas fa-check-circle"></i> ĐÃ XỬ LÝ XONG
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status-pending">
                                                    <i class="fas fa-hourglass-half"></i> ĐANG CHỜ ADMIN XỬ LÝ
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- User Request Content -->
                                <div style="margin-bottom: 14px;">
                                    <div style="font-size: 0.78rem; text-transform: uppercase; letter-spacing: 1px; color: #888; margin-bottom: 6px;">Nội dung bạn gửi:</div>
                                    <p style="color: #E0E0E0; font-size: 0.92rem; line-height: 1.6; background: rgba(0,0,0,0.3); padding: 12px 16px; border-radius: 8px; border-left: 3px solid #D4AF37; margin: 0;">
                                        ${item.message}
                                    </p>
                                </div>

                                <!-- Admin Response Box (Synced immediately when admin clicks 'Xử lý xong') -->
                                <c:choose>
                                    <c:when test="${item.status == 'resolved' || item.status == 'Đã xử lý'}">
                                        <div class="admin-reply-box">
                                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                                <span style="color: #D4AF37; font-size: 0.85rem; font-weight: 700; display: inline-flex; align-items: center; gap: 6px;">
                                                    <i class="fas fa-shield-alt"></i> Phản hồi từ Ban Quản Trị Nexora
                                                </span>
                                                <c:if test="${not empty item.processedAt}">
                                                    <span style="color: #28a745; font-size: 0.75rem;">
                                                        <i class="fas fa-check-double"></i> Đã xử lý lúc: <fmt:formatDate value="${item.processedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </span>
                                                </c:if>
                                            </div>
                                            <p style="color: #C8D6E5; font-size: 0.9rem; line-height: 1.6; margin: 0;">
                                                ${not empty item.reply ? item.reply : 'Ban quản trị Nexora đã tiếp nhận và hoàn tất xử lý yêu cầu của quý khách qua điện thoại/email hỗ trợ.'}
                                            </p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="display: flex; align-items: center; gap: 8px; color: #ffc107; font-size: 0.82rem; background: rgba(255,193,7,0.06); padding: 8px 14px; border-radius: 6px; border: 1px solid rgba(255,193,7,0.2);">
                                            <i class="fas fa-info-circle"></i> Yêu cầu của bạn đang được đội ngũ quản trị viên Nexora tiếp nhận xem xét. Kết quả xử lý sẽ được cập nhật tại đây.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 50px 20px; color: #888;">
                        <i class="fas fa-inbox" style="font-size: 3.5rem; color: rgba(212,175,55,0.3); margin-bottom: 15px;"></i>
                        <h4 style="color: #ddd; font-size: 1.15rem; margin-bottom: 8px;">Chưa Có Lịch Sử Liên Hệ Nào</h4>
                        <p style="max-width: 460px; margin: 0 auto 20px; font-size: 0.9rem;">
                            <c:choose>
                                <c:when test="${empty sessionScope.user_id}">
                                    Hãy đăng nhập tài khoản hoặc nhập email đã gửi lời nhắn ở thanh trên để kiểm tra lịch sử liên hệ của bạn.
                                </c:when>
                                <c:otherwise>
                                    Bạn chưa gửi yêu cầu liên hệ hoặc tư vấn nào. Hãy gửi lời nhắn đầu tiên đến chúng tôi!
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <button type="button" class="btn btn-primary" onclick="switchTab('form')">
                            <i class="fas fa-pen-nib" style="margin-right: 6px;"></i> Gửi Lời Nhắn Mới
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<style>
.tab-btn {
    background: transparent;
    border: none;
    color: #888;
    font-size: 0.95rem;
    font-weight: 600;
    padding: 10px 20px;
    cursor: pointer;
    border-radius: 30px;
    transition: all 0.3s;
    display: inline-flex;
    align-items: center;
}
.tab-btn:hover {
    color: #D4AF37;
    background: rgba(212,175,55,0.06);
}
.tab-btn.active {
    background: linear-gradient(135deg, #D4AF37, #B8860B);
    color: #0C0C0C;
    box-shadow: 0 4px 15px rgba(212,175,55,0.3);
}
.tab-badge {
    background: #0C0C0C;
    color: #D4AF37;
    font-size: 0.72rem;
    padding: 2px 8px;
    border-radius: 20px;
    margin-left: 8px;
    font-weight: 800;
}
.contact-history-card {
    background: rgba(0,0,0,0.4);
    border: 1px solid rgba(255,255,255,0.08);
    border-radius: 10px;
    padding: 20px 24px;
    transition: transform 0.2s, border-color 0.2s;
}
.contact-history-card:hover {
    border-color: rgba(212,175,55,0.3);
}
.card-resolved {
    border-left: 4px solid #28a745;
}
.card-pending {
    border-left: 4px solid #ffc107;
}
.badge-status-resolved {
    background: rgba(40,167,69,0.15);
    color: #4cd137;
    border: 1px solid rgba(40,167,69,0.4);
    padding: 5px 14px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    letter-spacing: 0.5px;
}
.badge-status-pending {
    background: rgba(255,193,7,0.15);
    color: #fbc531;
    border: 1px solid rgba(255,193,7,0.4);
    padding: 5px 14px;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    letter-spacing: 0.5px;
}
.admin-reply-box {
    background: linear-gradient(135deg, rgba(20,30,25,0.8), rgba(15,20,18,0.9));
    border: 1px solid rgba(40,167,69,0.3);
    border-radius: 8px;
    padding: 14px 18px;
    margin-top: 10px;
}
</style>

<script>
function switchTab(tab) {
    var tabForm = document.getElementById('tabContentForm');
    var tabHistory = document.getElementById('tabContentHistory');
    var btnForm = document.getElementById('btnTabForm');
    var btnHistory = document.getElementById('btnTabHistory');

    if (tab === 'history') {
        tabForm.style.display = 'none';
        tabHistory.style.display = 'block';
        btnForm.classList.remove('active');
        btnHistory.classList.add('active');
    } else {
        tabForm.style.display = 'block';
        tabHistory.style.display = 'none';
        btnForm.classList.add('active');
        btnHistory.classList.remove('active');
    }
}
</script>

<%@ include file="/includes/footer.jsp" %>
