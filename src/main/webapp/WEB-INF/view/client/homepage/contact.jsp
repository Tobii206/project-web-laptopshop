<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ - LaptopShop</title>
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
    <style>
        .contact-page {
            background:
                radial-gradient(circle at top left, rgba(20, 184, 166, 0.16), transparent 32rem),
                radial-gradient(circle at top right, rgba(255, 181, 36, 0.18), transparent 28rem),
                linear-gradient(135deg, #f8fffe 0%, #ffffff 46%, #fff7ed 100%);
        }

        .contact-hero {
            padding: 74px 0 34px;
        }

        .contact-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(15, 118, 110, 0.1);
            color: #0f766e;
            font-weight: 800;
            margin-bottom: 18px;
        }

        .contact-title {
            font-size: clamp(42px, 6vw, 86px);
            line-height: 0.96;
            color: #111827;
            font-weight: 900;
            letter-spacing: 0;
            max-width: 920px;
        }

        .contact-lead {
            max-width: 760px;
            color: #64748b;
            font-size: 20px;
            line-height: 1.65;
            margin-top: 22px;
        }

        .contact-shell {
            border-radius: 30px;
            background: rgba(255, 255, 255, 0.86);
            border: 1px solid rgba(15, 118, 110, 0.12);
            box-shadow: 0 28px 80px rgba(15, 23, 42, 0.11);
            overflow: hidden;
        }

        .contact-info-panel {
            background: linear-gradient(160deg, #0f766e 0%, #0d9488 58%, #14b8a6 100%);
            color: #ffffff;
            min-height: 100%;
            padding: 34px;
        }

        .contact-info-panel h2,
        .contact-info-panel h4 {
            color: #ffffff;
        }

        .contact-info-card {
            display: flex;
            gap: 16px;
            padding: 18px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.22);
        }

        .contact-info-card:last-child {
            border-bottom: 0;
        }

        .contact-info-icon {
            width: 48px;
            height: 48px;
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.16);
            color: #ffdd72;
            flex: 0 0 auto;
        }

        .contact-form-panel {
            padding: 34px;
        }

        .contact-form-panel .form-control {
            border: 1px solid #dbeafe;
            border-radius: 18px;
            min-height: 58px;
            padding: 16px 18px;
            background: #f8fafc;
        }

        .contact-form-panel textarea.form-control {
            min-height: 160px;
        }

        .contact-send-btn {
            min-height: 58px;
            border-radius: 999px;
            font-weight: 900;
            background: linear-gradient(135deg, #0f766e, #14b8a6);
            border: 0;
            box-shadow: 0 14px 28px rgba(20, 184, 166, 0.22);
        }

        .contact-map-card {
            border-radius: 28px;
            overflow: hidden;
            border: 1px solid rgba(15, 118, 110, 0.12);
            box-shadow: 0 20px 54px rgba(15, 23, 42, 0.1);
        }

        .contact-map-card iframe {
            width: 100%;
            height: 430px;
            display: block;
            border: 0;
        }

        .contact-quick-card {
            border-radius: 24px;
            background: #ffffff;
            border: 1px solid rgba(15, 118, 110, 0.12);
            box-shadow: 0 16px 36px rgba(15, 23, 42, 0.07);
            padding: 24px;
            height: 100%;
        }

        .contact-quick-card i {
            color: #0f766e;
            font-size: 28px;
            margin-bottom: 14px;
        }
    </style>
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


    <!-- Liên hệ Start -->
    <main class="contact-page">
        <section class="contact-hero">
            <div class="container">
                <div class="contact-eyebrow">
                    <i class="fas fa-headset"></i>
                    Hỗ trợ khách hàng LaptopShop
                </div>
                <h1 class="contact-title">Liên hệ với LaptopShop</h1>
                <p class="contact-lead">
                    Cần tư vấn cấu hình, kiểm tra đơn hàng, bảo hành hay đổi trả? Gửi thông tin cho shop, đội ngũ hỗ trợ sẽ phản hồi nhanh nhất có thể.
                </p>
            </div>
        </section>

        <section class="container pb-5">
            <div class="contact-shell mb-5">
                <div class="row g-0">
                    <div class="col-lg-5">
                        <div class="contact-info-panel">
                            <h2 class="mb-3">Thông tin cửa hàng</h2>
                            <p class="mb-4">LaptopShop hỗ trợ khách hàng trực tuyến và tiếp nhận yêu cầu tại khu vực Cầu Giấy, Hà Nội.</p>

                            <div class="contact-info-card">
                                <div class="contact-info-icon"><i class="fas fa-map-marker-alt"></i></div>
                                <div>
                                    <h4 class="mb-1">Địa chỉ</h4>
                                    <p class="mb-0">Cầu Giấy, Hà Nội, Việt Nam</p>
                                </div>
                            </div>

                            <div class="contact-info-card">
                                <div class="contact-info-icon"><i class="fas fa-phone-alt"></i></div>
                                <div>
                                    <h4 class="mb-1">Số điện thoại</h4>
                                    <p class="mb-0"><a class="text-white" href="tel:+84325327602">(+84) 325 327 602</a></p>
                                </div>
                            </div>

                            <div class="contact-info-card">
                                <div class="contact-info-icon"><i class="fas fa-envelope"></i></div>
                                <div>
                                    <h4 class="mb-1">Email</h4>
                                    <p class="mb-0"><a class="text-white" href="mailto:mynametobiii@gmail.com">mynametobiii@gmail.com</a></p>
                                </div>
                            </div>

                            <div class="contact-info-card">
                                <div class="contact-info-icon"><i class="fas fa-clock"></i></div>
                                <div>
                                    <h4 class="mb-1">Thời gian hỗ trợ</h4>
                                    <p class="mb-0">08:00 - 21:00, tất cả các ngày trong tuần</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-7">
                        <div class="contact-form-panel">
                            <h2 class="mb-2">Gửi yêu cầu hỗ trợ</h2>
                            <p class="text-muted mb-4">Nhập nội dung cần hỗ trợ, shop sẽ liên hệ lại qua email hoặc số điện thoại bạn cung cấp.</p>
                            <form action="/contact" method="get">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <input type="text" class="form-control" placeholder="Họ và tên">
                                    </div>
                                    <div class="col-md-6">
                                        <input type="tel" class="form-control" placeholder="Số điện thoại">
                                    </div>
                                    <div class="col-12">
                                        <input type="email" class="form-control" placeholder="Email của bạn">
                                    </div>
                                    <div class="col-12">
                                        <select class="form-control">
                                            <option>Tư vấn chọn laptop</option>
                                            <option>Hỗ trợ đơn hàng</option>
                                            <option>Bảo hành sản phẩm</option>
                                            <option>Đổi trả hàng</option>
                                            <option>Góp ý dịch vụ</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <textarea class="form-control" placeholder="Nội dung cần hỗ trợ"></textarea>
                                    </div>
                                    <div class="col-12">
                                        <button class="btn btn-primary contact-send-btn w-100" type="submit">
                                            <i class="fas fa-paper-plane me-2"></i>Gửi yêu cầu
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="contact-quick-card">
                        <i class="fas fa-laptop"></i>
                        <h4>Tư vấn laptop</h4>
                        <p class="mb-0 text-muted">Gợi ý máy theo ngân sách, học tập, lập trình, đồ họa hoặc gaming.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="contact-quick-card">
                        <i class="fas fa-truck"></i>
                        <h4>Theo dõi đơn hàng</h4>
                        <p class="mb-0 text-muted">Kiểm tra trạng thái xác nhận, giao hàng, thanh toán và mã vận đơn.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="contact-quick-card">
                        <i class="fas fa-shield-alt"></i>
                        <h4>Bảo hành, đổi trả</h4>
                        <p class="mb-0 text-muted">Tiếp nhận yêu cầu sau bán hàng và cập nhật kết quả xử lý rõ ràng.</p>
                    </div>
                </div>
            </div>

            <div class="contact-map-card">
                <iframe
                    title="Bản đồ LaptopShop tại Cầu Giấy, Hà Nội"
                    src="https://www.google.com/maps?q=C%E1%BA%A7u%20Gi%E1%BA%A5y%2C%20H%C3%A0%20N%E1%BB%99i%2C%20Vi%E1%BB%87t%20Nam&output=embed"
                    loading="lazy"
                    referrerpolicy="no-referrer-when-downgrade">
                </iframe>
            </div>
        </section>
    </main>
    <!-- Liên hệ End -->


    <!-- Footer Start -->
    <jsp:include page="../layout/footer.jsp" />
    <!-- Footer End -->


    <!-- Quay lại to Top -->
    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i class="fa fa-arrow-up"></i></a>


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
