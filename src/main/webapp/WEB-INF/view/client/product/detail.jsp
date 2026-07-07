<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - LaptopShop</title>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

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


    <!-- Single Page Header start -->
    <div class="container-fluid page-header py-5">
        <h1 class="text-center text-white display-6">Cửa hàng Chi tiết</h1>
        <ol class="breadcrumb justify-content-center mb-0">
            <li class="breadcrumb-item"><a href="#">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="#">Trang</a></li>
            <li class="breadcrumb-item active text-white">Cửa hàng Chi tiết</li>
        </ol>
    </div>
    <!-- Single Page Header End -->


    <!-- Single Sản phẩm Start -->
    <div class="container-fluid py-5 mt-5">
        <div class="container py-5">
            <div class="row g-4 mb-5">
                <div class="col-lg-8 col-xl-9">
                    <div class="row g-4">
                        <div class="col-lg-6">
                            <div class="border rounded">
                                <a href="#">
                                    <img src="/images/products/${product.image}" class="img-fluid rounded" alt="Hinh anh">
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <h4 class="fw-bold mb-3">${product.name}</h4>
                            <p class="mb-3">${product.factory}</p>
                            <h5 class="fw-bold mb-3">$  <fmt:formatNumber type="number" value="${product.price}" /></h5>
                            <p class="text-muted mb-3">Còn lại: ${product.quantity} sản phẩm</p>
                            <c:if test="${product.quantity <= 0}">
                                <span class="badge bg-danger mb-3">Hết hàng</span>
                            </c:if>
                            <div class="d-flex mb-4">
                                <i class="fa fa-star text-secondary"></i>
                                <i class="fa fa-star text-secondary"></i>
                                <i class="fa fa-star text-secondary"></i>
                                <i class="fa fa-star text-secondary"></i>
                                <i class="fa fa-star"></i>
                            </div>
                            <p class="mb-4">${product.displayShortDesc}</p>
                            <form action="/add-product-to-cart-from-product-detail" method="post" modelAttribute="product">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <div class="input-group quantity mb-5" style="width: 100px;">
                                    <div class="input-group-btn">
                                        <button type="button" class="btn btn-sm btn-minus rounded-circle bg-light border">
                                            <i class="fa fa-minus"></i>
                                        </button>
                                    </div>
                                    <input type="text" class="form-control form-control-sm text-center border-0" value="1" name="quantity">
                                    <div class="input-group-btn">
                                        <button type="button" class="btn btn-sm btn-plus rounded-circle bg-light border">
                                            <i class="fa fa-plus"></i>
                                        </button>
                                    </div>
                                </div>
                                <div style="display: none;">
                                    <div class="mb-3">
                                        <div class="form-group">
                                            <label>Id:</label>
                                            <input type="text" class="form-control" name="id" value="${product.id}">
                                        </div>
                                    </div>
                                </div>
                                <button class="btn border border-secondary rounded-pill px-4 mb-4 text-primary"
                                    ${product.quantity <= 0 ? 'disabled' : ''}>
                                    <i class="fa fa-shopping-bag me-2 text-primary"></i>Thêm
                                </button>
                            </form>
                            <form action="/wishlist/add/${product.id}" method="post" class="d-inline-block">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button class="btn btn-outline-danger rounded-pill px-4 mb-4" type="submit">
                                    <i class="fa fa-heart me-2"></i>Yeu thich
                                </button>
                            </form>
                            <form action="/compare/add/${product.id}" method="post" class="d-inline-block">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button class="btn btn-outline-primary rounded-pill px-4 mb-4" type="submit">
                                    <i class="fa fa-balance-scale me-2"></i>So sánh
                                </button>
                            </form>
                        </div>
                        <div class="col-lg-12">
                            <nav>
                                <div class="nav nav-tabs mb-3">
                                    <button class="nav-link active border-white border-bottom-0" type="button"
                                        role="tab" id="nav-about-tab" data-bs-toggle="tab" data-bs-target="#nav-about"
                                        aria-controls="nav-about" aria-selected="true">Mo ta</button>
                                    <button class="nav-link border-white border-bottom-0" type="button" role="tab"
                                        id="nav-mission-tab" data-bs-toggle="tab" data-bs-target="#nav-mission"
                                        aria-controls="nav-mission" aria-selected="false">Đánh giá</button>
                                </div>
                            </nav>
                            <div class="tab-content mb-5">
                                <div class="tab-pane active" id="nav-about" role="tabpanel"
                                    aria-labelledby="nav-about-tab">
                                    <p>${product.displayDetailDesc}</p>
                                </div>
                                <div class="tab-pane" id="nav-mission" role="tabpanel"
                                    aria-labelledby="nav-mission-tab">
                                    <c:choose>
                                        <c:when test="${empty reviews}">
                                            <p class="text-muted">Chưa có đánh giá nào cho sản phẩm này.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="review" items="${reviews}">
                                                <div class="d-flex mb-4">
                                                    <img src="/images/products/avatar.jpg" class="img-fluid rounded-circle p-3"
                                                        style="width: 100px; height: 100px;" alt="avatar">
                                                    <div class="w-100">
                                                        <p class="mb-2" style="font-size: 14px;">
                                                            ${fn:replace(fn:substring(review.createdAt, 0, 10), '-', '/')}
                                                        </p>
                                                        <div class="d-flex justify-content-between">
                                                            <h5>${review.user.fullName}</h5>
                                                            <div class="d-flex mb-3">
                                                                <c:forEach begin="1" end="5" var="star">
                                                                    <i class="fa fa-star ${star <= review.rating ? 'text-secondary' : ''}"></i>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                        <p class="text-dark mb-0">${review.comment}</p>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="mt-5">
                                        <h4 class="mb-4">Đánh giá sản phẩm</h4>
                                        <c:choose>
                                            <c:when test="${currentUser == null}">
                                                <p class="text-muted">Bạn cần đăng nhập để đánh giá sản phẩm.</p>
                                            </c:when>
                                            <c:when test="${!canReview}">
                                                <p class="text-muted">Mỗi sản phẩm trong mỗi đơn hàng hoàn thành chỉ được đánh giá 1 lần. Muốn đánh giá tiếp, bạn cần hoàn thành đơn hàng tiếp theo.</p>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="text-muted">Bạn còn ${reviewTurns} lượt đánh giá cho sản phẩm này.</p>
                                                <form action="/product/${product.id}/review" method="post">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                    <div class="row g-3">
                                                        <div class="col-md-4">
                                                            <label class="form-label d-block">Chọn số sao</label>
                                                            <div class="star-rating" aria-label="Chọn số sao đánh giá">
                                                                <input type="radio" id="rating-5" name="rating" value="5" checked required />
                                                                <label for="rating-5" title="5 sao"><i class="fa fa-star"></i></label>
                                                                <input type="radio" id="rating-4" name="rating" value="4" />
                                                                <label for="rating-4" title="4 sao"><i class="fa fa-star"></i></label>
                                                                <input type="radio" id="rating-3" name="rating" value="3" />
                                                                <label for="rating-3" title="3 sao"><i class="fa fa-star"></i></label>
                                                                <input type="radio" id="rating-2" name="rating" value="2" />
                                                                <label for="rating-2" title="2 sao"><i class="fa fa-star"></i></label>
                                                                <input type="radio" id="rating-1" name="rating" value="1" />
                                                                <label for="rating-1" title="1 sao"><i class="fa fa-star"></i></label>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-8">
                                                            <label class="form-label">Noi dung</label>
                                                            <textarea class="form-control" name="comment" rows="4" required></textarea>
                                                        </div>
                                                        <div class="col-12">
                                                            <button type="submit" class="btn border border-secondary rounded-pill px-4 text-primary">
                                                                Gửi đánh giá
                                                            </button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="tab-pane" id="nav-vision" role="tabpanel">
                                    <p class="text-dark">Tempor erat elitr rebum at clita. Diam dolor diam ipsum et
                                        tempor sit. Aliqu diam
                                        amet diam et eos labore. 3</p>
                                    <p class="mb-0">Diam dolor diam ipsum et tempor sit. Aliqu diam amet diam et eos
                                        labore.
                                        Clita erat ipsum et lorem et sit</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <c:if test="${not empty relatedProducts}">
                <div class="mt-5">
                    <h3 class="mb-4">Sản phẩm liên quan</h3>
                    <div class="row g-4">
                        <c:forEach items="${relatedProducts}" var="related">
                            <div class="col-md-3">
                                <div class="border rounded p-3 h-100">
                                    <img src="/images/products/${related.image}" class="img-fluid mb-3" alt="${related.name}">
                                    <h6><a href="/product/${related.id}">${related.name}</a></h6>
                                    <div class="text-muted small">${related.factory} - ${related.displayTarget}</div>
                                    <strong><fmt:formatNumber type="number" value="${related.price}" /> đ</strong>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    <!-- Single Sản phẩm End -->


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

