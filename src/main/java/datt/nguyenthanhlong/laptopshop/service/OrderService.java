package datt.nguyenthanhlong.laptopshop
.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.OrderStatusHistory;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.dto.OrderTimelineStepDTO;
import datt.nguyenthanhlong.laptopshop.repository.OrderRepository;
import datt.nguyenthanhlong.laptopshop.repository.OrderStatusHistoryRepository;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final NotificationService notificationService;
    private final OrderStatusHistoryRepository orderStatusHistoryRepository;

    public OrderService(OrderRepository orderRepository, NotificationService notificationService,
            OrderStatusHistoryRepository orderStatusHistoryRepository) {
        this.orderRepository = orderRepository;
        this.notificationService = notificationService;
        this.orderStatusHistoryRepository = orderStatusHistoryRepository;
    }

    public List<Order> fetchOrders() {
        return this.orderRepository.findAll();
    }

    public Page<Order> fetchOrders(Pageable pageable) {
        return this.orderRepository.findAll(pageable);
    }

    public List<Order> fetchOrdersByUser(User user) {
        return this.orderRepository.findByUserOrderByCreatedAtDescIdDesc(user);
    }

    public List<Order> fetchOrdersByUserAndRange(User user, LocalDateTime start, LocalDateTime end) {
        return this.orderRepository.findByUserAndCreatedAtBetweenOrderByCreatedAtDescIdDesc(user, start, end);
    }

    public List<OrderStatusHistory> fetchStatusHistory(Order order) {
        if (order == null) {
            return List.of();
        }
        return this.orderStatusHistoryRepository.findByOrderOrderByCreatedAtDescIdDesc(order);
    }

    public Map<Long, List<OrderTimelineStepDTO>> buildTimelineMap(List<Order> orders) {
        if (orders == null || orders.isEmpty()) {
            return Map.of();
        }
        Map<Long, List<OrderTimelineStepDTO>> timelines = new HashMap<>();
        for (Order order : orders) {
            timelines.put(order.getId(), buildTimeline(order));
        }
        return timelines;
    }

    public List<OrderTimelineStepDTO> buildTimeline(Order order) {
        if (order == null) {
            return List.of();
        }

        Map<String, LocalDateTime> statusTimes = new HashMap<>();
        statusTimes.put("PENDING", order.getCreatedAt());
        for (OrderStatusHistory history : fetchStatusHistory(order)) {
            statusTimes.put(normalizeStatus(history.getNewStatus()), history.getCreatedAt());
        }
        if (order.getReceivedAt() != null) {
            statusTimes.put("COMPLETE", order.getReceivedAt());
        }

        String currentStatus = normalizeStatus(order.getStatus());
        int currentIndex = statusIndex(currentStatus);
        List<OrderTimelineStepDTO> steps = new ArrayList<>();
        steps.add(new OrderTimelineStepDTO("PENDING", "Da dat hang", "Shop da nhan don", currentIndex >= 0,
                statusTimes.get("PENDING")));
        steps.add(new OrderTimelineStepDTO("CONFIRM", "Da xac nhan", "Admin da xac nhan don", currentIndex >= 1,
                firstTime(statusTimes, "CONFIRM", "CONFIRMED")));
        steps.add(new OrderTimelineStepDTO("SHIPPING", "Dang giao", "Don dang duoc giao toi ban", currentIndex >= 2,
                statusTimes.get("SHIPPING")));
        steps.add(new OrderTimelineStepDTO("COMPLETE", "Đã nhận hàng", "Hoàn thành và có thể đánh giá/bảo hành",
                currentIndex >= 3 || order.isCustomerConfirmedReceived(), statusTimes.get("COMPLETE")));

        if ("CANCEL".equals(currentStatus)) {
            steps.add(new OrderTimelineStepDTO("CANCEL", "Đã hủy", "Đơn hàng đã bị hủy", true,
                    firstTime(statusTimes, "CANCEL", "CANCELLED")));
        }
        return steps;
    }

    public Order findOrderById(long id) {
        Optional<Order> order = this.orderRepository.findById(id);
        if(order.isPresent()){
            return order.get();
        }
        return null;
    }

    public void save(Order order) {
        this.orderRepository.save(order);
    }

    public boolean markReceived(long orderId, User user) {
        Order order = findOrderById(orderId);
        if (order == null || user == null || order.getUser() == null || order.getUser().getId() != user.getId()) {
            return false;
        }
        if (order.isCustomerConfirmedReceived()) {
            return true;
        }
        if (!"SHIPPING".equalsIgnoreCase(order.getStatus())) {
            return false;
        }

        String oldStatus = order.getStatus();
        order.setCustomerConfirmedReceived(true);
        order.setReceivedAt(LocalDateTime.now());
        order.setStatus("COMPLETE");
        if ("COD".equalsIgnoreCase(order.getPaymentMethod())) {
            order.setPaymentStatus("PAID");
            order.setPaidConfirmedAt(LocalDateTime.now());
        }
        this.orderRepository.save(order);
        recordStatusHistory(order, oldStatus, order.getStatus(), "CUSTOMER", "Khach xac nhan da nhan hang");
        return true;
    }

    public boolean requestReturn(long orderId, User user, String reason) {
        Order order = findOrderById(orderId);
        if (order == null || user == null || order.getUser() == null || order.getUser().getId() != user.getId()) {
            return false;
        }
        if (!order.isCustomerConfirmedReceived()) {
            return false;
        }

        order.setReturnRequested(true);
        order.setReturnReason(reason == null ? "" : reason.trim());
        order.setReturnStatus("PENDING");
        order.setReturnRequestedAt(LocalDateTime.now());
        this.orderRepository.save(order);
        return true;
    }

    public boolean updateStatusFromAdmin(long orderId, String status) {
        return updateStatusFromAdmin(orderId, status, null);
    }

    public boolean updateStatusFromAdmin(long orderId, String status, String trackingCode) {
        Order order = findOrderById(orderId);
        if (order == null || order.isLockedForAdminChanges()) {
            return false;
        }

        String oldStatus = order.getStatus();
        String normalizedStatus = status == null || status.isBlank() ? oldStatus : status.trim();
        if ("COMPLETE".equalsIgnoreCase(normalizedStatus) || "COMPLETED".equalsIgnoreCase(normalizedStatus)) {
            return false;
        }
        order.setStatus(normalizedStatus);
        String normalizedTrackingCode = trackingCode == null ? "" : trackingCode.trim();
        if (!normalizedTrackingCode.isBlank()) {
            order.setTrackingCode(normalizedTrackingCode);
        } else if ("SHIPPING".equalsIgnoreCase(normalizedStatus)
                && (order.getTrackingCode() == null || order.getTrackingCode().isBlank())) {
            order.setTrackingCode(generateTrackingCode(order));
        }
        this.orderRepository.save(order);
        recordStatusHistory(order, oldStatus, normalizedStatus, "ADMIN", "Admin cập nhật đơn hàng");
        this.notificationService.notify(order.getUser(), "Đơn hàng đã đổi trạng thái",
                "Đơn #" + order.getId() + " hiện là " + order.getStatusLabel(), "/order-history");
        return true;
    }

    private String generateTrackingCode(Order order) {
        long orderId = order == null ? 0 : order.getId();
        String datePart = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.BASIC_ISO_DATE);
        return "LTS" + datePart + String.format("%06d", orderId);
    }

    public boolean cancelOrderFromCustomer(long orderId, User user, String reason) {
        Order order = findOrderById(orderId);
        if (order == null || user == null || order.getUser() == null || order.getUser().getId() != user.getId()) {
            return false;
        }
        if (!order.isCancelableByCustomer()) {
            return false;
        }
        String normalizedReason = reason == null ? "" : reason.trim();
        if (normalizedReason.isBlank()) {
            return false;
        }

        String oldStatus = order.getStatus();
        order.setStatus("CANCEL");
        order.setCancelReason(normalizedReason);
        this.orderRepository.save(order);
        recordStatusHistory(order, oldStatus, order.getStatus(), "CUSTOMER", normalizedReason);
        this.notificationService.notifyAdmins("Khách đã hủy đơn hàng",
                "Don #" + order.getId() + " da bi huy. Ly do: " + normalizedReason, "/admin/order");
        return true;
    }

    public boolean updateReturnStatusFromAdmin(long orderId, String returnStatus) {
        Order order = findOrderById(orderId);
        if (order == null || !order.isReturnRequested() || isReturnCompleted(order)) {
            return false;
        }

        order.setReturnStatus(returnStatus == null || returnStatus.isBlank() ? "PENDING" : returnStatus.trim());
        this.orderRepository.save(order);
        this.notificationService.notify(order.getUser(), "Yêu cầu đổi trả đã cập nhật",
                "Đơn #" + order.getId() + " đổi trả: " + order.getReturnStatusLabel(), "/order-history");
        return true;
    }

    private boolean isReturnCompleted(Order order) {
        return order != null && "COMPLETED".equalsIgnoreCase(order.getReturnStatus());
    }

    public boolean markQrPaymentSubmitted(long orderId, User user) {
        Order order = findOrderById(orderId);
        if (order == null || user == null || order.getUser() == null || order.getUser().getId() != user.getId()) {
            return false;
        }
        if (!"QR".equalsIgnoreCase(order.getPaymentMethod())) {
            return false;
        }

        order.setPaymentStatus("WAITING_CONFIRM");
        order.setPaidRequestedAt(LocalDateTime.now());
        this.orderRepository.save(order);
        String customerName = order.getUser() == null ? "Khách hàng" : order.getUser().getFullName();
        this.notificationService.notifyAdmins("Khach da bao thanh toan QR",
                customerName + " da bam da thanh toan cho don #" + order.getId(),
                "/admin/order");
        return true;
    }

    public boolean updatePaymentStatusFromAdmin(long orderId, String paymentStatus) {
        Order order = findOrderById(orderId);
        if (order == null || !"QR".equalsIgnoreCase(order.getPaymentMethod())) {
            return false;
        }

        String normalizedStatus = paymentStatus == null || paymentStatus.isBlank()
                ? "WAITING_CONFIRM"
                : paymentStatus.trim();
        order.setPaymentStatus(normalizedStatus);
        if ("PAID".equals(normalizedStatus)) {
            order.setPaidConfirmedAt(LocalDateTime.now());
        }
        this.orderRepository.save(order);
        return true;
    }

    public void handleDeleteOrder(Order order) {
        this.orderRepository.delete(order);
    }

    private void recordStatusHistory(Order order, String oldStatus, String newStatus, String actor, String note) {
        if (order == null || newStatus == null || newStatus.equals(oldStatus)) {
            return;
        }
        OrderStatusHistory history = new OrderStatusHistory();
        history.setOrder(order);
        history.setOldStatus(oldStatus);
        history.setNewStatus(newStatus);
        history.setActor(actor);
        history.setNote(note);
        this.orderStatusHistoryRepository.save(history);
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return "PENDING";
        }
        String value = status.trim().toUpperCase();
        if ("CONFIRMED".equals(value)) {
            return "CONFIRM";
        }
        if ("COMPLETED".equals(value)) {
            return "COMPLETE";
        }
        if ("CANCELLED".equals(value)) {
            return "CANCEL";
        }
        return value;
    }

    private int statusIndex(String status) {
        return switch (normalizeStatus(status)) {
            case "PENDING" -> 0;
            case "CONFIRM" -> 1;
            case "SHIPPING" -> 2;
            case "COMPLETE" -> 3;
            case "CANCEL" -> 0;
            default -> 0;
        };
    }

    private LocalDateTime firstTime(Map<String, LocalDateTime> statusTimes, String... statuses) {
        for (String status : statuses) {
            LocalDateTime time = statusTimes.get(status);
            if (time != null) {
                return time;
            }
        }
        return null;
    }
}
