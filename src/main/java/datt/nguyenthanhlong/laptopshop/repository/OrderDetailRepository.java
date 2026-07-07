package datt.nguyenthanhlong.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import datt.nguyenthanhlong.laptopshop.domain.Order;
import datt.nguyenthanhlong.laptopshop.domain.OrderDetail;

@Repository
public interface OrderDetailRepository extends JpaRepository<OrderDetail, Long> {
    List<OrderDetail> findByOrderIn(List<Order> orders);
    boolean existsByProductIdAndOrderUserId(long productId, long userId);
    boolean existsByProductIdAndOrderUserIdAndOrderCustomerConfirmedReceivedTrue(long productId, long userId);
    List<OrderDetail> findByProductIdAndOrderUserIdAndOrderCustomerConfirmedReceivedTrueOrderByOrderReceivedAtDescIdDesc(
            long productId, long userId);
}
