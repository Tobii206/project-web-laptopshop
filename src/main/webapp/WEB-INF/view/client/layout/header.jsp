<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<link href="/css/modern-ui.css" rel="stylesheet">
<!-- Navbar start -->
<div class="container-fluid fixed-top">
    <div class="container topbar bg-primary d-none d-lg-block">
        <div class="d-flex justify-content-between">
            <div class="top-info ps-2">
                <small class="me-3"><i class="fas fa-map-marker-alt me-2 text-secondary"></i> <a href="/contact"
                        class="text-white">Cầu Giấy, Hà Nội, Việt Nam</a></small>
                <small class="me-3"><i class="fa fa-phone-alt me-2 text-secondary"></i><a href="tel:+84325327602"
                        class="text-white">(+84) 325 327 602</a></small>
                <small class="me-3"><i class="fas fa-envelope me-2 text-secondary"></i><a href="#"
                        class="text-white">mynametobiii@gmail.com</a></small>
            </div>
            <div class="top-link pe-2">
                <a href="#" class="text-white"><small class="text-white mx-2">Chính sách bảo mật</small>/</a>
                <a href="#" class="text-white"><small class="text-white mx-2">Điều khoản sử dụng</small>/</a>
                <a href="#" class="text-white"><small class="text-white ms-2">Bán hàng và hoàn tiền</small></a>
            </div>
        </div>
    </div>
    <div class="container px-0">
        <nav class="navbar navbar-light bg-white navbar-expand-xl">
            <a href="/" class="navbar-brand">
                <h1 class="text-primary display-6">LaptopShop</h1>
            </a>
            <button class="navbar-toggler py-2 px-3" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarCollapse">
                <span class="fa fa-bars text-primary"></span>
            </button>
            <div class="collapse navbar-collapse bg-white justify-content-between mx-5" id="navbarCollapse">
                <div class="navbar-nav">
                    <a href="/" class="nav-item nav-link active">Trang chủ</a>
                    <a href="/shop" class="nav-item nav-link">Cửa hàng</a>
                    <a href="/laptop-finder" class="nav-item nav-link">Tư vấn AI</a>
                    <a href="/compare" class="nav-item nav-link">So sánh</a>
                    <a href="/contact" class="nav-item nav-link">Liên hệ</a>
                    <c:if test="${pageContext.request.isUserInRole('ROLE_ADMIN')}">
                        <a href="/admin" class="nav-item nav-link">Quản trị</a>
                    </c:if>
                </div>
                <div class="d-flex m-3 me-0">
                    <c:if test="${not empty pageContext.request.userPrincipal}">
                        <button class="btn-search btn border border-secondary btn-md-square rounded-circle bg-white me-4"
                            data-bs-toggle="modal" data-bs-target="#searchModal"><i
                                class="fas fa-search text-primary"></i></button>
                        <div class="nav-item dropdown my-auto me-4">
                            <a href="#" class="position-relative" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-bell fa-2x"></i>
                                <c:if test="${currentUnreadNotifications > 0}">
                                    <span class="position-absolute bg-danger text-white rounded-circle d-flex align-items-center justify-content-center px-1"
                                        style="top: -5px; left: 15px; height: 20px; min-width: 20px; font-size: 12px;">
                                        ${currentUnreadNotifications}
                                    </span>
                                </c:if>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end p-3 notification-menu">
                                <li class="fw-bold mb-2">Thông báo</li>
                                <c:choose>
                                    <c:when test="${empty currentNotifications}">
                                        <li class="text-muted small">Chưa có thông báo.</li>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${currentNotifications}" var="notification">
                                            <li class="mb-2">
                                                <a class="dropdown-item rounded ${notification.readStatus ? '' : 'fw-bold'} ${(fn:contains(notification.link, 'openChat=1') or fn:startsWith(notification.link, '/ai-chat')) ? 'js-open-ai-chat-notification' : ''}"
                                                    href="/notifications/read/${notification.id}"
                                                    data-chat-link="${notification.link}">
                                                    <div class="notification-title">${notification.title}</div>
                                                    <small class="notification-content text-muted">${notification.content}</small>
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                        <a href="/cart" class="position-relative me-4 my-auto">
                            <i class="fa fa-shopping-bag fa-2x"></i>
                            <span
                                class="position-absolute bg-secondary rounded-circle d-flex align-items-center justify-content-center text-dark px-1"
                                style="top: -5px; left: 15px; height: 20px; min-width: 20px;">${currentCartQuantity}</span>
                        </a>
                        <div class="nav-item dropdown my-auto">
                            <a href="#" class="dropdown" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user fa-2x"></i>
                            </a>
                            <ul class="dropdown-menu m-4 dropdown-menu-start p-3 bg-secondary" arialabelledby="dropdownMenuLink" style="right: -50px;">
                                <li class="d-flex align-items-center flex-column" style="min-width: 200px;">
                                    <img style="width: 150px; height: 150px; border-radius: 50%; overflow: hidden;"
                                    src="/images/avatar/${currentUser.avatar}" />
                                    <div class="text-center my-3">
                                        <c:out value="${currentUser.fullName}" />
                                    </div>
                                </li>
                                <li><a class="dropdown-item rounded" href="/account">Quản lý tài khoản</a></li>
                                <li><a class="dropdown-item rounded" href="/wishlist">Sản phẩm yêu thích</a></li>
                                <li><a class="dropdown-item rounded" href="/order-history">Lịch sử mua hàng</a></li>
                                <c:if test="${pageContext.request.isUserInRole('ROLE_ADMIN')}">
                                    <li><a class="dropdown-item rounded" href="/admin">Trang admin</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <form method="post" action="/tab-logout">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button class="dropdown-item rounded" href="#">Đăng xuất</button>
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </c:if>
                    <c:if test="${empty pageContext.request.userPrincipal}">
                        <div class="header-auth-actions">
                            <a href="/login" class="header-auth-link header-auth-link-primary">
                                <i class="fas fa-right-to-bracket"></i>
                                <span>Đăng nhập</span>
                            </a>
                            <a href="/register" class="header-auth-link">
                                <i class="fas fa-user-plus"></i>
                                <span>Đăng ký</span>
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </nav>
    </div>
</div>
<!-- Navbar End -->
<script src="/js/tab-auth.js"></script>

<!-- Modal Search Start -->
<div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-fullscreen">
        <div class="modal-content rounded-0">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Tìm kiếm theo từ khóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body d-flex align-items-center">
                <form action="/shop" method="get" class="input-group w-75 mx-auto d-flex">
                    <input type="search" class="form-control p-3" placeholder="Nhập từ khóa" name="keyword"
                        aria-describedby="search-icon-1">
                    <button id="search-icon-1" class="input-group-text p-3" type="submit"><i class="fa fa-search"></i></button>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- Modal Search End -->
