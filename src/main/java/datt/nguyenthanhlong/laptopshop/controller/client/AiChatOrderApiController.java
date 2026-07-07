package datt.nguyenthanhlong.laptopshop.controller.client;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletRequest;
import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.repository.OrderDetailRepository;
import datt.nguyenthanhlong.laptopshop.repository.OrderRepository;
import datt.nguyenthanhlong.laptopshop.service.OrderService;
import datt.nguyenthanhlong.laptopshop.service.UserService;
import datt.nguyenthanhlong.laptopshop.service.WarrantyService;

@RestController
public class AiChatOrderApiController {
    private final UserService userService;
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final OrderService orderService;
    private final WarrantyService warrantyService;

    public AiChatOrderApiController(UserService userService,
            OrderRepository orderRepository,
            OrderDetailRepository orderDetailRepository,
            OrderService orderService,
            WarrantyService warrantyService) {
        this.userService = userService;
        this.orderRepository = orderRepository;
        this.orderDetailRepository = orderDetailRepository;
        this.orderService = orderService;
        this.warrantyService = warrantyService;
    }

    @GetMapping("/ai-chat/api/orders")
    @ResponseBody
    public Map<String, Object> listOrders(HttpServletRequest request) {
        User user = currentUser(request);
        Map<String, Object> response = new LinkedHashMap<>();
        if (user == null) {
            response.put("authenticated", false);
            response.put("message", "Bạn cần đăng nhập để xem đơn hàng.");
            response.put("orders", List.of());
            return response;
        }

        List<Order> orders = this.orderRepository.findByUserOrderByCreatedAtDescIdDesc(user);
        response.put("authenticated", true);
        response.put("orders", orders.stream().limit(8).map(this::orderDto).toList());
        return response;
    }

    @GetMapping("/ai-chat/api/orders/{id}")
    @ResponseBody
    public Map<String, Object> orderDetail(@PathVariable long id, HttpServletRequest request) {
        User user = currentUser(request);
        Order order = ownedOrder(id, user);
        if (order == null) {
            return Map.of("success", false, "message", "Không tìm thấy đơn hàng của bạn.");
        }

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("order", orderDto(order));
        response.put("items", this.orderDetailRepository.findByOrderIn(List.of(order)).stream()
                .map(this::orderDetailDto)
                .toList());
        return response;
    }

    @PostMapping("/ai-chat/api/orders/{id}/return")
    @ResponseBody
    public Map<String, Object> requestReturn(@PathVariable long id,
            @RequestParam("reason") String reason,
            HttpServletRequest request) {
        User user = currentUser(request);
        boolean success = this.orderService.requestReturn(id, user, reason);
        return Map.of(
                "success", success,
                "message", success
                        ? "Đã gửi yêu cầu đổi trả cho đơn #" + id + ". Admin sẽ kiểm tra và phản hồi."
                        : "Chưa thể gửi yêu cầu đổi trả. Đơn hàng phải đã nhận và chưa có yêu cầu đổi trả.");
    }

    @PostMapping("/ai-chat/api/warranty/{orderDetailId}")
    @ResponseBody
    public Map<String, Object> requestWarranty(@PathVariable long orderDetailId,
            @RequestParam("issue") String issue,
            HttpServletRequest request) {
        User user = currentUser(request);
        boolean success = this.warrantyService.requestWarranty(orderDetailId, user, issue);
        return Map.of(
                "success", success,
                "message", success
                        ? "Đã gửi yêu cầu bảo hành. Admin sẽ cập nhật trạng thái trên hệ thống."
                        : "Chưa thể gửi bảo hành. Sản phẩm phải thuộc đơn đã nhận và chưa có phiếu bảo hành.");
    }

    private User currentUser(HttpServletRequest request) {
        if (request.getUserPrincipal() == null) {
            return null;
        }
        return this.userService.getUserByEmail(request.getUserPrincipal().getName());
    }

    private Order ownedOrder(long orderId, User user) {
        if (user == null) {
            return null;
        }
        return this.orderRepository.findById(orderId)
                .filter(order -> order.getUser() != null && order.getUser().getId() == user.getId())
                .orElse(null);
    }

    private Map<String, Object> orderDto(Order order) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("id", order.getId());
        dto.put("status", order.getStatusLabel());
        dto.put("rawStatus", order.getStatus());
        dto.put("paymentStatus", order.getPaymentStatusLabel());
        dto.put("paymentMethod", order.getPaymentMethod());
        dto.put("trackingCode", order.getTrackingCode());
        dto.put("totalPrice", order.getTotalPrice());
        dto.put("createdAt", order.getCreatedAt() == null ? "" : order.getCreatedAt().toString());
        dto.put("received", order.isCustomerConfirmedReceived());
        dto.put("returnRequested", order.isReturnRequested());
        dto.put("returnStatus", order.getReturnStatusLabel());
        dto.put("canReturn", order.isCustomerConfirmedReceived() && !order.isReturnRequested());
        dto.put("canWarranty", order.isCustomerConfirmedReceived());
        return dto;
    }

    private Map<String, Object> orderDetailDto(OrderDetail detail) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("id", detail.getId());
        dto.put("productName", detail.getProduct() == null ? "Sản phẩm" : detail.getProduct().getName());
        dto.put("quantity", detail.getQuantity());
        dto.put("price", detail.getPrice());
        return dto;
    }
}
