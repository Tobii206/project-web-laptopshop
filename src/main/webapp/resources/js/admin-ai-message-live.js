(function () {
    const chatBody = document.getElementById("adminChatBody");
    const conversationList = document.getElementById("adminConversationList");
    const replyInput = document.getElementById("adminReplyInput");
    const activeCustomerName = document.getElementById("activeCustomerName");
    const activeCustomerEmail = document.getElementById("activeCustomerEmail");
    const activeConversationLabel = document.getElementById("activeConversationLabel");
    const conversationSummaryText = document.getElementById("conversationSummaryText");
    const suggestedReplyText = document.getElementById("suggestedReplyText");

    if (!conversationList) {
        return;
    }

    let lastSignature = "";
    let currentConversationKey = chatBody ? chatBody.dataset.conversationKey || "" : "";
    let socket = null;

    function getTabToken() {
        return window.sessionStorage ? window.sessionStorage.getItem("laptopshop.tabToken") || "" : "";
    }

    function escapeHtml(value) {
        const div = document.createElement("div");
        div.textContent = value || "";
        return div.innerHTML;
    }

    function rowType(senderType) {
        if (senderType === "ADMIN") {
            return "admin";
        }
        if (senderType === "AI") {
            return "ai";
        }
        return "customer";
    }

    function renderConversations(items, activeKey) {
        if (!Array.isArray(items) || items.length === 0) {
            conversationList.innerHTML = "<div class=\"p-4 text-muted\">Chưa có cuộc trò chuyện nào.</div>";
            return;
        }

        conversationList.innerHTML = items.map(function (item) {
            const key = item.conversationKey || "";
            const active = key === activeKey ? " active" : "";
            return ""
                + "<a class=\"conversation-item" + active + "\" data-conversation-key=\"" + escapeHtml(key) + "\""
                + " href=\"/admin/ai-messages?conversationKey=" + encodeURIComponent(key) + "\">"
                + "<div class=\"conversation-name\">" + escapeHtml(item.customerName || "Khách hàng") + "</div>"
                + "<div class=\"conversation-meta\">" + escapeHtml(item.customerEmail || "") + "</div>"
                + "<div class=\"conversation-preview mt-2\">" + escapeHtml(item.preview || "") + "</div>"
                + "</a>";
        }).join("");
    }

    function renderMessages(items) {
        if (!chatBody || !Array.isArray(items)) {
            return;
        }

        const signature = items.map(function (item) {
            return item.id + ":" + item.senderType + ":" + item.content;
        }).join("|");

        if (signature === lastSignature) {
            return;
        }

        chatBody.innerHTML = items.map(function (item) {
            const type = rowType(item.senderType);
            return ""
                + "<div class=\"chat-row " + type + "\">"
                + "<div class=\"chat-bubble\">"
                + "<div class=\"chat-sender\">" + escapeHtml(item.senderLabel) + "</div>"
                + escapeHtml(item.content)
                + "<div class=\"chat-time\">" + escapeHtml(item.createdAt) + "</div>"
                + (item.receiptLabel ? "<div class=\"chat-time\">" + escapeHtml(item.receiptLabel) + "</div>" : "")
                + "</div>"
                + "</div>";
        }).join("");

        lastSignature = signature;
        chatBody.scrollTop = chatBody.scrollHeight;
    }

    function applyHeader(data, activeKey) {
        const activeConversation = Array.isArray(data.conversations)
            ? data.conversations.find(function (item) {
                return item.conversationKey === activeKey;
            })
            : null;

        if (activeConversation) {
            if (activeCustomerName) {
                activeCustomerName.textContent = activeConversation.customerName || "Khách hàng";
            }
            if (activeCustomerEmail) {
                activeCustomerEmail.textContent = activeConversation.customerEmail || "";
            }
        }
        if (activeConversationLabel) {
            activeConversationLabel.textContent = activeKey;
        }
        if (conversationSummaryText) {
            conversationSummaryText.textContent = "AI tóm tắt: " + (data.conversationSummary || "");
        }
        if (suggestedReplyText) {
            suggestedReplyText.textContent = "Gợi ý trả lời: " + (data.suggestedReply || "");
        }
    }

    async function fetchConversation(conversationKey) {
        const url = new URL("/admin/ai-messages/poll", window.location.origin);
        const tabToken = getTabToken();
        if (conversationKey) {
            url.searchParams.set("conversationKey", conversationKey);
        }
        if (tabToken) {
            url.searchParams.set("tabToken", tabToken);
        }

        const response = await fetch(url.toString(), {
            method: "GET",
            cache: "no-store",
            headers: {
                "Accept": "application/json",
                "X-Tab-Token": tabToken
            }
        });

        if (!response.ok) {
            return null;
        }
        const contentType = response.headers.get("content-type") || "";
        if (!contentType.includes("application/json")) {
            return null;
        }
        return response.json();
    }

    async function refresh(preferredConversationKey) {
        const inputHasDraft = replyInput && replyInput.value.trim() !== "";
        let targetKey = preferredConversationKey || currentConversationKey;
        let data = await fetchConversation(targetKey);
        if (!data) {
            return;
        }

        const latestConversation = Array.isArray(data.conversations) && data.conversations.length > 0
            ? data.conversations[0]
            : null;

        if (!preferredConversationKey && latestConversation && latestConversation.conversationKey
                && latestConversation.conversationKey !== targetKey && !inputHasDraft) {
            targetKey = latestConversation.conversationKey;
            data = await fetchConversation(targetKey);
            if (!data) {
                return;
            }
        }

        const activeKey = data.activeConversationKey || targetKey || "";
        currentConversationKey = activeKey;
        if (chatBody) {
            chatBody.dataset.conversationKey = activeKey;
        }
        renderConversations(data.conversations, activeKey);
        applyHeader(data, activeKey);
        renderMessages(data.messages);

        if (activeKey) {
            window.history.replaceState(null, "", "/admin/ai-messages?conversationKey=" + encodeURIComponent(activeKey));
        }
    }

    conversationList.addEventListener("click", function (event) {
        const link = event.target.closest(".conversation-item");
        if (!link) {
            return;
        }
        event.preventDefault();
        lastSignature = "";
        refresh(link.dataset.conversationKey || "").catch(function () {});
    });

    function connectSocket() {
        if (socket && socket.readyState <= 1) {
            return;
        }
        const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
        const tabToken = getTabToken();
        socket = new WebSocket(protocol + "//" + window.location.host
            + "/ws/ai-chat?role=admin&tabToken=" + encodeURIComponent(tabToken));
        socket.onmessage = function (event) {
            try {
                const data = JSON.parse(event.data);
                if (data.type === "chat_updated") {
                    lastSignature = "";
                    refresh(data.conversationKey).catch(function () {});
                }
            } catch (error) {
            }
        };
        socket.onclose = function () {
            socket = null;
            window.setTimeout(connectSocket, 1500);
        };
    }

    refresh(currentConversationKey).catch(function () {});
    window.setInterval(function () {
        refresh().catch(function () {});
    }, 800);
    connectSocket();
})();
