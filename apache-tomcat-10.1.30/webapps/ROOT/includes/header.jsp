<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    // Tinh Số lượng Sản phẩm trong gio hang
    java.util.Map<String, com.nexora.model.CartItem> sessionCart =
        (java.util.Map<String, com.nexora.model.CartItem>) session.getAttribute("cart");
    int cartCount = 0;
    if (sessionCart != null) {
        for (com.nexora.model.CartItem ci : sessionCart.values()) cartCount += ci.getQty();
    }
    request.setAttribute("cartCount", cartCount);
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <meta name="theme-color" content="#0C0C0C">
    <title>NEXORA | Premium Men's Fashion &amp; Fragrance</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nexora_luxury.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>
    <!-- REALTIME SKY BACKGROUND (VIETNAM TIME GMT+7) -->
    <%@ include file="/includes/vn_live_sky_backdrop.jsp" %>

    <!-- PRELOADER -->
    <div id="preloader">
        <div class="loader-content">
            <div class="loader-logo">NEXORA</div>
            <p style="color: #D4AF37; letter-spacing: 3px; font-size: 0.7rem; margin-top: 10px; text-transform: uppercase;">Defining Elegance</p>
        </div>
    </div>

    <!-- NAVIGATION -->
    <header id="mainHeader">
        <div class="navbar">
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/" class="logo">Nexora</a>

            <!-- Desktop Search -->
            <div class="search-container">
                <form action="${pageContext.request.contextPath}/" method="GET">
                    <i class="fas fa-search"></i>
                    <input type="text" name="search" placeholder="Tìm kiếm phong cách của bạn..."
                           value="<c:out value='${param.search}'/>">
                </form>
            </div>

            <!-- Desktop Nav Icons -->
            <div class="nav-icons">
                <a href="${pageContext.request.contextPath}/" class="nav-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>CỬA HÀNG</span>
                </a>

                <a href="${pageContext.request.contextPath}/posts" class="nav-item">
                    <i class="fas fa-newspaper"></i>
                    <span>BÀI VIẾT</span>
                </a>

                <a href="${pageContext.request.contextPath}/contact" class="nav-item">
                    <i class="fas fa-envelope"></i>
                    <span>LIÊN HỆ</span>
                </a>

                <a href="${pageContext.request.contextPath}/cart" class="nav-item" style="position: relative;">
                    <i class="fas fa-shopping-bag"></i>
                    <span>TÚI ĐỒ</span>
                    <c:if test="${cartCount > 0}">
                        <span class="cart-badge">${cartCount}</span>
                    </c:if>
                </a>

                <c:choose>
                    <c:when test="${not empty sessionScope.user_id}">
                        <div class="nav-dropdown">
                            <div class="nav-item" onclick="toggleDropdown()" style="position:relative;">
                                <i class="fas fa-user-tie"></i>
                                <span><c:out value="${sessionScope.fullname}"/></span>
                            </div>
                            <div id="userDropdown" class="user-dropdown-menu">
                                <a href="${pageContext.request.contextPath}/history">
                                    <i class="fas fa-history"></i>Lịch sử Đơn hàng
                                </a>
                                <a href="${pageContext.request.contextPath}/contact?tab=history">
                                    <i class="fas fa-headset"></i>Lịch sử Liên hệ
                                </a>
                                <a href="${pageContext.request.contextPath}/change-password">
                                    <i class="fas fa-key"></i>Đổi mật khẩu
                                </a>
                                <c:if test="${sessionScope.role == 'admin'}">
                                    <a href="${pageContext.request.contextPath}/admin/products">
                                        <i class="fas fa-cog"></i>Quản trị
                                    </a>
                                </c:if>
                                <hr>
                                <a href="${pageContext.request.contextPath}/logout" style="color: #ff6b6b;">
                                    <i class="fas fa-sign-out-alt" style="color:#ff6b6b;"></i>Đăng xuất
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="nav-item">
                            <i class="fas fa-user"></i>
                            <span>ĐĂNG NHẬP</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Hamburger Button (Mobile) -->
            <button class="hamburger" id="hamburger" aria-label="Menu" aria-expanded="false">
                <span></span><span></span><span></span>
            </button>
        </div>
    </header>

    <!-- Mobile Navigation Overlay -->
    <nav class="mobile-nav" id="mobileNav" aria-hidden="true">
        <div class="mobile-search">
            <form action="${pageContext.request.contextPath}/" method="GET">
                <i class="fas fa-search"></i>
                <input type="text" name="search" placeholder="Tìm kiếm Sản phẩm...">
            </form>
        </div>
        <a href="${pageContext.request.contextPath}/" class="mobile-nav-item"><i class="fas fa-map-marker-alt"></i> Cửa hàng</a>
        <a href="${pageContext.request.contextPath}/posts" class="mobile-nav-item"><i class="fas fa-newspaper"></i> Bài viết</a>
        <a href="${pageContext.request.contextPath}/contact" class="mobile-nav-item"><i class="fas fa-envelope"></i> Liên hệ</a>
        <a href="${pageContext.request.contextPath}/cart" class="mobile-nav-item">
            <i class="fas fa-shopping-bag"></i> Túi đồ
            <c:if test="${cartCount > 0}">
                <span style="margin-left:auto; background:var(--secondary); color:#0C0C0C; font-size:0.75rem; font-weight:800; padding:2px 8px; border-radius:20px;">${cartCount}</span>
            </c:if>
        </a>
        <div class="mobile-nav-divider"></div>
        <c:choose>
            <c:when test="${not empty sessionScope.user_id}">
                <div style="padding: 10px 16px; font-size: 0.78rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px;">
                    Tài khoản &mdash; <c:out value="${sessionScope.fullname}"/>
                </div>
                <a href="${pageContext.request.contextPath}/history" class="mobile-nav-item"><i class="fas fa-history"></i> Lịch sử Đơn hàng</a>
                <a href="${pageContext.request.contextPath}/contact?tab=history" class="mobile-nav-item"><i class="fas fa-headset"></i> Lịch sử Liên hệ</a>
                <a href="${pageContext.request.contextPath}/change-password" class="mobile-nav-item"><i class="fas fa-key"></i> Đổi mật khẩu</a>
                <c:if test="${sessionScope.role == 'admin'}">
                    <a href="${pageContext.request.contextPath}/admin/products" class="mobile-nav-item"><i class="fas fa-cog"></i> Quan tri</a>
                </c:if>
                <div class="mobile-nav-divider"></div>
                <a href="${pageContext.request.contextPath}/logout" class="mobile-nav-item mobile-nav-logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="mobile-nav-item"><i class="fas fa-user"></i> Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="mobile-nav-item"><i class="fas fa-user-plus"></i> Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </nav>

    <div class="main-content">
    <script>
        window.addEventListener('scroll', function() {
            document.getElementById('mainHeader').classList.toggle('scrolled', window.scrollY > 50);
        });
        window.addEventListener('load', function() {
            var preloader = document.getElementById('preloader');
            setTimeout(() => {
                preloader.style.opacity = '0';
                setTimeout(() => { preloader.style.display = 'none'; }, 800);
            }, 900);
        });
        function toggleDropdown() {
            var dd = document.getElementById('userDropdown');
            if (dd) dd.style.display = dd.style.display === 'block' ? 'none' : 'block';
        }
        document.addEventListener('click', function(e) {
            var dd = document.getElementById('userDropdown');
            if (dd && !e.target.closest('.nav-dropdown')) dd.style.display = 'none';
        });
        var hamburger = document.getElementById('hamburger');
        var mobileNav = document.getElementById('mobileNav');
        hamburger.addEventListener('click', function() {
            var isOpen = mobileNav.classList.contains('open');
            mobileNav.classList.toggle('open', !isOpen);
            hamburger.classList.toggle('open', !isOpen);
            hamburger.setAttribute('aria-expanded', String(!isOpen));
            mobileNav.setAttribute('aria-hidden', String(isOpen));
            document.body.style.overflow = isOpen ? '' : 'hidden';
        });
        mobileNav.querySelectorAll('a').forEach(function(link) {
            link.addEventListener('click', function() {
                mobileNav.classList.remove('open');
                hamburger.classList.remove('open');
                hamburger.setAttribute('aria-expanded', 'false');
                mobileNav.setAttribute('aria-hidden', 'true');
                document.body.style.overflow = '';
            });
        });
    </script>
