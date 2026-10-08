<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- ===================================================================
     NEXORA REALTIME LANDSCAPE VIDEO & AMBIENT BACKGROUND
     - 100% tự động đồng bộ theo thời gian thực (Giờ Việt Nam - GMT+7)
     - Sử dụng Video Firewatch Day-Night Cycle 1440p mở rộng 24 giờ
     - Tự động nhảy và cập nhật khung hình chính xác theo từng giây trong ngày
     - Hiển thị trọn vẹn toàn bộ background xuyên qua cả HEADER và FOOTER
     =================================================================== -->
<div id="vnLiveSkyBackdrop" aria-hidden="true">
    <!-- 1. Video Timelapse Thiên nhiên 24 Giờ theo Thời Gian Thực -->
    <video id="vnLiveSkyVideo"
           class="vn-landscape-video"
           src="${pageContext.request.contextPath}/assets/videos/Firewatch-DayNight-Cycle-1440p.mp4"
           preload="auto"
           muted
           playsinline
           loop>
    </video>

    <!-- 2. Lớp Fallback / Poster hình ảnh phong cảnh (khi video đang tải) -->
    <div class="vn-landscape-bg vn-bg-day" id="vnLandscapeDay">
        <div class="vn-sun-lensflare"></div>
    </div>
    <div class="vn-landscape-bg vn-bg-night" id="vnLandscapeNight"></div>

    <!-- 3. Lớp Sao đêm lấp lánh & Sao băng tăng thêm chiều sâu nghệ thuật về đêm -->
    <div class="vn-night-effects" id="vnNightEffects">
        <div class="vn-stars-wrapper" id="vnStarsWrapper"></div>
        <div class="vn-shooting-star" id="vnShootingStar"></div>
    </div>

    <!-- 4. Lớp phủ kính nhẹ bảo vệ độ tương phản sang trọng cho chữ & sản phẩm -->
    <div class="vn-ambient-mask"></div>
</div>

<style>
/* 1. Nền xuyên thấu toàn trang */
html, body {
    background-color: transparent !important;
}

#vnLiveSkyBackdrop {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    z-index: -999;
    pointer-events: none;
    overflow: hidden;
    user-select: none;
    background-color: #060913;
}

/* 2. Video nền Fullscreen tràn viền */
.vn-landscape-video {
    position: absolute;
    top: 50%;
    left: 50%;
    min-width: 100%;
    min-height: 100%;
    width: auto;
    height: auto;
    transform: translate(-50%, -50%);
    object-fit: cover;
    z-index: 2;
    opacity: 0;
    transition: opacity 1.5s ease-in-out;
    pointer-events: none;
}

.vn-landscape-video.ready {
    opacity: 1;
}

/* 3. Hai lớp ảnh Fallback / Poster */
.vn-landscape-bg {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    background-size: cover;
    background-position: center center;
    background-repeat: no-repeat;
    z-index: 1;
    transition: opacity 1.5s ease;
}

.vn-bg-day {
    background-image: url('${pageContext.request.contextPath}/assets/images/landscape_day.png');
    opacity: 0;
}

.vn-bg-night {
    background-image: url('${pageContext.request.contextPath}/assets/images/landscape_night.png');
    opacity: 1;
}

/* Ánh dương lấp lánh nhẹ */
.vn-sun-lensflare {
    position: absolute;
    top: 40%;
    left: 53%;
    transform: translate(-50%, -50%);
    width: 300px;
    height: 300px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.45) 0%, rgba(200, 235, 255, 0.18) 40%, transparent 75%);
    animation: vnSunShine 7s infinite ease-in-out alternate;
    pointer-events: none;
}

@keyframes vnSunShine {
    0%   { transform: translate(-50%, -50%) scale(0.92); opacity: 0.65; }
    100% { transform: translate(-50%, -50%) scale(1.15); opacity: 0.95; }
}

/* 4. Sao đêm & Sao băng */
.vn-night-effects {
    position: absolute;
    inset: 0;
    z-index: 3;
    pointer-events: none;
    opacity: 0;
    transition: opacity 2s ease;
}

.vn-stars-wrapper {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 52%;
}

.vn-star {
    position: absolute;
    background: #FFFFFF;
    border-radius: 50%;
    animation: vnTwinkle 3s infinite ease-in-out alternate;
}

@keyframes vnTwinkle {
    0%   { opacity: 0.15; transform: scale(0.75); }
    50%  { opacity: 0.95; transform: scale(1.3); box-shadow: 0 0 4px #FFFFFF, 0 0 7px rgba(212, 175, 55, 0.7); }
    100% { opacity: 0.25; transform: scale(0.85); }
}

.vn-shooting-star {
    position: absolute;
    top: -60px;
    left: -60px;
    width: 130px;
    height: 2px;
    background: linear-gradient(90deg, rgba(255,255,255,0.95), rgba(212,175,55,0.85), transparent);
    transform: rotate(-35deg);
    opacity: 0;
    pointer-events: none;
    border-radius: 2px;
    box-shadow: 0 0 8px rgba(255,255,255,0.85);
}

.vn-shooting-star.active {
    animation: vnShootingStarShoot 1.4s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
}

@keyframes vnShootingStarShoot {
    0% {
        transform: translate3d(0, 0, 0) rotate(-35deg);
        opacity: 0.95;
    }
    100% {
        transform: translate3d(450px, 300px, 0) rotate(-35deg);
        opacity: 0;
    }
}

/* 5. Lớp phủ kính nhẹ bảo vệ tương phản */
.vn-ambient-mask {
    position: absolute;
    inset: 0;
    z-index: 4;
    background: radial-gradient(circle at 50% 45%, rgba(6, 10, 20, 0.10) 0%, rgba(4, 7, 15, 0.45) 100%);
    pointer-events: none;
}

/* ===================================================================
   6. HEADER & FOOTER XUYÊN THẤU ĐỂ LỘ TOÀN BỘ BACKGROUND
   =================================================================== */
header#mainHeader {
    background: rgba(8, 12, 22, 0.35) !important;
    backdrop-filter: blur(10px) !important;
    -webkit-backdrop-filter: blur(10px) !important;
    border-bottom: 1px solid rgba(212, 175, 55, 0.22) !important;
    box-shadow: 0 4px 25px rgba(0, 0, 0, 0.25) !important;
}

header#mainHeader.scrolled {
    background: rgba(8, 12, 22, 0.65) !important;
    backdrop-filter: blur(14px) !important;
    -webkit-backdrop-filter: blur(14px) !important;
    box-shadow: 0 6px 30px rgba(0, 0, 0, 0.45) !important;
}

footer {
    background: linear-gradient(180deg, rgba(8, 12, 22, 0.25) 0%, rgba(4, 7, 15, 0.68) 100%) !important;
    backdrop-filter: blur(10px) !important;
    -webkit-backdrop-filter: blur(10px) !important;
    border-top: 1px solid rgba(212, 175, 55, 0.28) !important;
}

.main-content {
    background: transparent !important;
}

.brand-statement {
    background: rgba(10, 15, 26, 0.38) !important;
    backdrop-filter: blur(8px) !important;
    border-top: 1px solid rgba(212, 175, 55, 0.15) !important;
    border-bottom: 1px solid rgba(212, 175, 55, 0.15) !important;
}

.product-card {
    background: rgba(15, 20, 32, 0.72) !important;
    backdrop-filter: blur(10px) !important;
    border: 1px solid rgba(255, 255, 255, 0.08) !important;
}

.product-card:hover {
    background: rgba(22, 30, 48, 0.85) !important;
    border-color: rgba(212, 175, 55, 0.35) !important;
}
</style>

<script>
(function() {
    'use strict';

    var video = document.getElementById('vnLiveSkyVideo');
    var dayEl = document.getElementById('vnLandscapeDay');
    var nightEl = document.getElementById('vnLandscapeNight');
    var nightEffects = document.getElementById('vnNightEffects');
    var starsWrapper = document.getElementById('vnStarsWrapper');
    var shootingStar = document.getElementById('vnShootingStar');

    // 1. Hàm lấy giờ Việt Nam (UTC+7) chuẩn xác
    function getVietnamDecHour() {
        var now = new Date();
        var utcMs = now.getTime() + (now.getTimezoneOffset() * 60000);
        var vnDate = new Date(utcMs + (7 * 3600000));
        return vnDate.getHours() + (vnDate.getMinutes() / 60) + (vnDate.getSeconds() / 3600);
    }

    // 2. Tạo 45 ngôi sao lấp lánh ban đêm
    if (starsWrapper && starsWrapper.children.length === 0) {
        var frag = document.createDocumentFragment();
        for (var i = 0; i < 45; i++) {
            var s = document.createElement('div');
            s.className = 'vn-star';
            var sz = (Math.random() * 2 + 1.2).toFixed(1);
            s.style.width = sz + 'px';
            s.style.height = sz + 'px';
            s.style.left = (Math.random() * 96 + 2).toFixed(2) + '%';
            s.style.top = (Math.random() * 45 + 2).toFixed(2) + '%';
            s.style.animationDelay = (Math.random() * 4).toFixed(2) + 's';
            s.style.animationDuration = (Math.random() * 3 + 2.5).toFixed(2) + 's';
            frag.appendChild(s);
        }
        starsWrapper.appendChild(frag);
    }

    // 3. Sao băng tự động về đêm
    function launchShootingStar() {
        if (!shootingStar) return;
        var decH = getVietnamDecHour();
        if (decH >= 18.5 || decH <= 5.5) {
            shootingStar.style.top = (Math.random() * 30 + 5) + '%';
            shootingStar.style.left = (Math.random() * 60 + 5) + '%';
            shootingStar.classList.remove('active');
            void shootingStar.offsetWidth;
            shootingStar.classList.add('active');
        }
        var nextDelay = Math.random() * 9000 + 7000;
        setTimeout(launchShootingStar, nextDelay);
    }
    setTimeout(launchShootingStar, 3000);

    // Mốc chuẩn người dùng cung cấp: Lúc 20h24 (20.4h) tối tương đương giây thứ 13.0 trong video
    var REF_HOUR = 20.4;    // 20h24 tối
    var REF_SECOND = 13.0;  // Giây thứ 13.0 trong video

    // 4. Tính giây mục tiêu trong video (chu kỳ 24 giờ khớp chuẩn xác mốc 20h24 = 13s)
    function calculateTargetSecond(duration) {
        if (!duration || isNaN(duration)) duration = 60.0;
        var decH = getVietnamDecHour();
        var rate = duration / 24.0; // 2.5 giây cho mỗi 1 giờ thực tế
        var deltaH = decH - REF_HOUR;
        var targetSec = REF_SECOND + (deltaH * rate);
        targetSec = ((targetSec % duration) + duration) % duration;
        return targetSec;
    }

    // 5. Cập nhật trạng thái ngày/đêm & video
    function syncRealtimeState() {
        var decH = getVietnamDecHour();
        var isNight = (decH >= 18.5 || decH < 5.5);

        // Hiệu ứng đêm
        if (nightEffects) {
            nightEffects.style.opacity = isNight ? '1' : '0';
        }

        // Cập nhật fallback poster
        if (dayEl && nightEl) {
            if (decH >= 6.5 && decH < 17.5) {
                dayEl.style.opacity = '1';
                nightEl.style.opacity = '0';
            } else if (decH >= 17.5 && decH < 18.5) {
                var t = (decH - 17.5);
                dayEl.style.opacity = (1 - t).toFixed(2);
                nightEl.style.opacity = t.toFixed(2);
            } else if (isNight) {
                dayEl.style.opacity = '0';
                nightEl.style.opacity = '1';
            } else {
                var t2 = (decH - 5.5);
                dayEl.style.opacity = t2.toFixed(2);
                nightEl.style.opacity = (1 - t2).toFixed(2);
            }
        }

        // Đồng bộ vị trí video theo thời gian thực
        if (video && video.duration && !isNaN(video.duration)) {
            var targetSec = calculateTargetSecond(video.duration);
            // Nếu chênh lệch hơn 0.5s thì đồng bộ lại
            if (Math.abs(video.currentTime - targetSec) > 0.5) {
                video.currentTime = targetSec;
            }
        }
    }

    // 6. Xử lý video khi sẵn sàng
    if (video) {
        function onVideoReady() {
            video.classList.add('ready');
            syncRealtimeState();
        }

        video.addEventListener('loadedmetadata', function() {
            var targetSec = calculateTargetSecond(video.duration);
            video.currentTime = targetSec;
            onVideoReady();
        });

        video.addEventListener('canplay', function() {
            onVideoReady();
        });

        // Nếu video đã cached sẵn
        if (video.readyState >= 1) {
            onVideoReady();
        }
    }

    // Chạy đồng bộ ngay lập tức
    syncRealtimeState();

    // Tự động kiểm tra và đồng bộ liên tục mỗi 2 giây
    setInterval(syncRealtimeState, 2000);
})();
</script>
