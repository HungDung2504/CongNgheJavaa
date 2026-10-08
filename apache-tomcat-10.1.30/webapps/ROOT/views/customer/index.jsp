<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/includes/header.jsp" %>

<!-- HERO SECTION -->
<div class="hero-container" data-aos="fade-in">
    <div class="main-slider">
        <div class="slides" id="bannerSlides">
            <div class="slide">
                <img src="${pageContext.request.contextPath}/assets/images/nexora_banner1.png" alt="Nexora Collection 2026">
                <div class="banner-overlay">
                    <p>Elevating Masculine Style</p>
                    <h1 class="luxury-font">Collection 2026</h1>
                </div>
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/assets/images/nexora_banner2.png" alt="Nexora The New Standard">
                <div class="banner-overlay">
                    <p>Minimalist Craftsmanship</p>
                    <h1 class="luxury-font">The New Standard</h1>
                </div>
            </div>
            <div class="slide">
                <img src="${pageContext.request.contextPath}/assets/images/nexora_banner3.png" alt="Nexora Brand">
                <div class="banner-overlay">
                    <p style="letter-spacing: 4px; color: #D4AF37; text-transform:uppercase; font-size: 0.8rem; margin-bottom: 4px;">DEFINING ELEGANCE</p>
                    <h1 class="luxury-font" style="font-size: clamp(2rem, 4vw, 3rem); letter-spacing: 6px; text-transform: uppercase;">NEXORA</h1>
                </div>
            </div>
        </div>
        <button class="slider-btn prev" onclick="moveSlide(-1)" aria-label="Truoc">&#10094;</button>
        <button class="slider-btn next" onclick="moveSlide(1)" aria-label="Sau">&#10095;</button>
        <div style="position:absolute; bottom:12px; left:50%; transform:translateX(-50%); display:flex; gap:6px; z-index:2;">
            <span class="slider-dot active" onclick="goToSlide(0)"></span>
            <span class="slider-dot" onclick="goToSlide(1)"></span>
            <span class="slider-dot" onclick="goToSlide(2)"></span>
        </div>
    </div>
    <div class="side-banners">
        <a href="#lane-6" class="side-banner" onclick="return scrollToLane('lane-6')" data-aos="fade-left" data-aos-delay="200">
            <img src="${pageContext.request.contextPath}/assets/images/nexora_side_perfume.png" alt="Fragrance">
            <div class="banner-overlay">
                <p style="font-size:0.65rem;letter-spacing:2px;color:#D4AF37;text-transform:uppercase;">FRAGRANCE</p>
                <h3 class="luxury-font" style="font-size:1.1rem;">Nexora Parfum</h3>
            </div>
        </a>
        <a href="#lane-1" class="side-banner" onclick="return scrollToLane('lane-1')" data-aos="fade-left" data-aos-delay="400">
            <img src="${pageContext.request.contextPath}/assets/images/nexora_side_suit.png" alt="Tailoring">
            <div class="banner-overlay">
                <p style="font-size:0.65rem;letter-spacing:2px;color:#D4AF37;text-transform:uppercase;">TAILORING</p>
                <h3 class="luxury-font" style="font-size:1.1rem;">The Classic Edit</h3>
            </div>
        </a>
    </div>
</div>

<style>
.slider-dot { width:8px;height:8px;border-radius:50%;background:rgba(255,255,255,0.3);cursor:pointer;transition:all 0.3s;border:none; }
.slider-dot.active { background:var(--secondary);width:22px;border-radius:4px; }
</style>
<script>
let currentSlide = 0;
const totalSlides = 3;
function goToSlide(idx) {
    currentSlide = idx;
    document.getElementById('bannerSlides').style.transform = 'translateX(-' + (currentSlide*100) + '%)';
    document.querySelectorAll('.slider-dot').forEach((d,i)=>d.classList.toggle('active',i===currentSlide));
}
function moveSlide(step) { goToSlide((currentSlide+step+totalSlides)%totalSlides); }
let autoPlay = setInterval(()=>moveSlide(1),6000);
const sliderEl = document.querySelector('.main-slider');
if(sliderEl){ sliderEl.addEventListener('mouseenter',()=>clearInterval(autoPlay)); sliderEl.addEventListener('mouseleave',()=>{autoPlay=setInterval(()=>moveSlide(1),6000);}); }
</script>

<!-- BRAND STATEMENT -->
<section class="brand-statement" data-aos="fade-up" data-aos-duration="1200">
    <div class="brand-statement-inner">
        <div class="brand-statement-ornament"></div>
        <p class="brand-statement-label">NEXORA &mdash; Our Philosophy</p>
        <h2 class="brand-statement-title luxury-font">Ban Sac Rieng Cho Quy Ong Hien Dai</h2>
        <p class="brand-statement-body">NEXORA la diem den hang dau danh cho nhung quy ong Tìm kiếm su doc ban. Tu nhung bo suit duoc cat may ti mi den dong nuoc hoa Nexora Parfum doc quyen, chung toi cham chut tung Chi tiết de tao nen mot he sinh thai phong cach toan dien.</p>
        <div class="brand-statement-ornament flip"></div>
    </div>
</section>

<!-- BOUTIQUE CATEGORIES -->
<div class="category-section" id="categoriesSection" data-aos="fade-up">
    <h2 class="luxury-font">Boutique Categories</h2>
    <div class="category-grid">
        <a href="#lane-hot" class="category-item" onclick="return scrollToLane('lane-hot')">
            <div class="category-name">&#128293; HOT COLLECTION</div>
        </a>
        <c:forEach var="cat" items="${categories}">
            <a href="#lane-${cat.catId}" class="category-item" onclick="return scrollToLane('lane-${cat.catId}')">
                <div class="category-name">${fn:toUpperCase(cat.catName)}</div>
            </a>
        </c:forEach>
    </div>
</div>

<!-- SEARCH RESULTS -->
<div id="searchResultsSection" style="display:none;">
    <div class="lane-header" style="padding:0 20px 16px; max-width:1400px; margin:0 auto;">
        <div class="lane-title-wrap">
            <i class="fas fa-search"></i>
            <span class="lane-title">Ket qua Tìm kiếm: "<span id="searchKeyword"></span>"</span>
        </div>
        <button class="lane-clear-btn" onclick="clearSearch()">x Xoa Tìm kiếm</button>
    </div>
    <div class="lane-track" id="searchResultsTrack"></div>
</div>

<!-- 6 PRODUCT LANES - thay PHP while bang JSTL c:forEach -->
<div id="allLanes">
    <%-- Lane: Hot Collection --%>
    <c:if test="${not empty lanes['hot']}">
    <section class="product-lane" id="lane-hot" data-lane="hot">
        <div class="lane-header">
            <div class="lane-title-wrap">
                <span class="lane-accent"></span>
                <span class="lane-title">&#128293; Hot Collection</span>
                <span class="lane-count">${fn:length(lanes['hot'])} Sản phẩm</span>
            </div>
            <a href="${pageContext.request.contextPath}/category?id=1" class="lane-view-all">Xem Tất cả <i class="fas fa-arrow-right"></i></a>
        </div>
        <div class="lane-scroll-wrap" id="track-lane-hot">
            <div class="lane-track" id="inner-track-lane-hot">
                <c:forEach var="p" items="${lanes['hot']}" end="5">
                <div class="lane-card" data-name="${fn:toLowerCase(p.productName)}" data-cat="${p.catId}" data-hot="${p.hot}">
                    <div class="lane-card-img-wrap">
                        <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                            <img src="${fn:startsWith(p.image, 'http') ? p.image : pageContext.request.contextPath.concat('/assets/images/').concat(p.image)}" alt="${p.productName}" loading="lazy">
                        </a>
                        <c:choose>
                            <c:when test="${p.status == 2 || (p.status != 3 && p.stock <= 0)}">
                                <div class="product-banner-tag banner-out-of-stock"><i class="fas fa-ban"></i> HẾT HÀNG</div>
                            </c:when>
                            <c:when test="${p.status == 3}">
                                <div class="product-banner-tag banner-pre-order"><i class="fas fa-clock"></i> TẠM HẾT, ĐẶT TRƯỚC</div>
                            </c:when>
                            <c:when test="${p.hot}">
                                <div class="product-badge">Hot</div>
                            </c:when>
                        </c:choose>
                    </div>
                    <div class="lane-card-info">
                        <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                            <p class="lane-card-name"><c:out value="${p.productName}"/></p>
                        </a>
                        <p class="lane-card-price"><fmt:formatNumber value="${p.price}" pattern="#,###"/> &#8363;</p>
                        <div class="lane-card-actions">
                            <c:choose>
                                <c:when test="${p.status == 2 || (p.status != 3 && p.stock <= 0)}">
                                    <span class="btn-primary" style="background:#2a2a2a; color:#888; border:1px solid #444; cursor:not-allowed; display:block; width:100%; text-align:center; font-weight:700;">Hết hàng</span>
                                </c:when>
                                <c:when test="${p.status == 3}">
                                    <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="btn-primary" style="background:linear-gradient(135deg, #f08c00, #D4AF37); color:#000; font-weight:800; display:block; width:100%; text-align:center;">Đặt trước ngay</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="btn-primary">Mua ngay</a>
                                    <a href="${pageContext.request.contextPath}/cart?action=add&id=${p.productId}" class="btn-cart" title="Thêm vào giỏ"><i class="fas fa-cart-plus"></i></a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </div>
        </div>
        <div style="text-align: center; margin-top: 18px;">
            <a href="${pageContext.request.contextPath}/category?id=1" class="btn-lane-bottom">
                Xem tất cả sản phẩm Hot Collection <i class="fas fa-arrow-right" style="margin-left: 6px;"></i>
            </a>
        </div>
    </section>
    </c:if>

    <%-- Cac Lane Danh mục --%>
    <c:set var="laneIds" value="1,2,3,5,6"/>
    <c:forTokens var="catIdStr" items="${laneIds}" delims=",">
        <c:set var="catId" value="${catIdStr}"/>
        <c:if test="${not empty lanes[catId]}">
        <section class="product-lane" id="lane-${catId}" data-lane="${catId}">
            <div class="lane-header">
                <div class="lane-title-wrap">
                    <span class="lane-accent"></span>
                    <span class="lane-title">${laneLabels[catId]}</span>
                    <span class="lane-count">Hiển thị 6 sản phẩm</span>
                </div>
                <a href="${pageContext.request.contextPath}/category?id=${catId}" class="lane-view-all">Xem Tất cả <i class="fas fa-arrow-right"></i></a>
            </div>
            <div class="lane-scroll-wrap" id="track-lane-${catId}">
                <div class="lane-track" id="inner-track-lane-${catId}">
                    <c:forEach var="p" items="${lanes[catId]}" end="5">
                    <div class="lane-card" data-name="${fn:toLowerCase(p.productName)}" data-cat="${p.catId}">
                        <div class="lane-card-img-wrap">
                            <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                                <img src="${fn:startsWith(p.image, 'http') ? p.image : pageContext.request.contextPath.concat('/assets/images/').concat(p.image)}" alt="${p.productName}" loading="lazy">
                            </a>
                            <c:choose>
                                <c:when test="${p.status == 2 || (p.status != 3 && p.stock <= 0)}">
                                    <div class="product-banner-tag banner-out-of-stock"><i class="fas fa-ban"></i> HẾT HÀNG</div>
                                </c:when>
                                <c:when test="${p.status == 3}">
                                    <div class="product-banner-tag banner-pre-order"><i class="fas fa-clock"></i> TẠM HẾT, ĐẶT TRƯỚC</div>
                                </c:when>
                                <c:when test="${p.hot}">
                                    <div class="product-badge">Hot</div>
                                </c:when>
                            </c:choose>
                        </div>
                        <div class="lane-card-info">
                            <a href="${pageContext.request.contextPath}/product?id=${p.productId}">
                                <p class="lane-card-name"><c:out value="${p.productName}"/></p>
                            </a>
                            <p class="lane-card-price"><fmt:formatNumber value="${p.price}" pattern="#,###"/> &#8363;</p>
                            <div class="lane-card-actions">
                                <c:choose>
                                    <c:when test="${p.status == 2 || (p.status != 3 && p.stock <= 0)}">
                                        <span class="btn-primary" style="background:#2a2a2a; color:#888; border:1px solid #444; cursor:not-allowed; display:block; width:100%; text-align:center; font-weight:700;">Hết hàng</span>
                                    </c:when>
                                    <c:when test="${p.status == 3}">
                                        <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="btn-primary" style="background:linear-gradient(135deg, #f08c00, #D4AF37); color:#000; font-weight:800; display:block; width:100%; text-align:center;">Đặt trước ngay</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="btn-primary">Mua ngay</a>
                                        <a href="${pageContext.request.contextPath}/cart?action=add&id=${p.productId}" class="btn-cart" title="Thêm vào giỏ"><i class="fas fa-cart-plus"></i></a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    </c:forEach>
                </div>
            </div>
            <div style="text-align: center; margin-top: 18px;">
                <a href="${pageContext.request.contextPath}/category?id=${catId}" class="btn-lane-bottom">
                    Xem tất cả ${laneLabels[catId]} <i class="fas fa-arrow-right" style="margin-left: 6px;"></i>
                </a>
            </div>
        </section>
        </c:if>
    </c:forTokens>
</div>

<!-- SECTION BÀI VIẾT & TIN TỨC ĐỒNG BỘ TỪ ADMIN -->
<c:if test="${not empty latestPosts}">
<section class="home-journal-section" style="padding: 70px 20px; border-top: 1px solid rgba(212,175,55,0.15); max-width: 1400px; margin: 0 auto;">
    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 35px; flex-wrap: wrap; gap: 15px;">
        <div>
            <span style="color: #D4AF37; font-size: 0.78rem; letter-spacing: 3px; text-transform: uppercase; font-weight: 600;">Nexora Journal & Lifestyle</span>
            <h2 style="font-family: 'Playfair Display', serif; color: #F5F0E8; font-size: clamp(1.5rem, 3vw, 2.2rem); margin-top: 6px; font-weight: 700;">
                Bài Viết &amp; Phong Cách Quý Ông
            </h2>
        </div>
        <a href="${pageContext.request.contextPath}/posts" class="lane-view-all">
            Xem tất cả bài viết <i class="fas fa-arrow-right"></i>
        </a>
    </div>
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 25px;">
        <c:forEach var="lp" items="${latestPosts}">
            <div style="background: rgba(255,255,255,0.02); border: 1px solid rgba(212,175,55,0.15); border-radius: 12px; overflow: hidden; display: flex; flex-direction: column; transition: transform 0.3s; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
                <div style="height: 210px; overflow: hidden; position: relative; background:#161616;">
                    <a href="${pageContext.request.contextPath}/post?id=${lp.postId}">
                        <c:set var="postThumb" value="${not empty lp.image ? (fn:startsWith(lp.image, 'http') ? lp.image : pageContext.request.contextPath.concat('/assets/images/').concat(lp.image)) : 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=600&q=80'}"/>
                        <img src="${postThumb}" alt="${lp.title}" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s;">
                    </a>
                    <span style="position: absolute; bottom: 10px; right: 10px; background: rgba(0,0,0,0.8); backdrop-filter: blur(4px); color: #D4AF37; font-size: 0.72rem; padding: 4px 10px; border-radius: 4px; border: 1px solid rgba(212,175,55,0.3);">
                        <i class="far fa-calendar-alt"></i> <fmt:formatDate value="${lp.createdAt}" pattern="dd/MM/yyyy"/>
                    </span>
                </div>
                <div style="padding: 22px; flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
                    <div>
                        <h3 style="font-size: 1.1rem; font-weight: 600; line-height: 1.4; margin-bottom: 10px;">
                            <a href="${pageContext.request.contextPath}/post?id=${lp.postId}" style="color: #F5F0E8; text-decoration: none;">
                                ${lp.title}
                            </a>
                        </h3>
                        <p style="color: #888; font-size: 0.86rem; line-height: 1.6; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 15px;">
                            ${lp.content}
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/post?id=${lp.postId}" style="color: #D4AF37; font-size: 0.85rem; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 6px;">
                        Đọc bài viết <i class="fas fa-arrow-right" style="font-size: 0.75rem;"></i>
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>
</section>
</c:if>

<!-- SECTION LIÊN HỆ & TƯ VẤN QUÝ ÔNG (GIỐNG FOOTER GLASSMORPISM) -->
<section class="home-contact-section" style="padding: 70px 20px; background: linear-gradient(180deg, rgba(8, 12, 22, 0.25) 0%, rgba(4, 7, 15, 0.68) 100%); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); border-top: 1px solid rgba(212,175,55,0.28); border-bottom: 1px solid rgba(212,175,55,0.15); position: relative; margin-top: 60px;">
    <div style="position: absolute; top: 0; left: 50%; transform: translateX(-50%); width: 120px; height: 2px; background: linear-gradient(90deg, transparent, #D4AF37, transparent);"></div>
    <div style="max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 40px; align-items: center; position: relative; z-index: 1;">
        <div>
            <span style="color: #D4AF37; font-size: 0.78rem; letter-spacing: 3px; text-transform: uppercase; font-weight: 600;">Nexora Concierge &amp; Showroom</span>
            <h2 style="font-family: 'Playfair Display', serif; color: #F5F0E8; font-size: clamp(1.6rem, 3.2vw, 2.3rem); margin-top: 8px; margin-bottom: 16px; font-weight: 700; line-height: 1.3; text-shadow: 0 2px 10px rgba(0,0,0,0.8);">
                Liên Hệ &amp; Tư Vấn Phong Cách
            </h2>
            <p style="color: #aaa; font-size: 0.92rem; line-height: 1.8; margin-bottom: 25px;">
                Bạn cần hỗ trợ lựa chọn size, tư vấn phối trang phục quý ông hoặc đặt may đo theo yêu cầu? Hãy để lại thông tin, đội ngũ chuyên viên Nexora sẽ liên hệ trực tiếp hỗ trợ bạn.
            </p>
            <div style="display: flex; flex-direction: column; gap: 14px; font-size: 0.9rem; color: #ccc;">
                <div><i class="fas fa-map-marker-alt" style="color: #D4AF37; width: 22px;"></i> 124 Đồng Khởi, Quận 1, TP. Hồ Chí Minh</div>
                <div><i class="fas fa-phone-alt" style="color: #D4AF37; width: 22px;"></i> Hotline: <strong style="color:#fff;">0912 345 678</strong> (08:30 - 21:30)</div>
                <div><i class="fas fa-envelope" style="color: #D4AF37; width: 22px;"></i> Email: <strong style="color:#D4AF37;">contact@nexora.com</strong></div>
            </div>
        </div>

        <!-- Form gửi liên hệ trực tiếp từ trang chủ -->
        <div style="background: rgba(12, 16, 28, 0.65); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); border: 1px solid rgba(212,175,55,0.3); border-radius: 14px; padding: 32px 28px; box-shadow: 0 12px 35px rgba(0,0,0,0.5);">
            <h3 style="font-family: 'Playfair Display', serif; color: #D4AF37; font-size: 1.25rem; margin-bottom: 18px; text-shadow: 0 2px 8px rgba(0,0,0,0.7);">
                Gửi Lời Nhắn Đến Nexora
            </h3>
            <form action="${pageContext.request.contextPath}/contact" method="POST">
                <div style="margin-bottom: 14px;">
                    <input type="text" name="name" required placeholder="Họ và tên của bạn (*)" value="${sessionScope.fullname}" style="width: 100%; padding: 11px 14px; background: rgba(0,0,0,0.5); border: 1px solid rgba(255,255,255,0.12); border-radius: 6px; color: #fff; font-size: 0.9rem;">
                </div>
                <div style="margin-bottom: 14px;">
                    <input type="email" name="email" required placeholder="Địa chỉ email (*)" value="${sessionScope.email}" style="width: 100%; padding: 11px 14px; background: rgba(0,0,0,0.5); border: 1px solid rgba(255,255,255,0.12); border-radius: 6px; color: #fff; font-size: 0.9rem;">
                </div>
                <div style="margin-bottom: 18px;">
                    <textarea name="message" rows="4" required placeholder="Nội dung cần tư vấn hoặc phản hồi..." style="width: 100%; padding: 11px 14px; background: rgba(0,0,0,0.5); border: 1px solid rgba(255,255,255,0.12); border-radius: 6px; color: #fff; font-size: 0.9rem;"></textarea>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; font-weight: 700; font-size: 0.95rem; border-radius: 6px; cursor: pointer;">
                    <i class="fas fa-paper-plane" style="margin-right: 8px;"></i> GỬI LIÊN HỆ ĐẾN BAN QUẢN TRỊ
                </button>
                <div style="text-align: center; margin-top: 14px;">
                    <a href="${pageContext.request.contextPath}/contact?tab=history" style="color: #D4AF37; font-size: 0.82rem; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; letter-spacing: 0.5px;">
                        <i class="fas fa-history"></i> Xem lịch sử liên hệ &amp; tiến độ xử lý <i class="fas fa-arrow-right" style="font-size: 0.75rem;"></i>
                    </a>
                </div>
            </form>
        </div>
    </div>
</section>

<style>
.product-banner-tag {
    position: absolute;
    top: 10px;
    left: 10px;
    padding: 5px 10px;
    font-size: 0.68rem;
    font-weight: 800;
    letter-spacing: 0.6px;
    text-transform: uppercase;
    border-radius: 6px;
    z-index: 5;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.6);
    backdrop-filter: blur(8px);
}
.banner-out-of-stock {
    background: linear-gradient(135deg, #c92a2a, #800000);
    color: #fff;
    border: 1px solid rgba(255,255,255,0.25);
}
.banner-pre-order {
    background: linear-gradient(135deg, #f08c00, #d9480f);
    color: #fff;
    border: 1px solid rgba(255,255,255,0.3);
}
.product-lane { padding: 36px 0 28px; border-bottom: 1px solid rgba(212,175,55,0.07); position: relative; max-width: 1400px; margin: 0 auto; }
.product-lane:last-child { border-bottom: none; }
.lane-header { display: flex; align-items: center; justify-content: space-between; padding: 0 20px 20px; max-width: 1400px; margin: 0 auto; gap: 12px; }
.lane-title-wrap { display: flex; align-items: center; gap: 12px; flex: 1; min-width: 0; }
.lane-accent { display: inline-block; width: 3px; height: 20px; background: linear-gradient(to bottom, #D4AF37, #8B0000); border-radius: 2px; flex-shrink: 0; }
.lane-title { font-family: 'Playfair Display', serif; font-size: clamp(1rem, 2.2vw, 1.3rem); color: #F5F0E8; font-weight: 600; letter-spacing: 0.5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.lane-count { font-size: 0.7rem; color: #444; letter-spacing: 2px; text-transform: uppercase; flex-shrink: 0; }
.lane-view-all { font-size: 0.75rem; color: #D4AF37; letter-spacing: 1.5px; text-transform: uppercase; text-decoration: none; border: 1px solid rgba(212,175,55,0.3); padding: 6px 14px; border-radius: 20px; white-space: nowrap; transition: all 0.2s; flex-shrink: 0; }
.lane-view-all:hover { background: rgba(212,175,55,0.1); border-color: #D4AF37; }
.btn-lane-bottom { display: inline-flex; align-items: center; gap: 8px; padding: 10px 24px; border-radius: 25px; background: rgba(212,175,55,0.06); border: 1px solid rgba(212,175,55,0.3); color: #D4AF37; font-size: 0.82rem; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; transition: all 0.3s ease; }
.btn-lane-bottom:hover { background: #D4AF37; color: #0C0C0C; box-shadow: 0 4px 15px rgba(212,175,55,0.3); transform: translateY(-2px); }
.lane-clear-btn { font-size: 0.75rem; color: #666; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); padding: 6px 14px; border-radius: 20px; cursor: pointer; transition: all 0.2s; flex-shrink: 0; }
.lane-clear-btn:hover { color: #D4AF37; border-color: rgba(212,175,55,0.3); }
.lane-scroll-wrap { position: relative; display: flex; justify-content: center; width: 100%; max-width: 1400px; margin: 0 auto; }
.lane-track { display: flex; flex-wrap: wrap; justify-content: center; align-items: stretch; gap: 20px; padding: 8px 16px; width: 100%; max-width: 1400px; margin: 0 auto; }
.lane-arrow { display: none !important; }
.lane-card { flex: 0 0 200px; width: 200px; max-width: 200px; background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 12px; overflow: hidden; transition: all 0.3s; cursor: pointer; position: relative; }
.lane-card:hover { transform: translateY(-6px); border-color: rgba(212,175,55,0.3); box-shadow: 0 12px 30px rgba(0,0,0,0.5); }
.lane-card-img-wrap { position: relative; aspect-ratio: 3/4; overflow: hidden; background: #111; }
.lane-card-img-wrap img { width:100%; height:100%; object-fit:cover; transition:transform 0.4s; }
.lane-card:hover .lane-card-img-wrap img { transform: scale(1.06); }
.lane-card-info { padding: 12px 14px 14px; }
.lane-card-name { font-size: 0.8rem; color: #D4D4D4; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; transition: color 0.2s; }
.lane-card:hover .lane-card-name { color: #D4AF37; }
.lane-card-name a { color: inherit; text-decoration: none; }
.lane-card-price { font-size: 0.85rem; color: #D4AF37; font-weight: 600; margin-bottom: 10px; }
.lane-card-actions { display: flex; gap: 7px; }
.lane-card-actions .btn-primary { flex: 1; padding: 7px 8px; font-size: 0.72rem; text-align: center; border-radius: 6px; text-decoration: none; }
.lane-card-actions .btn-cart { width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; border-radius: 6px; text-decoration: none; font-size: 0.85rem; background: rgba(212,175,55,0.1); color: #D4AF37; border: 1px solid rgba(212,175,55,0.3); transition: all 0.2s; flex-shrink: 0; }
.lane-card-actions .btn-cart:hover { background: rgba(212,175,55,0.25); }
#searchResultsSection { max-width: 1400px; margin: 0 auto; padding: 32px 0 8px; }
#searchResultsSection .lane-track { justify-content: center; flex-wrap: wrap; height: auto; overflow-x: hidden; }
@media (max-width: 1350px) {
    .lane-track { gap: 16px; }
    .lane-card { flex: 0 0 185px; width: 185px; max-width: 185px; }
}
@media (max-width: 768px) {
    .lane-header { padding: 0 14px 14px; }
    .lane-track { gap: 12px; padding: 4px 10px; }
    .lane-card { flex: 0 0 calc(50% - 10px); width: calc(50% - 10px); max-width: calc(50% - 10px); }
    .lane-arrow { display: none; }
}
/* Hero Banner spacing so text doesn't clash */
.hero-container {
    margin-top: calc(var(--header-height) + 16px) !important;
    margin-bottom: 50px !important;
    position: relative;
    z-index: 2;
}
.slide .banner-overlay {
    max-width: 65%;
    padding: 20px 28px;
    border-radius: 0 14px 0 0;
}
.slide h1 {
    font-size: clamp(1.4rem, 2.5vw, 2.2rem) !important;
    margin-bottom: 4px;
}
.slide p {
    font-size: 0.72rem !important;
    letter-spacing: 3px !important;
}

/* Brand Statement: rõ ràng, tách biệt khỏi banner */
.brand-statement {
    background: rgba(10, 15, 26, 0.45) !important;
    backdrop-filter: blur(10px) !important;
    -webkit-backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(212,175,55,0.22) !important;
    border-radius: 16px;
    padding: 50px 30px;
    max-width: 1200px;
    margin: 50px auto 40px auto;
    position: relative;
    z-index: 2;
    box-shadow: 0 10px 35px rgba(0,0,0,0.4);
}
.brand-statement-inner { max-width: 780px; margin: 0 auto; text-align: center; position: relative; z-index: 1; }
.brand-statement-ornament { width: 60px; height: 1px; background: linear-gradient(90deg, transparent, #D4AF37, transparent); margin: 0 auto 16px; }
.brand-statement-ornament.flip { margin: 16px auto 0; }
.brand-statement-label { font-size: 0.72rem; letter-spacing: 4px; text-transform: uppercase; color: #D4AF37; margin-bottom: 12px; font-weight: 600; }
.brand-statement-title { font-size: clamp(1.5rem, 3.5vw, 2.2rem); color: #F5F0E8; margin-bottom: 18px; line-height: 1.3; letter-spacing: 1px; text-shadow: 0 2px 8px rgba(0,0,0,0.8); }
.brand-statement-body { font-size: clamp(0.88rem, 1.8vw, 1rem); line-height: 1.8; color: rgba(220, 215, 205, 0.9); font-weight: 300; letter-spacing: 0.3px; }

/* Category Section: hiện siêu rõ nét, không bị chìm trên nền sáng */
.category-section {
    position: relative;
    z-index: 2;
    padding: 30px 20px 45px;
}
.category-section h2 {
    font-size: clamp(1.6rem, 3.5vw, 2.2rem) !important;
    color: #D4AF37 !important;
    text-shadow: 0 2px 10px rgba(0, 0, 0, 0.9), 0 4px 20px rgba(0, 0, 0, 0.8) !important;
    font-weight: 700 !important;
    letter-spacing: 1px !important;
    margin-bottom: 28px !important;
}
.category-grid {
    display: flex;
    justify-content: center;
    gap: 12px;
    flex-wrap: wrap;
}
.category-name {
    display: inline-block !important;
    padding: 10px 24px !important;
    border: 1.5px solid rgba(212, 175, 55, 0.55) !important;
    border-radius: 30px !important;
    background: rgba(10, 15, 26, 0.85) !important;
    backdrop-filter: blur(12px) !important;
    -webkit-backdrop-filter: blur(12px) !important;
    color: #FFFFFF !important;
    font-family: 'Inter', sans-serif !important;
    font-size: 0.82rem !important;
    font-weight: 800 !important;
    letter-spacing: 2px !important;
    text-transform: uppercase !important;
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.5) !important;
    transition: all 0.25s ease !important;
    white-space: nowrap !important;
}
.category-item:hover .category-name,
.category-item.active .category-name {
    background: #D4AF37 !important;
    color: #0C0C0C !important;
    border-color: #D4AF37 !important;
    box-shadow: 0 6px 24px rgba(212, 175, 55, 0.6) !important;
    transform: translateY(-2px) !important;
}
</style>
<script>
function laneScroll(trackId, dir) {
    var el = document.querySelector('#' + trackId + ' .lane-track');
    if (!el) el = document.getElementById(trackId);
    if (el) el.scrollBy({ left: dir * 700, behavior: 'smooth' });
}
function scrollToLane(laneId) {
    var el = document.getElementById(laneId);
    if (el) {
        var top = el.getBoundingClientRect().top + window.pageYOffset - 90;
        window.scrollTo({ top: top, behavior: 'smooth' });
    }
    return false;
}
var _allCards = null;
function doClientSearch(keyword) {
    if (!_allCards) _allCards = Array.from(document.querySelectorAll('#allLanes .lane-card'));
    keyword = keyword.trim().toLowerCase();
    var searchSec = document.getElementById('searchResultsSection');
    var track = document.getElementById('searchResultsTrack');
    var kwLabel = document.getElementById('searchKeyword');
    var allLanes = document.getElementById('allLanes');
    if (!keyword) { searchSec.style.display='none'; allLanes.style.display=''; track.innerHTML=''; return; }
    var matches = _allCards.filter(c => c.dataset.name.indexOf(keyword) !== -1);
    kwLabel.textContent = keyword; track.innerHTML = '';
    if (matches.length === 0) { track.innerHTML = '<div style="padding:40px 20px;color:#444;">Khong tim thay Sản phẩm nao.</div>'; }
    else { matches.forEach(c => track.appendChild(c.cloneNode(true))); }
    searchSec.style.display=''; allLanes.style.display='none';
}
function clearSearch() {
    document.getElementById('searchResultsSection').style.display = 'none';
    document.getElementById('allLanes').style.display = '';
}
window.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('form').forEach(function(f) {
        var inp = f.querySelector('input[name="search"]');
        if (inp) {
            f.addEventListener('submit', function(e) { e.preventDefault(); doClientSearch(inp.value); });
            var deb; inp.addEventListener('input', function() { clearTimeout(deb); deb=setTimeout(function(){ doClientSearch(inp.value); },300); });
        }
    });
});
</script>

<%@ include file="/includes/footer.jsp" %>

