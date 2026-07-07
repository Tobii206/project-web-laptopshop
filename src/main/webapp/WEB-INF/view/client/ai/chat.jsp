<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI tư vấn laptop - LaptopShop</title>
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

    <div style="margin-top: 145px;"></div>

    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="row g-4">
                <div class="col-lg-5">
                    <div class="bg-light rounded p-4 h-100">
                        <h2 class="text-primary mb-3">AI tư vấn laptop</h2>
                        <p class="mb-4">
                            Hỏi AI về laptop theo ngân sách, nhu cầu học tập, lập trình, thiết kế hoặc gaming.
                            Tin nhắn sẽ được admin hỗ trợ thêm khi cần.
                        </p>

                        <form method="post" action="/ai-chat">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <c:if test="${empty pageContext.request.userPrincipal}">
                                <input class="form-control border-0 py-3 mb-3" name="guestName"
                                    placeholder="Tên của bạn">
                                <input class="form-control border-0 py-3 mb-3" name="guestEmail"
                                    placeholder="Email hoặc số điện thoại">
                            </c:if>

                            <textarea class="form-control border-0 mb-3" name="question" rows="7"
                                placeholder="Ví dụ: Em có 15 triệu, học lập trình, cần laptop pin tốt thì nên chọn cấu hình như nào?"
                                required></textarea>
                            <div class="row g-2 mb-3">
                                <div class="col-md-6">
                                    <input class="form-control border-0 py-3" name="budget" placeholder="Ngân sách, ví dụ 20 triệu">
                                </div>
                                <div class="col-md-6">
                                    <select class="form-select border-0 py-3" name="need">
                                        <option value="">Nhu cầu</option>
                                        <option value="gaming">Gaming</option>
                                        <option value="hoc lap trinh">Học lập trình</option>
                                        <option value="van phong">Văn phòng</option>
                                        <option value="do hoa">Đồ họa</option>
                                        <option value="mong nhe">Mỏng nhẹ</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <input class="form-control border-0 py-3" name="preferredBrand" placeholder="Hãng thích">
                                </div>
                                <div class="col-md-6">
                                    <input class="form-control border-0 py-3" name="priority" placeholder="Ưu tiên: pin, nhẹ, màn đẹp...">
                                </div>
                            </div>
                            <button class="btn border-secondary py-3 px-4 bg-white text-primary" type="submit">
                                <i class="fas fa-paper-plane me-2"></i>Gửi câu hỏi
                            </button>
                        </form>
                    </div>
                </div>

                <div class="col-lg-7">
                    <c:if test="${not empty latestMessage}">
                        <div class="rounded p-4 mb-4" style="background: #f5fff2;">
                            <h4 class="text-primary mb-3">Câu trả lời mới nhất</h4>
                            <div class="mb-3">
                                <strong>Bạn hỏi:</strong>
                                <div class="mt-2"><c:out value="${latestMessage.question}" /></div>
                            </div>
                            <div class="mb-3">
                                <strong>AI trả lời:</strong>
                                <div class="mt-2"><c:out value="${latestMessage.aiAnswer}" /></div>
                            </div>
                        </div>
                    </c:if>

                    <div class="bg-light rounded p-4">
                        <h4 class="mb-3">Lịch sử tư vấn của bạn</h4>
                        <c:choose>
                            <c:when test="${empty messages}">
                                <p class="mb-0">Chưa có tin nhắn nào. Bạn gửi câu hỏi đầu tiên đi, AI đang đợi ở quầy tư vấn.</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${messages}" var="message">
                                    <div class="bg-white rounded p-3 mb-3">
                                        <div class="d-flex justify-content-between gap-3">
                                            <strong><c:out value="${message.customerName}" /></strong>
                                            <small class="text-muted"><c:out value="${message.createdAt}" /></small>
                                        </div>
                                        <div class="mt-2">
                                            <span class="text-primary">Câu hỏi:</span>
                                            <c:out value="${message.question}" />
                                        </div>
                                        <div class="mt-2">
                                            <span class="text-success">AI:</span>
                                            <c:out value="${message.aiAnswer}" />
                                        </div>
                                        <c:if test="${not empty message.adminReply}">
                                            <div class="mt-2 alert alert-info mb-0">
                                                <strong>Quản trị phản hồi:</strong>
                                                <c:out value="${message.adminReply}" />
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i class="fa fa-arrow-up"></i></a>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/lib/easing/easing.min.js"></script>
    <script src="/lib/waypoints/waypoints.min.js"></script>
    <script src="/lib/lightbox/js/lightbox.min.js"></script>
    <script src="/lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="/js/main.js"></script>
</body>

</html>
