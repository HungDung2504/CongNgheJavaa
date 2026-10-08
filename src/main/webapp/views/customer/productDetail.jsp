<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="vi_VN" scope="session"/>
<%@ include file="/includes/header.jsp" %>

<style>
    .detail-layout { display: flex; gap: 35px; }
    .detail-left { width: 42%; }
    .detail-right { width: 58%; }
    
    .bottom-layout { display: flex; gap: 30px; margin-top: 40px; border-top: 1px solid var(--border-color); padding-top: 30px; }
    .desc-section { width: 60%; }
    .specs-section { width: 40%; }
    
    /* Gallery */
    .main-img-box {
        text-align: center;
        border: 1px solid var(--border-color);
        padding: 20px;
        border-radius: 12px;
        position: relative;
        margin-bottom: 15px;
        background: #181818;
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 380px;
    }
    .main-img-box img {
        max-width: 100%;
        max-height: 420px;
        object-fit: contain;
        transition: transform 0.3s ease;
    }
    .gallery-thumb {
        width: 65px;
        height: 65px;
        object-fit: contain;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        cursor: pointer;
        margin: 5px;
        transition: 0.3s;
        background: #222;
        padding: 4px;
    }
    .gallery-thumb:hover, .gallery-thumb.active {
        border-color: var(--secondary);
        box-shadow: 0 0 10px rgba(212,175,55,0.3);
    }

    /* Option buttons */
    .option-group { margin-bottom: 20px; }
    .option-title {
        font-weight: 600;
        font-size: 0.82rem;
        margin-bottom: 10px;
        display: block;
        color: var(--text-gray);
        text-transform: uppercase;
        letter-spacing: 1.5px;
    }
    
    .btn-option {
        display: inline-block;
        border: 1px solid var(--border-color);
        background: rgba(255,255,255,0.03);
        padding: 10px 16px;
        margin-right: 10px;
        margin-bottom: 10px;
        border-radius: 8px;
        cursor: pointer;
        min-width: 75px;
        text-align: center;
        position: relative;
        transition: all 0.25s ease;
        font-size: 14px;
        color: var(--text-gray);
        user-select: none;
    }
    
    .btn-option:hover {
        border-color: var(--secondary);
        color: var(--secondary);
    }
    
    .btn-option.active {
        border: 1px solid var(--secondary);
        background: rgba(212, 175, 55, 0.12);
        color: var(--secondary);
        font-weight: bold;
    }
    
    .btn-option.active::after {
        content: '✔';
        position: absolute;
        top: 0; right: 0;
        background: var(--secondary);
        color: #0c0c0c;
        font-size: 10px;
        width: 16px; height: 16px;
        border-bottom-left-radius: 6px;
        border-top-right-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 900;
    }

    .btn-option.disabled {
        opacity: 0.35;
        background: rgba(255,255,255,0.02);
        cursor: not-allowed;
        border-color: var(--border-color);
        color: #555;
        pointer-events: none;
    }

    /* Qty input */
    input[type=number]::-webkit-inner-spin-button, 
    input[type=number]::-webkit-outer-spin-button { 
        -webkit-appearance: none; 
        margin: 0; 
    }

    @media (max-width: 992px) {
        .detail-layout, .bottom-layout { flex-direction: column; }
        .detail-left, .detail-right, .desc-section, .specs-section { width: 100%; }
    }
</style>

<div class="page-wrapper">
    <div class="container">
        <div class="nexora-card">
            <div class="detail-layout">
                <!-- LEFT: Hình ảnh sản phẩm -->
                <div class="detail-left">
                    <div class="main-img-box">
                        <c:set var="imgSrc" value="${fn:startsWith(product.image, 'http') ? product.image : pageContext.request.contextPath.concat('/assets/images/').concat(product.image)}"/>
                        <img id="main-img" src="${imgSrc}" alt="${product.productName}">
                        
                        <c:choose>
                            <c:when test="${product.status == 2 || (product.status != 3 && product.stock <= 0)}">
                                <span class="product-banner-tag banner-out-of-stock" style="top:12px; left:12px; font-size:0.78rem; padding:6px 14px;"><i class="fas fa-ban"></i> HẾT HÀNG</span>
                            </c:when>
                            <c:when test="${product.status == 3}">
                                <span class="product-banner-tag banner-pre-order" style="top:12px; left:12px; font-size:0.78rem; padding:6px 14px;"><i class="fas fa-clock"></i> TẠM HẾT, ĐẶT TRƯỚC</span>
                            </c:when>
                            <c:when test="${product.hot}">
                                <span style="position: absolute; top: 12px; left: 12px; background: var(--primary); color: white; padding: 4px 10px; border-radius: 4px; font-weight: bold; font-size: 0.72rem; letter-spacing: 1px;">HOT</span>
                            </c:when>
                        </c:choose>
                    </div>

                    <div style="display: flex; justify-content: center; flex-wrap: wrap;">
                        <img src="${imgSrc}" class="gallery-thumb active" onclick="changeImg(this)">
                    </div>
                </div>

                <!-- RIGHT: Chi tiết & Tùy chọn mua hàng -->
                <div class="detail-right">
                    <p style="color: var(--text-muted); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 8px;">
                        <c:choose>
                            <c:when test="${not empty product.catName}">${product.catName}</c:when>
                            <c:otherwise>NEXORA COLLECTION</c:otherwise>
                        </c:choose>
                    </p>
                    <h1 style="font-size: 1.7rem; margin-bottom: 15px; line-height: 1.3; font-weight: 700; font-family: 'Playfair Display', serif; color: var(--text-white);">
                        <c:out value="${product.productName}"/>
                    </h1>
                    
                    <div style="margin-bottom: 22px; display: flex; align-items: center; gap: 15px;">
                        <span id="display-price" style="color: var(--secondary); font-size: 2rem; font-weight: bold; font-family: 'Playfair Display', serif;">
                            <fmt:formatNumber value="${product.price}" pattern="#,###"/> &#8363;
                        </span>
                        <span style="font-size: 0.75rem; background: rgba(212,175,55,0.1); padding: 5px 12px; border-radius: 4px; color: var(--secondary); border: 1px solid var(--border-gold);">Trả góp 0%</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/cart" method="GET" id="add-to-cart-form">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="id" value="${product.productId}">
                        <input type="hidden" name="variant_id" id="input_variant_id" value="">
                        <input type="hidden" name="final_price" id="input_price" value="${product.price}">

                        <!-- CHỌN KÍCH CỠ -->
                        <div class="option-group" id="size-group">
                            <span class="option-title">Chọn Kích cỡ:</span>
                            <div id="version-list" style="display:flex; flex-wrap:wrap;"></div>
                        </div>

                        <!-- CHỌN MÀU SẮC -->
                        <div class="option-group" id="color-group">
                            <span class="option-title">Chọn màu sắc:</span>
                            <div id="color-list" style="display:flex; flex-wrap:wrap;"></div>
                        </div>

                        <!-- TỒN KHO -->
                        <div style="font-size: 0.85rem; margin-bottom: 18px;">
                            <strong id="stock-status" style="color: #51cf66;"></strong>
                        </div>

                        <!-- CHỌN SỐ LƯỢNG -->
                        <div class="option-group" style="margin-bottom: 22px;">
                            <span class="option-title">Số lượng:</span>
                            <div style="display: inline-flex; align-items: center; border: 1px solid var(--border-color); border-radius: 8px; overflow: hidden; background: rgba(255,255,255,0.03);">
                                <button type="button" onclick="adjustQty(-1)" style="padding: 10px 18px; background: transparent; border: none; color: #fff; cursor: pointer; font-size: 1.1rem; transition: background 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.1)'" onmouseout="this.style.background='transparent'">-</button>
                                <input type="number" id="input_qty" name="qty" value="1" min="1" max="99" style="width: 55px; text-align: center; background: transparent; border: none; color: #fff; font-weight: 600; font-size: 1rem; outline: none; -moz-appearance: textfield;">
                                <button type="button" onclick="adjustQty(1)" style="padding: 10px 18px; background: transparent; border: none; color: #fff; cursor: pointer; font-size: 1.1rem; transition: background 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.1)'" onmouseout="this.style.background='transparent'">+</button>
                            </div>
                        </div>

                        <!-- KHUYẾN MÃI NỔI BẬT -->
                        <div style="margin-bottom: 25px; border: 1px solid var(--border-gold); border-radius: 8px; overflow: hidden;">
                            <div style="background: rgba(212,175,55,0.1); padding: 10px 15px; font-weight: bold; color: var(--secondary); font-size: 0.9rem;">
                                <i class="fas fa-gift" style="margin-right: 6px;"></i> Khuyến mãi nổi bật
                            </div>
                            <div style="padding: 14px 16px; font-size: 0.85rem;">
                                <ul style="list-style: none; padding: 0; margin: 0;">
                                    <li style="margin-bottom: 8px; color: var(--text-gray);"><i class="fas fa-check-circle" style="color: #51cf66; margin-right: 8px;"></i>Giảm thêm 5% khi thanh toán chuyển khoản/VNPay.</li>
                                    <li style="margin-bottom: 8px; color: var(--text-gray);"><i class="fas fa-check-circle" style="color: #51cf66; margin-right: 8px;"></i>Miễn phí giao hàng nội thành toàn quốc cho đơn từ 500k.</li>
                                    <li style="color: var(--text-gray);"><i class="fas fa-check-circle" style="color: #51cf66; margin-right: 8px;"></i>Đổi trả miễn phí trong vòng 7 ngày & bảo hành chính hãng.</li>
                                </ul>
                            </div>
                        </div>

                        <!-- NÚT MUA VÀ THÊM VÀO GIỎ -->
                        <div style="display: flex; gap: 12px;">
                            <c:choose>
                                <c:when test="${product.status == 2 || (product.status != 3 && product.stock <= 0)}">
                                    <button type="button" disabled class="btn-nexora" style="flex:1; padding:14px; font-size:1rem; border-radius:8px; background:rgba(220,53,69,0.2); color:#ff6b6b; border:1px solid rgba(220,53,69,0.4); cursor:not-allowed; font-weight:700;">
                                        <i class="fas fa-ban" style="margin-right:8px;"></i> SẢN PHẨM HIỆN ĐÃ HẾT HÀNG
                                    </button>
                                </c:when>
                                <c:when test="${product.status == 3}">
                                    <button type="submit" name="type" value="buy" id="btn-buy" class="btn-nexora btn-nexora-gold" style="flex: 1; padding: 14px; font-size: 1rem; border-radius: 8px; text-transform: uppercase; background:linear-gradient(135deg, #f08c00, #D4AF37); color:#000; font-weight:800;">
                                        ĐẶT TRƯỚC NGAY <br> <span style="font-size: 0.72rem; font-weight: normal; opacity: 0.9; text-transform: none;">(Nhận hàng sớm nhất khi có đợt hàng mới)</span>
                                    </button>
                                    <button type="submit" name="type" value="add" id="btn-add" class="btn-nexora btn-nexora-outline" style="padding: 14px 24px; border-radius: 8px; font-size: 1.3rem; display: flex; align-items: center; justify-content: center;" title="Thêm vào danh sách đặt trước">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" name="type" value="buy" id="btn-buy" class="btn-nexora btn-nexora-gold" style="flex: 1; padding: 14px; font-size: 1rem; border-radius: 8px; text-transform: uppercase;">
                                        MUA NGAY <br> <span style="font-size: 0.72rem; font-weight: normal; opacity: 0.85; text-transform: none;">(Giao tận nơi hoặc lấy tại cửa hàng)</span>
                                    </button>
                                    
                                    <button type="submit" name="type" value="add" id="btn-add" class="btn-nexora btn-nexora-outline" style="padding: 14px 24px; border-radius: 8px; font-size: 1.3rem; display: flex; align-items: center; justify-content: center;" title="Thêm vào giỏ hàng">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Bottom: Đặc điểm nổi bật + Thông số kỹ thuật -->
            <div class="bottom-layout">
                <div class="desc-section">
                    <h3 style="border-left: 3px solid var(--secondary); padding-left: 12px; margin-bottom: 15px; text-transform: uppercase; font-size: 1rem; color: var(--secondary); font-family: 'Playfair Display', serif;">Đặc điểm nổi bật</h3>
                    <div style="line-height: 1.8; color: var(--text-gray); text-align: justify; font-size: 0.9rem;">
                        <c:choose>
                            <c:when test="${not empty product.productDesc}">
                                <c:out value="${product.productDesc}"/>
                            </c:when>
                            <c:otherwise>
                                Thiết kế hiện đại mang phong cách lịch lãm của thương hiệu Nexora. Sản phẩm được hoàn thiện tỉ mỉ từ những chất liệu cao cấp nhất, đem lại cảm giác thoải mái và tự tin cho quý ông thời thượng.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="specs-section">
                    <h3 style="font-size: 1rem; font-weight: bold; margin-bottom: 15px; color: var(--secondary); font-family: 'Playfair Display', serif; text-transform: uppercase;">Thông số kỹ thuật</h3>
                    
                    <div style="border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden;">
                        <table style="width: 100%; border-collapse: collapse; font-size: 0.85rem;">
                            <tr style="background-color: rgba(255,255,255,0.02); border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 12px 15px; width: 40%; color: var(--text-muted);">Chất liệu</td>
                                <td style="padding: 12px 15px; color: var(--text-white); font-weight: 500;">
                                    ${not empty product.material ? product.material : 'Cotton & Poly thượng hạng'}
                                </td>
                            </tr>
                            <tr style="background-color: transparent; border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 12px 15px; width: 40%; color: var(--text-muted);">Kiểu dáng</td>
                                <td style="padding: 12px 15px; color: var(--text-white); font-weight: 500;">
                                    ${not empty product.style ? product.style : 'Slim Fit / Regular'}
                                </td>
                            </tr>
                            <tr style="background-color: rgba(255,255,255,0.02); border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 12px 15px; width: 40%; color: var(--text-muted);">Xuất xứ</td>
                                <td style="padding: 12px 15px; color: var(--text-white); font-weight: 500;">
                                    ${not empty product.origin ? product.origin : 'Chính hãng Nexora'}
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Reviews -->
            <div id="reviews" style="margin-top: 40px; padding-top: 25px; border-top: 1px solid var(--border-color);">
                <h3 style="margin-bottom: 20px; font-size: 1rem; color: var(--secondary); font-family: 'Playfair Display', serif; text-transform: uppercase;">
                    <i class="fas fa-star" style="margin-right: 8px;"></i> Đánh giá sản phẩm
                </h3>

                <c:choose>
                    <c:when test="${not empty sessionScope.user_id}">
                        <div style="background: rgba(255,255,255,0.02); padding: 20px; border-radius: 8px; margin-bottom: 30px; border: 1px solid var(--border-color);">
                            <h4 style="font-size: 0.9rem; margin-bottom: 12px; color: var(--text-gray);">Gửi đánh giá của bạn</h4>
                            <form action="${pageContext.request.contextPath}/product" method="POST" class="nexora-form">
                                <input type="hidden" name="product_id" value="${product.productId}">
                                <div style="margin-bottom: 12px;">
                                    <label style="font-size: 0.78rem; color: var(--text-gray); text-transform: uppercase; letter-spacing: 1.5px;">Số sao:</label>
                                    <select name="star" style="display:block; margin-top:8px; padding:8px 12px; background:rgba(255,255,255,0.05); border:1px solid var(--border-color); border-radius:6px; color:#E8E8E8; outline:none;">
                                        <option value="5">&#9733;&#9733;&#9733;&#9733;&#9733; (5 sao - Tuyệt vời)</option>
                                        <option value="4">&#9733;&#9733;&#9733;&#9733; (4 sao - Tốt)</option>
                                        <option value="3">&#9733;&#9733;&#9733; (3 sao - Bình thường)</option>
                                        <option value="2">&#9733;&#9733; (2 sao - Tạm)</option>
                                        <option value="1">&#9733; (1 sao - Kém)</option>
                                    </select>
                                </div>
                                <div class="form-group" style="margin-bottom: 12px;">
                                    <textarea name="content" required placeholder="Nhập cảm nhận của bạn về sản phẩm..." style="height: 80px; width: 100%; border-radius: 6px; padding: 10px; background: rgba(255,255,255,0.05); border: 1px solid var(--border-color); color: #fff;"></textarea>
                                </div>
                                <button type="submit" class="btn-nexora btn-nexora-gold" style="padding: 8px 24px; font-size: 0.85rem;">
                                    Gửi đánh giá
                                </button>
                            </form>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="margin-bottom: 30px; color: var(--text-gray);">
                            <a href="${pageContext.request.contextPath}/login" style="color: var(--secondary); font-weight: bold;">Đăng nhập</a> để viết đánh giá.
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${not empty reviews}">
                        <c:forEach var="r" items="${reviews}">
                            <div style="border-bottom: 1px solid var(--border-color); padding: 15px 0;">
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="font-weight: bold; color: var(--text-white); font-size: 0.9rem;">
                                        <i class="fas fa-user-circle" style="color: var(--secondary); margin-right: 5px;"></i>
                                        <c:out value="${r.fullname}"/>
                                    </span>
                                </div>
                                <div style="color: #D4AF37; font-size: 0.8rem; margin: 5px 0;">
                                    <c:forEach begin="1" end="${r.star}">&#9733;</c:forEach>
                                </div>
                                <p style="color: var(--text-gray); margin: 0; font-size: 0.9rem;"><c:out value="${r.content}"/></p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; color: var(--text-muted); padding: 20px;">Chưa có đánh giá nào cho sản phẩm này.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    // Danh sách variants từ server
    const variants = [
        <c:forEach var="v" items="${variants}" varStatus="st">
        {
            variant_id: ${v.variantId},
            product_id: ${v.productId},
            size: '${v.size}',
            color: '${v.color}',
            price: ${v.price},
            stock: ${v.stock}
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    function changeImg(el) {
        document.getElementById('main-img').src = el.src;
        document.querySelectorAll('.gallery-thumb').forEach(i => i.classList.remove('active'));
        el.classList.add('active');
    }

    function adjustQty(delta) {
        const input = document.getElementById('input_qty');
        let current = parseInt(input.value) || 1;
        let max = parseInt(input.max) || 99;
        let newVal = current + delta;
        if (newVal >= 1 && newVal <= max) {
            input.value = newVal;
        }
    }

    // Logic lựa chọn Size và Màu sắc
    if (variants.length > 0) {
        const groups = {};
        
        variants.forEach(v => {
            let label = "Size " + v.size;
            if (!groups[label]) groups[label] = [];
            groups[label].push(v);
        });

        const versionContainer = document.getElementById('version-list');
        let firstGroup = true;

        for (const [verLabel, items] of Object.entries(groups)) {
            let btn = document.createElement('div');
            btn.className = 'btn-option';
            btn.innerText = verLabel;
            
            btn.onclick = function() {
                document.querySelectorAll('#version-list .btn-option').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                renderColors(items);
            };
            
            versionContainer.appendChild(btn);

            if (firstGroup) {
                btn.click();
                firstGroup = false;
            }
        }
    } else {
        // Trường hợp không có variants trong DB
        document.getElementById('size-group').style.display = 'none';
        document.getElementById('color-group').style.display = 'none';
        document.getElementById('stock-status').innerText = "✔ Còn ${product.stock} sản phẩm (Sẵn sàng giao ngay)";
        document.getElementById('input_price').value = "${product.price}";
    }

    function renderColors(items) {
        const colorContainer = document.getElementById('color-list');
        colorContainer.innerHTML = '';
        
        let firstColor = true;

        items.forEach(v => {
            let btn = document.createElement('div');
            btn.className = 'btn-option';
            btn.innerHTML = "<div>" + v.color + "</div><div style='font-size:11px; color:#aaa; margin-top:2px;'>" + new Intl.NumberFormat('vi-VN').format(v.price) + " ₫</div>";
            
            if (v.stock <= 0) {
                btn.classList.add('disabled');
                btn.title = 'Tạm hết hàng';
            } else {
                btn.onclick = function() {
                    document.querySelectorAll('#color-list .btn-option').forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                    updateInfo(v);
                };
            }
            
            colorContainer.appendChild(btn);

            if (firstColor && v.stock > 0) {
                btn.click();
                firstColor = false;
            }
        });
    }

    function updateInfo(variant) {
        document.getElementById('display-price').innerText = new Intl.NumberFormat('vi-VN').format(variant.price) + ' ₫';
        document.getElementById('stock-status').innerText = "✔ Còn " + variant.stock + " sản phẩm (Sẵn sàng giao ngay)";
        document.getElementById('input_variant_id').value = variant.variant_id;
        document.getElementById('input_price').value = variant.price;

        const qtyInput = document.getElementById('input_qty');
        qtyInput.max = variant.stock;
        if (parseInt(qtyInput.value) > variant.stock) {
            qtyInput.value = Math.max(1, variant.stock);
        }

        const btnBuy = document.getElementById('btn-buy');
        const btnAdd = document.getElementById('btn-add');
        if (btnBuy) btnBuy.disabled = false;
        if (btnAdd) btnAdd.disabled = false;
    }
</script>

<%@ include file="/includes/footer.jsp" %>
