<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Đăng nhập - LaptopShop</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        :root {
            --auth-primary: #0f766e;
            --auth-primary-dark: #115e59;
            --auth-accent: #f59e0b;
            --auth-ink: #0f172a;
            --auth-muted: #64748b;
            --auth-line: #e2e8f0;
            --auth-shadow: 0 26px 70px rgba(15, 23, 42, 0.16);
        }

        body.auth-body {
            min-height: 100vh;
            margin: 0;
            color: var(--auth-ink);
            background:
                radial-gradient(circle at 14% 12%, rgba(20, 184, 166, 0.28), transparent 30%),
                radial-gradient(circle at 86% 18%, rgba(245, 158, 11, 0.22), transparent 28%),
                radial-gradient(circle at 76% 86%, rgba(56, 189, 248, 0.2), transparent 32%),
                linear-gradient(135deg, #f8fafc 0%, #ecfeff 48%, #fff7ed 100%);
            font-family: Inter, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        }

        .auth-shell {
            min-height: 100vh;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 520px;
            align-items: stretch;
        }

        .auth-hero {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: clamp(32px, 6vw, 82px);
        }

        .auth-brand {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            color: var(--auth-primary);
            font-size: clamp(2rem, 4vw, 4rem);
            font-weight: 900;
            letter-spacing: 0;
            margin-bottom: 26px;
            text-decoration: none;
        }

        .auth-brand-icon {
            width: 58px;
            height: 58px;
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            background: linear-gradient(135deg, var(--auth-primary), #0891b2);
            box-shadow: 0 18px 35px rgba(15, 118, 110, 0.24);
            font-size: 1.5rem;
        }

        .auth-hero h1 {
            max-width: 680px;
            color: var(--auth-ink);
            font-size: clamp(2.3rem, 5vw, 5.4rem);
            font-weight: 900;
            line-height: 1.02;
            margin-bottom: 18px;
        }

        .auth-hero p {
            max-width: 560px;
            color: var(--auth-muted);
            font-size: 1.12rem;
            font-weight: 700;
            line-height: 1.65;
            margin-bottom: 30px;
        }

        .auth-chip-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .auth-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 1px solid rgba(15, 118, 110, 0.18);
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.78);
            color: var(--auth-primary-dark);
            font-weight: 900;
            padding: 10px 14px;
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.06);
        }

        .auth-panel-wrap {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px;
            background: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(18px);
            border-left: 1px solid rgba(226, 232, 240, 0.75);
        }

        .auth-card {
            width: min(100%, 460px);
            border: 1px solid rgba(226, 232, 240, 0.95);
            border-radius: 28px;
            background:
                radial-gradient(circle at top left, rgba(20, 184, 166, 0.14), transparent 38%),
                #ffffff;
            box-shadow: var(--auth-shadow);
            overflow: hidden;
        }

        .auth-card-header {
            padding: 34px 34px 18px;
        }

        .auth-card-header h2 {
            color: var(--auth-ink);
            font-size: 2rem;
            font-weight: 900;
            margin-bottom: 8px;
        }

        .auth-card-header p {
            color: var(--auth-muted);
            font-weight: 700;
            margin: 0;
        }

        .auth-card-body {
            padding: 16px 34px 34px;
        }

        .auth-card .form-floating > .form-control {
            min-height: 64px;
            border: 1px solid var(--auth-line);
            border-radius: 18px;
            color: var(--auth-ink);
            font-size: 1rem;
            font-weight: 700;
            box-shadow: none;
        }

        .auth-card .form-floating > label {
            color: var(--auth-muted);
            font-weight: 700;
            padding-left: 1rem;
        }

        .auth-card .form-control:focus {
            border-color: var(--auth-primary);
            box-shadow: 0 0 0 0.22rem rgba(15, 118, 110, 0.14);
        }

        .auth-submit {
            min-height: 58px;
            border: 0;
            border-radius: 18px;
            background: linear-gradient(135deg, var(--auth-primary), #0891b2);
            color: #fff;
            font-size: 1.05rem;
            font-weight: 900;
            box-shadow: 0 18px 34px rgba(15, 118, 110, 0.24);
        }

        .auth-submit:hover {
            color: #fff;
            transform: translateY(-1px);
        }

        .auth-alert {
            border: 0;
            border-radius: 16px;
            font-weight: 800;
            padding: 12px 14px;
        }

        .auth-footer {
            border-top: 1px solid var(--auth-line);
            padding: 20px 34px 26px;
            text-align: center;
            color: var(--auth-muted);
            font-weight: 700;
        }

        .auth-footer a,
        .auth-back {
            color: var(--auth-primary);
            font-weight: 900;
            text-decoration: none;
        }

        .auth-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 20px;
        }

        @media (max-width: 991.98px) {
            .auth-shell {
                grid-template-columns: 1fr;
            }

            .auth-hero {
                padding-bottom: 18px;
            }

            .auth-panel-wrap {
                border-left: 0;
                padding-top: 0;
            }
        }

        @media (max-width: 575.98px) {
            .auth-hero {
                padding: 24px;
            }

            .auth-panel-wrap {
                padding: 0 16px 24px;
            }

            .auth-card-header,
            .auth-card-body {
                padding-left: 22px;
                padding-right: 22px;
            }
        }
    </style>
</head>

<body class="auth-body">
    <main class="auth-shell">
        <section class="auth-hero">
            <a class="auth-brand" href="/">
                <span class="auth-brand-icon"><i class="fas fa-laptop"></i></span>
                LaptopShop
            </a>
            <h1>Đăng nhập để mua laptop nhanh hơn</h1>
            <p>
                Quản lý giỏ hàng, theo dõi đơn hàng, nhận thông báo, chat với AI và lưu các mẫu laptop bạn quan tâm.
            </p>
            <div class="auth-chip-row">
                <span class="auth-chip"><i class="fas fa-shield-alt"></i> Bảo hành điện tử</span>
                <span class="auth-chip"><i class="fas fa-truck"></i> Theo dõi đơn hàng</span>
                <span class="auth-chip"><i class="fas fa-robot"></i> Tư vấn AI</span>
            </div>
            <a class="auth-back" href="/">
                <i class="fas fa-arrow-left"></i> Về trang chủ
            </a>
        </section>

        <section class="auth-panel-wrap">
            <div class="auth-card">
                <div class="auth-card-header">
                    <h2>Đăng nhập</h2>
                    <p>Nhập tài khoản của bạn để tiếp tục.</p>
                </div>
                <div class="auth-card-body">
                    <form method="post" action="/tab-login">
                        <c:if test="${param.error != null}">
                            <div class="alert alert-danger auth-alert">
                                Email hoặc mật khẩu không đúng.
                            </div>
                        </c:if>
                        <c:if test="${param.logout != null}">
                            <div class="alert alert-success auth-alert">
                                Đăng xuất thành công.
                            </div>
                        </c:if>
                        <div class="form-floating mb-3">
                            <input class="form-control" id="inputEmail" type="email" placeholder="name@example.com"
                                name="username" autocomplete="email" required />
                            <label for="inputEmail">Email</label>
                        </div>
                        <div class="form-floating mb-4">
                            <input class="form-control" id="inputPassword" type="password" placeholder="Mật khẩu"
                                name="password" autocomplete="current-password" required />
                            <label for="inputPassword">Mật khẩu</label>
                        </div>
                        <div class="d-grid">
                            <button class="btn auth-submit" type="submit">
                                <i class="fas fa-right-to-bracket me-2"></i>Đăng nhập
                            </button>
                        </div>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </form>
                </div>
                <div class="auth-footer">
                    Chưa có tài khoản? <a href="/register">Đăng ký ngay</a>
                </div>
            </div>
        </section>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
    <script src="/js/tab-auth.js"></script>
</body>

</html>
