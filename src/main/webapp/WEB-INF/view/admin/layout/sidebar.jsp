<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<div id="layoutSidenav_nav">
    <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
        <div class="sb-sidenav-menu">
            <div class="nav">
                <div class="sb-sidenav-menu-heading">CHỨC NĂNG</div>
                <a class="nav-link" href="/admin">
                    <div class="sb-nav-link-icon"><i class="fas fa-gauge-high"></i></div>
                    Bảng điều khiển
                </a>
                <a class="nav-link" href="/admin/statistics">
                    <div class="sb-nav-link-icon"><i class="fas fa-chart-column"></i></div>
                    Thống kê
                </a>
                <a class="nav-link" href="/admin/user">
                    <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
                    Người dùng
                </a>
                <a class="nav-link" href="/admin/order">
                    <div class="sb-nav-link-icon"><i class="fas fa-receipt"></i></div>
                    Đơn hàng
                </a>
                <a class="nav-link" href="/admin/product">
                    <div class="sb-nav-link-icon"><i class="fas fa-laptop"></i></div>
                    Sản phẩm
                </a>
                <a class="nav-link" href="/admin/voucher">
                    <div class="sb-nav-link-icon"><i class="fas fa-ticket"></i></div>
                    Phiếu giảm giá
                </a>
                <a class="nav-link" href="/admin/warranty">
                    <div class="sb-nav-link-icon"><i class="fas fa-shield-halved"></i></div>
                    Bảo hành
                </a>
                <a class="nav-link" href="/admin/ai-messages">
                    <div class="sb-nav-link-icon"><i class="fas fa-comments"></i></div>
                    Tin nhắn
                </a>
                <a class="nav-link" href="/shop" target="_blank" rel="noopener noreferrer">
                    <div class="sb-nav-link-icon"><i class="fas fa-store"></i></div>
                    Mở cửa hàng
                </a>
            </div>
        </div>
        <div class="sb-sidenav-footer">
            <div class="small">Đăng nhập:</div>
            ${pageContext.request.userPrincipal.name}
        </div>
    </nav>
</div>
