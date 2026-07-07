<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Tin nhắn - LaptopShop Admin</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        .admin-chat-page {
            height: calc(100vh - 72px);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            padding-top: 0 !important;
            padding-bottom: 8px;
        }

        .admin-chat-page > h1 {
            flex: 0 0 auto;
            margin-top: 8px !important;
            margin-bottom: 6px !important;
            font-size: clamp(2rem, 2.8vw, 3rem) !important;
        }

        .admin-chat-page .breadcrumb {
            flex: 0 0 auto;
            min-height: 46px;
            padding: 10px 16px;
            margin-bottom: 10px !important;
        }

        .messenger-shell {
            flex: 1 1 auto;
            min-height: 0;
            height: auto;
            display: grid;
            grid-template-columns: minmax(280px, 360px) minmax(0, 1fr);
            border: 1px solid rgba(148, 163, 184, 0.22);
            border-radius: 24px;
            overflow: hidden;
            background:
                linear-gradient(rgba(255, 255, 255, 0.96), rgba(255, 255, 255, 0.96)) padding-box,
                linear-gradient(135deg, rgba(37, 99, 235, 0.28), rgba(6, 182, 212, 0.2), rgba(244, 114, 182, 0.2)) border-box;
            box-shadow: 0 28px 80px rgba(15, 23, 42, 0.12);
        }

        .conversation-list {
            min-height: 0;
            border-right: 1px solid #e2e8f0;
            background: linear-gradient(180deg, #f8fbff, #ffffff);
            overflow-y: auto;
            scrollbar-width: thin;
        }

        .conversation-item {
            display: block;
            padding: 18px 20px;
            color: #0f172a;
            text-decoration: none;
            border-bottom: 1px solid #e2e8f0;
            transition: background-color 0.16s ease, color 0.16s ease, transform 0.16s ease;
        }

        .conversation-item:hover,
        .conversation-item.active {
            background: linear-gradient(135deg, #eff6ff, #eef2ff);
            color: #2563eb;
            transform: translateX(2px);
        }

        .conversation-name {
            font-weight: 700;
            margin-bottom: 4px;
        }

        .conversation-meta,
        .conversation-preview {
            font-size: 13px;
            color: #6c757d;
        }

        .chat-pane {
            display: flex;
            min-width: 0;
            min-height: 0;
            flex-direction: column;
            background:
                radial-gradient(circle at 10% 0%, rgba(37, 99, 235, 0.10), transparent 28%),
                radial-gradient(circle at 96% 8%, rgba(244, 114, 182, 0.10), transparent 24%),
                linear-gradient(180deg, #f8fafc 0%, #edf2f7 100%);
        }

        .chat-header {
            flex: 0 0 auto;
            padding: 18px 24px;
            background: rgba(255, 255, 255, 0.92);
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            gap: 16px;
            align-items: center;
            backdrop-filter: blur(14px);
        }

        .chat-body {
            flex: 1;
            min-height: 0;
            padding: 24px 28px;
            overflow-y: auto;
            scrollbar-width: thin;
        }

        .chat-row {
            display: flex;
            margin-bottom: 12px;
        }

        .chat-row.customer,
        .chat-row.ai {
            justify-content: flex-start;
        }

        .chat-row.admin {
            justify-content: flex-end;
        }

        .chat-bubble {
            max-width: min(72%, 720px);
            padding: 14px 16px;
            border-radius: 20px;
            background: #fff;
            border: 1px solid #e5e7eb;
            line-height: 1.45;
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.08);
            word-break: break-word;
        }

        .chat-row.admin .chat-bubble {
            background: linear-gradient(135deg, #2563eb, #06b6d4);
            border-color: transparent;
            color: #fff;
            border-bottom-right-radius: 8px;
        }

        .chat-row.customer .chat-bubble {
            border-bottom-left-radius: 8px;
        }

        .chat-row.ai .chat-bubble {
            background: #ecfdf3;
            border-color: #badbcc;
            border-bottom-left-radius: 8px;
        }

        .chat-sender {
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 4px;
            opacity: 0.8;
        }

        .chat-time {
            font-size: 11px;
            margin-top: 6px;
            opacity: 0.7;
        }

        .chat-reply {
            flex: 0 0 auto;
            background: rgba(255, 255, 255, 0.94);
            border-top: 1px solid #e2e8f0;
            padding: 16px 20px;
            backdrop-filter: blur(14px);
        }

        .chat-reply .input-group {
            border: 1px solid #dbeafe;
            border-radius: 24px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 18px 38px rgba(15, 23, 42, 0.08);
            flex: 0 0 auto;
        }

        .chat-reply textarea {
            resize: none;
            min-height: 58px;
            max-height: 118px;
            border: 0;
            box-shadow: none !important;
            padding: 16px 18px;
        }

        .chat-reply .btn {
            border-radius: 0 !important;
            min-width: 132px;
        }

        .admin-ai-tools {
            flex: 0 0 auto;
            background: rgba(255, 255, 255, 0.96);
            border-bottom: 1px solid #e2e8f0;
            padding: 14px 18px;
            max-height: min(320px, 42vh);
            overflow-y: auto;
            overflow-x: hidden;
        }

        .admin-ai-tools.is-hidden {
            display: none;
        }

        .chat-header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .admin-ai-tools-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 12px;
        }

        .quick-reply-box {
            border: 1px solid #dbeafe;
            background: linear-gradient(135deg, #eff6ff, #f8fafc);
            border-radius: 18px;
            padding: 12px 14px;
        }

        .preset-replies {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }

        .preset-reply-btn {
            border: 1px solid #c7d2fe;
            border-radius: 999px;
            background: #ffffff;
            color: #1d4ed8;
            font-size: 0.82rem;
            font-weight: 800;
            padding: 7px 11px;
            transition: background 0.15s ease, border-color 0.15s ease, transform 0.15s ease;
        }

        .preset-reply-btn:hover {
            background: #e0e7ff;
            border-color: #818cf8;
            transform: translateY(-1px);
        }

        .suggested-products {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
            margin-top: 12px;
        }

        .suggested-product {
            border: 1px solid #e5e7eb;
            border-radius: 18px;
            padding: 12px;
            background: #f8fafc;
        }

        .suggested-product img {
            width: 100%;
            height: 86px;
            object-fit: contain;
            border-radius: 10px;
            background: #fff;
            margin-bottom: 8px;
        }

        .suggested-product-name {
            color: #111827;
            font-weight: 800;
            font-size: 0.9rem;
            min-height: 38px;
        }

        @media (max-width: 1199.98px) {
            .suggested-products {
                grid-template-columns: 1fr;
            }
        }

        .empty-chat {
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            text-align: center;
            padding: 24px;
        }

        .chat-header h5 {
            font-weight: 950;
            color: #0f172a;
        }

        #activeConversationLabel {
            display: inline-block;
            max-width: 280px;
            overflow: hidden;
            text-overflow: ellipsis;
            vertical-align: bottom;
            white-space: nowrap;
        }

        @media (max-width: 991.98px) {
            .admin-chat-page {
                height: auto;
                min-height: calc(100vh - 88px);
                overflow: visible;
            }

            .messenger-shell {
                grid-template-columns: 1fr;
                min-height: 760px;
            }

            .conversation-list {
                max-height: 280px;
                border-right: 0;
                border-bottom: 1px solid #dee2e6;
            }

            .chat-pane {
                min-height: 520px;
            }

            .chat-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .chat-header-actions {
                width: 100%;
                justify-content: flex-start;
            }

            .chat-bubble {
                max-width: 88%;
            }
        }

        @media (max-width: 575.98px) {
            .chat-body {
                padding: 18px;
            }

            .chat-reply {
                padding: 12px;
            }

            .chat-reply .input-group {
                border-radius: 18px;
            }

            .chat-reply .btn {
                min-width: 86px;
            }
        }
    </style>
</head>

<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4 admin-chat-page">
                    <h1 class="mt-3">Tin nhắn</h1>
                    <ol class="breadcrumb mb-3">
                        <li class="breadcrumb-item active">Trả lời khách hàng đang hội thoại trực tiếp với admin</li>
                    </ol>

                    <div class="messenger-shell">
                        <aside class="conversation-list" id="adminConversationList">
                            <c:choose>
                                <c:when test="${empty conversations}">
                                    <div class="p-4 text-muted">Chưa có cuộc trò chuyện nào.</div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${conversations}" var="conversation">
                                        <a class="conversation-item ${conversation.conversationKey eq activeConversationKey ? 'active' : ''}"
                                            data-conversation-key="${conversation.conversationKey}"
                                            href="/admin/ai-messages?conversationKey=${conversation.conversationKey}">
                                            <div class="conversation-name">
                                                <c:out value="${conversation.customerName}" />
                                            </div>
                                            <div class="conversation-meta">
                                                <c:out value="${conversation.customerEmail}" />
                                            </div>
                                            <div class="conversation-preview mt-2">
                                                <c:choose>
                                                    <c:when test="${not empty conversation.content}">
                                                        <c:out value="${conversation.content}" />
                                                    </c:when>
                                                    <c:when test="${not empty conversation.question}">
                                                        <c:out value="${conversation.question}" />
                                                    </c:when>
                                                    <c:when test="${not empty conversation.aiAnswer}">
                                                        <c:out value="${conversation.aiAnswer}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:out value="${conversation.adminReply}" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </aside>

                        <section class="chat-pane">
                            <c:choose>
                                <c:when test="${empty activeConversation}">
                                    <div class="empty-chat">
                                        <div>
                                            <h4>Chọn một cuộc trò chuyện</h4>
                                            <p class="mb-0">Tin nhắn của khách sẽ hiển thị ở đây.</p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="chat-header">
                                        <div>
                                            <h5 class="mb-1" id="activeCustomerName"><c:out value="${activeConversation.customerName}" /></h5>
                                            <div class="text-muted small">
                                                <span id="activeCustomerEmail"><c:out value="${activeConversation.customerEmail}" /></span>
                                                <span class="mx-1">-</span>
                                                <span id="activeConversationLabel"><c:out value="${activeConversation.conversationKey}" /></span>
                                            </div>
                                        </div>
                                        <div class="chat-header-actions">
                                            <button class="btn btn-outline-primary btn-sm" type="button" id="showAiTools">
                                                <i class="fas fa-wand-magic-sparkles me-1"></i>Hiện gợi ý
                                            </button>
                                            <span class="badge bg-primary">Chat 1-1</span>
                                        </div>
                                    </div>
                                    <div class="admin-ai-tools is-hidden" id="adminAiTools">
                                        <div class="admin-ai-tools-header">
                                            <div class="small" id="conversationSummaryText"><strong>AI tóm tắt:</strong> <c:out value="${conversationSummary}" /></div>
                                            <button class="btn btn-light btn-sm text-muted" type="button" id="hideAiTools">
                                                <i class="fas fa-eye-slash me-1"></i>Ẩn gợi ý
                                            </button>
                                        </div>
                                        <div class="quick-reply-box mt-2">
                                            <div class="small text-primary" id="suggestedReplyText"><strong>Gợi ý trả lời:</strong> <c:out value="${suggestedReply}" /></div>
                                            <button class="btn btn-outline-primary btn-sm mt-2" type="button" id="useSuggestedReply">
                                                Dùng gợi ý này
                                            </button>
                                        </div>
                                        <div class="quick-reply-box mt-2">
                                            <div class="small fw-bold text-primary mb-2">Câu trả lời nhanh có sẵn</div>
                                            <div class="preset-replies">
                                                <button class="preset-reply-btn" type="button"
                                                    data-template="Bên shop sẽ kiểm tra mẫu laptop có giá tốt nhất theo ngân sách của bạn và gợi ý sản phẩm phù hợp nhất trong kho.">
                                                    Giá tốt nhất
                                                </button>
                                                <button class="preset-reply-btn" type="button"
                                                    data-template="Hiện shop có một số mẫu bán chạy được khách chọn nhiều vì cấu hình ổn, giá hợp lý và còn hàng sẵn. Mình sẽ gửi bạn mẫu phù hợp nhất với nhu cầu.">
                                                    Hàng bán chạy
                                                </button>
                                                <button class="preset-reply-btn" type="button"
                                                    data-template="Bạn cho shop biết ngân sách dự kiến và nhu cầu chính như học tập, lập trình, đồ họa hay gaming để shop lọc đúng mẫu laptop hơn nhé.">
                                                    Hỏi nhu cầu
                                                </button>
                                                <button class="preset-reply-btn" type="button"
                                                    data-template="Shop se kiem tra ton kho mau ban quan tam. Neu con hang, shop co the ho tro dat hang va giao hang theo dia chi cua ban.">
                                                    Còn hàng không
                                                </button>
                                                <button class="preset-reply-btn" type="button"
                                                    data-template="Sản phẩm ben shop co ho tro bao hanh dien tu. Neu may phat sinh loi trong thoi gian bao hanh, ban co the gui yeu cau bao hanh tren website.">
                                                    Bảo hành
                                                </button>
                                                <button class="preset-reply-btn" type="button"
                                                    data-template="Shop hỗ trợ thanh toán khi nhận hàng COD và thanh toán QR. Với QR, sau khi chuyển khoản bạn bấm Đã thanh toán QR để admin xác nhận.">
                                                    Thanh toán
                                                </button>
                                                <button class="preset-reply-btn" type="button"
                                                    data-template="Đơn hàng được hỗ trợ đổi trả theo trạng thái và điều kiện của shop. Bạn gửi lý do đổi trả, admin sẽ kiểm tra và phản hồi trên hệ thống.">
                                                    Đổi trả
                                                </button>
                                            </div>
                                        </div>
                                        <c:if test="${not empty suggestedProducts}">
                                            <div class="suggested-products">
                                                <c:forEach items="${suggestedProducts}" var="item">
                                                    <div class="suggested-product">
                                                        <img src="/images/products/${item.product.image}" alt="${item.product.name}">
                                                        <div class="suggested-product-name">${item.product.name}</div>
                                                        <div class="small fw-bold text-primary">
                                                            <fmt:formatNumber type="number" value="${item.product.price}" /> đ
                                                        </div>
                                                        <div class="small text-muted">${item.reason}</div>
                                                        <a href="/product/${item.product.id}" target="_blank" class="btn btn-sm btn-outline-secondary mt-2">
                                                            Xem sản phẩm
                                                        </a>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="chat-body" id="adminChatBody" data-conversation-key="${activeConversationKey}">
                                        <c:forEach items="${activeMessages}" var="message">
                                            <c:choose>
                                                <c:when test="${message.senderType == 'ADMIN'}">
                                                    <c:set var="rowType" value="admin" />
                                                    <c:set var="senderLabel" value="Quan tri" />
                                                </c:when>
                                                <c:when test="${message.senderType == 'AI'}">
                                                    <c:set var="rowType" value="ai" />
                                                    <c:set var="senderLabel" value="AI" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="rowType" value="customer" />
                                                    <c:set var="senderLabel" value="${activeConversation.customerName}" />
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="chat-row ${rowType}">
                                                <div class="chat-bubble">
                                                    <div class="chat-sender"><c:out value="${senderLabel}" /></div>
                                                    <c:choose>
                                                        <c:when test="${not empty message.content}">
                                                            <c:out value="${message.content}" />
                                                        </c:when>
                                                        <c:when test="${not empty message.question}">
                                                            <c:out value="${message.question}" />
                                                        </c:when>
                                                        <c:when test="${not empty message.aiAnswer}">
                                                            <c:out value="${message.aiAnswer}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${message.adminReply}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div class="chat-time"><c:out value="${message.createdAt}" /></div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <form class="chat-reply" method="post" action="/admin/ai-messages/${activeConversation.id}/reply">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <div class="input-group">
                                            <textarea class="form-control" name="adminReply" id="adminReplyInput"
                                                placeholder="Nhập tin nhắn trả lời..." required></textarea>
                                            <button class="btn btn-primary px-4" type="submit">
                                                <i class="fas fa-paper-plane me-1"></i>Gửi
                                            </button>
                                        </div>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </section>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
    <script src="/js/admin-ai-message-live.js?v=<%= System.currentTimeMillis() %>"></script>
    <script>
        const adminChatBody = document.getElementById("adminChatBody");
        if (adminChatBody) {
            adminChatBody.scrollTop = adminChatBody.scrollHeight;
        }

        const replyBox = document.querySelector(".chat-reply textarea");
        if (replyBox) {
            replyBox.addEventListener("input", function () {
                replyBox.style.height = "auto";
                replyBox.style.height = Math.min(replyBox.scrollHeight, 130) + "px";
            });
        }

        const useSuggestedReply = document.getElementById("useSuggestedReply");
        const suggestedReplyText = document.getElementById("suggestedReplyText");
        const adminReplyInput = document.getElementById("adminReplyInput");
        const adminAiTools = document.getElementById("adminAiTools");
        const hideAiTools = document.getElementById("hideAiTools");
        const showAiTools = document.getElementById("showAiTools");
        const presetReplyButtons = document.querySelectorAll(".preset-reply-btn");

        function hideSuggestionTools() {
            if (adminAiTools) {
                adminAiTools.classList.add("is-hidden");
            }
        }

        function showSuggestionTools() {
            if (adminAiTools) {
                adminAiTools.classList.remove("is-hidden");
            }
        }

        if (useSuggestedReply && suggestedReplyText && adminReplyInput) {
            useSuggestedReply.addEventListener("click", function () {
                adminReplyInput.value = suggestedReplyText.textContent.replace("Gợi ý trả lời:", "").trim();
                adminReplyInput.focus();
                adminReplyInput.dispatchEvent(new Event("input"));
                hideSuggestionTools();
            });
        }

        if (hideAiTools) {
            hideAiTools.addEventListener("click", hideSuggestionTools);
        }

        if (showAiTools) {
            showAiTools.addEventListener("click", showSuggestionTools);
        }

        presetReplyButtons.forEach(function (button) {
            button.addEventListener("click", function () {
                if (!adminReplyInput) {
                    return;
                }
                adminReplyInput.value = button.dataset.template || button.textContent.trim();
                adminReplyInput.focus();
                adminReplyInput.dispatchEvent(new Event("input"));
            });
        });
    </script>
</body>

</html>
