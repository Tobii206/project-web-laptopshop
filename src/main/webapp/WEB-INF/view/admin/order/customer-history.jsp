<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Lịch sử mua của khách hàng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="/css/admin-modern.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        .history-filter {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
            padding: 18px;
        }

        .history-table td {
            vertical-align: top;
        }

        .product-list {
            min-width: 280px;
            max-width: 420px;
        }

        .product-line {
            border-bottom: 1px dashed #e5e7eb;
            padding: 4px 0;
        }

        .product-line:last-child {
            border-bottom: 0;
        }
    </style>
</head>

<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mt-4 mb-3">
                        <div>
                            <h1 class="mb-1">Lịch sử mua của khách hàng</h1>
                            <div class="text-muted">
                                <c:choose>
                                    <c:when test="${not empty customer.fullName}">${customer.fullName}</c:when>
                                    <c:otherwise>Khách hàng #${customer.id}</c:otherwise>
                                </c:choose>
                                <span> - ${customer.email}</span>
                            </div>
                        </div>
                        <a href="/admin/order-history" class="btn btn-outline-secondary">
                            <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách khách
                        </a>
                    </div>

                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a class="text-decoration-none" href="/admin">Bảng điều khiển</a></li>
                        <li class="breadcrumb-item"><a class="text-decoration-none" href="/admin/order-history">Lịch sử mua hàng</a></li>
                        <li class="breadcrumb-item active">${customer.email}</li>
                    </ol>

                    <form action="/admin/order-history/customer/${customer.id}" method="get"
                        class="history-filter row g-3 align-items-end mb-4">
                        <div class="col-lg-4 col-md-6">
                            <label class="form-label fw-bold">Thời gian</label>
                            <select class="form-select" name="range">
                                <option value="all" ${activeRange eq 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="day" ${activeRange eq 'day' ? 'selected' : ''}>24 giờ qua</option>
                                <option value="week" ${activeRange eq 'week' ? 'selected' : ''}>7 ngày qua</option>
                                <option value="month" ${activeRange eq 'month' ? 'selected' : ''}>30 ngày qua</option>
                                <option value="year" ${activeRange eq 'year' ? 'selected' : ''}>12 tháng qua</option>
                            </select>
                        </div>
                        <div class="col-lg-5 col-md-6">
                            <label class="form-label fw-bold">Mã vận đơn</label>
                            <input class="form-control" name="trackingCode" value="${trackingCode}"
                                placeholder="VD: LTS20260704000012">
                        </div>
                        <div class="col-lg-3 col-md-12 d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-fill">
                                <i class="fa-solid fa-filter"></i> Lọc
                            </button>
                            <a href="/admin/order-history/customer/${customer.id}" class="btn btn-outline-secondary">Xóa lọc</a>
                        </div>
                    </form>

                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-history me-1"></i> Các đơn đã mua</span>
                            <span class="badge bg-primary">${fn:length(orders)} đơn</span>
                        </div>
                        <div class="card-body table-responsive">
                            <table class="table table-bordered table-hover history-table">
                                <thead>
                                    <tr>
                                        <th>Đơn</th>
                                        <th>Thời gian</th>
                                        <th>Sản phẩm</th>
                                        <th>Thanh toán</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-primary">#${order.id}</div>
                                                <c:if test="${not empty order.trackingCode}">
                                                    <div class="small text-muted">${order.trackingCode}</div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty order.createdAt}">
                                                        ${fn:replace(fn:substring(order.createdAt, 0, 16), 'T', ' ')}
                                                    </c:when>
                                                    <c:otherwise>Chưa có</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="product-list">
                                                    <c:forEach var="orderDetail" items="${orderDetails}">
                                                        <c:if test="${orderDetail.order.id == order.id}">
                                                            <div class="product-line">
                                                                <div class="fw-bold">${orderDetail.product.name}</div>
                                                                <div class="small text-muted">
                                                                    <fmt:formatNumber type="number" value="${orderDetail.price}" /> đ
                                                                    x ${orderDetail.quantity}
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="fw-bold"><fmt:formatNumber type="number" value="${order.totalPrice}" /> đ</div>
                                                <div class="small text-muted">${order.paymentMethod} - ${order.paymentStatusLabel}</div>
                                                <c:if test="${order.discountAmount > 0}">
                                                    <div class="small text-success">
                                                        ${order.voucherCode}: -<fmt:formatNumber type="number" value="${order.discountAmount}" /> đ
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge bg-primary">${order.statusLabel}</span>
                                                <c:if test="${order.customerConfirmedReceived}">
                                                    <div class="small text-success mt-2">Khách đã nhận hàng</div>
                                                </c:if>
                                                <c:if test="${order.returnRequested}">
                                                    <div class="small text-warning mt-2">${order.returnTypeLabel}: ${order.returnStatusLabel}</div>
                                                    <c:choose>
                                                        <c:when test="${order.exchangeRequested}">
                                                            <c:if test="${not empty order.exchangeProduct}">
                                                                <div class="small text-muted mt-1">
                                                                    Đổi sang: ${order.exchangeProduct.name}
                                                                </div>
                                                            </c:if>
                                                            <div class="small text-muted mt-1">
                                                                80% máy cũ:
                                                                <fmt:formatNumber type="number" value="${order.exchangeCreditAmount}" /> đ
                                                            </div>
                                                            <c:if test="${order.exchangeNewProductPrice > 0}">
                                                                <c:choose>
                                                                    <c:when test="${order.exchangeAdditionalAmount > 0}">
                                                                        <div class="small text-primary">
                                                                            Cần chuyển thêm:
                                                                            <fmt:formatNumber type="number" value="${order.exchangeAdditionalAmount}" /> đ
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${order.exchangeRefundAmount > 0}">
                                                                        <div class="small text-success">
                                                                            Cần hoàn cho khách:
                                                                            <fmt:formatNumber type="number" value="${order.exchangeRefundAmount}" /> đ
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="small text-success">Không phát sinh chênh lệch.</div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:if>
                                                            <c:if test="${order.exchangePaymentConfirmed}">
                                                                <div class="small text-success mt-1">Đã xác nhận đủ tiền.</div>
                                                            </c:if>
                                                            <c:if test="${order.exchangePaymentSubmitted and not order.exchangePaymentConfirmed}">
                                                                <div class="small text-warning mt-1">Khách đã báo chuyển khoản, chờ xác nhận.</div>
                                                            </c:if>
                                                            <c:if test="${order.exchangeCompleted}">
                                                                <div class="small text-success mt-1">Đã đổi máy mới cho khách hàng.</div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="small text-success mt-1">Đã hoàn lại 70% tiền cho khách hàng.</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                                <c:if test="${not empty order.cancelReason}">
                                                    <div class="small text-danger mt-2">
                                                        <c:out value="${order.cancelReason}" />
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <a href="/admin/order/${order.id}" class="btn btn-success btn-sm">
                                                    <i class="fa-solid fa-eye"></i> Chi tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty orders}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-5">
                                                Khách hàng này chưa có đơn phù hợp.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
</body>

</html>
