<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật đơn hàng</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="/css/admin-modern.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
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
                            <a style="text-decoration: none;" href="/admin">Bảng điều khiển</a> /
                            <a style="text-decoration: none;" href="/admin/order">Đơn hàng</a>
                        </li>
                    </ol>

                    <div class="mt-5">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Cập nhật đơn hàng</h3>
                                <hr />

                                <c:choose>
                                    <c:when test="${order.lockedForAdminChanges}">
                                        <div class="alert alert-warning">
                                            Đơn hàng đã bị khóa, admin không thể cập nhật trạng thái đơn này nữa.
                                            <c:if test="${order.warrantyCompleted}">
                                                <div class="mt-2">Lý do: bảo hành đã hoàn tất.</div>
                                            </c:if>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Mã đơn hàng:</label>
                                            <input type="text" class="form-control" value="${order.id}" readonly />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Tổng tiền:</label>
                                            <input type="text" class="form-control" value="${order.totalPrice}" readonly />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Trạng thái:</label>
                                            <input type="text" class="form-control" value="${order.statusLabel}" readonly />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Mã vận đơn:</label>
                                            <input type="text" class="form-control" value="${order.trackingCode}" readonly />
                                        </div>
                                        <a href="/admin/order" class="btn btn-primary">Quay lại</a>
                                    </c:when>
                                    <c:otherwise>
                                        <form:form action="/admin/order/update" method="post" modelAttribute="order">
                                            <div class="mb-3">
                                                <label class="form-label">Mã đơn hàng:</label>
                                                <form:input type="text" class="form-control" path="id" readonly="true" />
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Tổng tiền:</label>
                                                <form:input type="text" class="form-control" path="totalPrice" readonly="true" />
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Trạng thái:</label>
                                                <form:select class="form-select" path="status">
                                                    <form:option value="PENDING">Chờ xác nhận</form:option>
                                                    <form:option value="CONFIRM">Đã xác nhận</form:option>
                                                    <form:option value="SHIPPING">Đang giao hàng</form:option>
                                                    <form:option value="CANCEL">Đã hủy</form:option>
                                                </form:select>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Mã vận đơn:</label>
                                                <form:input type="text" class="form-control" path="trackingCode"
                                                    placeholder="Bỏ trống để tự sinh khi chuyển sang Đang giao hàng" />
                                            </div>
                                            <div class="d-flex justify-content-between">
                                                <button type="submit" class="btn btn-warning">Cập nhật</button>
                                                <a href="/admin/order" class="btn btn-primary">Quay lại</a>
                                            </div>
                                        </form:form>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>

</html>
