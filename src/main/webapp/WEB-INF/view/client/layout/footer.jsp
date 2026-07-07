<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!-- Footer Start -->
<div class="container-fluid bg-dark text-white-50 footer pt-5 mt-5">
    <div class="container py-5">
        <div class="pb-4 mb-4" style="border-bottom: 1px solid rgba(226, 175, 24, 0.5) ;">
            <div class="row g-4">
                <div class="col-lg-3">
                    <a href="#">
                        <h1 class="text-primary mb-0">LaptopShop</h1>
                        <p class="text-secondary mb-0">Hàng xịn giá tốt</p>
                    </a>
                </div>
                <div class="col-lg-6">
                    <div class="position-relative mx-auto">
                        <input class="form-control border-0 w-100 py-3 px-4 rounded-pill" type="email"
                            placeholder="Nhập email để nhận ưu đãi">
                        <button type="submit"
                            class="btn btn-primary border-0 border-secondary py-3 px-4 position-absolute rounded-pill text-white"
                            style="top: 0; right: 0;">Đăng ký</button>
                    </div>
                </div>
                <div class="col-lg-3">
                    <div class="d-flex justify-content-end pt-3">
                        <a class="btn  btn-outline-secondary me-2 btn-md-square rounded-circle" href=""><i
                                class="fab fa-twitter"></i></a>
                        <a class="btn btn-outline-secondary me-2 btn-md-square rounded-circle" href=""><i
                                class="fab fa-facebook-f"></i></a>
                        <a class="btn btn-outline-secondary me-2 btn-md-square rounded-circle" href=""><i
                                class="fab fa-youtube"></i></a>
                        <a class="btn btn-outline-secondary btn-md-square rounded-circle" href=""><i
                                class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
            </div>
        </div>
        <div class="row g-5">
            <div class="col-lg-3 col-md-6">
                <div class="footer-item">
                    <h4 class="text-light mb-3">Vì sao chọn LaptopShop?</h4>
                    <p class="mb-4">Tư vấn đúng nhu cầu, sản phẩm rõ cấu hình, hỗ trợ bảo hành, đổi trả và theo dõi đơn hàng ngay trên website.</p>
                    <a href="/shop" class="btn border-secondary py-2 px-4 rounded-pill text-primary">Xem cửa hàng</a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="d-flex flex-column text-start footer-item">
                    <h4 class="text-light mb-3">Thông tin cửa hàng</h4>
                    <a class="btn-link" href="/contact">Về LaptopShop</a>
                    <a class="btn-link" href="/contact">Liên hệ</a>
                    <a class="btn-link" href="">Chính sách bảo mật</a>
                    <a class="btn-link" href="">Điều khoản sử dụng</a>
                    <a class="btn-link" href="">Chính sách đổi trả</a>
                    <a class="btn-link" href="/contact">Hỗ trợ khách hàng</a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="d-flex flex-column text-start footer-item">
                    <h4 class="text-light mb-3">Tài khoản</h4>
                    <a class="btn-link" href="/account">Tài khoản của tôi</a>
                    <a class="btn-link" href="/shop">Cửa hàng</a>
                    <a class="btn-link" href="/cart">Giỏ hàng</a>
                    <a class="btn-link" href="/wishlist">Yêu thích</a>
                    <a class="btn-link" href="/order-history">Lịch sử đơn hàng</a>
                    <a class="btn-link" href="/laptop-finder">Tư vấn AI</a>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="footer-item">
                    <h4 class="text-light mb-3">Liên hệ</h4>
                    <p>Địa chỉ: Cầu Giấy, Hà Nội, Việt Nam</p>
                    <p>Email: mynametobiii@gmail.com</p>
                    <p>Số điện thoại: (+84) 325 327 602</p>
                    <p>Hỗ trợ thanh toán</p>
                    <img src="/products/payment.png" class="img-fluid" alt="">
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Footer End -->

<!-- Copyright Start -->
<div class="container-fluid copyright bg-dark py-4">
    <div class="container">
        <div class="row">
            <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                <span class="text-light"><a href="#"><i class="fas fa-copyright text-light me-2"></i>
                        LaptopShop</a>, đã đăng ký bản quyền.</span>
            </div>
            <div class="col-md-6 my-auto text-center text-md-end text-white">
                <!--/*** This template is free as long as you keep the below author’s credit link/attribution link/backlink. ***/-->
                <!--/*** If you'd like to use the template without the below author’s credit link/attribution link/backlink, ***/-->
                <!--/*** you can purchase the Credit Removal License from "https://htmlcodex.com/credit-removal". ***/-->
                Thiết kế bởi <a class="border-bottom">NguyenThanhLong</a>
            </div>
        </div>
    </div>
</div>
<!-- Copyright End -->

<!-- AI Chat Bubble Start -->
<style>
    .ai-chat-widget {
        position: fixed;
        right: 24px;
        bottom: 24px;
        z-index: 1050;
        font-family: "Open Sans", "Segoe UI", Arial, sans-serif;
        font-weight: 400;
        letter-spacing: 0;
        -webkit-font-smoothing: antialiased;
        text-rendering: geometricPrecision;
    }

    .ai-chat-widget *:not(i),
    .ai-chat-widget *:not(i)::before,
    .ai-chat-widget *:not(i)::after {
        letter-spacing: 0;
        font-family: inherit;
    }

    .ai-chat-widget i,
    .ai-chat-widget .fa,
    .ai-chat-widget .fas,
    .ai-chat-widget .far,
    .ai-chat-widget .fab {
        font-family: "Font Awesome 5 Free" !important;
        font-weight: 900;
    }

    .ai-chat-toggle {
        width: 62px;
        height: 62px;
        border: 0;
        border-radius: 50%;
        background: #81c408;
        color: #ffffff;
        box-shadow: 0 14px 28px rgba(0, 0, 0, 0.24);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .ai-chat-toggle:hover {
        transform: translateY(-2px);
        box-shadow: 0 18px 32px rgba(0, 0, 0, 0.28);
    }

    .ai-chat-panel {
        position: absolute;
        right: 0;
        bottom: 76px;
        width: min(360px, calc(100vw - 32px));
        height: 500px;
        max-height: calc(100vh - 120px);
        background: #ffffff;
        border-radius: 14px;
        overflow: hidden;
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25);
        display: none;
        border: 1px solid rgba(0, 0, 0, 0.08);
    }

    .ai-chat-widget.open .ai-chat-panel {
        display: flex;
        flex-direction: column;
    }

    .ai-chat-header {
        background: #81c408;
        color: #ffffff;
        padding: 14px 16px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
    }

    .ai-chat-title {
        font-weight: 700;
        line-height: 1.2;
    }

    .ai-chat-subtitle {
        font-size: 12px;
        opacity: 0.9;
    }

    .ai-chat-close {
        border: 0;
        background: transparent;
        color: #ffffff;
        font-size: 20px;
        line-height: 1;
    }

    .ai-chat-mode-switch {
        display: flex;
        gap: 8px;
        padding: 10px 12px;
        background: #ffffff;
        border-bottom: 1px solid #eeeeee;
    }

    .ai-chat-mode-btn {
        flex: 1;
        border: 1px solid rgba(129, 196, 8, 0.35);
        border-radius: 999px;
        background: #ffffff;
        color: #4d7c0f;
        font-size: 12px;
        font-weight: 900;
        padding: 8px 10px;
    }

    .ai-chat-mode-btn.active {
        background: #81c408;
        color: #ffffff;
    }

    .ai-chat-mode-btn:disabled {
        cursor: not-allowed;
        opacity: 0.55;
        background: #f1f5f9;
        color: #64748b;
    }

    .ai-chat-messages {
        flex: 1;
        overflow-y: auto;
        padding: 16px;
        background: #f7f8f3;
    }

    .ai-chat-message {
        margin-bottom: 12px;
        display: flex;
    }

    .ai-chat-message.user {
        justify-content: flex-end;
    }

    .ai-chat-bubble {
        max-width: 84%;
        padding: 10px 12px;
        border-radius: 14px;
        font-size: 14px;
        line-height: 1.45;
        font-weight: 400;
        color: #303030;
        background: #ffffff;
        border: 1px solid #ececec;
    }

    .ai-chat-message.user .ai-chat-bubble {
        background: #81c408;
        border-color: #81c408;
        color: #ffffff;
        border-bottom-right-radius: 4px;
    }

    .ai-chat-message.bot .ai-chat-bubble {
        border-bottom-left-radius: 4px;
    }

    .ai-chat-receipt {
        margin-top: 6px;
        font-size: 11px;
        opacity: 0.75;
        text-align: right;
    }

    .ai-chat-form {
        padding: 12px;
        border-top: 1px solid #eeeeee;
        background: #ffffff;
    }

    .ai-chat-suggestions {
        display: flex;
        gap: 8px;
        overflow-x: auto;
        padding: 10px 12px 0;
        background: #ffffff;
        border-top: 1px solid #eeeeee;
        scrollbar-width: thin;
    }

    .ai-chat-suggestion {
        flex: 0 0 auto;
        border: 1px solid rgba(129, 196, 8, 0.35);
        border-radius: 999px;
        background: #f8fff0;
        color: #4d7c0f;
        font-size: 12px;
        font-weight: 800;
        line-height: 1;
        padding: 9px 12px;
        white-space: nowrap;
        transition: background 0.16s ease, color 0.16s ease, transform 0.16s ease;
    }

    .ai-chat-suggestion.ai-chat-action {
        background: #ecfeff;
        color: #0f766e;
        border-color: rgba(15, 118, 110, 0.32);
    }

    .ai-chat-suggestion:hover {
        background: #81c408;
        color: #ffffff;
        transform: translateY(-1px);
    }

    .ai-chat-service-panel {
        display: none;
        border-top: 1px solid #eeeeee;
        background: #ffffff;
        padding: 10px 12px;
        max-height: 230px;
        overflow-y: auto;
    }

    .ai-chat-service-panel.open {
        display: block;
    }

    .ai-chat-order-card {
        border: 1px solid #dbeafe;
        border-radius: 12px;
        padding: 10px;
        margin-bottom: 8px;
        background: #f8fafc;
        font-size: 13px;
    }

    .ai-chat-order-card strong {
        color: #0f766e;
    }

    .ai-chat-order-actions {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;
        margin-top: 8px;
    }

    .ai-chat-mini-btn {
        border: 1px solid #0f766e;
        border-radius: 999px;
        background: #ffffff;
        color: #0f766e;
        font-size: 12px;
        font-weight: 800;
        padding: 6px 9px;
    }

    .ai-chat-inline-form {
        display: none;
        gap: 6px;
        margin-top: 8px;
    }

    .ai-chat-inline-form.open {
        display: block;
    }

    .ai-chat-inline-form textarea,
    .ai-chat-inline-form select {
        font-size: 12px;
        border-radius: 10px;
        margin-bottom: 6px;
    }

    .ai-chat-input {
        resize: none;
        min-height: 52px;
        max-height: 110px;
        font-size: 14px;
        font-weight: 400;
        line-height: 1.45;
    }

    @media (max-width: 575.98px) {
        .ai-chat-widget {
            right: 16px;
            bottom: 16px;
        }

        .ai-chat-panel {
            width: calc(100vw - 32px);
            height: 460px;
        }
    }
</style>

<div class="ai-chat-widget" id="aiChatWidget"
    data-csrf-name="${_csrf.parameterName}"
    data-csrf-token="${_csrf.token}"
    data-authenticated="${not empty pageContext.request.userPrincipal}">
    <div class="ai-chat-panel" aria-live="polite">
        <div class="ai-chat-header">
            <div>
                <div class="ai-chat-title">AI tư vấn laptop</div>
                <div class="ai-chat-subtitle">Hỏi nhanh về cấu hình, ngân sách, nhu cầu</div>
            </div>
            <button class="ai-chat-close" type="button" id="aiChatClose" aria-label="Đóng chat">&times;</button>
        </div>
        <div class="ai-chat-mode-switch">
            <button class="ai-chat-mode-btn active" type="button" data-chat-mode="ai">AI tư vấn</button>
            <button class="ai-chat-mode-btn" type="button" data-chat-mode="admin">Chat admin</button>
        </div>
        <div class="ai-chat-messages" id="aiChatMessages">
            <div class="ai-chat-message bot">
                <div class="ai-chat-bubble">
                    Chào bạn, mình có thể tư vấn laptop theo ngân sách, học tập, lập trình, đồ họa hoặc gaming.
                </div>
            </div>
        </div>
        <div class="ai-chat-suggestions" aria-label="Gợi ý câu hỏi nhanh">
            <button class="ai-chat-suggestion ai-chat-action" type="button" data-action="orders">
                Theo dõi đơn
            </button>
            <button class="ai-chat-suggestion ai-chat-action" type="button" data-action="returns">
                Đổi trả
            </button>
            <button class="ai-chat-suggestion ai-chat-action" type="button" data-action="warranty">
                Bảo hành
            </button>
            <button class="ai-chat-suggestion" type="button"
                data-prompt="Shop gợi ý cho mình laptop giá tốt nhất hiện tại với.">
                Giá tốt nhất
            </button>
            <button class="ai-chat-suggestion" type="button"
                data-prompt="Shop có những laptop nào đang bán chạy nhất?">
                Hàng bán chạy
            </button>
            <button class="ai-chat-suggestion" type="button"
                data-prompt="Mình cần laptop tầm 20 đến 30 triệu, shop tư vấn giúp mình mẫu phù hợp.">
                Tầm 20-30tr
            </button>
            <button class="ai-chat-suggestion" type="button"
                data-prompt="Mình cần laptop để học tập và lập trình, shop gợi ý giúp mình.">
                Học lập trình
            </button>
            <button class="ai-chat-suggestion" type="button"
                data-prompt="Mình cần laptop gaming cấu hình tốt, shop tư vấn mẫu phù hợp.">
                Gaming
            </button>
            <button class="ai-chat-suggestion" type="button"
                data-prompt="Sản phẩm bên shop bảo hành và đổi trả như thế nào?">
                Bảo hành đổi trả
            </button>
        </div>
        <div class="ai-chat-service-panel" id="aiChatServicePanel"></div>
        <form class="ai-chat-form" id="aiChatForm">
            <div class="input-group">
                <textarea class="form-control ai-chat-input" id="aiChatInput"
                    placeholder="Nhập nhu cầu của bạn..." required></textarea>
                <button class="btn btn-primary" type="submit">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </form>
    </div>
    <button class="ai-chat-toggle" type="button" id="aiChatToggle" aria-label="Mở chat AI">
        <i class="fas fa-comments"></i>
    </button>
</div>

<script src="/js/ai-chat-widget.js"></script>
<!-- AI Chat Bubble End -->
