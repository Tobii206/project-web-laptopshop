<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tư vấn AI - LaptopShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800&family=Raleway:wght@600;700;800&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
    <link href="/css/modern-ui.css" rel="stylesheet">
    <style>
        .ai-page-header {
            margin-top: 164px;
            padding: 84px 0 74px;
            background:
                radial-gradient(circle at 18% 22%, rgba(20, 184, 166, 0.35), transparent 28rem),
                radial-gradient(circle at 88% 18%, rgba(37, 99, 235, 0.32), transparent 28rem),
                linear-gradient(135deg, #0f766e 0%, #111827 52%, #2563eb 100%);
            border-radius: 0 0 42px 42px;
            box-shadow: 0 22px 60px rgba(15, 23, 42, 0.18);
        }

        .ai-page-header h1 {
            font-size: clamp(42px, 5.4vw, 78px);
            font-weight: 900;
            color: #ffffff;
            letter-spacing: 0;
        }

        .ai-page-header .breadcrumb a,
        .ai-page-header .breadcrumb-item {
            color: rgba(255, 255, 255, 0.78);
            font-weight: 800;
        }

        .ai-finder-page {
            max-width: 1180px;
        }

        .ai-finder-panel {
            position: relative;
            overflow: hidden;
            border-radius: 34px;
            padding: 42px;
            background:
                linear-gradient(135deg, rgba(255, 255, 255, 0.94), rgba(236, 254, 255, 0.88)),
                radial-gradient(circle at top right, rgba(255, 181, 36, 0.18), transparent 20rem);
            border: 1px solid rgba(15, 118, 110, 0.18);
            box-shadow: 0 26px 70px rgba(15, 23, 42, 0.12);
            font-family: "Open Sans", "Segoe UI", Arial, sans-serif;
        }

        .ai-finder-panel::after {
            content: "";
            position: absolute;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            right: -80px;
            top: -90px;
            background: rgba(20, 184, 166, 0.16);
        }

        .finder-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 14px;
            border-radius: 999px;
            background: rgba(255, 181, 36, 0.18);
            color: #f59e0b;
            font-weight: 900;
            text-transform: uppercase;
            margin-bottom: 16px;
        }

        .ai-finder-panel h2 {
            max-width: 880px;
            color: #111827;
            font-family: "Segoe UI", "Open Sans", Arial, sans-serif;
            font-size: clamp(30px, 3.25vw, 46px);
            line-height: 1.14;
            font-weight: 800;
            letter-spacing: 0;
        }

        .ai-finder-panel .form-label {
            color: #0f172a;
            font-weight: 800;
        }

        .ai-finder-panel .form-control,
        .ai-finder-panel .form-select {
            min-height: 58px;
            border-radius: 18px;
            border: 1px solid #dbeafe;
            background-color: #ffffff;
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.04);
            font-weight: 600;
            color: #334155;
        }

        .ai-finder-panel .btn-primary {
            min-height: 58px;
            border-radius: 999px;
            padding: 0 30px;
            border: 0;
            background: linear-gradient(135deg, #0f766e, #06b6d4);
            color: #ffffff;
            font-weight: 900;
            box-shadow: 0 14px 30px rgba(20, 184, 166, 0.22);
        }

        .ai-summary {
            border-radius: 24px;
            padding: 22px 24px;
            background: #ecfeff;
            border: 1px solid rgba(6, 182, 212, 0.24);
            color: #0f172a;
            font-weight: 800;
        }

        .finder-card {
            border-radius: 26px;
            padding: 22px;
            background: #ffffff;
            border: 1px solid rgba(15, 118, 110, 0.12);
            box-shadow: 0 22px 50px rgba(15, 23, 42, 0.1);
        }

        .finder-score {
            display: inline-flex;
            border-radius: 999px;
            padding: 7px 12px;
            background: #dcfce7;
            color: #15803d;
            font-weight: 900;
            margin-bottom: 14px;
        }

        .finder-card img {
            width: 100%;
            height: 180px;
            object-fit: contain;
            border-radius: 20px;
            background: #f8fafc;
            padding: 12px;
            margin-bottom: 16px;
        }

        .finder-card h3 {
            color: #111827;
            font-weight: 900;
            font-size: 24px;
        }

        .finder-price {
            color: #0f766e;
            font-size: 24px;
            font-weight: 900;
            margin-bottom: 4px;
        }
    </style>
</head>
<body>
    <jsp:include page="../layout/header.jsp" />

    <div class="container-fluid ai-page-header">
        <h1 class="text-center text-white display-6">Tư vấn AI chọn laptop</h1>
        <ol class="breadcrumb justify-content-center mb-0">
            <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
            <li class="breadcrumb-item active text-white">Tư vấn AI</li>
        </ol>
    </div>

    <main class="container py-5 ai-finder-page">
        <section class="ai-finder-panel">
            <div>
                <div class="finder-eyebrow"><i class="fa fa-magic"></i> Bộ lọc thông minh</div>
                <h2>Nhập nhu cầu, AI sẽ gợi ý laptop đang có trong shop</h2>
                <p class="text-muted mb-0">Hệ thống chấm điểm theo ngân sách, nhu cầu, hãng, tồn kho và mô tả sản phẩm.</p>
            </div>
            <form action="/laptop-finder" method="post" class="row g-3 mt-2">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <div class="col-lg-5">
                    <label class="form-label fw-bold">Nhu cầu</label>
                    <input class="form-control" name="need" value="${need}"
                        placeholder="VD: 15 triệu, học IT, pin tốt, mỏng nhẹ">
                </div>
                <div class="col-lg-2">
                    <label class="form-label fw-bold">Ngân sách</label>
                    <input class="form-control" name="budget" value="${budget}" placeholder="20 triệu">
                </div>
                <div class="col-lg-3">
                    <label class="form-label fw-bold">Mục đích</label>
                    <select class="form-select" name="purpose">
                        <option value="" ${empty purpose ? 'selected' : ''}>Tự nhận diện</option>
                        <option value="hoc tap lap trinh" ${purpose eq 'hoc tap lap trinh' ? 'selected' : ''}>Học tập / lập trình</option>
                        <option value="gaming" ${purpose eq 'gaming' ? 'selected' : ''}>Gaming</option>
                        <option value="van phong mong nhe" ${purpose eq 'van phong mong nhe' ? 'selected' : ''}>Văn phòng / mỏng nhẹ</option>
                        <option value="do hoa thiet ke" ${purpose eq 'do hoa thiet ke' ? 'selected' : ''}>Đồ họa / thiết kế</option>
                    </select>
                </div>
                <div class="col-lg-2">
                    <label class="form-label fw-bold">Hãng thích</label>
                    <input class="form-control" name="factory" value="${factory}" placeholder="ASUS">
                </div>
                <div class="col-12">
                    <button class="btn btn-primary px-4" type="submit">
                        <i class="fa fa-magic me-2"></i>Gợi ý laptop
                    </button>
                </div>
            </form>
        </section>

        <c:if test="${not empty advisorSummary}">
            <section class="ai-summary mt-4">
                <i class="fa fa-robot"></i>
                <span>${advisorSummary}</span>
            </section>
        </c:if>

        <c:if test="${not empty recommendations}">
            <section class="row g-4 mt-2">
                <c:forEach items="${recommendations}" var="item">
                    <div class="col-md-4">
                        <article class="finder-card h-100">
                            <div class="finder-score">${item.score} điểm phù hợp</div>
                            <img src="/images/products/${item.product.image}" alt="${item.product.name}">
                            <h3>${item.product.name}</h3>
                            <p>${item.product.displayShortDesc}</p>
                            <div class="finder-price">
                                <fmt:formatNumber type="number" value="${item.product.price}" /> đ
                            </div>
                            <div class="small text-muted mb-3">Còn lại: ${item.product.quantity} sản phẩm</div>
                            <div class="finder-reason">${item.reason}</div>
                            <a href="/product/${item.product.id}" class="btn btn-outline-primary w-100 mt-3">Xem chi tiết</a>
                        </article>
                    </div>
                </c:forEach>
            </section>
        </c:if>
    </main>

    <jsp:include page="../layout/footer.jsp" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="/js/main.js"></script>
</body>
</html>

