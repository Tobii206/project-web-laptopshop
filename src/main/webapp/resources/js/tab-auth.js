(function () {
    const STORAGE_KEY = "laptopshop.tabToken";

    function getCurrentUrl() {
        return new URL(window.location.href);
    }

    function getStoredToken() {
        return window.sessionStorage.getItem(STORAGE_KEY);
    }

    function setStoredToken(token) {
        if (token) {
            window.sessionStorage.setItem(STORAGE_KEY, token);
        }
    }

    function clearStoredToken() {
        window.sessionStorage.removeItem(STORAGE_KEY);
    }

    function syncTokenFromUrl() {
        const url = getCurrentUrl();
        const token = url.searchParams.get("tabToken");
        if (!token) {
            if (url.searchParams.has("logout")) {
                clearStoredToken();
            }
            return;
        }

        setStoredToken(token);
    }

    function appendTokenToUrl(rawUrl, token) {
        if (!token || !rawUrl || rawUrl.startsWith("#") || rawUrl.startsWith("javascript:")) {
            return rawUrl;
        }

        const url = new URL(rawUrl, window.location.origin);
        if (url.origin !== window.location.origin) {
            return rawUrl;
        }
        if (url.searchParams.has("tabToken")) {
            return url.pathname + url.search + url.hash;
        }

        url.searchParams.set("tabToken", token);
        return url.pathname + url.search + url.hash;
    }

    function decorateLinks(token) {
        const accountLink = document.querySelector(".dropdown-menu a.dropdown-item[href='#']");
        if (accountLink) {
            accountLink.setAttribute("href", appendTokenToUrl("/account", token));
        }

        document.querySelectorAll("a[href]").forEach(function (link) {
            const href = link.getAttribute("href");
            if (href === "#") {
                return;
            }
            const updated = appendTokenToUrl(href, token);
            if (updated && updated !== href) {
                link.setAttribute("href", updated);
            }
        });
    }

    function decorateForms(token) {
        document.querySelectorAll("form").forEach(function (form) {
            form.addEventListener("submit", function () {
                if (!token) {
                    return;
                }

                let input = form.querySelector('input[name="tabToken"]');
                if (!input) {
                    input = document.createElement("input");
                    input.type = "hidden";
                    input.name = "tabToken";
                    form.appendChild(input);
                }
                input.value = token;
            });
        });
    }

    document.addEventListener("DOMContentLoaded", function () {
        syncTokenFromUrl();
        const token = getStoredToken();
        decorateLinks(token);
        decorateForms(token);
    });
})();
