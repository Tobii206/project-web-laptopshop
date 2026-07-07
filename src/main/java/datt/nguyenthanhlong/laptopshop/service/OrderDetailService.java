package datt.nguyenthanhlong.laptopshop
.service;

import java.util.List;

import org.springframework.stereotype.Service;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;
import datt.nguyenthanhlong.laptopshop.repository.OrderDetailRepository;

@Service
public class OrderDetailService {
    private final OrderDetailRepository orderDetailRepository;

    public OrderDetailService(OrderDetailRepository orderDetailRepository) {
        this.orderDetailRepository = orderDetailRepository;
    }

    public List<OrderDetail> fetchOrderDetails() {
        return this.orderDetailRepository.findAll();
    }

    public List<OrderDetail> fetchOrderDetailsByOrders(List<Order> orders) {
        if (orders == null || orders.isEmpty()) {
            return List.of();
        }
        return this.orderDetailRepository.findByOrderIn(orders);
    }

    public boolean hasUserPurchasedProduct(long productId, long userId) {
        return this.orderDetailRepository.existsByProductIdAndOrderUserId(productId, userId);
    }

    public boolean hasUserReceivedProduct(long productId, long userId) {
        return this.orderDetailRepository
                .existsByProductIdAndOrderUserIdAndOrderCustomerConfirmedReceivedTrue(productId, userId);
    }

    public void save(OrderDetail orderDetail) {
        this.orderDetailRepository.save(orderDetail);
    }

    public void handleDeleteOrderDetail(OrderDetail orderDetail) {
        this.orderDetailRepository.delete(orderDetail);
    }
}
