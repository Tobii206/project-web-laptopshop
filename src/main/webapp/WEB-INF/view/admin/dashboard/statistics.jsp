<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Thong ke - LaptopShop Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="/css/admin-modern.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stats-hero {
            background: linear-gradient(135deg, #111827 0%, #1d4ed8 100%);
            border-radius: 18px;
            color: #fff;
            padding: 28px;
            box-shadow: 0 18px 40px rgba(17, 24, 39, 0.2);
        }

        .stats-hero h1 {
            color: #fff;
            font-weight: 900;
            margin: 0 0 6px;
        }

        .filter-card {
            border: 0 !important;
            margin-top: -16px;
        }

        .kpi-card {
            border: 0 !important;
            min-height: 150px;
        }

        .kpi-icon {
            width: 44px;
            height: 44px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            margin-bottom: 12px;
        }

        .kpi-label {
            color: #6b7280;
            font-weight: 800;
        }

        .kpi-number {
            color: #111827;
            font-size: 1.9rem;
            font-weight: 900;
            line-height: 1.1;
        }

        .kpi-money {
            font-weight: 900;
        }

        .chart-card {
            border: 0 !important;
        }

        .chart-card .card-header {
            background: #fff;
            padding: 16px 20px;
            font-weight: 900;
        }

        .chart-wrap {
            position: relative;
            height: 340px;
        }

        .chart-wrap.compact {
            height: 300px;
        }

        .chart-wrap canvas {
            width: 100% !important;
            height: 100% !important;
        }
    </style>
</head>

<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <div class="stats-hero mt-4 mb-4">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div>
                                <h1>Thong ke kinh doanh</h1>
                                <div class="text-white-50">
                                    Theo dõi doanh thu, số đơn, trạng thái đơn hàng và sản phẩm bán chạy.
                                </div>
                            </div>
                            <a href="/admin" class="btn btn-light px-4">
                                <i class="fas fa-arrow-left me-2"></i>Bang dieu khien
                            </a>
                        </div>
                    </div>

                    <div class="card filter-card mb-4">
                        <div class="card-header">
                            <i class="fas fa-filter me-1"></i>
                            Bộ lọc thống kê
                        </div>
                        <div class="card-body">
                            <form action="/admin/statistics" method="get" class="row g-3 align-items-end">
                                <div class="col-md-4">
                                    <label class="form-label">Theo ngay</label>
                                    <input type="date" class="form-control" name="selectedDate" value="${selectedDate}">
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Theo thang</label>
                                    <input type="month" class="form-control" name="selectedMonth" value="${selectedMonth}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Theo nam</label>
                                    <input type="number" class="form-control" name="selectedYear" min="2000" max="2100"
                                        value="${selectedYear}">
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="fas fa-rotate me-1"></i>Áp dụng
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-xl-4 col-md-6">
                            <div class="card kpi-card">
                                <div class="card-body">
                                    <div class="kpi-icon bg-primary"><i class="fas fa-calendar-day"></i></div>
                                    <div class="kpi-label">Ngay da chon</div>
                                    <div class="kpi-number">${dailyStats.totalOrders} don</div>
                                    <div class="kpi-money text-primary">
                                        <fmt:formatNumber type="number" value="${dailyStats.totalRevenue}" /> d
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-md-6">
                            <div class="card kpi-card">
                                <div class="card-body">
                                    <div class="kpi-icon bg-warning"><i class="fas fa-calendar-alt"></i></div>
                                    <div class="kpi-label">Thang da chon</div>
                                    <div class="kpi-number">${monthlyStats.totalOrders} don</div>
                                    <div class="kpi-money text-warning">
                                        <fmt:formatNumber type="number" value="${monthlyStats.totalRevenue}" /> d
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-4 col-md-6">
                            <div class="card kpi-card">
                                <div class="card-body">
                                    <div class="kpi-icon bg-success"><i class="fas fa-chart-line"></i></div>
                                    <div class="kpi-label">Nam ${selectedYear}</div>
                                    <div class="kpi-number">${yearlyStats.totalOrders} don</div>
                                    <div class="kpi-money text-success">
                                        <fmt:formatNumber type="number" value="${yearlyStats.totalRevenue}" /> d
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card chart-card mb-4">
                        <div class="card-header">
                            <i class="fas fa-chart-column me-1"></i>
                            Doanh thu theo thang nam ${selectedYear}
                        </div>
                        <div class="card-body">
                            <div class="chart-wrap">
                                <canvas id="revenueBarChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-xl-6">
                            <div class="card chart-card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-chart-pie me-1"></i>
                                    Tỉ lệ trạng thái đơn hàng
                                </div>
                                <div class="card-body">
                                    <div class="chart-wrap compact">
                                        <canvas id="orderStatusPieChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-6">
                            <div class="card chart-card mb-4">
                                <div class="card-header">
                                    <i class="fas fa-chart-column me-1"></i>
                                    So don theo thang nam ${selectedYear}
                                </div>
                                <div class="card-body">
                                    <div class="chart-wrap compact">
                                        <canvas id="orderCountBarChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card chart-card mb-4">
                        <div class="card-header">
                            <i class="fas fa-ranking-star me-1"></i>
                            Top sản phẩm bán chạy
                        </div>
                        <div class="card-body">
                            <div class="chart-wrap compact">
                                <canvas id="topProductBarChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
    <script>
        const revenueLabels = [
            <c:forEach var="label" items="${chartLabels}" varStatus="loop">
                "${label}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const revenueValues = [
            <c:forEach var="value" items="${chartValues}" varStatus="loop">
                ${value}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const monthlyOrderValues = [
            <c:forEach var="value" items="${monthlyOrderValues}" varStatus="loop">
                ${value}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const statusLabels = [
            <c:forEach var="label" items="${statusLabels}" varStatus="loop">
                "${label}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const statusValues = [
            <c:forEach var="value" items="${statusValues}" varStatus="loop">
                ${value}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const topProductLabels = [
            <c:forEach var="label" items="${topProductLabels}" varStatus="loop">
                "${label}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const topProductValues = [
            <c:forEach var="value" items="${topProductValues}" varStatus="loop">
                ${value}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const chartGrid = {
            color: "rgba(148, 163, 184, 0.25)"
        };

        new Chart(document.getElementById("revenueBarChart"), {
            type: "bar",
            data: {
                labels: revenueLabels,
                datasets: [{
                    label: "Doanh thu (d)",
                    data: revenueValues,
                    backgroundColor: "rgba(37, 99, 235, 0.72)",
                    borderColor: "rgba(37, 99, 235, 1)",
                    borderWidth: 1,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, grid: chartGrid },
                    x: { grid: { display: false } }
                }
            }
        });

        new Chart(document.getElementById("orderStatusPieChart"), {
            type: "doughnut",
            data: {
                labels: statusLabels,
                datasets: [{
                    data: statusValues,
                    backgroundColor: ["#f59e0b", "#2563eb", "#06b6d4", "#16a34a", "#dc2626", "#64748b"],
                    borderWidth: 2,
                    borderColor: "#fff"
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: "58%",
                plugins: {
                    legend: { position: "bottom" }
                }
            }
        });

        new Chart(document.getElementById("orderCountBarChart"), {
            type: "bar",
            data: {
                labels: revenueLabels,
                datasets: [{
                    label: "So don",
                    data: monthlyOrderValues,
                    backgroundColor: "rgba(20, 184, 166, 0.72)",
                    borderColor: "rgba(15, 118, 110, 1)",
                    borderWidth: 1,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, ticks: { precision: 0 }, grid: chartGrid },
                    x: { grid: { display: false } }
                }
            }
        });

        new Chart(document.getElementById("topProductBarChart"), {
            type: "bar",
            data: {
                labels: topProductLabels,
                datasets: [{
                    label: "Da ban",
                    data: topProductValues,
                    backgroundColor: "rgba(245, 158, 11, 0.78)",
                    borderColor: "rgba(245, 158, 11, 1)",
                    borderWidth: 1,
                    borderRadius: 8
                }]
            },
            options: {
                indexAxis: "y",
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    x: { beginAtZero: true, ticks: { precision: 0 }, grid: chartGrid },
                    y: { grid: { display: false } }
                }
            }
        });
    </script>
</body>

</html>
