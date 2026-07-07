<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<link href="/css/admin-modern.css" rel="stylesheet">
<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark admin-topbar">
    <!-- Navbar Brand-->
    <a class="navbar-brand ps-3" href="/admin">LaptopShop</a>
    <!-- Sidebar Toggle-->
    <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i
            class="fas fa-bars"></i></button>
    <!-- Navbar Search-->
    <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
        <div style="color: aliceblue;" class="d-flex align-items-center gap-3">
            <a href="/" class="btn btn-outline-light btn-sm"><i class="fa-solid fa-store me-1"></i>Xem cửa hàng</a>
            <span class="admin-user-chip">${pageContext.request.userPrincipal.name}</span>
        </div>
    </form>
    <!-- Navbar-->
    <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
        <li class="nav-item dropdown me-2">
            <a class="nav-link position-relative" href="#" role="button" data-bs-toggle="dropdown"
                aria-expanded="false">
                <i class="fas fa-bell fa-fw"></i>
                <c:if test="${currentUnreadNotifications > 0}">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                        id="adminNotificationBadge">
                        ${currentUnreadNotifications}
                    </span>
                </c:if>
                <c:if test="${currentUnreadNotifications <= 0}">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger d-none"
                        id="adminNotificationBadge">0</span>
                </c:if>
            </a>
            <ul class="dropdown-menu dropdown-menu-end p-2 notification-menu" id="adminNotificationMenu">
                <li class="dropdown-header">Thông báo</li>
                <c:choose>
                    <c:when test="${empty currentNotifications}">
                        <li class="dropdown-item text-muted small">Chưa có thông báo.</li>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${currentNotifications}" var="notification">
                            <li>
                                <a class="dropdown-item rounded ${notification.readStatus ? '' : 'fw-bold'}"
                                    href="/notifications/read/${notification.id}">
                                    <div class="notification-title">${notification.title}</div>
                                    <small class="notification-content text-muted">${notification.content}</small>
                                </a>
                            </li>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </ul>
        </li>
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button"
                data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                <li><a class="dropdown-item" href="/">Xem cửa hàng</a></li>
                <li>
                    <hr class="dropdown-divider" />
                </li>
                <li>
                    <form method="post" action="/tab-logout" class="px-3">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button class="dropdown-item px-0" type="submit">Đăng xuất</button>
                    </form>
                </li>
            </ul>
        </li>
    </ul>
</nav>
<script src="/js/tab-auth.js"></script>
<script>
    (function () {
        const badge = document.getElementById("adminNotificationBadge");
        const menu = document.getElementById("adminNotificationMenu");
        let notificationSocket = null;

        function escapeHtml(value) {
            const div = document.createElement("div");
            div.textContent = value || "";
            return div.innerHTML;
        }

        function renderNotifications(data) {
            if (!badge || !menu) {
                return;
            }
            const unread = Number(data.unread || 0);
            badge.textContent = unread;
            badge.classList.toggle("d-none", unread <= 0);

            const items = data.notifications || [];
            let html = "<li class=\"dropdown-header\">Thông báo</li>";
            if (items.length === 0) {
                html += "<li class=\"dropdown-item text-muted small\">Chưa có thông báo.</li>";
            } else {
                html += items.map(function (item) {
                    const weight = item.readStatus ? "" : " fw-bold";
                    return ""
                        + "<li>"
                        + "<a class=\"dropdown-item rounded" + weight + "\" href=\"/notifications/read/" + item.id + "\">"
                        + "<div class=\"notification-title\">" + escapeHtml(item.title) + "</div>"
                        + "<small class=\"notification-content text-muted\">" + escapeHtml(item.content) + "</small>"
                        + "</a>"
                        + "</li>";
                }).join("");
            }
            menu.innerHTML = html;
        }

        function getTabToken() {
            return window.sessionStorage ? window.sessionStorage.getItem("laptopshop.tabToken") || "" : "";
        }

        async function refreshAdminNotifications() {
            const tabToken = getTabToken();
            const url = new URL("/notifications/api/current", window.location.origin);
            if (tabToken) {
                url.searchParams.set("tabToken", tabToken);
            }
            const response = await fetch(url.toString(), {
                method: "GET",
                headers: {
                    "Accept": "application/json",
                    "X-Tab-Token": tabToken
                }
            });
            if (!response.ok) {
                return;
            }
            renderNotifications(await response.json());
        }

        function connectNotificationSocket() {
            if (notificationSocket && notificationSocket.readyState <= 1) {
                return;
            }
            const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
            const tabToken = getTabToken();
            notificationSocket = new WebSocket(protocol + "//" + window.location.host
                + "/ws/ai-chat?role=admin&tabToken=" + encodeURIComponent(tabToken));
            notificationSocket.onmessage = function (event) {
                try {
                    const data = JSON.parse(event.data);
                    if (data.type === "chat_updated") {
                        refreshAdminNotifications().catch(function () {});
                    }
                } catch (error) {
                }
            };
            notificationSocket.onclose = function () {
                notificationSocket = null;
                window.setTimeout(connectNotificationSocket, 1500);
            };
        }

        connectNotificationSocket();
    })();
</script>
