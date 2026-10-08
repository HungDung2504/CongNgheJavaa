<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/includes/header.jsp" %>

<div class="container" style="max-width: 1200px; margin: 40px auto; padding: 0 20px;">
    <!-- Breadcrumb & Title -->
    <div style="margin-bottom: 30px; text-align: center;">
        <span style="color: #D4AF37; font-size: 0.8rem; letter-spacing: 3px; text-transform: uppercase; font-weight: 600;">Nexora Journal & Lifestyle</span>
        <h1 style="font-family: 'Playfair Display', serif; color: #F5F0E8; font-size: 2.4rem; margin-top: 10px; font-weight: 700;">Tin Tức &amp; Bài Viết Quý Ông</h1>
        <div style="width: 60px; height: 2px; background: #D4AF37; margin: 15px auto;"></div>
        <p style="color: #888; max-width: 650px; margin: 0 auto; font-size: 0.95rem;">Khám phá nghệ thuật ăn mặc chuẩn mực, bí quyết phong cách và những câu chuyện thời trang đương đại từ Nexora.</p>
    </div>

    <!-- Posts Grid -->
    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 30px; margin-top: 40px;">
        <c:forEach var="p" items="${posts}">
            <article style="background: rgba(255,255,255,0.02); border: 1px solid rgba(212,175,55,0.15); border-radius: 12px; overflow: hidden; display: flex; flex-direction: column; transition: transform 0.3s, border-color 0.3s; box-shadow: 0 10px 30px rgba(0,0,0,0.5);">
                <div style="position: relative; width: 100%; height: 220px; overflow: hidden; background: #161616;">
                    <a href="${pageContext.request.contextPath}/post?id=${p.postId}">
                        <c:set var="postImg" value="${not empty p.image ? (fn:startsWith(p.image, 'http') ? p.image : pageContext.request.contextPath.concat('/assets/images/').concat(p.image)) : 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=600&q=80'}"/>
                        <img src="${postImg}" alt="${p.title}" style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s;">
                    </a>
                    <span style="position: absolute; top: 12px; right: 12px; background: rgba(0,0,0,0.7); backdrop-filter: blur(4px); color: #D4AF37; font-size: 0.72rem; padding: 4px 10px; border-radius: 20px; border: 1px solid rgba(212,175,55,0.3);">
                        <i class="far fa-calendar-alt"></i> <fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy"/>
                    </span>
                </div>
                <div style="padding: 22px; flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
                    <div>
                        <h2 style="font-size: 1.15rem; font-weight: 600; line-height: 1.4; margin-bottom: 12px;">
                            <a href="${pageContext.request.contextPath}/post?id=${p.postId}" style="color: #F5F0E8; text-decoration: none; transition: color 0.2s;">
                                ${p.title}
                            </a>
                        </h2>
                        <p style="color: #999; font-size: 0.88rem; line-height: 1.6; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 20px;">
                            ${p.content}
                        </p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/post?id=${p.postId}" style="color: #D4AF37; font-size: 0.85rem; font-weight: 600; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; letter-spacing: 0.5px;">
                            Đọc bài viết <i class="fas fa-arrow-right" style="font-size: 0.75rem;"></i>
                        </a>
                    </div>
                </div>
            </article>
        </c:forEach>
    </div>

    <c:if test="${empty posts}">
        <div style="text-align: center; padding: 60px 20px; color: #777;">
            <i class="fas fa-newspaper" style="font-size: 3rem; color: #333; margin-bottom: 15px;"></i>
            <p>Chưa có bài viết nào được đăng tải.</p>
        </div>
    </c:if>
</div>

<%@ include file="/includes/footer.jsp" %>
