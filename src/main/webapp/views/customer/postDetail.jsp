<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/includes/header.jsp" %>

<div class="container" style="max-width: 900px; margin: 40px auto; padding: 0 20px;">
    <!-- Back Link -->
    <div style="margin-bottom: 25px;">
        <a href="${pageContext.request.contextPath}/posts" style="color: #D4AF37; text-decoration: none; font-size: 0.85rem; display: inline-flex; align-items: center; gap: 8px;">
            <i class="fas fa-chevron-left"></i> Quay lại danh sách bài viết
        </a>
    </div>

    <!-- Article Header -->
    <article style="background: rgba(255,255,255,0.02); border: 1px solid rgba(212,175,55,0.15); border-radius: 12px; padding: 35px 30px; box-shadow: 0 10px 40px rgba(0,0,0,0.6);">
        <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 20px; font-size: 0.82rem; color: #888;">
            <span style="color: #D4AF37; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;">Nexora Journal</span>
            <span>&bull;</span>
            <span><i class="far fa-calendar-alt"></i> <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
        </div>

        <h1 style="font-family: 'Playfair Display', serif; color: #F5F0E8; font-size: clamp(1.8rem, 3.5vw, 2.5rem); line-height: 1.35; margin-bottom: 25px;">
            ${post.title}
        </h1>

        <!-- Featured Image -->
        <c:if test="${not empty post.image}">
            <div style="width: 100%; max-height: 480px; overflow: hidden; border-radius: 8px; margin-bottom: 30px;">
                <c:set var="postImg" value="${fn:startsWith(post.image, 'http') ? post.image : pageContext.request.contextPath.concat('/assets/images/').concat(post.image)}"/>
                <img src="${postImg}" alt="${post.title}" style="width: 100%; height: 100%; object-fit: cover;">
            </div>
        </c:if>

        <!-- Content -->
        <div style="color: #d1cfcb; font-size: 1.05rem; line-height: 1.9; white-space: pre-line; letter-spacing: 0.2px;">
            ${post.content}
        </div>

        <div style="margin-top: 40px; padding-top: 25px; border-top: 1px solid rgba(255,255,255,0.08); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px;">
            <span style="color: #666; font-size: 0.85rem;">Bản quyền bài viết thuộc về &copy; NEXORA Men Boutique</span>
            <a href="${pageContext.request.contextPath}/posts" class="btn btn-primary" style="padding: 8px 18px; font-size: 0.85rem;">
                Xem thêm bài viết khác
            </a>
        </div>
    </article>

    <!-- Other Suggested Posts -->
    <c:if test="${not empty otherPosts}">
        <div style="margin-top: 50px;">
            <h3 style="font-family: 'Playfair Display', serif; color: #D4AF37; font-size: 1.4rem; margin-bottom: 20px;">
                Bài viết cùng chủ đề
            </h3>
            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 20px;">
                <c:forEach var="op" items="${otherPosts}">
                    <div style="background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.08); border-radius: 8px; padding: 15px;">
                        <a href="${pageContext.request.contextPath}/post?id=${op.postId}" style="color: #F5F0E8; text-decoration: none; font-weight: 600; font-size: 0.95rem; line-height: 1.4; display: block; margin-bottom: 8px;">
                            ${op.title}
                        </a>
                        <span style="color: #777; font-size: 0.75rem;"><fmt:formatDate value="${op.createdAt}" pattern="dd/MM/yyyy"/></span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="/includes/footer.jsp" %>
