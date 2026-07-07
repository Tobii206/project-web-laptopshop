<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Wishlist - LaptopShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../layout/header.jsp" />
    <div class="container" style="margin-top: 170px;">
        <h2 class="mb-4">Sản phẩm yêu thích</h2>
        <div class="row g-4">
            <c:forEach items="${items}" var="item">
                <div class="col-md-4">
                    <div class="border rounded p-3 h-100">
                        <img src="/images/products/${item.product.image}" class="img-fluid mb-3" alt="${item.product.name}">
                        <h5><a href="/product/${item.product.id}">${item.product.name}</a></h5>
                        <p><fmt:formatNumber type="number" value="${item.product.price}" /> đ</p>
                        <form method="post" action="/wishlist/delete/${item.id}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button class="btn btn-outline-danger btn-sm" type="submit">Bo yeu thich</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
        <c:if test="${empty items}">
            <div class="alert alert-info">Bạn chưa lưu sản phẩm nào.</div>
        </c:if>
    </div>
    <jsp:include page="../layout/footer.jsp" />
    <script src="/js/main.js"></script>
</body>
</html>
