package datt.nguyenthanhlong.laptopshop.controller.admin;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.dto.AdminCustomerOrderHistoryDTO;
import datt.nguyenthanhlong.laptopshop.service.OrderDetailService;
import datt.nguyenthanhlong.laptopshop.service.OrderService;
import datt.nguyenthanhlong.laptopshop.service.ProductService;
import datt.nguyenthanhlong.laptopshop.service.UserService;
import datt.nguyenthanhlong.laptopshop.service.WarrantyService;

@Controller
public class OrderController {
    private final OrderService orderService;
    private final OrderDetailService orderDetailService;
    private final UserService userService;
    private final WarrantyService warrantyService;
    private final ProductService productService;

    public OrderController(OrderService orderService, OrderDetailService orderDetailService, UserService userService,
            WarrantyService warrantyService, ProductService productService) {
        this.orderService = orderService;
        this.orderDetailService = orderDetailService;
        this.userService = userService;
        this.warrantyService = warrantyService;
        this.productService = productService;
    }

    @GetMapping("/admin/order")
    public String getDashboard(Model model, @RequestParam(value = "page", defaultValue = "1") int page) {
        Page<Order> orders = this.orderService.fetchOrders(
                PageRequest.of(page - 1, 6, Sort.by(Sort.Direction.DESC, "createdAt", "id")));
        List<Order> listOrders = orders.getContent();
        model.addAttribute("orders", listOrders);

        model.addAttribute("totalPages", orders.getTotalPages());
        model.addAttribute("currentPage", page);
        return "/admin/order/show";
    }

    @GetMapping("/admin/order-history")
    public String getAdminOrderHistoryPage(Model model,
            @RequestParam(value = "range", defaultValue = "all") String range,
            @RequestParam(value = "trackingCode", required = false) String trackingCode,
            @RequestParam(value = "customerKeyword", required = false) String customerKeyword) {
        List<Order> orders = fetchAdminOrdersByRange(range);
        orders = filterOrdersByTrackingCode(orders, trackingCode);
        orders = filterOrdersByCustomerKeyword(orders, customerKeyword);

        model.addAttribute("customerHistories", buildCustomerHistories(orders));
        model.addAttribute("activeRange", range);
        model.addAttribute("trackingCode", trackingCode == null ? "" : trackingCode.trim());
        model.addAttribute("customerKeyword", customerKeyword == null ? "" : customerKeyword.trim());
        return "admin/order/history";
    }

    @GetMapping("/admin/order-history/customer/{userId}")
    public String getAdminCustomerOrderHistoryPage(Model model,
            @PathVariable long userId,
            @RequestParam(value = "range", defaultValue = "all") String range,
            @RequestParam(value = "trackingCode", required = false) String trackingCode) {
        User customer = this.userService.getUserById(userId);
        if (customer == null) {
            return "redirect:/admin/order-history";
        }

        List<Order> orders = fetchOrdersByRange(customer, range);
        orders = filterOrdersByTrackingCode(orders, trackingCode);
        List<OrderDetail> orderDetails = this.orderDetailService.fetchOrderDetailsByOrders(orders);

        model.addAttribute("customer", customer);
        model.addAttribute("orders", orders);
        model.addAttribute("orderDetails", orderDetails);
        model.addAttribute("orderTimelineMap", this.orderService.buildTimelineMap(orders));
        model.addAttribute("activeRange", range);
        model.addAttribute("trackingCode", trackingCode == null ? "" : trackingCode.trim());
        return "admin/order/customer-history";
    }

    @GetMapping("/admin/order/{id}")
    public String getOrderDetailPage(Model model, @PathVariable long id) {
        Order order = this.orderService.findOrderById(id);
        List<OrderDetail> orderDetails = this.orderDetailService.fetchOrderDetails().stream()
                .filter(detail -> detail.getOrder() != null && detail.getOrder().getId() == id)
                .toList();
        long totalQuantity = orderDetails.stream().mapToLong(OrderDetail::getQuantity).sum();
        double calculatedTotal = orderDetails.stream()
                .mapToDouble(detail -> detail.getPrice() * detail.getQuantity())
                .sum();

        model.addAttribute("orderDetails", orderDetails);
        model.addAttribute("order", order);
        model.addAttribute("statusHistory", this.orderService.fetchStatusHistory(order));
        model.addAttribute("itemCount", orderDetails.size());
        model.addAttribute("totalQuantity", totalQuantity);
        model.addAttribute("calculatedTotal", calculatedTotal);
        model.addAttribute("id", id);
        return "/admin/order/detail";
    }

    @RequestMapping("/admin/order/update/{id}")
    public String updateOrderStatus(Model model, @PathVariable long id) {
        Order order = this.orderService.findOrderById(id);
        model.addAttribute("order", order);
        return "admin/order/update";
    }

    @RequestMapping("/admin/order/update")
    public String updateOrderStatus(@ModelAttribute("order") Order dataForm) {
        this.orderService.updateStatusFromAdmin(dataForm.getId(), dataForm.getStatus(), dataForm.getTrackingCode());
        return "redirect:/admin/order";
    }

    @PostMapping("/admin/order/{id}/return-status")
    public String updateReturnStatus(@PathVariable long id,
            @RequestParam("returnStatus") String returnStatus) {
        this.orderService.updateReturnStatusFromAdmin(id, returnStatus);
        return "redirect:/admin/order";
    }

    @PostMapping("/admin/order/{id}/exchange-payment")
    public String confirmExchangePayment(@PathVariable long id) {
        this.orderService.confirmExchangePaymentFromAdmin(id);
        return "redirect:/admin/order";
    }

    @PostMapping("/admin/order/{id}/exchange-complete")
    public String completeExchange(@PathVariable long id) {
        this.orderService.completeExchangeFromAdmin(id);
        return "redirect:/admin/order";
    }

    @PostMapping("/admin/order/{id}/payment-status")
    public String updatePaymentStatus(@PathVariable long id,
            @RequestParam("paymentStatus") String paymentStatus) {
        this.orderService.updatePaymentStatusFromAdmin(id, paymentStatus);
        return "redirect:/admin/order";
    }

    @GetMapping("/admin/order/delete/{id}")
    public String getDeleteOrderPage(Model model, @PathVariable long id) {
        model.addAttribute("id", id);
        Order order = this.orderService.findOrderById(id);
        model.addAttribute("order", order);
        return "/admin/order/delete";
    }

    @PostMapping("admin/order/delete")
    public String postDeleteOrder(Model model, @RequestParam("id") String id) {
        if (id == null || id.isBlank()) {
            return "redirect:/admin/order";
        }
        long orderId = Long.parseLong(id);
        Order order = this.orderService.findOrderById(orderId);
        if (order == null || !order.isDeletableByAdmin()) {
            return "redirect:/admin/order";
        }
        List<OrderDetail> orderDetail = this.orderDetailService.fetchOrderDetails();
        for(OrderDetail detail : orderDetail) {
            if(detail.getOrder().getId() == orderId) {
                this.orderDetailService.handleDeleteOrderDetail(detail);
            }
        }
        this.orderService.handleDeleteOrder(order);
        return "redirect:/admin/order";
    }

    @GetMapping("/order-history")
    public String getOrderHistoryPage(Model model,
            @RequestParam(value = "range", defaultValue = "all") String range,
            @RequestParam(value = "trackingCode", required = false) String trackingCode,
            jakarta.servlet.http.HttpServletRequest request) {
        String email = request.getUserPrincipal().getName();
        User currentUser = this.userService.getUserByEmail(email);

        List<Order> orders = fetchOrdersByRange(currentUser, range);
        orders = filterOrdersByTrackingCode(orders, trackingCode);
        model.addAttribute("orders", orders);
        List<OrderDetail> orderDetails = this.orderDetailService.fetchOrderDetailsByOrders(orders);
        model.addAttribute("orderDetails", orderDetails);
        model.addAttribute("orderTimelineMap", this.orderService.buildTimelineMap(orders));
        model.addAttribute("warrantyClaimMap", this.warrantyService.fetchClaimMap(orderDetails));
        model.addAttribute("exchangeProducts", this.productService.fetchProducts());
        model.addAttribute("activeRange", range);
        model.addAttribute("trackingCode", trackingCode == null ? "" : trackingCode.trim());
        return "client/cart/orderHistory";
    }

    @GetMapping("/order-history/{id}/exchange-qr")
    public String getExchangeQrPage(Model model, @PathVariable long id,
            jakarta.servlet.http.HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        Order order = this.orderService.findOrderById(id);
        if (order == null || currentUser == null || order.getUser() == null
                || order.getUser().getId() != currentUser.getId() || !order.isExchangeQrAvailable()) {
            return "redirect:/order-history";
        }
        model.addAttribute("order", order);
        model.addAttribute("qrUrl", buildExchangeQrUrl(order));
        return "client/cart/exchangeQr";
    }

    @PostMapping("/order-history/{id}/exchange-payment-submitted")
    public String markExchangePaymentSubmitted(@PathVariable long id,
            jakarta.servlet.http.HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        this.orderService.markExchangePaymentSubmitted(id, currentUser);
        return "redirect:/order-history";
    }

    @PostMapping("/order-history/{id}/received")
    public String confirmReceived(@PathVariable long id, jakarta.servlet.http.HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        this.orderService.markReceived(id, currentUser);
        return "redirect:/order-history";
    }

    @PostMapping("/order-history/{id}/return")
    public String requestReturn(@PathVariable long id,
            @RequestParam(value = "returnType", defaultValue = "REFUND") String returnType,
            @RequestParam(value = "exchangeProductId", required = false) Long exchangeProductId,
            @RequestParam("returnReason") String returnReason,
            jakarta.servlet.http.HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        this.orderService.requestReturn(id, currentUser, returnType, exchangeProductId, returnReason);
        Order order = this.orderService.findOrderById(id);
        if (order != null && order.isExchangeRequested() && order.getExchangeAdditionalAmount() > 0) {
            return "redirect:/order-history/" + id + "/exchange-qr";
        }
        return "redirect:/order-history";
    }

    @PostMapping("/order-history/{id}/cancel")
    public String cancelOrder(@PathVariable long id,
            @RequestParam("cancelReason") String cancelReason,
            jakarta.servlet.http.HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        this.orderService.cancelOrderFromCustomer(id, currentUser, cancelReason);
        return "redirect:/order-history";
    }

    private List<Order> fetchOrdersByRange(User user, String range) {
        LocalDateTime now = LocalDateTime.now();
        return switch (range) {
            case "day" -> this.orderService.fetchOrdersByUserAndRange(user, now.minusDays(1), now);
            case "week" -> this.orderService.fetchOrdersByUserAndRange(user, now.minusWeeks(1), now);
            case "month" -> this.orderService.fetchOrdersByUserAndRange(user, now.minusMonths(1), now);
            case "year" -> this.orderService.fetchOrdersByUserAndRange(user, now.minusYears(1), now);
            default -> this.orderService.fetchOrdersByUser(user);
        };
    }

    private List<Order> fetchAdminOrdersByRange(String range) {
        LocalDateTime now = LocalDateTime.now();
        return switch (range) {
            case "day" -> this.orderService.fetchOrdersForAdminHistoryByRange(now.minusDays(1), now);
            case "week" -> this.orderService.fetchOrdersForAdminHistoryByRange(now.minusWeeks(1), now);
            case "month" -> this.orderService.fetchOrdersForAdminHistoryByRange(now.minusMonths(1), now);
            case "year" -> this.orderService.fetchOrdersForAdminHistoryByRange(now.minusYears(1), now);
            default -> this.orderService.fetchOrdersForAdminHistory();
        };
    }

    private List<AdminCustomerOrderHistoryDTO> buildCustomerHistories(List<Order> orders) {
        Map<Long, List<Order>> ordersByCustomer = new LinkedHashMap<>();
        for (Order order : orders) {
            if (order.getUser() == null) {
                continue;
            }
            ordersByCustomer.computeIfAbsent(order.getUser().getId(), id -> new java.util.ArrayList<>()).add(order);
        }

        return ordersByCustomer.values().stream()
                .map(customerOrders -> {
                    User user = customerOrders.get(0).getUser();
                    Order lastOrder = customerOrders.stream()
                            .max(Comparator.comparing(Order::getCreatedAt,
                                    Comparator.nullsFirst(Comparator.naturalOrder())))
                            .orElse(customerOrders.get(0));
                    double totalSpent = customerOrders.stream().mapToDouble(Order::getTotalPrice).sum();
                    long completedOrderCount = countOrdersByStatus(customerOrders, "COMPLETE", "COMPLETED");
                    long shippingOrderCount = countOrdersByStatus(customerOrders, "SHIPPING");
                    long cancelledOrderCount = countOrdersByStatus(customerOrders, "CANCEL", "CANCELLED");
                    long returnOrderCount = customerOrders.stream().filter(Order::isReturnRequested).count();
                    long exchangeOrderCount = customerOrders.stream().filter(Order::isExchangeRequested).count();
                    return new AdminCustomerOrderHistoryDTO(user, customerOrders.size(), totalSpent,
                            lastOrder.getCreatedAt(), lastOrder, completedOrderCount, shippingOrderCount,
                            cancelledOrderCount, returnOrderCount, exchangeOrderCount);
                })
                .sorted(Comparator.comparing(AdminCustomerOrderHistoryDTO::getLastOrderAt,
                        Comparator.nullsLast(Comparator.reverseOrder())))
                .toList();
    }

    private long countOrdersByStatus(List<Order> orders, String... statuses) {
        return orders.stream()
                .filter(order -> {
                    String orderStatus = order.getStatus();
                    if (orderStatus == null) {
                        return false;
                    }
                    for (String status : statuses) {
                        if (status.equalsIgnoreCase(orderStatus)) {
                            return true;
                        }
                    }
                    return false;
                })
                .count();
    }

    private List<Order> filterOrdersByTrackingCode(List<Order> orders, String trackingCode) {
        String keyword = trackingCode == null ? "" : trackingCode.trim().toLowerCase();
        if (keyword.isBlank()) {
            return orders;
        }
        String normalizedKeyword = keyword.replace(" ", "");
        return orders.stream()
                .filter(order -> order.getTrackingCode() != null
                        && order.getTrackingCode().toLowerCase().replace(" ", "").contains(normalizedKeyword))
                .toList();
    }

    private List<Order> filterOrdersByCustomerKeyword(List<Order> orders, String customerKeyword) {
        String keyword = customerKeyword == null ? "" : customerKeyword.trim().toLowerCase();
        if (keyword.isBlank()) {
            return orders;
        }
        return orders.stream()
                .filter(order -> {
                    User user = order.getUser();
                    if (user == null) {
                        return false;
                    }
                    return containsIgnoreCase(user.getFullName(), keyword)
                            || containsIgnoreCase(user.getEmail(), keyword)
                            || containsIgnoreCase(user.getPhone(), keyword);
                })
                .toList();
    }

    private boolean containsIgnoreCase(String value, String keyword) {
        return value != null && value.toLowerCase().contains(keyword);
    }

    private String buildExchangeQrUrl(Order order) {
        String addInfo = "EXCHANGE" + order.getId();
        String accountName = URLEncoder.encode("NGUYEN THANH LONG", StandardCharsets.UTF_8);
        String encodedAddInfo = URLEncoder.encode(addInfo, StandardCharsets.UTF_8);
        return "https://img.vietqr.io/image/TCB-3208032006-compact2.png?amount="
                + Math.round(order.getExchangeAdditionalAmount())
                + "&addInfo=" + encodedAddInfo
                + "&accountName=" + accountName;
    }

    private User getCurrentUser(jakarta.servlet.http.HttpServletRequest request) {
        if (request.getUserPrincipal() == null) {
            return null;
        }
        return this.userService.getUserByEmail(request.getUserPrincipal().getName());
    }

}
