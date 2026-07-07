<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tai Khoan - LaptopShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
    <link href="/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>

<body>
    <div id="spinner"
        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-grow text-primary" role="status"></div>
    </div>

    <jsp:include page="../layout/header.jsp" />

    <div class="container-fluid page-header py-5">
        <h1 class="text-center text-white display-6">Tai Khoan Cua Toi</h1>
        <ol class="breadcrumb justify-content-center mb-0">
            <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
            <li class="breadcrumb-item active text-white">Tai khoan</li>
        </ol>
    </div>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-body p-5">
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success">${successMessage}</div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger">${errorMessage}</div>
                        </c:if>

                        <form:form action="/account/update" method="post" modelAttribute="accountForm" enctype="multipart/form-data">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="row g-4">
                                <div class="col-lg-4">
                                    <div class="border rounded-4 p-4 h-100 text-center bg-light">
                                        <img src="/images/avatar/${currentUser.avatar}" alt="${currentUser.fullName}"
                                            style="width: 170px; height: 170px; border-radius: 50%; object-fit: cover;">
                                        <h4 class="mt-3 mb-1">${currentUser.fullName}</h4>
                                        <div class="text-muted mb-3">${currentUser.role.name}</div>
                                        <label for="avatarFile" class="form-label fw-semibold">Avatar moi</label>
                                        <input id="avatarFile" name="avatarFile" type="file" class="form-control">
                                    </div>
                                </div>
                                <div class="col-lg-8">
                                    <div class="border rounded-4 p-4 h-100">
                                        <h4 class="mb-4">Thong tin ca nhan</h4>
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <label class="form-label">Email</label>
                                                <input class="form-control" value="${currentUser.email}" disabled>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Vai tro</label>
                                                <input class="form-control" value="${currentUser.role.name}" disabled>
                                            </div>
                                            <div class="col-12">
                                                <label class="form-label">Họ tên</label>
                                                <form:input path="fullName" class="form-control" />
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Số điện thoại</label>
                                                <form:input path="phone" class="form-control" />
                                            </div>
                                            <div class="col-12">
                                                <label class="form-label">Địa chỉ</label>
                                                <form:textarea path="address" class="form-control" rows="3" />
                                            </div>
                                        </div>

                                        <div class="mt-4 d-flex gap-3 flex-wrap">
                                            <button type="submit" class="btn border-secondary rounded-pill px-4 py-2 text-primary">
                                                Luu thay doi
                                            </button>
                                            <a href="/order-history" class="btn border-secondary rounded-pill px-4 py-2 text-primary">
                                                Lịch sử mua hàng
                                            </a>
                                            <a href="/shop" class="btn border-secondary rounded-pill px-4 py-2 text-primary">
                                                Tiep Tuc Mua Sam
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i
            class="fa fa-arrow-up"></i></a>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/lib/easing/easing.min.js"></script>
    <script src="/lib/waypoints/waypoints.min.js"></script>
    <script src="/lib/lightbox/js/lightbox.min.js"></script>
    <script src="/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="/js/main.js"></script>
</body>

</html>
