<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán đổi hàng - LaptopShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>

<body class="thanks-page">
    <jsp:include page="../layout/header.jsp" />

    <main class="thanks-main">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-12 col-xl-8">
                    <div class="alert alert-info thanks-alert" role="alert">
                        <i class="fa fa-exchange-alt me-2"></i>
                        Vui lòng chuyển khoản phần tiền còn thiếu để đổi máy mới.
                    </div>

                    <div class="qr-payment-card mt-4">
                        <div class="qr-payment-body text-center">
                            <div class="qr-payment-eyebrow">Quét mã để chuyển tiền đến</div>
                            <h4 class="mb-1">NGUYEN THANH LONG</h4>
                            <div class="qr-account mb-3">Techcombank - 3208 0320 06</div>

                            <div class="qr-order-info">
                                <span>Ma yeu cau: <strong>EXCHANGE${order.id}</strong></span>
                                <span>
                                    Số tiền còn thiếu:
                                    <strong><fmt:formatNumber type="number" value="${order.exchangeAdditionalAmount}" /> đ</strong>
                                </span>
                            </div>

                            <div class="text-muted mb-3">
                                <div>Máy cũ được tính 80%:
                                    <strong><fmt:formatNumber type="number" value="${order.exchangeCreditAmount}" /> đ</strong>
                                </div>
                                <c:if test="${not empty order.exchangeProduct}">
                                    <div>Máy mới: <strong>${order.exchangeProduct.name}</strong></div>
                                </c:if>
                                <div>Giá máy mới:
                                    <strong><fmt:formatNumber type="number" value="${order.exchangeNewProductPrice}" /> đ</strong>
                                </div>
                            </div>

                            <img src="${qrUrl}" alt="QR thanh toán đổi hàng Techcombank" class="qr-payment-image">

                            <p class="text-muted mb-3">
                                Sau khi chuyển khoản, bấm nút bên dưới để báo admin kiểm tra và xác nhận tiền.
                            </p>
                            <form method="post" action="/order-history/${order.id}/exchange-payment-submitted" class="mb-3">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button class="btn btn-primary rounded-pill px-4" type="submit">
                                    <i class="fa fa-check me-2"></i>Tôi đã chuyển khoản
                                </button>
                            </form>
                            <a class="btn btn-outline-secondary rounded-pill px-4" href="/order-history">
                                <i class="fa fa-arrow-left me-2"></i>Quay lại lịch sử đơn hàng
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../layout/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
