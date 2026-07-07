package datt.nguyenthanhlong.laptopshop.domain;

import java.util.Set;
import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private double totalPrice;

    private double subtotalPrice;

    private double discountAmount;

    private String voucherCode;

    private String voucherName;

    private String paymentMethod;

    private String paymentStatus;

    private LocalDateTime paidRequestedAt;

    private LocalDateTime paidConfirmedAt;

    private String receiverName;

    private String receiverPhone;

    private String receiverAddress;

    private String status;

    private String trackingCode;

    private String cancelReason;

    @CreationTimestamp
    private LocalDateTime createdAt;

    private boolean customerConfirmedReceived;

    private LocalDateTime receivedAt;

    private boolean returnRequested;

    private String returnStatus;

    private LocalDateTime returnRequestedAt;

    private String returnReason;

    private boolean warrantyCompleted;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "order")
    private Set<OrderDetail> orderDetails;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public double getSubtotalPrice() {
        return subtotalPrice;
    }

    public void setSubtotalPrice(double subtotalPrice) {
        this.subtotalPrice = subtotalPrice;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public String getVoucherName() {
        return voucherName;
    }

    public void setVoucherName(String voucherName) {
        this.voucherName = voucherName;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDateTime getPaidRequestedAt() {
        return paidRequestedAt;
    }

    public void setPaidRequestedAt(LocalDateTime paidRequestedAt) {
        this.paidRequestedAt = paidRequestedAt;
    }

    public LocalDateTime getPaidConfirmedAt() {
        return paidConfirmedAt;
    }

    public void setPaidConfirmedAt(LocalDateTime paidConfirmedAt) {
        this.paidConfirmedAt = paidConfirmedAt;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public String getReceiverAddress() {
        return receiverAddress;
    }

    public void setReceiverAddress(String receiverAddress) {
        this.receiverAddress = receiverAddress;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatusLabel() {
        if (status == null) {
            return "Chưa xác định";
        }
        return switch (status.toUpperCase()) {
            case "PENDING" -> "Chờ xác nhận";
            case "CONFIRM", "CONFIRMED" -> "Đã xác nhận";
            case "SHIPPING" -> "Đang giao hàng";
            case "COMPLETE", "COMPLETED" -> "Hoàn thành";
            case "CANCEL", "CANCELLED" -> "Đã hủy";
            default -> status;
        };
    }

    public String getTrackingCode() {
        return trackingCode;
    }

    public void setTrackingCode(String trackingCode) {
        this.trackingCode = trackingCode;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public boolean isCancelableByCustomer() {
        return !customerConfirmedReceived && "PENDING".equalsIgnoreCase(status);
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isCustomerConfirmedReceived() {
        return customerConfirmedReceived;
    }

    public void setCustomerConfirmedReceived(boolean customerConfirmedReceived) {
        this.customerConfirmedReceived = customerConfirmedReceived;
    }

    public LocalDateTime getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(LocalDateTime receivedAt) {
        this.receivedAt = receivedAt;
    }

    public boolean isReturnRequested() {
        return returnRequested;
    }

    public void setReturnRequested(boolean returnRequested) {
        this.returnRequested = returnRequested;
    }

    public String getReturnStatus() {
        return returnStatus;
    }

    public void setReturnStatus(String returnStatus) {
        this.returnStatus = returnStatus;
    }

    public String getReturnStatusLabel() {
        if (returnStatus == null || returnStatus.isBlank()) {
            return "Chưa yêu cầu";
        }
        return switch (returnStatus.toUpperCase()) {
            case "PENDING" -> "Chờ xử lý";
            case "APPROVED" -> "Đã duyệt";
            case "REJECTED" -> "Từ chối";
            case "COMPLETED", "COMPLETE" -> "Đã hoàn tất";
            default -> returnStatus;
        };
    }

    public String getPaymentStatusLabel() {
        if (paymentStatus == null || paymentStatus.isBlank()) {
            return "Chưa xác định";
        }
        return switch (paymentStatus.toUpperCase()) {
            case "UNPAID" -> "Chưa thanh toán";
            case "WAITING_PAYMENT" -> "Chờ khách thanh toán";
            case "WAITING_CONFIRM" -> "Chờ admin xác nhận";
            case "PAID" -> "Đã thanh toán";
            case "FAILED" -> "Thanh toán thất bại";
            default -> paymentStatus;
        };
    }

    public boolean isLockedForAdminChanges() {
        return customerConfirmedReceived || "COMPLETED".equalsIgnoreCase(returnStatus) || warrantyCompleted;
    }

    public boolean isDeletableByAdmin() {
        return !isLockedForAdminChanges()
                && !"COMPLETE".equalsIgnoreCase(status)
                && !"COMPLETED".equalsIgnoreCase(status);
    }

    public LocalDateTime getReturnRequestedAt() {
        return returnRequestedAt;
    }

    public void setReturnRequestedAt(LocalDateTime returnRequestedAt) {
        this.returnRequestedAt = returnRequestedAt;
    }

    public String getReturnReason() {
        return returnReason;
    }

    public void setReturnReason(String returnReason) {
        this.returnReason = returnReason;
    }

    public boolean isWarrantyCompleted() {
        return warrantyCompleted;
    }

    public void setWarrantyCompleted(boolean warrantyCompleted) {
        this.warrantyCompleted = warrantyCompleted;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Set<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(Set<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    @Override
    public String toString() {
        return "Order [id=" + id + ", totalPrice=" + totalPrice + ", receiverName=" + receiverName + ", receiverPhone="
                + receiverPhone + ", receiverAddress=" + receiverAddress + ", status=" + status + "]";
    }

}
