<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>LaptopShop Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>

<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Bảng điều khiển</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">Tổng quan vận hành LaptopShop</li>
                    </ol>

                    <div class="row g-4">
                        <div class="col-xl-4 col-md-6">
                            <div class="card bg-primary text-white mb-4 admin-stat-card">
                                <div class="card-body">
                                    <i class="fas fa-users me-2"></i>Người dùng
                                    <span class="admin-stat-number">${totalUsers}</span>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="small text-white stretched-link" href="/admin/user">Xem chi tiết</a>
                                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-md-6">
                            <div class="card bg-warning text-white mb-4 admin-stat-card">
                                <div class="card-body">
                                    <i class="fas fa-laptop me-2"></i>Sản phẩm
                                    <span class="admin-stat-number">${totalProducts}</span>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="small text-white stretched-link" href="/admin/product">Xem chi tiết</a>
                                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-md-6">
                            <div class="card bg-success text-white mb-4 admin-stat-card">
                                <div class="card-body">
                                    <i class="fas fa-receipt me-2"></i>Đơn hàng
                                    <span class="admin-stat-number">${totalOrders}</span>
                                </div>
                                <div class="card-footer d-flex align-items-center justify-content-between">
                                    <a class="small text-white stretched-link" href="/admin/order">Xem chi tiết</a>
                                    <div class="small text-white"><i class="fas fa-angle-right"></i></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card mb-4">
                        <div class="card-header">
                            <i class="fas fa-boxes-stacked me-2"></i>
                            Cảnh báo tồn kho thấp
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty lowStockProducts}">
                                    <div class="admin-empty-state">Không có sản phẩm sắp hết hàng.</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-sm align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Sản phẩm</th>
                                                    <th>Hãng</th>
                                                    <th>Tồn kho</th>
                                                    <th>Đã bán</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="product" items="${lowStockProducts}">
                                                    <tr>
                                                        <td class="fw-bold">${product.name}</td>
                                                        <td>${product.factory}</td>
                                                        <td><span class="badge bg-danger">${product.quantity}</span></td>
                                                        <td>${product.sold}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>

</html>
