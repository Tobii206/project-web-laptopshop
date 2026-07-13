package datt.nguyenthanhlong.laptopshop.domain.dto;

import java.time.LocalDateTime;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.User;

public class AdminCustomerOrderHistoryDTO {
    private final User user;
    private final long orderCount;
    private final double totalSpent;
    private final LocalDateTime lastOrderAt;
    private final Order lastOrder;
    private final long completedOrderCount;
    private final long shippingOrderCount;
    private final long cancelledOrderCount;
    private final long returnOrderCount;
    private final long exchangeOrderCount;

    public AdminCustomerOrderHistoryDTO(User user, long orderCount, double totalSpent, LocalDateTime lastOrderAt,
            Order lastOrder, long completedOrderCount, long shippingOrderCount, long cancelledOrderCount,
            long returnOrderCount, long exchangeOrderCount) {
        this.user = user;
        this.orderCount = orderCount;
        this.totalSpent = totalSpent;
        this.lastOrderAt = lastOrderAt;
        this.lastOrder = lastOrder;
        this.completedOrderCount = completedOrderCount;
        this.shippingOrderCount = shippingOrderCount;
        this.cancelledOrderCount = cancelledOrderCount;
        this.returnOrderCount = returnOrderCount;
        this.exchangeOrderCount = exchangeOrderCount;
    }

    public User getUser() {
        return user;
    }

    public long getOrderCount() {
        return orderCount;
    }

    public double getTotalSpent() {
        return totalSpent;
    }

    public LocalDateTime getLastOrderAt() {
        return lastOrderAt;
    }

    public Order getLastOrder() {
        return lastOrder;
    }

    public long getCompletedOrderCount() {
        return completedOrderCount;
    }

    public long getShippingOrderCount() {
        return shippingOrderCount;
    }

    public long getCancelledOrderCount() {
        return cancelledOrderCount;
    }

    public long getReturnOrderCount() {
        return returnOrderCount;
    }

    public long getExchangeOrderCount() {
        return exchangeOrderCount;
    }
}
