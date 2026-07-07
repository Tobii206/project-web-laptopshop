package datt.nguyenthanhlong.laptopshop.controller.admin;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.dto.DashboardStatDTO;
import datt.nguyenthanhlong.laptopshop.service.OrderService;
import datt.nguyenthanhlong.laptopshop.service.ProductService;
import datt.nguyenthanhlong.laptopshop.service.UserService;

@Controller
public class DashboardController {
    private final OrderService orderService;
    private final ProductService productService;
    private final UserService userService;

    public DashboardController(OrderService orderService, ProductService productService, UserService userService) {
        this.orderService = orderService;
        this.productService = productService;
        this.userService = userService;
    }

    @GetMapping("/admin")
    public String getDashboard(Model model) {
        int totalUsers = 0;
        int totalProducts = 0;
        int totalOrders = 0;

        totalUsers = this.userService.getAllUser().size();
        totalProducts = this.productService.fetchProducts().size();
        totalOrders = this.orderService.fetchOrders().size();

        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("totalOrders", totalOrders);
        model.addAttribute("lowStockProducts", this.productService.fetchLowStockProducts(5));

        return "admin/dashboard/show";
    }

    @GetMapping("/admin/statistics")
    public String getStatisticsDashboard(Model model,
            @RequestParam(value = "selectedDate", required = false) String selectedDate,
            @RequestParam(value = "selectedMonth", required = false) String selectedMonth,
            @RequestParam(value = "selectedYear", required = false) Integer selectedYear) {
        List<Order> orders = this.orderService.fetchOrders();

        LocalDate currentDate = (selectedDate == null || selectedDate.isBlank())
                ? LocalDate.now()
                : LocalDate.parse(selectedDate);
        YearMonth currentMonth = (selectedMonth == null || selectedMonth.isBlank())
                ? YearMonth.now()
                : YearMonth.parse(selectedMonth);
        int currentYear = (selectedYear == null) ? LocalDate.now().getYear() : selectedYear;
        model.addAttribute("selectedDate", currentDate);
        model.addAttribute("selectedMonth", currentMonth);
        model.addAttribute("selectedYear", currentYear);
        model.addAttribute("dailyStats", calculateDailyStats(orders, currentDate));
        model.addAttribute("monthlyStats", calculateMonthlyStats(orders, currentMonth));
        model.addAttribute("yearlyStats", calculateYearlyStats(orders, currentYear));
        model.addAttribute("chartLabels", buildMonthlyChartLabels());
        model.addAttribute("chartValues", buildMonthlyRevenueChartValues(orders, currentYear));
        model.addAttribute("monthlyOrderValues", buildMonthlyOrderChartValues(orders, currentYear));
        model.addAttribute("statusLabels", buildOrderStatusLabels(orders));
        model.addAttribute("statusValues", buildOrderStatusValues(orders));
        model.addAttribute("topProductLabels", buildTopProductLabels());
        model.addAttribute("topProductValues", buildTopProductSoldValues());

        return "admin/dashboard/statistics";
    }

    private DashboardStatDTO calculateDailyStats(List<Order> orders, LocalDate date) {
        LocalDateTime start = date.atStartOfDay();
        LocalDateTime end = date.plusDays(1).atStartOfDay();
        return calculateStats(orders, start, end);
    }

    private DashboardStatDTO calculateMonthlyStats(List<Order> orders, YearMonth month) {
        LocalDateTime start = month.atDay(1).atStartOfDay();
        LocalDateTime end = month.plusMonths(1).atDay(1).atStartOfDay();
        return calculateStats(orders, start, end);
    }

    private DashboardStatDTO calculateYearlyStats(List<Order> orders, int year) {
        LocalDateTime start = LocalDate.of(year, 1, 1).atStartOfDay();
        LocalDateTime end = LocalDate.of(year + 1, 1, 1).atStartOfDay();
        return calculateStats(orders, start, end);
    }

    private DashboardStatDTO calculateStats(List<Order> orders, LocalDateTime start, LocalDateTime end) {
        long totalOrders = 0;
        double totalRevenue = 0;

        for (Order order : orders) {
            if (order.getCreatedAt() == null) {
                continue;
            }
            boolean isInRange = !order.getCreatedAt().isBefore(start) && order.getCreatedAt().isBefore(end);
            if (isInRange) {
                totalOrders++;
                totalRevenue += order.getTotalPrice();
            }
        }

        return new DashboardStatDTO(totalOrders, totalRevenue);
    }

    private List<String> buildMonthlyChartLabels() {
        List<String> labels = new ArrayList<>();
        for (int month = 1; month <= 12; month++) {
            labels.add("Thang " + month);
        }
        return labels;
    }

    private List<Double> buildMonthlyRevenueChartValues(List<Order> orders, int year) {
        List<Double> revenues = new ArrayList<>();
        for (int month = 1; month <= 12; month++) {
            DashboardStatDTO stat = calculateMonthlyStats(orders, YearMonth.of(year, month));
            revenues.add(stat.getTotalRevenue());
        }
        return revenues;
    }

    private List<Long> buildMonthlyOrderChartValues(List<Order> orders, int year) {
        List<Long> totals = new ArrayList<>();
        for (int month = 1; month <= 12; month++) {
            DashboardStatDTO stat = calculateMonthlyStats(orders, YearMonth.of(year, month));
            totals.add(stat.getTotalOrders());
        }
        return totals;
    }

    private Map<String, Long> buildOrderStatusMap(List<Order> orders) {
        Map<String, Long> statusMap = new LinkedHashMap<>();
        statusMap.put("Cho xac nhan", 0L);
        statusMap.put("Da xac nhan", 0L);
        statusMap.put("Dang giao", 0L);
        statusMap.put("Hoan thanh", 0L);
        statusMap.put("Đã hủy", 0L);

        for (Order order : orders) {
            String label = switch (order.getStatus() == null ? "" : order.getStatus().toUpperCase()) {
                case "PENDING" -> "Cho xac nhan";
                case "CONFIRM", "CONFIRMED" -> "Da xac nhan";
                case "SHIPPING" -> "Dang giao";
                case "COMPLETE", "COMPLETED" -> "Hoan thanh";
                case "CANCEL", "CANCELLED" -> "Đã hủy";
                default -> "Khac";
            };
            statusMap.put(label, statusMap.getOrDefault(label, 0L) + 1);
        }

        return statusMap;
    }

    private List<String> buildOrderStatusLabels(List<Order> orders) {
        return new ArrayList<>(buildOrderStatusMap(orders).keySet());
    }

    private List<Long> buildOrderStatusValues(List<Order> orders) {
        return new ArrayList<>(buildOrderStatusMap(orders).values());
    }

    private List<Product> fetchTopProducts() {
        return this.productService.fetchProducts().stream()
                .sorted(Comparator.comparingLong(Product::getSold).reversed())
                .limit(5)
                .toList();
    }

    private List<String> buildTopProductLabels() {
        return fetchTopProducts().stream().map(Product::getName).toList();
    }

    private List<Long> buildTopProductSoldValues() {
        return fetchTopProducts().stream().map(Product::getSold).toList();
    }
}
