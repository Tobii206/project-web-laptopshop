<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>So sánh - LaptopShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    <div class="container compare-page" style="margin-top: 170px;">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <div class="finder-eyebrow">AI Compare</div>
                <h2 class="mb-1">So sánh laptop</h2>
                <p class="text-muted mb-0">Chọn 2-3 sản phẩm, AI sẽ tóm tắt điểm đáng mua.</p>
            </div>
            <a href="/laptop-finder" class="btn btn-outline-primary">Cần AI tư vấn?</a>
        </div>
        <c:choose>
            <c:when test="${empty products}">
                <div class="alert alert-info">Hãy thêm 2-3 sản phẩm vào danh sách so sánh.</div>
            </c:when>
            <c:otherwise>
                <div class="ai-summary mb-4">
                    <i class="fa fa-robot"></i>
                    <span>${comparisonSummary}</span>
                </div>
                <div class="table-responsive compare-table-wrap">
                    <table class="table table-bordered align-middle">
                        <tr>
                            <th>Tiêu chí</th>
                            <c:forEach items="${products}" var="product">
                                <th>
                                    ${product.name}
                                    <form method="post" action="/compare/remove/${product.id}" class="mt-2">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button class="btn btn-outline-danger btn-sm" type="submit">Bỏ</button>
                                    </form>
                                </th>
                            </c:forEach>
                        </tr>
                        <tr>
                            <td>Hinh anh</td>
                            <c:forEach items="${products}" var="product">
                                <td><img src="/images/products/${product.image}" class="img-fluid" style="max-width: 180px;"></td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <td>Giá</td>
                            <c:forEach items="${products}" var="product">
                                <td class="fw-bold text-primary"><fmt:formatNumber type="number" value="${product.price}" /> đ</td>
                            </c:forEach>
                        </tr>
                        <tr>
                            <td>Hãng</td>
                            <c:forEach items="${products}" var="product"><td>${product.factory}</td></c:forEach>
                        </tr>
                        <tr>
                            <td>Nhu cầu</td>
                            <c:forEach items="${products}" var="product"><td>${product.displayTarget}</td></c:forEach>
                        </tr>
                        <tr>
                            <td>Tồn kho</td>
                            <c:forEach items="${products}" var="product"><td>${product.quantity}</td></c:forEach>
                        </tr>
                        <tr>
                            <td>Mô tả ngắn</td>
                            <c:forEach items="${products}" var="product"><td>${product.displayShortDesc}</td></c:forEach>
                        </tr>
                        <tr>
                            <td>Kết luận nhanh</td>
                            <c:forEach items="${products}" var="product">
                                <td>
                                    <div class="small">
                                        Phù hợp với <strong>${product.displayTarget}</strong>, hãng <strong>${product.factory}</strong>.
                                        <c:choose>
                                            <c:when test="${product.quantity > 20}">Ton kho tot, co the mua ngay.</c:when>
                                            <c:when test="${product.quantity > 0}">Ton kho con it, nen chot som.</c:when>
                                            <c:otherwise>Đang hết hàng.</c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </c:forEach>
                        </tr>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
        <a href="/shop" class="btn btn-primary">Tiếp tục chọn sản phẩm</a>
    </div>
    <jsp:include page="../layout/footer.jsp" />
</body>
</html>

