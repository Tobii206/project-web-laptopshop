<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm</title>
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
                    <h1 class="mt-4">Sản phẩm</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">
                            <a class="text-decoration-none" href="/admin">Bảng điều khiển</a> / Sản phẩm
                        </li>
                    </ol>

                    <div class="admin-toolbar">
                        <div>
                            <h3>Danh sách laptop</h3>
                            <p>Quản lý giá, tồn kho, hãng và thông tin hiển thị trong cửa hàng.</p>
                        </div>
                        <a href="/admin/product/create" class="btn btn-primary">
                            <i class="fa-solid fa-plus"></i>Thêm sản phẩm
                        </a>
                    </div>

                    <div class="simple-table-shell table-responsive">
                        <table class="table table-bordered table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Giá</th>
                                    <th>Tồn kho</th>
                                    <th>Hãng</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                        <th>#${product.id}</th>
                                        <td class="fw-bold">${product.name}</td>
                                        <td><fmt:formatNumber type="number" value="${product.price}" /> đ</td>
                                        <td>
                                            <span class="badge ${product.quantity <= 5 ? 'bg-danger' : 'bg-success'}">${product.quantity}</span>
                                        </td>
                                        <td>${product.factory}</td>
                                        <td class="action-group">
                                            <a href="/admin/product/${product.id}" class="btn btn-success btn-sm"><i class="fa-solid fa-eye"></i>Xem</a>
                                            <a href="/admin/product/update/${product.id}" class="btn btn-warning btn-sm"><i class="fa-solid fa-pen"></i>Cập nhật</a>
                                            <a href="/admin/product/delete/${product.id}" class="btn btn-danger btn-sm"><i class="fa-solid fa-trash"></i>Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${totalPages > 0}">
                        <nav class="mt-4" aria-label="Phân trang sản phẩm">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage eq 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="/admin/product?page=${currentPage - 1}">Trước</a>
                                </li>
                                <c:forEach begin="0" end="${totalPages-1}" varStatus="loop">
                                    <li class="page-item">
                                        <a class="${(loop.index + 1) eq currentPage ? 'active' : ''} page-link" href="/admin/product?page=${loop.index+1}">${loop.index+1}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage eq (totalPages) ? 'disabled' : ''}">
                                    <a class="page-link" href="/admin/product?page=${currentPage + 1}">Sau</a>
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
