<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LaptopShop</title>
    <!-- Latest compiled and minified CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Latest compiled JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
        rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
        rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
    <link href="/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">


    <!-- Customized Bootstrap Stylesheet -->
    <link href="/css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="/css/style.css" rel="stylesheet">
</head>

<body>

    <!-- Spinner Start -->
    <div id="spinner"
        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
        <div class="spinner-grow text-primary" role="status"></div>
    </div>
    <!-- Spinner End -->


    <!-- Navbar start -->
    <jsp:include page="../layout/header.jsp" />
    <!-- Navbar End -->

    <div style="margin-top: 145px;"></div>


    <!-- Fruits Cửa hàng Start-->
    <div class="container-fluid fruite py-5">
        <div class="container py-5">
            <div class="row g-4">
                <div class="col-12 col-md-3">
                    <form action="/shop" method="get" class="row g-4">
                        <div class="col-12">
                            <div class="mb-2"><b>Tìm kiếm</b></div>
                            <input type="search" class="form-control" name="keyword" value="${keyword}" placeholder="Nhập tên, hang, mo ta...">
                        </div>
                        <div class="col-12">
                            <div class="mb-2"><b>Hãng sản xuất</b></div>
                            <div class="row g-4">
                                <div class="col-4">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="factory-1" name="factory" value="APPLE" ${selectedFactories.contains('APPLE') ? 'checked' : ''}>
                                        <label class="form-check-label" for="factory-1">Apple</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="factory-2" name="factory" value="ASUS" ${selectedFactories.contains('ASUS') ? 'checked' : ''}>
                                        <label class="form-check-label" for="factory-2">Asus</label>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="factory-4" name="factory" value="DELL" ${selectedFactories.contains('DELL') ? 'checked' : ''}>
                                        <label class="form-check-label" for="factory-4">Dell</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="factory-5" name="factory" value="LG" ${selectedFactories.contains('LG') ? 'checked' : ''}>
                                        <label class="form-check-label" for="factory-5">LG</label>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="factory-3" name="factory" value="LENOVO" ${selectedFactories.contains('LENOVO') ? 'checked' : ''}>
                                        <label class="form-check-label" for="factory-3">Lenovo</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="factory-6" name="factory" value="ACER" ${selectedFactories.contains('ACER') ? 'checked' : ''}>
                                        <label class="form-check-label" for="factory-6">Acer</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="mb-2"><b>Mục đích sử dụng</b></div>
                            <div class="row g-4">
                                <div class="col-6">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="target-1" name="target" value="GAMING" ${selectedTargets.contains('GAMING') ? 'checked' : ''}>
                                        <label class="form-check-label" for="target-1">Gaming</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="target-4" name="target" value="MONG-NHE" ${selectedTargets.contains('MONG-NHE') ? 'checked' : ''}>
                                        <label class="form-check-label" for="target-4">Mỏng nhẹ</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="target-5" name="target" value="DOANH-NHAN" ${selectedTargets.contains('DOANH-NHAN') ? 'checked' : ''}>
                                        <label class="form-check-label" for="target-5">Doanh nhân</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="target-2" name="target" value="SINHVIEN-VANPHONG" ${selectedTargets.contains('SINHVIEN-VANPHONG') ? 'checked' : ''}>
                                        <label class="form-check-label" for="target-2">Văn phòng</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="target-3" name="target" value="THIET-KE-DO-HOA" ${selectedTargets.contains('THIET-KE-DO-HOA') ? 'checked' : ''}>
                                        <label class="form-check-label" for="target-3">Đồ họa</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="mb-2"><b>Mức giá</b></div>
                            <div class="row g-4">
                                <div class="col-6">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="price-2" name="price" value="duoi-10-trieu" ${selectedPrices.contains('duoi-10-trieu') ? 'checked' : ''}>
                                        <label class="form-check-label" for="price-2">&le; 10 triệu</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="price-3" name="price" value="10-15-trieu" ${selectedPrices.contains('10-15-trieu') ? 'checked' : ''}>
                                        <label class="form-check-label" for="price-3">10 - 15 triệu</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="price-4" name="price" value="15-20-trieu" ${selectedPrices.contains('15-20-trieu') ? 'checked' : ''}>
                                        <label class="form-check-label" for="price-4">15 - 20 triệu</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="checkbox" id="price-5" name="price" value="tren-20-trieu" ${selectedPrices.contains('tren-20-trieu') ? 'checked' : ''}>
                                        <label class="form-check-label" for="price-5">&ge; 20 triệu</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="mb-2"><b>Sắp xếp</b></div>
                            <div class="row g-4">
                                <div class="col-6">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" id="sort-1" value="gia-tang-dan" name="sort" ${selectedSort eq 'gia-tang-dan' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sort-1">Giá tăng dần</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" id="sort-2" value="gia-giam-dan" name="sort" ${selectedSort eq 'gia-giam-dan' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sort-2">Giá giảm dần</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" id="sort-3" value="gia-nothing" name="sort" ${selectedSort eq 'gia-nothing' ? 'checked' : ''}>
                                        <label class="form-check-label" for="sort-3">Không sắp xếp</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 d-flex justify-content-center gap-2">
                            <button type="submit"
                                class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase mb-4">
                                Lọc sản phẩm
                            </button>
                            <a href="/shop"
                                class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase mb-4">
                                Bỏ lọc
                            </a>
                        </div>
                    </form>
                </div>
                <div class="col-lg-9">
                    <div class="row g-4">
                        <c:forEach var="pr" items="${prs}">
                            <div class="col-md-6 col-lg-4 col-xl-4">
                                <div class="rounded position-relative fruite-item">
                                    <div class="fruite-img">
                                        <img src="/images/products/${pr.image}" class="img-fluid w-100 rounded-top" alt="">
                                    </div>
                                    <div class="text-white bg-secondary px-3 py-1 rounded position-absolute"
                                        style="top: 10px; left: 10px;">${pr.displayTarget}</div>
                                    <div
                                        class="p-4 border border-secondary border-top-0 rounded-bottom">
                                        <h4> <a href="/product/${pr.id}">${pr.name}</a> </h4>
                                        <p>${pr.displayShortDesc}</p>
                                        <p class="text-muted mb-2">Còn lại: ${pr.quantity} sản phẩm</p>
                                        <c:if test="${pr.quantity <= 0}">
                                            <span class="badge bg-danger mb-2">Hết hàng</span>
                                        </c:if>
                                        <div
                                            class="d-flex justify-content-between flex-lg-wrap">
                                            <p class="text-dark fs-5 fw-bold mb-0">$ <fmt:formatNumber type="number" value="${pr.price}" /> </p>
                                            <form action="/add-product-to-cart/${pr.id}" method="post">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <button class="btn border border-secondary rounded-pill px-3 text-primary"
                                                    ${pr.quantity <= 0 ? 'disabled' : ''}><i
                                                        class="fa fa-shopping-bag me-2 text-primary"></i> Thêm
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="col-12">
                        <c:if test="${totalPages > 0}">
                            <nav aria-label="...">
                                <ul class="pagination d-flex justify-content-center mt-5">
                                    <li class="page-item ${currentPage eq 1 ? 'disabled' : ''}">
                                        <c:url var="prevUrl" value="/shop">
                                            <c:param name="page" value="${currentPage - 1}" />
                                            <c:param name="keyword" value="${keyword}" />
                                            <c:forEach var="factory" items="${selectedFactories}">
                                                <c:param name="factory" value="${factory}" />
                                            </c:forEach>
                                            <c:forEach var="target" items="${selectedTargets}">
                                                <c:param name="target" value="${target}" />
                                            </c:forEach>
                                            <c:forEach var="price" items="${selectedPrices}">
                                                <c:param name="price" value="${price}" />
                                            </c:forEach>
                                            <c:param name="sort" value="${selectedSort}" />
                                        </c:url>
                                        <a class="page-link rounded" href="${prevUrl}">&laquo;</a>
                                    </li>
                                    <c:forEach begin="0" end="${totalPages-1}" varStatus="loop">
                                        <li>
                                            <c:url var="pageUrl" value="/shop">
                                                <c:param name="page" value="${loop.index + 1}" />
                                                <c:param name="keyword" value="${keyword}" />
                                                <c:forEach var="factory" items="${selectedFactories}">
                                                    <c:param name="factory" value="${factory}" />
                                                </c:forEach>
                                                <c:forEach var="target" items="${selectedTargets}">
                                                    <c:param name="target" value="${target}" />
                                                </c:forEach>
                                                <c:forEach var="price" items="${selectedPrices}">
                                                    <c:param name="price" value="${price}" />
                                                </c:forEach>
                                                <c:param name="sort" value="${selectedSort}" />
                                            </c:url>
                                            <a class="${(loop.index + 1) eq currentPage ? 'active' : ''} page-link rounded" href="${pageUrl}">${loop.index+1}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage eq (totalPages) ? 'disabled' : ''}">
                                        <c:url var="nextUrl" value="/shop">
                                            <c:param name="page" value="${currentPage + 1}" />
                                            <c:param name="keyword" value="${keyword}" />
                                            <c:forEach var="factory" items="${selectedFactories}">
                                                <c:param name="factory" value="${factory}" />
                                            </c:forEach>
                                            <c:forEach var="target" items="${selectedTargets}">
                                                <c:param name="target" value="${target}" />
                                            </c:forEach>
                                            <c:forEach var="price" items="${selectedPrices}">
                                                <c:param name="price" value="${price}" />
                                            </c:forEach>
                                            <c:param name="sort" value="${selectedSort}" />
                                        </c:url>
                                        <a class="page-link rounded" href="${nextUrl}">&raquo;</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- Fruits Cửa hàng End-->

    <!-- Featurs Section Start -->
    <jsp:include page="../layout/feature.jsp" />
    <!-- Featurs Section End -->

    <!-- Footer Start -->
    <jsp:include page="../layout/footer.jsp" />
    <!-- Footer End -->


    <!-- Quay lại to Top -->
    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i
            class="fa fa-arrow-up"></i></a>


    <!-- JavaScript Libraries -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/lib/easing/easing.min.js"></script>
    <script src="/lib/waypoints/waypoints.min.js"></script>
    <script src="/lib/lightbox/js/lightbox.min.js"></script>
    <script src="/lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- Template Javascript -->
    <script src="/js/main.js"></script>
</body>

</html>

