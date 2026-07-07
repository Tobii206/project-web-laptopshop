<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Đơn hàng</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">
                            <a class="text-decoration-none" href="/admin">Bảng điều khiển</a> / Đơn hàng
                        </li>
                    </ol>

                    <div class="admin-toolbar">
                        <div>
                            <h3>Danh sách đơn hàng</h3>
                            <p>Theo dõi thanh toán, giao hàng, đổi trả và trạng thái khóa đơn.</p>
                        </div>
                        <a href="/admin/order-history" class="btn btn-outline-primary">
                            <i class="fa-solid fa-clock-rotate-left"></i>Lịch sử mua hàng
                        </a>
                    </div>

                    <div class="simple-table-shell table-responsive">
                        <table class="table table-bordered table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Tổng tiền</th>
                                    <th>Khách hàng</th>
                                    <th>Trạng thái</th>
                                    <th>Sau bán hàng</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <th>#${order.id}</th>
                                        <td class="fw-bold text-primary"><fmt:formatNumber type="number" value="${order.totalPrice}" /> đ</td>
                                        <td>
                                            <div class="fw-bold">${order.user.fullName}</div>
                                            <div class="small text-muted">${order.user.email}</div>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary">${order.statusLabel}</span>
                                            <c:if test="${order.discountAmount > 0}">
                                                <div class="small text-success mt-2">
                                                    ${order.voucherCode}: -<fmt:formatNumber type="number" value="${order.discountAmount}" /> đ
                                                </div>
                                            </c:if>
                                            <div class="small mt-2">
                                                Thanh toán: <strong>${order.paymentMethod}</strong> - ${order.paymentStatusLabel}
                                            </div>
                                            <c:if test="${order.paymentMethod eq 'QR' and order.paymentStatus eq 'WAITING_CONFIRM'}">
                                                <form method="post" action="/admin/order/${order.id}/payment-status" class="mt-2 d-flex flex-wrap gap-2">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                    <button class="btn btn-success btn-sm" name="paymentStatus" value="PAID" type="submit">
                                                        <i class="fa-solid fa-check"></i>Xác nhận
                                                    </button>
                                                    <button class="btn btn-outline-danger btn-sm" name="paymentStatus" value="FAILED" type="submit">
                                                        <i class="fa-solid fa-xmark"></i>Từ chối
                                                    </button>
                                                </form>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:if test="${order.customerConfirmedReceived}">
                                                <span class="badge bg-success">Khách đã nhận hàng</span>
                                            </c:if>
                                            <c:if test="${order.warrantyCompleted}">
                                                <div class="mt-2">
                                                    <span class="badge bg-info text-dark">Bảo hành hoàn tất</span>
                                                    <div class="small text-success mt-1">Đơn đã khóa sau bảo hành.</div>
                                                </div>
                                            </c:if>
                                            <c:if test="${order.returnRequested}">
                                                <div class="mt-2">
                                                    <span class="badge bg-warning text-dark">Đổi trả: ${order.returnStatusLabel}</span>
                                                    <div class="small mt-1"><c:out value="${order.returnReason}" /></div>
                                                    <c:choose>
                                                        <c:when test="${order.returnStatus eq 'COMPLETED'}">
                                                            <div class="small text-success mt-2">Đổi trả đã hoàn tất, đơn đã khóa.</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form method="post" action="/admin/order/${order.id}/return-status" class="mt-2">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                                <select class="form-select form-select-sm mb-2" name="returnStatus">
                                                                    <option value="PENDING" ${order.returnStatus eq 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                                                                    <option value="APPROVED" ${order.returnStatus eq 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                                                                    <option value="REJECTED" ${order.returnStatus eq 'REJECTED' ? 'selected' : ''}>Từ chối</option>
                                                                    <option value="COMPLETED" ${order.returnStatus eq 'COMPLETED' ? 'selected' : ''}>Đã hoàn tất</option>
                                                                </select>
                                                                <button type="submit" class="btn btn-outline-primary btn-sm">Cập nhật đổi trả</button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:if>
                                        </td>
                                        <td class="action-group">
                                            <a href="/admin/order/${order.id}" class="btn btn-success btn-sm"><i class="fa-solid fa-eye"></i>Xem</a>
                                            <c:choose>
                                                <c:when test="${order.lockedForAdminChanges}">
                                                    <button class="btn btn-secondary btn-sm" disabled>Đã khóa</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="/admin/order/update/${order.id}" class="btn btn-warning btn-sm"><i class="fa-solid fa-pen"></i>Cập nhật</a>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:choose>
                                                <c:when test="${order.deletableByAdmin}">
                                                    <a href="/admin/order/delete/${order.id}" class="btn btn-danger btn-sm"><i class="fa-solid fa-trash"></i>Xóa</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-secondary btn-sm" disabled>Không thể xóa</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${totalPages > 0}">
                        <nav class="mt-4" aria-label="Phân trang đơn hàng">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage eq 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="/admin/order?page=${currentPage - 1}">Trước</a>
                                </li>
                                <c:forEach begin="0" end="${totalPages-1}" varStatus="loop">
                                    <li class="page-item">
                                        <a class="${(loop.index + 1) eq currentPage ? 'active' : ''} page-link" href="/admin/order?page=${loop.index+1}">${loop.index+1}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage eq (totalPages) ? 'disabled' : ''}">
                                    <a class="page-link" href="/admin/order?page=${currentPage + 1}">Sau</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="/js/scripts.js"></script>
</body>

</html>
