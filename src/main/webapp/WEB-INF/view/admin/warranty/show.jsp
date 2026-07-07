<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảo hành - LaptopShop Admin</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="/css/admin-modern.css" rel="stylesheet" />
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
                    <h1 class="mt-4">Bảo hành điện tử</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">Xử lý yêu cầu bảo hành từ khách hàng</li>
                    </ol>
                    <div class="admin-toolbar">
                        <div>
                            <h3>Danh sách phiếu bảo hành</h3>
                            <p>Theo dõi sản phẩm lỗi, cập nhật trạng thái xử lý và khóa đơn sau khi hoàn tất.</p>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header">
                            <i class="fas fa-shield-alt me-2"></i>Phiếu bảo hành
                        </div>
                        <div class="card-body table-responsive">
                            <table class="table table-bordered align-middle">
                                <thead>
                                    <tr>
                                        <th>Mã</th>
                                        <th>Khách hàng</th>
                                        <th>Sản phẩm</th>
                                        <th>Đơn hàng</th>
                                        <th>Lý do</th>
                                        <th>Trạng thái</th>
                                        <th>Cập nhật</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${claims}" var="claim">
                                        <tr>
                                            <td>#BH${claim.id}</td>
                                            <td>
                                                <strong>${claim.user.fullName}</strong><br>
                                                <span class="text-muted small">${claim.user.email}</span>
                                            </td>
                                            <td>${claim.orderDetail.product.name}</td>
                                            <td>#${claim.orderDetail.order.id}</td>
                                            <td><c:out value="${claim.issueDescription}" /></td>
                                            <td>
                                                <span class="badge bg-info">${claim.statusLabel}</span>
                                                <c:if test="${not empty claim.adminNote}">
                                                    <div class="small text-muted mt-1"><c:out value="${claim.adminNote}" /></div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${claim.status eq 'COMPLETED'}">
                                                        <span class="badge bg-secondary">Đã khóa</span>
                                                        <div class="small text-success mt-2">
                                                            Phiếu bảo hành đã hoàn tất, không thể cập nhật nữa.
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form method="post" action="/admin/warranty/${claim.id}/status">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <select name="status" class="form-select form-select-sm mb-2">
                                                                <option value="PENDING" ${claim.status eq 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                                                                <option value="APPROVED" ${claim.status eq 'APPROVED' ? 'selected' : ''}>Đã tiếp nhận</option>
                                                                <option value="PROCESSING" ${claim.status eq 'PROCESSING' ? 'selected' : ''}>Đang bảo hành</option>
                                                                <option value="COMPLETED" ${claim.status eq 'COMPLETED' ? 'selected' : ''}>Đã hoàn tất</option>
                                                                <option value="REJECTED" ${claim.status eq 'REJECTED' ? 'selected' : ''}>Từ chối</option>
                                                            </select>
                                                            <input name="adminNote" class="form-control form-control-sm mb-2"
                                                                placeholder="Ghi chú admin" value="${claim.adminNote}">
                                                            <button class="btn btn-primary btn-sm" type="submit"><i class="fa-solid fa-floppy-disk"></i>Lưu</button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty claims}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted">Chưa có yêu cầu bảo hành.</td>
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
