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
import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.domain.OrderStatusHistory;
import datt.nguyenthanhlong.laptopshop.domain.Product;
import datt.nguyenthanhlong.laptopshop.domain.User;
import datt.nguyenthanhlong.laptopshop.domain.dto.OrderTimelineStepDTO;
import datt.nguyenthanhlong.laptopshop.repository.OrderDetailRepository;
import datt.nguyenthanhlong.laptopshop.repository.OrderRepository;
import datt.nguyenthanhlong.laptopshop.repository.OrderStatusHistoryRepository;
import datt.nguyenthanhlong.laptopshop.repository.ProductRepository;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final NotificationService notificationService;
    private final OrderStatusHistoryRepository orderStatusHistoryRepository;
    private final ProductRepository productRepository;
    private final OrderDetailRepository orderDetailRepository;

    public OrderService(OrderRepository orderRepository, NotificationService notificationService,
            OrderStatusHistoryRepository orderStatusHistoryRepository, ProductRepository productRepository,
            OrderDetailRepository orderDetailRepository) {
        this.orderRepository = orderRepository;
        this.notificationService = notificationService;
        this.orderStatusHistoryRepository = orderStatusHistoryRepository;
        this.productRepository = productRepository;
        this.orderDetailRepository = orderDetailRepository;
    }

    public List<Order> fetchOrders() {
        return this.orderRepository.findAll();
    }

    public Page<Order> fetchOrders(Pageable pageable) {
        return this.orderRepository.findAll(pageable);
    }

    public List<Order> fetchOrdersForAdminHistory() {
        return this.orderRepository.findAllByOrderByCreatedAtDescIdDesc();
    }

    public List<Order> fetchOrdersForAdminHistoryByRange(LocalDateTime start, LocalDateTime end) {
        return this.orderRepository.findByCreatedAtBetweenOrderByCreatedAtDescIdDesc(start, end);
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
        List<OrderStatusHistory> histories = new ArrayList<>(
                this.orderStatusHistoryRepository.findByOrderOrderByCreatedAtDescIdDesc(order));
        if (order.isReturnRequested() && histories.stream().noneMatch(this::isReturnHistory)) {
            OrderStatusHistory returnHistory = new OrderStatusHistory();
            returnHistory.setOrder(order);
            returnHistory.setOldStatus("Doi tra");
            returnHistory.setNewStatus(order.getReturnTypeLabel() + ": " + order.getReturnStatusLabel());
            returnHistory.setActor("SYSTEM");
            returnHistory.setNote("Trang thai doi tra hien tai");
            returnHistory.setCreatedAt(order.getReturnRequestedAt());
            histories.add(0, returnHistory);
        }
        return histories;
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
            String normalizedHistoryStatus = normalizeStatus(history.getNewStatus());
            if (isOrderFlowStatus(normalizedHistoryStatus)) {
                statusTimes.put(normalizedHistoryStatus, history.getCreatedAt());
            }
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
        if (order.isExchangeRequested() && order.isExchangePaymentConfirmed() && !order.isExchangeCompleted()
                && "SHIPPING".equalsIgnoreCase(order.getStatus())) {
            order.setExchangeCompleted(true);
            order.setReturnStatus("COMPLETED");
            order.setStatus("COMPLETE");
            addExchangeProductToOrderDetails(order);
            this.orderRepository.save(order);
            recordOrderAction(order, "CUSTOMER", "Khach xac nhan da nhan may doi moi",
                    order.getExchangeProduct() == null ? "" : "Doi hang thanh cong: " + order.getExchangeProduct().getName());
            recordStatusHistory(order, "SHIPPING", order.getStatus(), "CUSTOMER", "Khach da nhan may doi moi");
            this.notificationService.notifyAdmins("Khach da nhan may doi moi",
                    customerName(order) + " da xac nhan da nhan may doi moi cho don #" + order.getId(),
                    adminOrderLink(order));
            return true;
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

    public boolean requestReturn(long orderId, User user, String returnType, Long exchangeProductId, String reason) {
        Order order = findOrderById(orderId);
        if (order == null || user == null || order.getUser() == null || order.getUser().getId() != user.getId()) {
            return false;
        }
        if (!order.isCustomerConfirmedReceived()) {
            return false;
        }

        String normalizedReturnType = "EXCHANGE".equalsIgnoreCase(returnType) ? "EXCHANGE" : "REFUND";
        Product exchangeProduct = null;
        if ("EXCHANGE".equals(normalizedReturnType)) {
            if (exchangeProductId == null) {
                return false;
            }
            exchangeProduct = this.productRepository.findOneById(exchangeProductId);
            if (exchangeProduct == null) {
                return false;
            }
        }
        order.setReturnRequested(true);
        order.setReturnType(normalizedReturnType);
        order.setReturnReason(reason == null ? "" : reason.trim());
        order.setReturnStatus("PENDING");
        order.setReturnRequestedAt(LocalDateTime.now());
        if (exchangeProduct != null) {
            applyExchangeProduct(order, exchangeProduct);
        }
        this.orderRepository.save(order);
        String action = order.isExchangeRequested() ? "Khach yeu cau doi hang" : "Khach yeu cau tra hang hoan tien";
        recordOrderAction(order, "CUSTOMER", action, order.getReturnReason());
        String title = order.isExchangeRequested() ? "Khach yeu cau doi hang" : "Khach yeu cau tra hang hoan tien";
        String content = customerName(order) + " da gui yeu cau cho don #" + order.getId();
        if (order.isExchangeRequested() && order.getExchangeProduct() != null) {
            content += " - doi sang " + order.getExchangeProduct().getName();
        }
        this.notificationService.notifyAdmins(title, content, adminOrderLink(order));
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

        String oldReturnStatus = order.getReturnStatus() == null || order.getReturnStatus().isBlank()
                ? "PENDING"
                : order.getReturnStatus().trim();
        String normalizedReturnStatus = returnStatus == null || returnStatus.isBlank() ? "PENDING" : returnStatus.trim();
        order.setReturnStatus(normalizedReturnStatus);
        this.orderRepository.save(order);
        recordReturnStatusHistory(order, oldReturnStatus, normalizedReturnStatus, "ADMIN",
                order.getReturnStatusLabel());
        this.notificationService.notify(order.getUser(), "Yêu cầu sau bán hàng đã cập nhật",
                "Đơn #" + order.getId() + " " + order.getReturnTypeLabel().toLowerCase() + ": "
                        + order.getReturnStatusLabel(),
                "/order-history");
        return true;
    }

    public boolean confirmExchangePaymentFromAdmin(long orderId) {
        Order order = findOrderById(orderId);
        if (order == null || !order.isExchangeRequested() || isReturnCompleted(order)) {
            return false;
        }

        order.setExchangePaymentConfirmed(true);
        if (!"COMPLETED".equalsIgnoreCase(order.getReturnStatus())) {
            order.setReturnStatus("APPROVED");
        }
        this.orderRepository.save(order);
        recordOrderAction(order, "ADMIN", "Admin xac nhan du tien doi hang",
                "Khach da chuyen du tien de doi may moi");
        this.notificationService.notify(order.getUser(), "Đổi hàng đã xác nhận đủ tiền",
                "Đơn #" + order.getId() + " đã được xác nhận đủ tiền để đổi máy mới.", "/order-history");
        return true;
    }

    private void applyExchangeProduct(Order order, Product exchangeProduct) {
        double newProductPrice = Math.max(exchangeProduct.getPrice(), 0);
        double creditAmount = order.getExchangeCreditAmount();
        order.setExchangeProduct(exchangeProduct);
        order.setExchangeNewProductPrice(newProductPrice);
        order.setExchangeAdditionalAmount(Math.max(newProductPrice - creditAmount, 0));
        order.setExchangeRefundAmount(Math.max(creditAmount - newProductPrice, 0));
        order.setExchangePaymentSubmitted(false);
        order.setExchangePaymentConfirmed(order.getExchangeAdditionalAmount() <= 0);
        order.setExchangeCompleted(false);
    }

    public boolean completeExchangeFromAdmin(long orderId) {
        Order order = findOrderById(orderId);
        if (order == null || !order.isExchangeRequested()
                || order.isExchangeCompleted()
                || (order.getExchangeAdditionalAmount() > 0 && !order.isExchangePaymentConfirmed())) {
            return false;
        }

        if (order.getExchangeAdditionalAmount() <= 0) {
            order.setExchangePaymentConfirmed(true);
        }
        order.setExchangeCompleted(true);
        order.setReturnStatus("COMPLETED");
        addExchangeProductToOrderDetails(order);
        this.orderRepository.save(order);
        recordOrderAction(order, "ADMIN", "Admin hoan tat doi hang",
                order.getExchangeProduct() == null ? "" : "May moi: " + order.getExchangeProduct().getName());
        this.notificationService.notify(order.getUser(), "Đổi hàng đã hoàn tất",
                "Đơn #" + order.getId() + " đã được đổi máy mới cho khách hàng.", "/order-history");
        return true;
    }

    public boolean markExchangePaymentSubmitted(long orderId, User user) {
        Order order = findOrderById(orderId);
        if (order == null || user == null || order.getUser() == null || order.getUser().getId() != user.getId()) {
            return false;
        }
        if (!order.isExchangeRequested() || order.getExchangeAdditionalAmount() <= 0 || order.isExchangePaymentConfirmed()) {
            return false;
        }
        order.setExchangePaymentSubmitted(true);
        this.orderRepository.save(order);
        recordOrderAction(order, "CUSTOMER", "Khach bao da chuyen tien doi hang",
                Math.round(order.getExchangeAdditionalAmount()) + " d");
        this.notificationService.notifyAdmins("Khách đã chuyển khoản đổi hàng",
                "Đơn #" + order.getId() + " đã báo chuyển "
                        + Math.round(order.getExchangeAdditionalAmount()) + " đ để đổi hàng.",
                adminOrderLink(order));
        return true;
    }

    private void addExchangeProductToOrderDetails(Order order) {
        if (order == null || order.getExchangeProduct() == null) {
            return;
        }

        Product exchangeProduct = order.getExchangeProduct();
        OrderDetail existingDetail = this.orderDetailRepository.findByOrderAndProduct(order, exchangeProduct);
        if (existingDetail != null) {
            return;
        }

        OrderDetail orderDetail = new OrderDetail();
        orderDetail.setOrder(order);
        orderDetail.setProduct(exchangeProduct);
        orderDetail.setQuantity(1);
        double exchangePrice = order.getExchangeNewProductPrice() > 0
                ? order.getExchangeNewProductPrice()
                : exchangeProduct.getPrice();
        orderDetail.setPrice(exchangePrice);
        this.orderDetailRepository.save(orderDetail);
    }

    private boolean isReturnCompleted(Order order) {
        return order != null && "COMPLETED".equalsIgnoreCase(order.getReturnStatus());
    }

    private boolean isReturnHistory(OrderStatusHistory history) {
        if (history == null || history.getOldStatus() == null) {
            return false;
        }
        return history.getOldStatus().startsWith("Doi tra")
                || history.getOldStatus().startsWith("Tra hang")
                || history.getOldStatus().startsWith("Doi hang")
                || "Hanh dong".equals(history.getOldStatus());
    }

    private void recordReturnStatusHistory(Order order, String oldStatus, String newStatus, String actor, String note) {
        if (order == null || newStatus == null || newStatus.equals(oldStatus)) {
            return;
        }
        OrderStatusHistory history = new OrderStatusHistory();
        history.setOrder(order);
        history.setOldStatus("Doi tra: " + oldStatus);
        history.setNewStatus(newStatus);
        history.setActor(actor);
        history.setNote(note == null ? "" : note);
        this.orderStatusHistoryRepository.save(history);
    }

    private void recordOrderAction(Order order, String actor, String action, String note) {
        if (order == null || action == null || action.isBlank()) {
            return;
        }
        OrderStatusHistory history = new OrderStatusHistory();
        history.setOrder(order);
        history.setOldStatus("Hanh dong");
        history.setNewStatus(action);
        history.setActor(actor);
        history.setNote(note == null ? "" : note);
        this.orderStatusHistoryRepository.save(history);
    }

    private String customerName(Order order) {
        if (order == null || order.getUser() == null) {
            return "Khach hang";
        }
        String fullName = order.getUser().getFullName();
        if (fullName == null || fullName.isBlank()) {
            return "Khach hang #" + order.getUser().getId();
        }
        return fullName;
    }

    private String adminOrderLink(Order order) {
        if (order == null) {
            return "/admin/order";
        }
        return "/admin/order/" + order.getId();
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

    private boolean isOrderFlowStatus(String status) {
        return switch (normalizeStatus(status)) {
            case "PENDING", "CONFIRM", "SHIPPING", "COMPLETE", "CANCEL" -> true;
            default -> false;
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
