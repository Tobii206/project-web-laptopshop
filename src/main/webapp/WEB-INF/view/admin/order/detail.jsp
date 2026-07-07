<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .order-detail-page {
            color: #0f172a;
        }

        .order-hero {
            border-radius: 28px;
            padding: 28px;
            background:
                radial-gradient(circle at 15% 15%, rgba(56, 189, 248, 0.28), transparent 34%),
                radial-gradient(circle at 80% 5%, rgba(244, 114, 182, 0.22), transparent 30%),
                linear-gradient(135deg, #ffffff 0%, #eef8ff 48%, #fff7ed 100%);
            border: 1px solid rgba(148, 163, 184, 0.25);
            box-shadow: 0 24px 70px rgba(15, 23, 42, 0.10);
        }

        .order-title {
            font-size: clamp(32px, 4vw, 54px);
            font-weight: 900;
            letter-spacing: 0;
            margin: 0;
        }

        .soft-card {
            border: 1px solid rgba(148, 163, 184, 0.22);
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.88);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.08);
        }

        .metric-card {
            min-height: 116px;
            padding: 20px;
            border-radius: 22px;
            color: #0f172a;
            border: 1px solid rgba(148, 163, 184, 0.22);
            background: #ffffff;
        }

        .metric-card .icon {
            width: 44px;
            height: 44px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            color: #ffffff;
            background: linear-gradient(135deg, #0ea5e9, #2563eb);
        }

        .metric-card:nth-child(2) .icon {
            background: linear-gradient(135deg, #22c55e, #0f766e);
        }

        .metric-card:nth-child(3) .icon {
            background: linear-gradient(135deg, #f59e0b, #ef4444);
        }

        .metric-card:nth-child(4) .icon {
            background: linear-gradient(135deg, #a855f7, #2563eb);
        }

        .metric-label {
            color: #64748b;
            font-weight: 800;
            font-size: 13px;
        }

        .metric-value {
            font-weight: 900;
            font-size: 24px;
            margin-top: 8px;
        }

        .info-label {
            color: #64748b;
            font-size: 13px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .info-value {
            font-weight: 800;
            margin-top: 4px;
            word-break: break-word;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border-radius: 999px;
            padding: 8px 14px;
            font-weight: 900;
            background: #e0f2fe;
            color: #0369a1;
        }

        .status-pill.success {
            background: #dcfce7;
            color: #15803d;
        }

        .status-pill.warning {
            background: #fef3c7;
            color: #b45309;
        }

        .status-pill.danger {
            background: #fee2e2;
            color: #b91c1c;
        }

        .product-thumb {
            width: 96px;
            height: 76px;
            object-fit: contain;
            border-radius: 18px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            padding: 8px;
        }

        .detail-table th {
            background: #f1f5f9;
            color: #0f172a;
            font-weight: 900;
            padding: 18px;
        }

        .detail-table td {
            vertical-align: middle;
            padding: 18px;
        }

        .timeline-item {
            position: relative;
            padding-left: 34px;
            padding-bottom: 20px;
        }

        .timeline-item::before {
            content: "";
            position: absolute;
            left: 9px;
            top: 25px;
            bottom: 0;
            width: 2px;
            background: #dbeafe;
        }

        .timeline-item:last-child::before {
            display: none;
        }

        .timeline-dot {
            position: absolute;
            left: 0;
            top: 3px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: linear-gradient(135deg, #06b6d4, #2563eb);
            box-shadow: 0 0 0 5px #e0f2fe;
        }
    </style>
</head>

<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4 order-detail-page">
                    <div class="order-hero mt-4 mb-4">
                        <div class="d-flex flex-wrap justify-content-between align-items-start gap-3">
                            <div>
                                <div class="text-primary fw-bold mb-2">
                                    <a class="text-decoration-none" href="/admin">Bảng điều khiển</a>
                                    <span class="text-secondary">/</span>
                                    <a class="text-decoration-none" href="/admin/order">Đơn hàng</a>
                                    <span class="text-secondary">/ Chi tiết</span>
                                </div>
                                <h1 class="order-title">Đơn hàng #${order.id}</h1>
                                <p class="text-secondary fs-5 mt-2 mb-0">Theo dõi thông tin giao hàng, thanh toán và sản phẩm trong đơn.</p>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="/admin/order/update/${order.id}" class="btn btn-warning rounded-pill px-4 fw-bold">
                                    <i class="fa-solid fa-pen-to-square me-2"></i>Cập nhật
                                </a>
                                <a href="/admin/order" class="btn btn-primary rounded-pill px-4 fw-bold">
                                    <i class="fa-solid fa-arrow-left me-2"></i>Quay lại
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mb-4">
                        <div class="col-12 col-md-6 col-xl-3">
                            <div class="metric-card h-100">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <div class="metric-label">Tổng thanh toán</div>
                                        <div class="metric-value"><fmt:formatNumber type="number" value="${order.totalPrice}" /> đ</div>
                                    </div>
                                    <div class="icon"><i class="fa-solid fa-wallet"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-md-6 col-xl-3">
                            <div class="metric-card h-100">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <div class="metric-label">Số sản phẩm</div>
                                        <div class="metric-value">${totalQuantity}</div>
                                    </div>
                                    <div class="icon"><i class="fa-solid fa-box-open"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-md-6 col-xl-3">
                            <div class="metric-card h-100">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <div class="metric-label">Giảm giá</div>
                                        <div class="metric-value"><fmt:formatNumber type="number" value="${order.discountAmount}" /> đ</div>
                                    </div>
                                    <div class="icon"><i class="fa-solid fa-ticket"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-md-6 col-xl-3">
                            <div class="metric-card h-100">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <div class="metric-label">Mã vận đơn</div>
                                        <div class="metric-value fs-5">
                                            <c:choose>
                                                <c:when test="${not empty order.trackingCode}">${order.trackingCode}</c:when>
                                                <c:otherwise>Chưa có</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="icon"><i class="fa-solid fa-truck-fast"></i></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-12 col-xl-4">
                            <div class="soft-card p-4 h-100">
                                <h4 class="fw-black fw-bold mb-3"><i class="fa-solid fa-user me-2 text-primary"></i>Khách hàng</h4>
                                <div class="mb-3">
                                    <div class="info-label">Tài khoản</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty order.user.fullName}">${order.user.fullName}</c:when>
                                            <c:otherwise>Khách hàng #${order.user.id}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <div class="info-label">Email</div>
                                    <div class="info-value">${order.user.email}</div>
                                </div>
                                <div>
                                    <div class="info-label">Số điện thoại tài khoản</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty order.user.phone}">${order.user.phone}</c:when>
                                            <c:otherwise>Chưa cập nhật</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-12 col-xl-4">
                            <div class="soft-card p-4 h-100">
                                <h4 class="fw-bold mb-3"><i class="fa-solid fa-location-dot me-2 text-danger"></i>Thông tin nhận hàng</h4>
                                <div class="mb-3">
                                    <div class="info-label">Người nhận</div>
                                    <div class="info-value">${order.receiverName}</div>
                                </div>
                                <div class="mb-3">
                                    <div class="info-label">Số điện thoại</div>
                                    <div class="info-value">${order.receiverPhone}</div>
                                </div>
                                <div>
                                    <div class="info-label">Địa chỉ giao hàng</div>
                                    <div class="info-value">${order.receiverAddress}</div>
                                </div>
                            </div>
                        </div>

                        <div class="col-12 col-xl-4">
                            <div class="soft-card p-4 h-100">
                                <h4 class="fw-bold mb-3"><i class="fa-solid fa-circle-info me-2 text-success"></i>Trạng thái</h4>
                                <div class="mb-3">
                                    <div class="info-label">Đơn hàng</div>
                                    <c:choose>
                                        <c:when test="${order.status == 'COMPLETE' || order.status == 'COMPLETED'}">
                                            <span class="status-pill success">Hoàn thành</span>
                                        </c:when>
                                        <c:when test="${order.status == 'SHIPPING'}">
                                            <span class="status-pill">Đang giao hàng</span>
                                        </c:when>
                                        <c:when test="${order.status == 'CANCEL' || order.status == 'CANCELLED'}">
                                            <span class="status-pill danger">Đã hủy</span>
                                        </c:when>
                                        <c:when test="${order.status == 'CONFIRM' || order.status == 'CONFIRMED'}">
                                            <span class="status-pill success">Đã xác nhận</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-pill warning">Chờ xác nhận</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="mb-3">
                                    <div class="info-label">Thanh toán</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${order.paymentMethod == 'QR'}">QR</c:when>
                                            <c:otherwise>COD</c:otherwise>
                                        </c:choose>
                                        -
                                        <c:choose>
                                            <c:when test="${order.paymentStatus == 'PAID'}">Đã thanh toán</c:when>
                                            <c:when test="${order.paymentStatus == 'WAITING_CONFIRM'}">Chờ xác nhận</c:when>
                                            <c:when test="${order.paymentStatus == 'FAILED'}">Thanh toán thất bại</c:when>
                                            <c:otherwise>Chưa thanh toán</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div>
                                    <div class="info-label">Sau bán hàng</div>
                                    <div class="info-value">
                                        <c:if test="${order.customerConfirmedReceived}">Khách đã nhận hàng</c:if>
                                        <c:if test="${!order.customerConfirmedReceived}">Khách chưa xác nhận nhận hàng</c:if>
                                        <c:if test="${order.returnRequested}">
                                            <br>Đổi trả: ${order.returnStatus}
                                        </c:if>
                                        <c:if test="${order.warrantyCompleted}">
                                            <br>Bảo hành: Đã hoàn tất
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="soft-card p-4 mb-4">
                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-3">
                            <div>
                                <h3 class="fw-bold mb-1">Sản phẩm trong đơn</h3>
                                <div class="text-secondary">${itemCount} dòng sản phẩm, tổng ${totalQuantity} sản phẩm</div>
                            </div>
                            <div class="text-end">
                                <div class="text-secondary fw-bold">Tạm tính theo chi tiết</div>
                                <div class="fs-4 fw-bold text-primary"><fmt:formatNumber type="number" value="${calculatedTotal}" /> đ</div>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table detail-table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Thông tin</th>
                                        <th>Đơn giá</th>
                                        <th>Số lượng</th>
                                        <th class="text-end">Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="orderDetail" items="${orderDetails}">
                                        <tr>
                                            <td style="width: 130px;">
                                                <img src="/images/products/${orderDetail.product.image}" class="product-thumb" alt="${orderDetail.product.name}">
                                            </td>
                                            <td>
                                                <div class="fw-bold fs-5">${orderDetail.product.name}</div>
                                                <div class="text-secondary mt-1">
                                                    Hãng: ${orderDetail.product.factory}
                                                    <c:if test="${not empty orderDetail.product.target}">
                                                        · Nhu cầu: ${orderDetail.product.target}
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td class="fw-bold"><fmt:formatNumber type="number" value="${orderDetail.price}" /> đ</td>
                                            <td>
                                                <span class="badge rounded-pill text-bg-light border px-3 py-2">${orderDetail.quantity}</span>
                                            </td>
                                            <td class="text-end fw-bold text-primary">
                                                <fmt:formatNumber type="number" value="${orderDetail.price * orderDetail.quantity}" /> đ
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="row g-4 mb-5">
                        <div class="col-12 col-xl-5">
                            <div class="soft-card p-4 h-100">
                                <h3 class="fw-bold mb-3">Tổng kết thanh toán</h3>
                                <div class="d-flex justify-content-between py-2 border-bottom">
                                    <span class="text-secondary fw-bold">Tạm tính</span>
                                    <span class="fw-bold"><fmt:formatNumber type="number" value="${order.subtotalPrice}" /> đ</span>
                                </div>
                                <div class="d-flex justify-content-between py-2 border-bottom">
                                    <span class="text-secondary fw-bold">Phiếu giảm giá</span>
                                    <span class="fw-bold text-success">
                                        - <fmt:formatNumber type="number" value="${order.discountAmount}" /> đ
                                        <c:if test="${not empty order.voucherCode}"> (${order.voucherCode})</c:if>
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-3">
                                    <span class="fs-5 fw-bold">Khách cần thanh toán</span>
                                    <span class="fs-3 fw-bold text-primary"><fmt:formatNumber type="number" value="${order.totalPrice}" /> đ</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-xl-7">
                            <div class="soft-card p-4 h-100">
                                <h3 class="fw-bold mb-3">Lịch sử cập nhật</h3>
                                <c:choose>
                                    <c:when test="${empty statusHistory}">
                                        <div class="text-secondary">Chưa có lịch sử cập nhật trạng thái.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="history" items="${statusHistory}">
                                            <div class="timeline-item">
                                                <span class="timeline-dot"></span>
                                                <div class="fw-bold">${history.actor}</div>
                                                <div class="text-secondary">
                                                    ${history.oldStatus} → ${history.newStatus}
                                                    <c:if test="${not empty history.note}"> · ${history.note}</c:if>
                                                </div>
                                                <div class="small text-muted">${fn:replace(history.createdAt, 'T', ' ')}</div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="/js/scripts.js"></script>
    <script src="/js/datatables-simple-demo.js"></script>
</body>

</html>
