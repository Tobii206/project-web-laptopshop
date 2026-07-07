(function () {
    const widget = document.getElementById("aiChatWidget");
    if (!widget) {
        return;
    }

    const toggle = document.getElementById("aiChatToggle");
    const close = document.getElementById("aiChatClose");
    const form = document.getElementById("aiChatForm");
    const input = document.getElementById("aiChatInput");
    const messages = document.getElementById("aiChatMessages");
    const subtitle = widget.querySelector(".ai-chat-subtitle");
    const suggestionButtons = widget.querySelectorAll(".ai-chat-suggestion");
    const modeButtons = widget.querySelectorAll(".ai-chat-mode-btn");
    const servicePanel = document.getElementById("aiChatServicePanel");
    const guestKey = "laptopshop.aiConversationKey";
    const adminGuestKey = "laptopshop.adminConversationKey";
    const isAuthenticated = widget.dataset.authenticated === "true";
    let chatMode = "ai";
    let loadedHistory = false;
    let pollingId = null;
    let realtimeSocket = null;
    let activeServiceMode = "";
    const aiSessionMessages = [];

    if (!isAuthenticated) {
        modeButtons.forEach(function (button) {
            if (button.dataset.chatMode === "admin") {
                button.disabled = true;
                button.title = "Đăng nhập để chat với admin";
            }
        });
    }

    function getConversationKey() {
        const storageKey = chatMode === "admin" ? adminGuestKey : guestKey;
        if (!window.localStorage) {
            return (chatMode === "admin" ? "ADMIN_GUEST_" : "AI_GUEST_") + Date.now();
        }
        let key = window.localStorage.getItem(storageKey);
        if (!key) {
            key = (chatMode === "admin" ? "ADMIN_GUEST_" : "AI_GUEST_")
                + Date.now() + "_" + Math.random().toString(36).slice(2);
            window.localStorage.setItem(storageKey, key);
        }
        return key;
    }

    function setConversationKey(key) {
        if (key && window.localStorage) {
            if (key.startsWith("ADMIN_")) {
                window.localStorage.setItem(adminGuestKey, key);
            } else {
                window.localStorage.setItem(guestKey, key);
            }
        }
    }

    function getTabToken() {
        return window.sessionStorage ? window.sessionStorage.getItem("laptopshop.tabToken") || "" : "";
    }

    function withTabToken(url) {
        const token = getTabToken();
        if (token) {
            url.searchParams.set("tabToken", token);
        }
        return url;
    }

    function renderMessageContent(bubble, text) {
        const value = text || "";
        const pattern = /(\/product\/\d+)/g;
        let lastIndex = 0;
        let match;

        while ((match = pattern.exec(value)) !== null) {
            if (match.index > lastIndex) {
                bubble.appendChild(document.createTextNode(value.slice(lastIndex, match.index)));
            }

            const link = document.createElement("a");
            link.href = match[1];
            link.textContent = "Xem sản phẩm";
            link.className = "ai-chat-product-link";
            link.target = "_blank";
            link.rel = "noopener noreferrer";
            bubble.appendChild(link);
            lastIndex = match.index + match[1].length;
        }

        if (lastIndex < value.length) {
            bubble.appendChild(document.createTextNode(value.slice(lastIndex)));
        }
    }

    function appendMessage(type, text, receiptLabel) {
        const row = document.createElement("div");
        row.className = "ai-chat-message " + type;

        const bubble = document.createElement("div");
        bubble.className = "ai-chat-bubble";
        renderMessageContent(bubble, text);
        if (receiptLabel) {
            const receipt = document.createElement("div");
            receipt.className = "ai-chat-receipt";
            receipt.textContent = receiptLabel;
            bubble.appendChild(receipt);
        }

        row.appendChild(bubble);
        messages.appendChild(row);
        messages.scrollTop = messages.scrollHeight;
        return row;
    }

    function clearMessages() {
        messages.innerHTML = "";
    }

    function showLoginRequired() {
        closeServicePanel();
        appendMessage("bot", "Bạn cần đăng nhập để chat trực tiếp với admin, theo dõi đơn hàng, đổi trả hoặc bảo hành. Khách vãng lai chỉ dùng AI tư vấn trong phiên này.");
    }

    function renderHistory(history) {
        clearMessages();
        const items = history.messages || [];
        if (items.length === 0) {
            appendMessage("bot", "Chào bạn, mình có thể tư vấn laptop theo ngân sách, học tập, lập trình, đồ họa hoặc gaming.");
        } else {
            items.forEach(function (item) {
                const sender = item.senderType === "CUSTOMER" ? "user" : "bot";
                const prefix = item.senderType === "ADMIN" ? "Admin: " : "";
                appendMessage(sender, prefix + item.content, item.receiptLabel);
            });
        }

        if (subtitle) {
            subtitle.textContent = chatMode === "admin"
                ? "Đang chat trực tiếp với admin"
                : "AI tư vấn riêng, không gửi sang admin";
        }
    }

    function renderAiSessionHistory() {
        clearMessages();
        if (aiSessionMessages.length === 0) {
            appendMessage("bot", "Chào bạn, mình có thể tư vấn laptop theo ngân sách, học tập, lập trình, đồ họa hoặc gaming.");
        } else {
            aiSessionMessages.forEach(function (item) {
                appendMessage(item.type, item.content, item.receiptLabel);
            });
        }

        if (subtitle) {
            subtitle.textContent = "AI tư vấn riêng trong phiên này, không gửi sang admin";
        }
    }

    async function loadHistory() {
        if (chatMode === "ai") {
            renderAiSessionHistory();
            loadedHistory = true;
            return;
        }

        const conversationKey = getConversationKey();
        const url = new URL("/ai-chat/api/history", window.location.origin);
        url.searchParams.set("conversationKey", conversationKey);
        withTabToken(url);

        const response = await fetch(url.toString(), { method: "GET" });
        if (!response.ok) {
            return;
        }
        const history = await response.json();
        if (history.conversationKey) {
            setConversationKey(history.conversationKey);
        }
        renderHistory(history);
        loadedHistory = true;
    }

    function startPolling() {
        if (pollingId) {
            return;
        }
        pollingId = window.setInterval(function () {
            if (widget.classList.contains("open")) {
                loadHistory().catch(function () {});
            }
        }, 5000);
    }

    function setOpen(open) {
        widget.classList.toggle("open", open);
        if (open) {
            if (!loadedHistory) {
                loadHistory().catch(function () {});
            }
            connectRealtime();
            startPolling();
            setTimeout(function () {
                input.focus();
            }, 50);
        }
    }

    toggle.addEventListener("click", function () {
        setOpen(!widget.classList.contains("open"));
    });

    close.addEventListener("click", function () {
        setOpen(false);
    });

    form.addEventListener("submit", async function (event) {
        event.preventDefault();

        const question = input.value.trim();
        if (!question) {
            return;
        }
        if (chatMode === "admin" && !isAuthenticated) {
            showLoginRequired();
            return;
        }

        appendMessage("user", question, "Đã gửi");
        input.value = "";
        input.style.height = "";

        const loadingRow = appendMessage("bot", "Đang gửi tin nhắn...");
        const submittedMode = chatMode;

        const body = new URLSearchParams();
            body.set("question", question);
            body.set("conversationKey", getConversationKey());
            body.set("chatMode", chatMode);

        const csrfName = widget.dataset.csrfName;
        const csrfToken = widget.dataset.csrfToken;
        if (csrfName && csrfToken) {
            body.set(csrfName, csrfToken);
        }

        const token = getTabToken();
        if (token) {
            body.set("tabToken", token);
        }

        try {
            const response = await fetch("/ai-chat/api", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                },
                body: body
            });

            if (!response.ok) {
                throw new Error("Request failed");
            }

            const data = await response.json();
            if (data.conversationKey) {
                setConversationKey(data.conversationKey);
            }
            loadingRow.querySelector(".ai-chat-bubble").textContent =
                data.answer || "Tin nhắn đã gửi. Admin sẽ hỗ trợ thêm.";
            if (submittedMode === "ai") {
                aiSessionMessages.push({ type: "user", content: question, receiptLabel: "Đã gửi" });
                aiSessionMessages.push({ type: "bot", content: data.answer || "AI chưa có câu trả lời lúc này.", receiptLabel: "" });
            }

            if (subtitle) {
                subtitle.textContent = chatMode === "admin"
                    ? "Đang chat trực tiếp với admin"
                    : "AI tư vấn riêng trong phiên này, không gửi sang admin";
            }
            loadedHistory = submittedMode === "ai";
            if (submittedMode === "admin") {
                loadHistory().catch(function () {});
            }
        } catch (error) {
            loadingRow.querySelector(".ai-chat-bubble").textContent =
                "Chưa gửi được tin nhắn. Bạn thử lại sau nhé.";
        }
    });

    input.addEventListener("input", function () {
        input.style.height = "auto";
        input.style.height = Math.min(input.scrollHeight, 110) + "px";
    });

    function connectRealtime() {
        if (realtimeSocket && realtimeSocket.readyState <= 1) {
            return;
        }
        const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
        const url = protocol + "//" + window.location.host
            + "/ws/ai-chat?conversationKey=" + encodeURIComponent(getConversationKey());
        realtimeSocket = new WebSocket(url);
        realtimeSocket.onmessage = function (event) {
            try {
                const data = JSON.parse(event.data);
                if (data.type === "chat_updated" && data.conversationKey === getConversationKey()) {
                    loadHistory().catch(function () {});
                }
            } catch (error) {
            }
        };
        realtimeSocket.onclose = function () {
            realtimeSocket = null;
            if (widget.classList.contains("open")) {
                window.setTimeout(connectRealtime, 1500);
            }
        };
    }

    function switchMode(mode) {
        if (mode !== "ai" && mode !== "admin") {
            return;
        }
        if (mode === "admin" && !isAuthenticated) {
            chatMode = "ai";
            modeButtons.forEach(function (button) {
                button.classList.toggle("active", button.dataset.chatMode === chatMode);
            });
            showLoginRequired();
            return;
        }
        if (chatMode === mode && loadedHistory) {
            return;
        }
        chatMode = mode;
        loadedHistory = false;
        if (realtimeSocket) {
            realtimeSocket.close();
            realtimeSocket = null;
        }
        modeButtons.forEach(function (button) {
            button.classList.toggle("active", button.dataset.chatMode === chatMode);
        });
        closeServicePanel();
        clearMessages();
        appendMessage("bot", chatMode === "admin"
            ? "Bạn đang chat với admin. Hãy gửi nội dung cần hỗ trợ."
            : "Bạn đang hỏi AI tư vấn laptop. Tin nhắn ở đây không gửi sang admin.");
        loadHistory().catch(function () {});
        connectRealtime();
    }

    function money(value) {
        return new Intl.NumberFormat("vi-VN").format(value || 0) + " đ";
    }

    async function apiGet(path) {
        const url = withTabToken(new URL(path, window.location.origin));
        const response = await fetch(url.toString(), {
            method: "GET",
            cache: "no-store",
            headers: {
                "Accept": "application/json",
                "X-Tab-Token": getTabToken()
            }
        });
        return response.json();
    }

    async function apiPost(path, body) {
        const url = withTabToken(new URL(path, window.location.origin));
        const token = getTabToken();
        if (token) {
            body.set("tabToken", token);
        }
        const csrfName = widget.dataset.csrfName;
        const csrfToken = widget.dataset.csrfToken;
        if (csrfName && csrfToken) {
            body.set(csrfName, csrfToken);
        }
        const response = await fetch(url.toString(), {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
                "Accept": "application/json",
                "X-Tab-Token": token
            },
            body: body
        });
        return response.json();
    }

    function openServicePanel(html) {
        if (!servicePanel) {
            return;
        }
        servicePanel.innerHTML = html;
        servicePanel.classList.add("open");
    }

    function closeServicePanel() {
        if (servicePanel) {
            servicePanel.classList.remove("open");
            servicePanel.innerHTML = "";
        }
        activeServiceMode = "";
    }

    function orderCard(order, mode, itemsByOrder) {
        const tracking = order.trackingCode ? "<div>Mã vận đơn: <strong>" + order.trackingCode + "</strong></div>" : "";
        const returnInfo = order.returnRequested ? "<div>Đổi trả: <strong>" + order.returnStatus + "</strong></div>" : "";
        const items = itemsByOrder && itemsByOrder[order.id] ? itemsByOrder[order.id] : [];
        const warrantyOptions = items.map(function (item) {
            return "<option value=\"" + item.id + "\">" + item.productName + " x" + item.quantity + "</option>";
        }).join("");
        const returnForm = ""
            + "<div class=\"ai-chat-inline-form\" id=\"returnForm" + order.id + "\">"
            + "<textarea class=\"form-control\" rows=\"2\" placeholder=\"Lý do đổi trả\"></textarea>"
            + "<button class=\"ai-chat-mini-btn\" type=\"button\" data-submit-return=\"" + order.id + "\">Gửi đổi trả</button>"
            + "</div>";
        const warrantyForm = ""
            + "<div class=\"ai-chat-inline-form\" id=\"warrantyForm" + order.id + "\">"
            + "<select class=\"form-select\">" + warrantyOptions + "</select>"
            + "<textarea class=\"form-control\" rows=\"2\" placeholder=\"Mô tả lỗi bảo hành\"></textarea>"
            + "<button class=\"ai-chat-mini-btn\" type=\"button\" data-submit-warranty=\"" + order.id + "\">Gửi bảo hành</button>"
            + "</div>";
        const actions = mode === "orders" ? "" : ""
            + "<div class=\"ai-chat-order-actions\">"
            + (order.canReturn ? "<button class=\"ai-chat-mini-btn\" type=\"button\" data-show-return=\"" + order.id + "\">Yêu cầu đổi trả</button>" : "")
            + (order.canWarranty ? "<button class=\"ai-chat-mini-btn\" type=\"button\" data-show-warranty=\"" + order.id + "\">Yêu cầu bảo hành</button>" : "")
            + "</div>"
            + returnForm + warrantyForm;
        return ""
            + "<div class=\"ai-chat-order-card\" data-order-id=\"" + order.id + "\">"
            + "<strong>Đơn #" + order.id + "</strong>"
            + "<div>Trạng thái: <strong>" + order.status + "</strong></div>"
            + "<div>Thanh toán: " + order.paymentMethod + " - " + order.paymentStatus + "</div>"
            + tracking
            + "<div>Tổng tiền: " + money(order.totalPrice) + "</div>"
            + returnInfo
            + actions
            + "</div>";
    }

    async function loadOrderPanel(mode) {
        setOpen(true);
        if (activeServiceMode === mode && servicePanel && servicePanel.classList.contains("open")) {
            closeServicePanel();
            return;
        }
        activeServiceMode = mode;
        openServicePanel("<div class=\"text-muted small\">Đang tải đơn hàng...</div>");
        const data = await apiGet("/ai-chat/api/orders");
        if (!data.authenticated) {
            openServicePanel("<div class=\"text-muted small\">" + data.message + "</div>");
            return;
        }
        const orders = data.orders || [];
        if (orders.length === 0) {
            openServicePanel("<div class=\"text-muted small\">Bạn chưa có đơn hàng nào.</div>");
            return;
        }
        const details = {};
        if (mode === "warranty") {
            await Promise.all(orders.map(async function (order) {
                const detail = await apiGet("/ai-chat/api/orders/" + order.id);
                details[order.id] = detail.items || [];
            }));
        }
        const title = mode === "orders" ? "Theo dõi trạng thái đơn hàng"
            : mode === "returns" ? "Yêu cầu đổi trả"
            : "Yêu cầu bảo hành";
        openServicePanel("<div class=\"fw-bold mb-2\">" + title + "</div>"
            + orders.map(function (order) {
                return orderCard(order, mode, details);
            }).join(""));
    }

    if (servicePanel) {
        servicePanel.addEventListener("click", async function (event) {
            const showReturn = event.target.closest("[data-show-return]");
            const showWarranty = event.target.closest("[data-show-warranty]");
            const submitReturn = event.target.closest("[data-submit-return]");
            const submitWarranty = event.target.closest("[data-submit-warranty]");
            if (showReturn) {
                document.getElementById("returnForm" + showReturn.dataset.showReturn).classList.toggle("open");
            }
            if (showWarranty) {
                document.getElementById("warrantyForm" + showWarranty.dataset.showWarranty).classList.toggle("open");
            }
            if (submitReturn) {
                const orderId = submitReturn.dataset.submitReturn;
                const formBox = document.getElementById("returnForm" + orderId);
                const reason = formBox.querySelector("textarea").value.trim();
                if (!reason) {
                    appendMessage("bot", "Bạn nhập lý do đổi trả trước nhé.");
                    return;
                }
                const body = new URLSearchParams();
                body.set("reason", reason);
                const result = await apiPost("/ai-chat/api/orders/" + orderId + "/return", body);
                appendMessage("bot", result.message || "Đã xử lý yêu cầu đổi trả.");
                await loadOrderPanel("returns");
            }
            if (submitWarranty) {
                const orderId = submitWarranty.dataset.submitWarranty;
                const formBox = document.getElementById("warrantyForm" + orderId);
                const orderDetailId = formBox.querySelector("select").value;
                const issue = formBox.querySelector("textarea").value.trim();
                if (!issue) {
                    appendMessage("bot", "Bạn mô tả lỗi cần bảo hành trước nhé.");
                    return;
                }
                const body = new URLSearchParams();
                body.set("issue", issue);
                const result = await apiPost("/ai-chat/api/warranty/" + orderDetailId, body);
                appendMessage("bot", result.message || "Đã xử lý yêu cầu bảo hành.");
                await loadOrderPanel("warranty");
            }
        });
    }

    suggestionButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const action = button.dataset.action;
            if (action) {
                if (!isAuthenticated) {
                    showLoginRequired();
                    return;
                }
                switchMode("admin");
                loadOrderPanel(action).catch(function () {
                    openServicePanel("<div class=\"text-danger small\">Chưa tải được dữ liệu đơn hàng.</div>");
                });
                return;
            }
            const prompt = button.dataset.prompt || button.textContent.trim();
            input.value = prompt;
            input.dispatchEvent(new Event("input"));
            form.requestSubmit();
        });
    });

    modeButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            switchMode(button.dataset.chatMode);
        });
    });

    document.querySelectorAll(".js-open-ai-chat-notification").forEach(function (link) {
        link.addEventListener("click", function (event) {
            const chatLink = link.dataset.chatLink || "";
            if (!chatLink.includes("openChat=1") && !chatLink.startsWith("/ai-chat")) {
                return;
            }
            event.preventDefault();
            const chatUrl = new URL(chatLink, window.location.origin);
            const key = chatUrl.searchParams.get("conversationKey");
            if (key) {
                setConversationKey(key);
                loadedHistory = false;
            }
            setOpen(true);
            fetch(link.href, { method: "GET", cache: "no-store" }).catch(function () {});
        });
    });

    const url = new URL(window.location.href);
    if (url.searchParams.get("conversationKey")) {
        const key = url.searchParams.get("conversationKey");
        setConversationKey(key);
        if (key && key.startsWith("ADMIN_")) {
            chatMode = "admin";
        }
    }
    if (url.searchParams.get("openChat") === "1") {
        switchMode(chatMode);
        setOpen(true);
        url.searchParams.delete("openChat");
        url.searchParams.delete("conversationKey");
        window.history.replaceState(null, "", url.pathname + url.search + url.hash);
    }
})();
