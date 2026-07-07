<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng</title>
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
                    <h1 class="mt-4">Người dùng</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">
                            <a class="text-decoration-none" href="/admin">Bảng điều khiển</a> / Người dùng
                        </li>
                    </ol>

                    <div class="admin-toolbar">
                        <div>
                            <h3>Danh sách tài khoản</h3>
                            <p>Quản lý thông tin khách hàng, quản trị viên và phân quyền hệ thống.</p>
                        </div>
                        <a href="/admin/user/create" class="btn btn-primary">
                            <i class="fa-solid fa-user-plus"></i>Thêm người dùng
                        </a>
                    </div>

                    <div class="simple-table-shell table-responsive">
                        <table class="table table-bordered table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Email</th>
                                    <th>Họ tên</th>
                                    <th>Vai trò</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <th>#${user.id}</th>
                                        <td class="fw-bold">${user.email}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty user.fullName}">${user.fullName}</c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge ${user.role.name eq 'ADMIN' ? 'bg-primary' : 'bg-success'}">${user.role.name}</span>
                                        </td>
                                        <td class="action-group">
                                            <a href="/admin/user/${user.id}" class="btn btn-success btn-sm"><i class="fa-solid fa-eye"></i>Xem</a>
                                            <a href="/admin/user/update/${user.id}" class="btn btn-warning btn-sm"><i class="fa-solid fa-pen"></i>Cập nhật</a>
                                            <a href="/admin/user/delete/${user.id}" class="btn btn-danger btn-sm"><i class="fa-solid fa-trash"></i>Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${totalPages > 0}">
                        <nav class="mt-4" aria-label="Phân trang người dùng">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage eq 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="/admin/user?page=${currentPage - 1}">Trước</a>
                                </li>
                                <c:forEach begin="0" end="${totalPages-1}" varStatus="loop">
                                    <li class="page-item">
                                        <a class="${(loop.index + 1) eq currentPage ? 'active' : ''} page-link" href="/admin/user?page=${loop.index+1}">${loop.index+1}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage eq (totalPages) ? 'disabled' : ''}">
                                    <a class="page-link" href="/admin/user?page=${currentPage + 1}">Sau</a>
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
