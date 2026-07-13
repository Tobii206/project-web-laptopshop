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
    <title>Lịch sử mua hàng - Admin</title>
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

        .customer-table td {
            vertical-align: middle;
        }

        .status-summary {
            min-width: 230px;
        }

        .status-summary .badge {
            margin: 2px 4px 2px 0;
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
                            <h1 class="mb-1">Lịch sử mua hàng</h1>
                            <div class="text-muted">Gom đơn hàng theo từng khách hàng.</div>
                        </div>
                        <a href="/admin/order" class="btn btn-outline-secondary">
                            <i class="fa-solid fa-arrow-left"></i> Quay lại đơn hàng
                        </a>
                    </div>

                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a class="text-decoration-none" href="/admin">Bảng điều khiển</a></li>
                        <li class="breadcrumb-item"><a class="text-decoration-none" href="/admin/order">Đơn hàng</a></li>
                        <li class="breadcrumb-item active">Lịch sử mua hàng</li>
                    </ol>

                    <form action="/admin/order-history" method="get" class="history-filter row g-3 align-items-end mb-4">
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label fw-bold">Thời gian phát sinh đơn</label>
                            <select class="form-select" name="range">
                                <option value="all" ${activeRange eq 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="day" ${activeRange eq 'day' ? 'selected' : ''}>24 giờ qua</option>
                                <option value="week" ${activeRange eq 'week' ? 'selected' : ''}>7 ngày qua</option>
                                <option value="month" ${activeRange eq 'month' ? 'selected' : ''}>30 ngày qua</option>
                                <option value="year" ${activeRange eq 'year' ? 'selected' : ''}>12 tháng qua</option>
                            </select>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label fw-bold">Khách hàng</label>
                            <input class="form-control" name="customerKeyword" value="${customerKeyword}"
                                placeholder="Tên, email hoặc SĐT">
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label fw-bold">Mã vận đơn</label>
                            <input class="form-control" name="trackingCode" value="${trackingCode}"
                                placeholder="VD: LTS20260704000012">
                        </div>
                        <div class="col-lg-3 col-md-6 d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-fill">
                                <i class="fa-solid fa-filter"></i> Lọc
                            </button>
                            <a href="/admin/order-history" class="btn btn-outline-secondary">Xóa lọc</a>
                        </div>
                    </form>

                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-users me-1"></i> Khách hàng đã mua</span>
                            <span class="badge bg-primary">${fn:length(customerHistories)} khách</span>
                        </div>
                        <div class="card-body table-responsive">
                            <table class="table table-bordered table-hover customer-table">
                                <thead>
                                    <tr>
                                        <th>Khách hàng</th>
                                        <th>Số đơn</th>
                                        <th>Tổng đã mua</th>
                                        <th>Thống kê trạng thái</th>
                                        <th>Đơn gần nhất</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="history" items="${customerHistories}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold">
                                                    <c:choose>
                                                        <c:when test="${not empty history.user.fullName}">${history.user.fullName}</c:when>
                                                        <c:otherwise>Khách hàng #${history.user.id}</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="small text-muted">${history.user.email}</div>
                                                <c:if test="${not empty history.user.phone}">
                                                    <div class="small text-muted">${history.user.phone}</div>
                                                </c:if>
                                            </td>
                                            <td><span class="badge bg-primary">${history.orderCount} đơn</span></td>
                                            <td class="fw-bold text-primary">
                                                <fmt:formatNumber type="number" value="${history.totalSpent}" /> đ
                                            </td>
                                            <td>
                                                <div class="status-summary">
                                                    <span class="badge bg-success">Hoàn thành: ${history.completedOrderCount}</span>
                                                    <span class="badge bg-info text-dark">Đang ship: ${history.shippingOrderCount}</span>
                                                    <span class="badge bg-danger">Đã hủy: ${history.cancelledOrderCount}</span>
                                                    <span class="badge bg-warning text-dark">Đổi trả: ${history.returnOrderCount}</span>
                                                    <span class="badge bg-secondary">Đổi hàng: ${history.exchangeOrderCount}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="fw-bold">#${history.lastOrder.id} - ${history.lastOrder.statusLabel}</div>
                                                <c:if test="${not empty history.lastOrderAt}">
                                                    <div class="small text-muted">
                                                        ${fn:replace(fn:substring(history.lastOrderAt, 0, 16), 'T', ' ')}
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <a href="/admin/order-history/customer/${history.user.id}" class="btn btn-success btn-sm">
                                                    <i class="fa-solid fa-clock-rotate-left"></i> Xem lịch sử
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty customerHistories}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-5">
                                                Không có khách hàng phù hợp.
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
