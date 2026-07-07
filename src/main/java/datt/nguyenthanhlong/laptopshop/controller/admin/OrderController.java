package datt.nguyenthanhlong.laptopshop.controller.admin;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.service.OrderDetailService;
import datt.nguyenthanhlong.laptopshop.service.OrderService;
import datt.nguyenthanhlong.laptopshop.service.UserService;
import datt.nguyenthanhlong.laptopshop.service.WarrantyService;

@Controller
public class OrderController {
    private final OrderService orderService;
    private final OrderDetailService orderDetailService;
    private final UserService userService;
    private final WarrantyService warrantyService;

    public OrderController(OrderService orderService, OrderDetailService orderDetailService, UserService userService,
            WarrantyService warrantyService) {
        this.orderService = orderService;
        this.orderDetailService = orderDetailService;
        this.userService = userService;
        this.warrantyService = warrantyService;
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
        model.addAttribute("activeRange", range);
        model.addAttribute("trackingCode", trackingCode == null ? "" : trackingCode.trim());
        return "client/cart/orderHistory";
    }

    @PostMapping("/order-history/{id}/received")
    public String confirmReceived(@PathVariable long id, jakarta.servlet.http.HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        this.orderService.markReceived(id, currentUser);
        return "redirect:/order-history";
    }

    @PostMapping("/order-history/{id}/return")
    public String requestReturn(@PathVariable long id,
            @RequestParam("returnReason") String returnReason,
            jakarta.servlet.http.HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        this.orderService.requestReturn(id, currentUser, returnReason);
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

    private User getCurrentUser(jakarta.servlet.http.HttpServletRequest request) {
        if (request.getUserPrincipal() == null) {
            return null;
        }
        return this.userService.getUserByEmail(request.getUserPrincipal().getName());
    }

}
