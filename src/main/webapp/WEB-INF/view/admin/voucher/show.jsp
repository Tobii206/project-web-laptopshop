<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý phiếu giảm giá</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Phiếu giảm giá</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">Thêm, sửa, xóa và bật/tắt voucher tự áp dụng cho khách hàng</li>
                    </ol>

                    <div class="row g-4">
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header"><i class="fa-solid fa-ticket me-2"></i>Thông tin voucher</div>
                                <div class="card-body">
                                    <form:form method="post" action="/admin/voucher/save" modelAttribute="voucher">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <form:hidden path="id" />
                                        <div class="mb-3">
                                            <label class="form-label">Mã voucher</label>
                                            <form:input path="code" class="form-control" required="true" />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Tên hiển thị</label>
                                            <form:input path="name" class="form-control" required="true" />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Kiểu giảm</label>
                                            <form:select path="discountType" class="form-select">
                                                <form:option value="PERCENT">Theo phần trăm (%)</form:option>
                                                <form:option value="FIXED">Theo số tiền</form:option>
                                            </form:select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Giá trị giảm</label>
                                            <form:input path="discountValue" type="number" step="0.01" class="form-control" required="true" />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Giảm tối đa</label>
                                            <form:input path="maxDiscount" type="number" step="1000" class="form-control" />
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Đơn tối thiểu</label>
                                            <form:input path="minOrderValue" type="number" step="1000" class="form-control" />
                                        </div>
                                        <div class="form-check mb-3">
                                            <form:checkbox path="active" class="form-check-input" />
                                            <label class="form-check-label">Đang bật</label>
                                        </div>
                                        <button class="btn btn-primary" type="submit"><i class="fa-solid fa-floppy-disk"></i>Lưu voucher</button>
                                        <a href="/admin/voucher" class="btn btn-outline-secondary">Làm mới</a>
                                    </form:form>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header"><i class="fa-solid fa-list-check me-2"></i>Danh sách voucher</div>
                                <div class="card-body table-responsive">
                                    <table class="table table-bordered align-middle">
                                        <thead>
                                            <tr>
                                                <th>Code</th>
                                                <th>Kiểu</th>
                                                <th>Giá trị</th>
                                                <th>Đơn tối thiểu</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${vouchers}" var="item">
                                                <tr>
                                                    <td>
                                                        <strong>${item.code}</strong>
                                                        <div class="small text-muted">${item.name}</div>
                                                    </td>
                                                    <td>${item.discountType}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${item.discountType eq 'PERCENT'}">${item.discountValue}%</c:when>
                                                            <c:otherwise><fmt:formatNumber type="number" value="${item.discountValue}" /> đ</c:otherwise>
                                                        </c:choose>
                                                        <c:if test="${item.maxDiscount > 0}">
                                                            <div class="small text-muted">Tối đa <fmt:formatNumber type="number" value="${item.maxDiscount}" /> đ</div>
                                                        </c:if>
                                                    </td>
                                                    <td><fmt:formatNumber type="number" value="${item.minOrderValue}" /> đ</td>
                                                    <td>
                                                        <span class="badge ${item.active ? 'bg-success' : 'bg-secondary'}">
                                                            ${item.active ? 'ON' : 'OFF'}
                                                        </span>
                                                    </td>
                                                    <td class="d-flex flex-wrap gap-2">
                                                        <a href="/admin/voucher/update/${item.id}" class="btn btn-warning btn-sm"><i class="fa-solid fa-pen"></i>Sửa</a>
                                                        <form method="post" action="/admin/voucher/toggle/${item.id}">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <button class="btn btn-outline-primary btn-sm" type="submit">Bật/Tắt</button>
                                                        </form>
                                                        <form method="post" action="/admin/voucher/delete">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <input type="hidden" name="id" value="${item.id}" />
                                                            <button class="btn btn-danger btn-sm" type="submit"><i class="fa-solid fa-trash"></i>Xóa</button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="/js/scripts.js"></script>
</body>
</html>
