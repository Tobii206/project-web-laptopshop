<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử mua hàng - LaptopShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
    <link href="/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
    <style>
        .order-history-shell {
            max-width: 1180px;
        }

        .history-toolbar {
            background: rgba(255, 255, 255, 0.92);
            border: 1px solid #e2e8f0;
            border-radius: 22px;
            padding: 18px;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.07);
        }

        .order-card {
            background: #fff;
            border: 1px solid rgba(15, 118, 110, 0.14);
            border-radius: 24px;
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.08);
            overflow: hidden;
        }

        .order-card + .order-card {
            margin-top: 24px;
        }

        .order-card-header {
            display: grid;
            grid-template-columns: 1.1fr 1fr 1fr;
            gap: 18px;
            padding: 24px;
            background: linear-gradient(135deg, #f8fafc 0%, #ecfeff 100%);
            border-bottom: 1px solid #e2e8f0;
        }

        .order-id {
            font-size: 1.25rem;
            font-weight: 900;
            color: #0f172a;
        }

        .order-meta {
            color: #64748b;
            font-weight: 700;
        }

        .order-total {
            font-size: 1.35rem;
            font-weight: 900;
            color: #0f766e;
        }

        .status-stack {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 8px;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            min-height: 34px;
            border-radius: 999px;
            padding: 6px 12px;
            font-weight: 900;
            font-size: 0.86rem;
            background: #e0f2fe;
            color: #0369a1;
        }

        .status-pill.success {
            background: #dcfce7;
            color: #15803d;
        }

        .status-pill.warning {
            background: #fef3c7;
            color: #92400e;
        }

        .order-card-body {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 320px;
            gap: 24px;
            padding: 24px;
        }

        .product-row {
            display: grid;
            grid-template-columns: 92px minmax(0, 1fr) auto;
            gap: 18px;
            align-items: center;
            padding: 14px 0;
            border-bottom: 1px solid #eef2f7;
        }

        .product-row:last-child {
            border-bottom: 0;
        }

        .product-thumb {
            width: 92px;
            height: 92px;
            border-radius: 18px;
            background: #f8fafc;
            object-fit: contain;
            padding: 8px;
        }

        .product-name {
            font-weight: 900;
            color: #0f172a;
            margin-bottom: 6px;
        }

        .product-sub {
            color: #64748b;
            font-weight: 700;
        }

        .line-total {
            font-weight: 900;
            color: #334155;
            text-align: right;
            min-width: 140px;
        }

        .order-actions {
            border-left: 1px solid #e2e8f0;
            padding-left: 24px;
        }

        .action-panel {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 16px;
        }

        .order-timeline {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 10px;
            padding: 16px 24px 0;
            background: #fff;
        }

        .timeline-step {
            position: relative;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            background: #f8fafc;
            padding: 12px;
            min-height: 92px;
        }

        .timeline-step.active {
            border-color: rgba(15, 118, 110, 0.28);
            background: linear-gradient(135deg, #ecfeff, #f0fdf4);
        }

        .timeline-dot {
            width: 28px;
            height: 28px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 8px;
            background: #cbd5e1;
            color: #fff;
            font-size: 0.8rem;
        }

        .timeline-step.active .timeline-dot {
            background: #0f766e;
        }

        .timeline-label {
            color: #0f172a;
            font-weight: 900;
            line-height: 1.2;
        }

        .timeline-note,
        .warranty-note {
            color: #64748b;
            font-size: 0.84rem;
            font-weight: 700;
        }

        .warranty-box {
            border: 1px dashed rgba(15, 118, 110, 0.3);
            border-radius: 14px;
            background: #f8fafc;
            padding: 10px;
            margin-top: 10px;
        }

        .warranty-code {
            color: #0f766e;
            font-weight: 900;
        }

        @media (max-width: 991.98px) {
            .order-card-header,
            .order-card-body {
                grid-template-columns: 1fr;
            }

            .order-timeline {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .order-actions {
                border-left: 0;
                padding-left: 0;
            }
        }

        @media (max-width: 575.98px) {
            .product-row {
                grid-template-columns: 72px minmax(0, 1fr);
            }

            .product-thumb {
                width: 72px;
                height: 72px;
            }

            .line-total {
                grid-column: 2;
                text-align: left;
            }

            .order-timeline {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
    <div id="spinner"
        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-grow text-primary" role="status"></div>
    </div>

    <jsp:include page="../layout/header.jsp" />

    <div class="container-fluid page-header py-5">
        <h1 class="text-center text-white display-6">Lịch sử mua hàng</h1>
        <ol class="breadcrumb justify-content-center mb-0">
            <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
            <li class="breadcrumb-item active text-white">Lịch sử mua hàng</li>
        </ol>
    </div>

    <div class="container-fluid py-5">
        <div class="container py-5 order-history-shell">
            <form action="/order-history" method="get" class="history-toolbar row g-3 align-items-end mb-5">
                <div class="col-md-4">
                    <label class="form-label fw-bold">Lọc theo thời gian</label>
                    <select class="form-select" name="range">
                        <option value="all" ${activeRange eq 'all' ? 'selected' : ''}>Tất cả</option>
                        <option value="day" ${activeRange eq 'day' ? 'selected' : ''}>Hôm nay</option>
                        <option value="week" ${activeRange eq 'week' ? 'selected' : ''}>7 ngày qua</option>
                        <option value="month" ${activeRange eq 'month' ? 'selected' : ''}>30 ngày qua</option>
                        <option value="year" ${activeRange eq 'year' ? 'selected' : ''}>12 tháng qua</option>
                    </select>
                </div>
                <div class="col-md-5">
                    <label class="form-label fw-bold">Tìm theo mã vận đơn</label>
                    <input class="form-control" name="trackingCode" value="${trackingCode}"
                        placeholder="VD: LTS20260704000012">
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn border-secondary rounded-pill px-4 py-2 text-primary w-100">
                        Áp dụng
                    </button>
                </div>
            </form>

            <c:forEach var="order" items="${orders}">
                <article class="order-card">
                    <div class="order-card-header">
                        <div>
                            <div class="order-id">Đơn hàng #${order.id}</div>
                            <div class="order-meta">${fn:replace(fn:substring(order.createdAt, 0, 16), 'T', ' ')}</div>
                        </div>
                        <div>
                            <div class="order-meta">Tổng thanh toán</div>
                            <div class="order-total">
                                <fmt:formatNumber type="number" value="${order.totalPrice}" /> đ
                            </div>
                            <c:if test="${order.discountAmount > 0}">
                                <div class="text-success fw-bold small">
                                    Giảm <fmt:formatNumber type="number" value="${order.discountAmount}" /> đ (${order.voucherCode})
                                </div>
                            </c:if>
                        </div>
                        <div>
                            <div class="order-meta">Trạng thái</div>
                            <div class="status-stack">
                                <span class="status-pill">${order.statusLabel}</span>
                                <c:if test="${order.customerConfirmedReceived}">
                                    <span class="status-pill success">Đã nhận hàng</span>
                                </c:if>
                                <c:if test="${order.returnRequested}">
                                    <span class="status-pill warning">${order.returnTypeLabel}: ${order.returnStatusLabel}</span>
                                </c:if>
                                <c:if test="${order.exchangeCompleted}">
                                    <span class="status-pill success">Đổi hàng thành công</span>
                                </c:if>
                            </div>
                            <c:if test="${order.returnRequested}">
                                <c:choose>
                                    <c:when test="${order.exchangeRequested}">
                                        <c:if test="${not empty order.exchangeProduct}">
                                            <div class="small text-muted mt-2">
                                                Sản phẩm đổi sang:
                                                <strong>${order.exchangeProduct.name}</strong>
                                            </div>
                                        </c:if>
                                        <div class="small text-muted mt-2">
                                            Giá trị máy cũ được tính 80%:
                                            <strong><fmt:formatNumber type="number" value="${order.exchangeCreditAmount}" /> đ</strong>
                                        </div>
                                        <c:if test="${order.exchangeNewProductPrice > 0}">
                                            <div class="small text-muted">
                                                Giá máy mới:
                                                <strong><fmt:formatNumber type="number" value="${order.exchangeNewProductPrice}" /> đ</strong>
                                            </div>
                                            <div class="small text-primary fw-bold">
                                                Cần chuyển thêm:
                                                <fmt:formatNumber type="number" value="${order.exchangeAdditionalAmount}" /> đ
                                            </div>
                                            <c:if test="${order.exchangeQrAvailable}">
                                                <a class="btn btn-outline-primary btn-sm rounded-pill mt-2"
                                                    href="/order-history/${order.id}/exchange-qr">
                                                    Mở QR chuyển khoản
                                                </a>
                                            </c:if>
                                            <c:if test="${order.exchangeRefundAmount > 0}">
                                                <div class="small text-success fw-bold mt-1">
                                                    Shop cần hoàn lại:
                                                    <fmt:formatNumber type="number" value="${order.exchangeRefundAmount}" /> đ
                                                </div>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${order.exchangePaymentConfirmed}">
                                            <div class="small text-success fw-bold mt-2">Admin đã xác nhận đủ tiền đổi máy.</div>
                                        </c:if>
                                        <c:if test="${order.exchangePaymentSubmitted and not order.exchangePaymentConfirmed}">
                                            <div class="small text-warning fw-bold mt-2">Đã báo chuyển khoản, chờ admin xác nhận.</div>
                                        </c:if>
                                        <c:if test="${order.exchangeCompleted}">
                                            <div class="small text-success fw-bold mt-2">Đã đổi máy mới cho khách hàng.</div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="small text-success fw-bold mt-2">Đã hoàn lại 70% tiền cho khách hàng.</div>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <div class="small mt-2 text-muted">
                                Thanh toán: ${order.paymentMethod} - ${order.paymentStatusLabel}
                            </div>
                            <c:if test="${not empty order.trackingCode}">
                                <div class="small text-primary fw-bold mt-1">Mã vận đơn: ${order.trackingCode}</div>
                            </c:if>
                            <c:if test="${not empty order.cancelReason}">
                                <div class="small text-danger fw-bold mt-1">Lý do hủy: <c:out value="${order.cancelReason}" /></div>
                            </c:if>
                        </div>
                    </div>

                    <div class="order-timeline">
                        <c:forEach items="${orderTimelineMap[order.id]}" var="step">
                            <div class="timeline-step ${step.active ? 'active' : ''}">
                                <div class="timeline-dot"><i class="fa fa-check"></i></div>
                                <div class="timeline-label">${step.label}</div>
                                <div class="timeline-note">${step.note}</div>
                                <c:if test="${not empty step.time}">
                                    <div class="timeline-note mt-1">${fn:replace(fn:substring(step.time, 0, 16), 'T', ' ')}</div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="order-card-body">
                        <div>
                            <c:forEach var="orderDetail" items="${orderDetails}">
                                <c:if test="${orderDetail.order.id == order.id}">
                                    <div class="product-row">
                                        <img src="images/products/${orderDetail.product.image}"
                                            class="product-thumb" alt="${orderDetail.product.name}">
                                        <div>
                                            <div class="product-name">${orderDetail.product.name}</div>
                                            <div class="product-sub">
                                                <fmt:formatNumber type="number" value="${orderDetail.price}" /> d
                                                x ${orderDetail.quantity}
                                            </div>
                                            <c:if test="${order.customerConfirmedReceived}">
                                                <div class="warranty-box">
                                                    <div class="warranty-code">Bảo hành điện tử: BH-${order.id}-${orderDetail.id}</div>
                                                    <div class="warranty-note">Áp dụng cho sản phẩm đã nhận trong đơn hàng này.</div>
                                                    <c:set var="claim" value="${warrantyClaimMap[orderDetail.id]}" />
                                                    <c:choose>
                                                        <c:when test="${not empty claim}">
                                                            <div class="mt-2">
                                                                <span class="status-pill success">Bảo hành: ${claim.statusLabel}</span>
                                                                <c:if test="${not empty claim.adminNote}">
                                                                    <div class="warranty-note mt-1"><c:out value="${claim.adminNote}" /></div>
                                                                </c:if>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form method="post" action="/warranty/request/${orderDetail.id}" class="mt-2">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                                <textarea class="form-control form-control-sm mb-2" name="issueDescription"
                                                                    rows="2" placeholder="Mo ta loi can bao hanh" required></textarea>
                                                                <button class="btn btn-outline-primary btn-sm rounded-pill" type="submit">
                                                                    Gửi yêu cầu bảo hành
                                                                </button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="line-total">
                                            <fmt:formatNumber type="number" value="${orderDetail.price * orderDetail.quantity}" /> d
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>

                        <aside class="order-actions">
                            <div class="action-panel">
                                <c:if test="${order.paymentMethod eq 'QR' and order.paymentStatus eq 'WAITING_PAYMENT'}">
                                    <form method="post" action="/order-history/${order.id}/payment-submitted" class="mb-3">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill w-100">
                                            Toi da thanh toan QR
                                        </button>
                                    </form>
                                </c:if>

                                <c:choose>
                                    <c:when test="${order.exchangeRequested and order.exchangePaymentConfirmed and not order.exchangeCompleted and order.status eq 'SHIPPING'}">
                                        <form method="post" action="/order-history/${order.id}/received" class="mb-3">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn-success btn-sm rounded-pill w-100">
                                                Đã nhận máy đổi mới
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${not order.customerConfirmedReceived and order.status eq 'SHIPPING'}">
                                        <form method="post" action="/order-history/${order.id}/received" class="mb-3">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn-success btn-sm rounded-pill w-100">
                                                Đã nhận hàng
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${not order.customerConfirmedReceived}">
                                        <div class="text-muted small mb-3">
                                            Nút nhận hàng sẽ hiện khi đơn đang giao.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-success fw-bold mb-3">Khách đã xác nhận nhận hàng</div>
                                    </c:otherwise>
                                </c:choose>

                                <c:choose>
                                    <c:when test="${order.customerConfirmedReceived and not order.returnRequested}">
                                        <form method="post" action="/order-history/${order.id}/return">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <select class="form-select form-select-sm mb-2 js-return-type" name="returnType" required>
                                                <option value="REFUND">Trả hàng hoàn tiền</option>
                                                <option value="EXCHANGE">Đổi hàng</option>
                                            </select>
                                            <div class="exchange-product-box d-none">
                                                <select class="form-select form-select-sm mb-2" name="exchangeProductId">
                                                    <option value="">Chọn sản phẩm cần đổi</option>
                                                    <c:forEach var="product" items="${exchangeProducts}">
                                                        <option value="${product.id}">
                                                            ${product.name} -
                                                            <fmt:formatNumber type="number" value="${product.price}" /> đ
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <textarea class="form-control form-control-sm mb-2" name="returnReason"
                                                rows="3" placeholder="Lý do yêu cầu" required></textarea>
                                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill w-100">
                                                Gửi yêu cầu sau bán hàng
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${order.returnRequested}">
                                        <div class="small">
                                            <strong>${order.returnTypeLabel}:</strong>
                                            <div><c:out value="${order.returnReason}" /></div>
                                            <c:choose>
                                                <c:when test="${order.exchangeRequested}">
                                                    <c:if test="${not empty order.exchangeProduct}">
                                                        <div class="text-muted mt-2">
                                                            Sản phẩm đổi sang: ${order.exchangeProduct.name}
                                                        </div>
                                                    </c:if>
                                                    <div class="text-muted mt-2">
                                                        80% giá trị máy cũ:
                                                        <fmt:formatNumber type="number" value="${order.exchangeCreditAmount}" /> đ
                                                    </div>
                                                    <c:if test="${order.exchangeNewProductPrice > 0}">
                                                        <div class="text-primary fw-bold mt-2">
                                                            Cần chuyển thêm:
                                                            <fmt:formatNumber type="number" value="${order.exchangeAdditionalAmount}" /> đ
                                                        </div>
                                                        <c:if test="${order.exchangeQrAvailable}">
                                                            <a class="btn btn-outline-primary btn-sm rounded-pill mt-2"
                                                                href="/order-history/${order.id}/exchange-qr">
                                                                Mở QR chuyển khoản
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${order.exchangeRefundAmount > 0}">
                                                            <div class="text-success fw-bold mt-2">
                                                                Shop cần hoàn lại:
                                                                <fmt:formatNumber type="number" value="${order.exchangeRefundAmount}" /> đ
                                                            </div>
                                                        </c:if>
                                                    </c:if>
                                                    <c:if test="${order.exchangePaymentConfirmed}">
                                                        <div class="text-success fw-bold mt-2">Admin đã xác nhận đủ tiền đổi máy.</div>
                                                    </c:if>
                                                    <c:if test="${order.exchangePaymentSubmitted and not order.exchangePaymentConfirmed}">
                                                        <div class="text-warning fw-bold mt-2">Đã báo chuyển khoản, chờ admin xác nhận.</div>
                                                    </c:if>
                                                    <c:if test="${order.exchangeCompleted}">
                                                        <div class="text-success fw-bold mt-2">Đã đổi máy mới cho khách hàng.</div>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="text-success fw-bold mt-2">Đã hoàn lại 70% tiền cho khách hàng.</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </div>
                        </aside>
                    </div>
                </article>
            </c:forEach>

            <c:if test="${empty orders}">
                <div class="text-center mt-5 order-card p-5">
                    <h3 class="text-danger">Bạn chưa có đơn hàng nào</h3>
                    <a href="/shop" class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase mt-4">
                        Tiếp tục mua hàng
                    </a>
                </div>
            </c:if>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top">
        <i class="fa fa-arrow-up"></i>
    </a>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/lib/easing/easing.min.js"></script>
    <script src="/lib/waypoints/waypoints.min.js"></script>
    <script src="/lib/lightbox/js/lightbox.min.js"></script>
    <script src="/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="/js/main.js"></script>
    <script>
        document.querySelectorAll('.js-return-type').forEach(function (select) {
            var form = select.closest('form');
            var box = form.querySelector('.exchange-product-box');
            var productSelect = box ? box.querySelector('select[name="exchangeProductId"]') : null;
            var syncExchangeProduct = function () {
                var isExchange = select.value === 'EXCHANGE';
                if (box) {
                    box.classList.toggle('d-none', !isExchange);
                }
                if (productSelect) {
                    productSelect.required = isExchange;
                    if (!isExchange) {
                        productSelect.value = '';
                    }
                }
            };
            select.addEventListener('change', syncExchangeProduct);
            syncExchangeProduct();
        });
    </script>
</body>

</html>
